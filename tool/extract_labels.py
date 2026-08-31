#!/usr/bin/env python3
"""Extract label text regions at high resolution and try to identify characters."""
import zlib, struct
from collections import Counter

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
            f.read(4)  # crc
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

# Let's look at the label text areas more carefully
# First, find the exact boundaries of the label text (not the product thumbnail)

for col in range(4):
    x1 = col * col_width + 10
    x2 = x1 + col_width - 20
    
    print(f"\n{'='*60}")
    print(f"COLUMN {col+1}")
    print(f"{'='*60}")
    
    # Scan for text rows with high dark pixel count
    # Text should be dark on light background
    text_rows = []
    for y in range(900, 1200):
        dark = 0
        for x in range(x1, x2):
            r, g, b = get_pixel(pixels, w, x, y)
            if rgb_to_gray(r, g, b) < 80:
                dark += 1
        text_rows.append((y, dark))
    
    # Find where the actual text starts (after the product thumbnail in the label)
    # The product thumbnail would have varied content, text would be dark pixels
    # Let's find the transition
    
    # Print dark pixel counts for key rows
    print("Dark pixel counts (every 5 rows):")
    for y in range(950, 1200, 5):
        dark = text_rows[y-900][1]
        bar = "#" * min(dark, 80)
        print(f"  y={y}: {dark:4d} {bar}")

    # Now let's extract just the text area and render it
    # Find the text start: first row with significant dark pixels after the thumbnail area
    # The thumbnail in the label seems to be around y=975-1060 for col 1
    
    # Let's find rows with consistent text-like patterns
    # Text should have alternating dark/light patterns
    
    # For now, let's just render the entire label band at higher resolution
    print(f"\nHigh-res rendering of label area (y=1050-1200):")
    for y in range(1050, 1200, 2):
        line = ""
        for x in range(x1, x2, 2):
            r, g, b = get_pixel(pixels, w, x, y)
            gray = rgb_to_gray(r, g, b)
            if gray < 70:
                line += "@"
            elif gray < 110:
                line += "#"
            elif gray < 150:
                line += "+"
            elif gray < 200:
                line += "."
            else:
                line += " "
        if line.strip():
            print(f"  {line}")