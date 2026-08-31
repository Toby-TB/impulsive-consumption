#!/usr/bin/env python3
"""Find the exact structure of the montage image."""
import zlib, struct

def decode_png(path):
    with open(path, 'rb') as f:
        header = f.read(8)
        idat_data = b''
        w = h = None
        while True:
            lb = f.read(4)
            if len(lb) < 4:
                break
            length = struct.unpack('>I', lb)[0]
            ctype = f.read(4)
            data = f.read(length)
            f.read(4)
            if ctype == b'IHDR':
                w, h, bit_depth, color_type = struct.unpack('>IIBB', data[:10])
            elif ctype == b'IDAT':
                idat_data += data
            elif ctype == b'IEND':
                break
        raw = zlib.decompress(idat_data)
        bpp = 3
        stride = w * bpp
        pixels = bytearray()
        prev_row = bytearray(stride)
        pos = 0
        for y in range(h):
            filter_type = raw[pos]
            pos += 1
            row = bytearray(raw[pos:pos + stride])
            pos += stride
            if filter_type == 1:
                for i in range(bpp, stride):
                    row[i] = (row[i] + row[i - bpp]) & 0xFF
            elif filter_type == 2:
                for i in range(stride):
                    row[i] = (row[i] + prev_row[i]) & 0xFF
            elif filter_type == 3:
                for i in range(stride):
                    left = row[i - bpp] if i >= bpp else 0
                    up = prev_row[i]
                    row[i] = (row[i] + (left + up) // 2) & 0xFF
            elif filter_type == 4:
                for i in range(stride):
                    a = row[i - bpp] if i >= bpp else 0
                    b = prev_row[i]
                    c = prev_row[i - bpp] if i >= bpp else 0
                    p = a + b - c
                    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                    pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                    row[i] = (row[i] + pr) & 0xFF
            pixels.extend(row)
            prev_row = row
        return w, h, pixels

def get_pixel(pixels, w, x, y):
    idx = (y * w + x) * 3
    return (pixels[idx], pixels[idx+1], pixels[idx+2])

def rgb_to_gray(r, g, b):
    return 0.299 * r + 0.587 * g + 0.114 * b

w, h, pixels = decode_png('/home/vaga/DSH_Projects/Project_impulsive consumption/tool/montage_new_1.png')
col_width = w // 4

print(f"Image: {w}x{h}")
print(f"Column width: {col_width}")

# Find horizontal structure by looking at row uniformity
print("\n=== Row analysis (every row, checking for uniform/dark rows) ===")
for y in range(0, h):
    # Sample across the row
    colors = []
    for x in range(0, w, 10):
        r, g, b = get_pixel(pixels, w, x, y)
        colors.append((r, g, b))
    uniq = len(set(colors))
    avg_gray = sum(rgb_to_gray(r,g,b) for r,g,b in colors) / len(colors)
    
    # Mark significant rows
    if uniq <= 5 or avg_gray < 40:
        print(f"  y={y}: {uniq} colors, avg_gray={avg_gray:.0f}")

# Also look at vertical structure
print("\n=== Column analysis (checking for vertical dividers) ===")
for x in range(0, w, 5):
    colors = []
    for y in range(0, h, 10):
        r, g, b = get_pixel(pixels, w, x, y)
        colors.append((r, g, b))
    uniq = len(set(colors))
    if uniq <= 5:
        print(f"  x={x}: {uniq} colors")