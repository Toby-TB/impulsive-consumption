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
    
    // Create a 30x30 pixel representation for detailed ASCII art
    const { data, info } = await img
      .resize(30, 30, { fit: 'inside' })
      .raw()
      .toBuffer({ resolveWithObject: true });

    // Print detailed 30x30 ASCII art
    console.log('\n30x30 ASCII Art:');
    const asciiChars = ' .:-=+*#%@';
    for (let y = 0; y < info.height; y++) {
      let line = '';
      for (let x = 0; x < info.width; x++) {
        const idx = (y * info.width + x) * info.channels;
        const r = data[idx], g = data[idx+1], b = data[idx+2];
        const brightness = (r + g + b) / 3;
        const charIdx = Math.min(9, Math.floor(brightness / 256 * 10));
        
        // Also indicate color type
        if (b > r + 20 && b > g + 20) {
          line += 'B'; // Blue dominant
        } else if (r > b + 30 && g > b + 20) {
          line += 'Y'; // Yellow/warm
        } else if (r > b + 20 && g < b) {
          line += 'R'; // Red
        } else {
          line += asciiChars[charIdx];
        }
      }
      console.log(line);
    }

    // Color-specific analysis (use original image)
    const fullData = await sharp(filePath).raw().toBuffer({ resolveWithObject: true });
    
    // Check for specific color signatures
    let blueCount = 0, redCount = 0, greenCount = 0, woodCount = 0, whiteCount = 0, blackCount = 0;
    let totalPixels = 0;
    
    for (let i = 0; i < fullData.data.length; i += fullData.info.channels) {
      const r = fullData.data[i], g = fullData.data[i+1], b = fullData.data[i+2];
      totalPixels++;
      
      // Blue dominant (for jeans, adidas)
      if (b > r + 15 && b > g + 10) blueCount++;
      // Red/warm tones
      if (r > b + 30 && g > b + 10) redCount++;
      // Green dominant
      if (g > r + 15 && g > b + 15) greenCount++;
      // Wood tones (brown: r>g>b with moderate values)
      if (r > g && g > b && r > 80 && r < 200 && b < 120) woodCount++;
      // Pure white/near white
      if (r > 200 && g > 200 && b > 200) whiteCount++;
      // Pure black/near black
      if (r < 40 && g < 40 && b < 40) blackCount++;
    }

    console.log('\nColor Signature Analysis:');
    console.log(`  Blue dominant: ${(blueCount/totalPixels*100).toFixed(1)}%`);
    console.log(`  Red/warm: ${(redCount/totalPixels*100).toFixed(1)}%`);
    console.log(`  Green: ${(greenCount/totalPixels*100).toFixed(1)}%`);
    console.log(`  Wood tones: ${(woodCount/totalPixels*100).toFixed(1)}%`);
    console.log(`  White: ${(whiteCount/totalPixels*100).toFixed(1)}%`);
    console.log(`  Black: ${(blackCount/totalPixels*100).toFixed(1)}%`);

    // Check center region specifically (use original dimensions)
    const centerData = await sharp(filePath)
      .extract({ left: 200, top: 200, width: 200, height: 200 })
      .raw()
      .toBuffer({ resolveWithObject: true });
    
    let centerBlue = 0, centerWood = 0, centerGray = 0;
    for (let i = 0; i < centerData.data.length; i += centerData.info.channels) {
      const r = centerData.data[i], g = centerData.data[i+1], b = centerData.data[i+2];
      if (b > r + 15 && b > g + 10) centerBlue++;
      if (r > g && g > b && r > 80 && r < 200 && b < 120) centerWood++;
      const max = Math.max(r, g, b), min = Math.min(r, g, b);
      if (max - min < 30) centerGray++;
    }
    const centerTotal = centerData.data.length / centerData.info.channels;
    console.log(`  Center blue: ${(centerBlue/centerTotal*100).toFixed(1)}%`);
    console.log(`  Center wood: ${(centerWood/centerTotal*100).toFixed(1)}%`);
    console.log(`  Center grayscale: ${(centerGray/centerTotal*100).toFixed(1)}%`);
  }
}

analyze().catch(console.error);