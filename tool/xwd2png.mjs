// xwd 抓屏 → PNG（Node 内置 zlib，无需外部依赖）
// 用法: node tool/xwd2png.mjs <input.xwd> <output.png>
import { readFileSync, writeFileSync } from "node:fs";
import { deflateSync } from "node:zlib";

const [inFile, outFile] = process.argv.slice(2);
const buf = readFileSync(inFile);
const u32 = (o) => buf.readUInt32BE(o);

const headerSize = u32(0);
const depth = u32(12);
const width = u32(16);
const height = u32(20);
const byteOrder = u32(28); // 0=LSB 1=MSB
const bitsPerPixel = u32(44);
const bytesPerLine = u32(48);
const redMask = u32(56);
const greenMask = u32(60);
const blueMask = u32(64);
const ncolors = u32(76);

console.log({ width, height, depth, bitsPerPixel, bytesPerLine, byteOrder, redMask: redMask.toString(16), ncolors });

const dataStart = headerSize + ncolors * 12;
const bytesPerPixel = Math.ceil(bitsPerPixel / 8);
const shift = (mask) => {
  let s = 0;
  while (mask && !(mask & 1)) { mask >>>= 1; s++; }
  return s;
};
const rs = shift(redMask), gs = shift(greenMask), bs = shift(blueMask);

const raw = Buffer.alloc(height * (1 + width * 3));
let out = 0;
for (let y = 0; y < height; y++) {
  raw[out++] = 0; // filter none
  const line = dataStart + y * bytesPerLine;
  for (let x = 0; x < width; x++) {
    const p = line + x * bytesPerPixel;
    let val = 0;
    if (byteOrder === 0) {
      for (let i = 0; i < bytesPerPixel; i++) val |= buf[p + i] << (8 * i);
    } else {
      for (let i = 0; i < bytesPerPixel; i++) val = (val << 8) | buf[p + i];
    }
    const r = (val & redMask) >>> rs;
    const g = (val & greenMask) >>> gs;
    const b = (val & blueMask) >>> bs;
    raw[out++] = r & 0xff;
    raw[out++] = g & 0xff;
    raw[out++] = b & 0xff;
  }
}

// ---- PNG 编码 ----
const crcTable = new Int32Array(256);
for (let n = 0; n < 256; n++) {
  let c = n;
  for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1;
  crcTable[n] = c;
}
const crc32 = (buf) => {
  let c = -1;
  for (let i = 0; i < buf.length; i++) c = crcTable[(c ^ buf[i]) & 0xff] ^ (c >>> 8);
  return (c ^ -1) >>> 0;
};
const chunk = (type, data) => {
  const len = Buffer.alloc(4);
  len.writeUInt32BE(data.length);
  const t = Buffer.from(type, "ascii");
  const crc = Buffer.alloc(4);
  crc.writeUInt32BE(crc32(Buffer.concat([t, data])));
  return Buffer.concat([len, t, data, crc]);
};
const ihdr = Buffer.alloc(13);
ihdr.writeUInt32BE(width, 0);
ihdr.writeUInt32BE(height, 4);
ihdr[8] = 8;  // bit depth
ihdr[9] = 2;  // truecolor
const png = Buffer.concat([
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
  chunk("IHDR", ihdr),
  chunk("IDAT", deflateSync(raw, { level: 6 })),
  chunk("IEND", Buffer.alloc(0)),
]);
writeFileSync(outFile, png);
console.log("written:", outFile, png.length, "bytes");
