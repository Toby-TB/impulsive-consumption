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

    // Get full resolution data
    const { data, info } = await sharp(filePath)
      .raw()
      .toBuffer({ resolveWithObject: true });

    // Row-by-row analysis: find horizontal edges/lines
    console.log('\nHorizontal structure (row profiles):');
    for (let y = 0; y < 600; y += 30) {
      let rowBright = 0, rowDark = 0, rowEdge = 0;
      let prevR = data[(y * 600) * 3];
      let prevG = data[(y * 600) * 3 + 1];
      let prevB = data[(y * 600) * 3 + 2];
      
      for (let x = 0; x < 600; x++) {
        const idx = (y * 600 + x) * 3;
        const r = data[idx], g = data[idx+1], b = data[idx+2];
        const bright = (r + g + b) / 3;
        rowBright += bright;
        if (bright < 60) rowDark++;
        
        const diff = Math.abs(r - prevR) + Math.abs(g - prevG) + Math.abs(b - prevB);
        if (diff > 50) rowEdge++;
        
        prevR = r; prevG = g; prevB = b;
      }
      const avgBright = rowBright / 600;
      const darkPct = (rowDark / 600 * 100).toFixed(0);
      const edgePct = (rowEdge / 600 * 100).toFixed(0);
      
      const bar = '█'.repeat(Math.min(50, Math.floor(avgBright / 5)));
      process.stdout.write(`  y=${y.toString().padStart(3)}: avg=${avgBright.toFixed(0).padStart(3)} dark=${darkPct.padStart(2)}% edge=${edgePct.padStart(2)}% ${bar}\n`);
    }

    // Column-by-column analysis
    console.log('\nVertical structure (column profiles):');
    for (let x = 0; x < 600; x += 30) {
      let colBright = 0, colDark = 0, colEdge = 0;
      let prevR = data[x * 3];
      let prevG = data[x * 3 + 1];
      let prevB = data[x * 3 + 2];
      
      for (let y = 0; y < 600; y++) {
        const idx = (y * 600 + x) * 3;
        const r = data[idx], g = data[idx+1], b = data[idx+2];
        const bright = (r + g + b) / 3;
        colBright += bright;
        if (bright < 60) colDark++;
        
        const diff = Math.abs(r - prevR) + Math.abs(g - prevG) + Math.abs(b - prevB);
        if (diff > 50) colEdge++;
        
        prevR = r; prevG = g; prevB = b;
      }
      const avgBright = colBright / 600;
      const darkPct = (colDark / 600 * 100).toFixed(0);
      const edgePct = (colEdge / 600 * 100).toFixed(0);
      
      const bar = '█'.repeat(Math.min(50, Math.floor(avgBright / 5)));
      process.stdout.write(`  x=${x.toString().padStart(3)}: avg=${avgBright.toFixed(0).padStart(3)} dark=${darkPct.padStart(2)}% edge=${edgePct.padStart(2)}% ${bar}\n`);
    }
  }
}

analyze().catch(console.error);