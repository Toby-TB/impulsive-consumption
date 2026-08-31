const sharp = require('sharp');
const fs = require('fs');
const path = require('path');

const dir = '/home/vaga/DSH_Projects/Project_impulsive consumption/assets/images/products/';

const files = [
  'standing-desk.png',
  'led-desk-lamp.png',
  'memory-mattress.png',
  'bookshelf.png',
  'storage-box.png',
  'nike-sneaker.png',
  'adidas-hoodie.png',
  'levi-jeans.png'
];

async function analyze() {
  for (const f of files) {
    const filePath = path.join(dir, f);
    console.log(`\n${'='.repeat(70)}`);
    console.log(`FILE: ${f}`);
    console.log(`${'='.repeat(70)}`);

    const img = sharp(filePath);
    const metadata = await img.metadata();
    console.log(`Dimensions: ${metadata.width}x${metadata.height}, channels: ${metadata.channels}`);

    // Get raw pixel data
    const { data, info } = await img
      .raw()
      .toBuffer({ resolveWithObject: true });

    const pixels = [];
    for (let i = 0; i < data.length; i += info.channels) {
      pixels.push({
        r: data[i],
        g: data[i + 1],
        b: data[i + 2]
      });
    }

    const totalPixels = pixels.length;

    // Color analysis
    // Divide into 8x8 grid blocks
    const blockSize = 75; // 600/8
    const grid = [];
    for (let row = 0; row < 8; row++) {
      grid[row] = [];
      for (let col = 0; col < 8; col++) {
        let rSum = 0, gSum = 0, bSum = 0, count = 0;
        for (let y = row * blockSize; y < (row + 1) * blockSize; y++) {
          for (let x = col * blockSize; x < (col + 1) * blockSize; x++) {
            const idx = y * 600 + x;
            if (idx < pixels.length) {
              rSum += pixels[idx].r;
              gSum += pixels[idx].g;
              bSum += pixels[idx].b;
              count++;
            }
          }
        }
        grid[row][col] = {
          r: Math.round(rSum / count),
          g: Math.round(gSum / count),
          b: Math.round(bSum / count)
        };
      }
    }

    // Print ASCII representation
    console.log('\nGrid (8x8 blocks, brightness-based ASCII):');
    const asciiChars = ' .:-=+*#%@';
    for (let row = 0; row < 8; row++) {
      let line = '';
      for (let col = 0; col < 8; col++) {
        const { r, g, b } = grid[row][col];
        const brightness = (r + g + b) / 3;
        const charIdx = Math.min(9, Math.floor(brightness / 256 * 10));
        line += asciiChars[charIdx];
      }
      console.log(line);
    }

    // Color distribution analysis
    console.log('\nColor Analysis:');
    
    // Dominant colors (quantized)
    const colorBuckets = {};
    for (const p of pixels) {
      const qr = Math.floor(p.r / 32) * 32;
      const qg = Math.floor(p.g / 32) * 32;
      const qb = Math.floor(p.b / 32) * 32;
      const key = `${qr},${qg},${qb}`;
      colorBuckets[key] = (colorBuckets[key] || 0) + 1;
    }

    const sortedColors = Object.entries(colorBuckets)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 10);

    console.log('Top 10 dominant colors (quantized):');
    for (const [color, count] of sortedColors) {
      const pct = (count / totalPixels * 100).toFixed(1);
      const [r, g, b] = color.split(',').map(Number);
      console.log(`  RGB(${r},${g},${b}): ${pct}% (${count} pixels)`);
    }

    // Brightness stats
    let totalBrightness = 0;
    let minBrightness = 255, maxBrightness = 0;
    for (const p of pixels) {
      const b = (p.r + p.g + p.b) / 3;
      totalBrightness += b;
      minBrightness = Math.min(minBrightness, b);
      maxBrightness = Math.max(maxBrightness, b);
    }
    console.log(`\nBrightness: min=${minBrightness.toFixed(0)}, max=${maxBrightness.toFixed(0)}, avg=${(totalBrightness/totalPixels).toFixed(1)}`);

    // Edge detection (simple horizontal gradient)
    console.log('\nHorizontal edge density (per row):');
    let edgeRows = 0;
    for (let y = 0; y < 600; y += 20) {
      let edgeCount = 0;
      for (let x = 1; x < 600; x += 4) {
        const idx1 = y * 600 + x;
        const idx2 = y * 600 + x + 1;
        if (idx2 < pixels.length) {
          const diff = Math.abs(pixels[idx1].r - pixels[idx2].r) +
                       Math.abs(pixels[idx1].g - pixels[idx2].g) +
                       Math.abs(pixels[idx1].b - pixels[idx2].b);
          if (diff > 60) edgeCount++;
        }
      }
      if (edgeCount > 5) edgeRows++;
      process.stdout.write(edgeCount > 5 ? '#' : ' ');
    }
    console.log(`\n  Edge rows: ${edgeRows}/30`);

    // Vertical edge density
    process.stdout.write('Vertical edge density (per col): ');
    let edgeCols = 0;
    for (let x = 0; x < 600; x += 20) {
      let edgeCount = 0;
      for (let y = 1; y < 600; y += 4) {
        const idx1 = y * 600 + x;
        const idx2 = (y + 1) * 600 + x;
        if (idx2 < pixels.length) {
          const diff = Math.abs(pixels[idx1].r - pixels[idx2].r) +
                       Math.abs(pixels[idx1].g - pixels[idx2].g) +
                       Math.abs(pixels[idx1].b - pixels[idx2].b);
          if (diff > 60) edgeCount++;
        }
      }
      if (edgeCount > 5) edgeCols++;
      process.stdout.write(edgeCount > 5 ? '#' : ' ');
    }
    console.log(`\n  Edge cols: ${edgeCols}/30`);

    // Center vs corner analysis (products often centered)
    const centerRegion = [];
    const cornerRegion = [];
    for (let y = 200; y < 400; y++) {
      for (let x = 200; x < 400; x++) {
        const idx = y * 600 + x;
        if (idx < pixels.length) centerRegion.push(pixels[idx]);
      }
    }
    for (let y = 0; y < 100; y++) {
      for (let x = 0; x < 100; x++) {
        const idx = y * 600 + x;
        if (idx < pixels.length) cornerRegion.push(pixels[idx]);
      }
    }

    let centerBright = 0, cornerBright = 0;
    for (const p of centerRegion) centerBright += (p.r + p.g + p.b) / 3;
    for (const p of cornerRegion) cornerBright += (p.r + p.g + p.b) / 3;
    centerBright /= centerRegion.length;
    cornerBright /= cornerRegion.length;
    console.log(`\nCenter avg brightness: ${centerBright.toFixed(1)}`);
    console.log(`Corner avg brightness: ${cornerBright.toFixed(1)}`);
    console.log(`Center darker than corner: ${centerBright < cornerBright ? 'YES (object on light bg)' : 'NO (object on dark bg or uniform)'}`);

    // Aspect ratio of non-background pixels
    // Assume background is the most common color in corners
    const bgR = Math.round(cornerRegion.reduce((s, p) => s + p.r, 0) / cornerRegion.length);
    const bgG = Math.round(cornerRegion.reduce((s, p) => s + p.g, 0) / cornerRegion.length);
    const bgB = Math.round(cornerRegion.reduce((s, p) => s + p.b, 0) / cornerRegion.length);
    console.log(`\nEstimated background color: RGB(${bgR},${bgG},${bgB})`);

    // Find bounding box of non-background pixels
    let minX = 600, maxX = 0, minY = 600, maxY = 0;
    let nonBgCount = 0;
    for (let y = 0; y < 600; y++) {
      for (let x = 0; x < 600; x++) {
        const idx = y * 600 + x;
        if (idx < pixels.length) {
          const p = pixels[idx];
          const dist = Math.abs(p.r - bgR) + Math.abs(p.g - bgG) + Math.abs(p.b - bgB);
          if (dist > 40) {
            nonBgCount++;
            minX = Math.min(minX, x);
            maxX = Math.max(maxX, x);
            minY = Math.min(minY, y);
            maxY = Math.max(maxY, y);
          }
        }
      }
    }
    if (nonBgCount > 0) {
      const objWidth = maxX - minX;
      const objHeight = maxY - minY;
      const objRatio = objWidth / objHeight;
      console.log(`Object bounding box: x=[${minX},${maxX}], y=[${minY},${maxY}]`);
      console.log(`Object size: ${objWidth}x${objHeight}, aspect ratio: ${objRatio.toFixed(2)}`);
      console.log(`Non-background pixels: ${nonBgCount} (${(nonBgCount/totalPixels*100).toFixed(1)}%)`);
    }
  }
}

analyze().catch(console.error);