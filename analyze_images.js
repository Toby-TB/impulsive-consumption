const { PNG } = require('pngjs');
const fs = require('fs');
const path = require('path');

const files = [
  'iphone-15-pro.png',
  'samsung-galaxy-s24.png',
  'macbook-air.png',
  'airpods-pro.png',
  'ipad-air.png',
  'kindle-paperwhite.png',
  'laser-printer.png',
  'dyson-v12.png'
];

const dir = 'assets/images/products';

function analyzeImage(filepath) {
  const data = fs.readFileSync(filepath);
  const png = PNG.sync.read(data);
  const { width, height, data: pixels } = png;

  // Color analysis
  const colorBuckets = {};
  let totalPixels = width * height;
  let nonWhitePixels = 0;
  let rSum = 0, gSum = 0, bSum = 0;

  // Sample every 4th pixel for performance
  const step = 4;
  for (let i = 0; i < pixels.length; i += step * 4) {
    const r = pixels[i];
    const g = pixels[i + 1];
    const b = pixels[i + 2];
    const a = pixels[i + 3];

    if (a < 128) continue; // skip transparent

    rSum += r;
    gSum += g;
    bSum += b;

    // Bucket color (coarse)
    const bucket = `${Math.floor(r/32)},${Math.floor(g/32)},${Math.floor(b/32)}`;
    colorBuckets[bucket] = (colorBuckets[bucket] || 0) + 1;

    // Count non-white pixels
    if (r < 240 || g < 240 || b < 240) {
      nonWhitePixels++;
    }
  }

  const sampleCount = Object.values(colorBuckets).reduce((a, b) => a + b, 0);
  const avgR = Math.round(rSum / sampleCount);
  const avgG = Math.round(gSum / sampleCount);
  const avgB = Math.round(bSum / sampleCount);

  // Sort color buckets by frequency
  const sortedBuckets = Object.entries(colorBuckets)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 10);

  // Edge detection (simple horizontal gradient)
  let edgePixels = 0;
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width - 1; x++) {
      const idx = (y * width + x) * 4;
      const idx2 = (y * width + x + 1) * 4;
      const dr = Math.abs(pixels[idx] - pixels[idx2]);
      const dg = Math.abs(pixels[idx + 1] - pixels[idx2 + 1]);
      const db = Math.abs(pixels[idx + 2] - pixels[idx2 + 2]);
      if (dr + dg + db > 60) edgePixels++;
    }
  }

  // Check if image looks like a placeholder (uniform color, low detail)
  const uniqueColors = Object.keys(colorBuckets).length;
  const edgeDensity = edgePixels / (width * height);
  const nonWhiteRatio = nonWhitePixels / sampleCount;

  // Check for common stock photo backgrounds
  const hasWhiteBackground = colorBuckets['7,7,7'] || colorBuckets['7,7,6'] || 0;
  const whiteBucketRatio = hasWhiteBackground / sampleCount;

  return {
    file: path.basename(filepath),
    width,
    height,
    fileSize: data.length,
    avgColor: `rgb(${avgR},${avgG},${avgB})`,
    uniqueColorBuckets: uniqueColors,
    nonWhiteRatio: nonWhiteRatio.toFixed(3),
    edgeDensity: edgeDensity.toFixed(5),
    whiteBackgroundRatio: whiteBucketRatio.toFixed(3),
    topColors: sortedBuckets.map(([bucket, count]) => ({
      bucket,
      count,
      pct: (count / sampleCount * 100).toFixed(1)
    }))
  };
}

console.log('=== PRODUCT IMAGE ANALYSIS ===\n');

for (const file of files) {
  const filepath = path.join(dir, file);
  if (!fs.existsSync(filepath)) {
    console.log(`${file}: FILE NOT FOUND`);
    continue;
  }
  const result = analyzeImage(filepath);
  console.log(`\n--- ${result.file} (${result.width}x${result.height}, ${(result.fileSize/1024).toFixed(0)}KB) ---`);
  console.log(`  Average color: ${result.avgColor}`);
  console.log(`  Non-white pixel ratio: ${result.nonWhiteRatio}`);
  console.log(`  Edge density: ${result.edgeDensity}`);
  console.log(`  White background ratio: ${result.whiteBackgroundRatio}`);
  console.log(`  Unique color buckets: ${result.uniqueColorBuckets}`);
  console.log(`  Top colors:`);
  result.topColors.forEach(c => {
    console.log(`    [${c.bucket}] ${c.count} pixels (${c.pct}%)`);
  });

  // Classification hints
  const hints = [];
  if (result.edgeDensity < 0.001) hints.push('VERY LOW DETAIL - possible placeholder');
  if (result.edgeDensity < 0.003) hints.push('LOW DETAIL - possible stock/blurry');
  if (result.whiteBackgroundRatio > 0.7) hints.push('WHITE BACKGROUND - typical product shot');
  if (result.nonWhiteRatio < 0.1) hints.push('MOSTLY WHITE - may be empty/placeholder');
  if (result.uniqueColorBuckets < 5) hints.push('FEW COLORS - possible simple graphic');

  if (hints.length > 0) {
    console.log(`  HINTS: ${hints.join('; ')}`);
  }
}