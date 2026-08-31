#!/usr/bin/env python3
"""Try to read label text by extracting and analyzing character patterns."""
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

# Let's look at the label text areas more carefully
# The labels seem to have: a small product thumbnail + text below it
# Let's find the exact text-only region

# First, let's find the dark bar that separates product image from label
print("=== Finding the dark separator bar ===")
for y in range(850, 950):
    dark_count = 0
    for x in range(0, w, 3):
        r, g, b = get_pixel(pixels, w, x, y)
        if rgb_to_gray(r, g, b) < 50:
            dark_count += 1
    total = len(range(0, w, 3))
    if dark_count > total * 0.8:
        print(f"  y={y}: {dark_count*100//total}% dark")

# Now let's look at the label area structure more carefully
# The label seems to have a light background with dark text
# Let's find the exact label background region

print("\n=== Label area structure ===")
for col in range(4):
    x1 = col * col_width + 5
    x2 = x1 + col_width - 10
    
    # Find the label background (light area)
    print(f"\nColumn {col+1}:")
    
    # Check y ranges for background color
    for y_start in range(900, 1200, 50):
        y_end = min(y_start + 50, 1200)
        light_count = 0
        dark_count = 0
        total = 0
        for y in range(y_start, y_end, 3):
            for x in range(x1, x2, 3):
                r, g, b = get_pixel(pixels, w, x, y)
                gray = rgb_to_gray(r, g, b)
                if gray > 200:
                    light_count += 1
                elif gray < 80:
                    dark_count += 1
                total += 1
        if total > 0:
            print(f"  y={y_start}-{y_end}: light={light_count*100//total}%, dark={dark_count*100//total}%")

# Let me try a different approach: extract the label text as a binary image
# and try to identify it by looking at the structure

print("\n\n=== Attempting to read label text ===")
for col in range(4):
    x1 = col * col_width + 15
    x2 = x1 + col_width - 30
    
    # Find the text region: rows with dark pixels on light background
    # First find the label background start
    label_start_y = 900
    for y in range(900, 1000):
        light = 0
        for x in range(x1, x2, 5):
            r, g, b = get_pixel(pixels, w, x, y)
            if rgb_to_gray(r, g, b) > 200:
                light += 1
        if light > 10:
            label_start_y = y
            break
    
    # Now find where text starts (after any product thumbnail in the label)
    # Text should be dark pixels
    text_start_y = label_start_y
    for y in range(label_start_y, 1100):
        dark = 0
        for x in range(x1, x2):
            r, g, b = get_pixel(pixels, w, x, y)
            if rgb_to_gray(r, g, b) < 80:
                dark += 1
        if dark > 20:
            text_start_y = y
            break
    
    print(f"\nColumn {col+1}: label starts at y={label_start_y}, text starts at y={text_start_y}")
    
    # Extract text region
    # The text is "商品id · 商品名称" format
    # Let's try to find individual characters
    
    # First, let's get a binary representation of the text area
    # Text is dark on light background
    
    # Let's find the vertical extent of the text
    text_rows = []
    for y in range(text_start_y, 1200):
        dark = 0
        for x in range(x1, x2):
            r, g, b = get_pixel(pixels, w, x, y)
            if rgb_to_gray(r, g, b) < 80:
                dark += 1
        text_rows.append((y, dark))
    
    # Find the text band
    in_text = False
    text_top = 0
    text_bottom = 0
    for y, dark in text_rows:
        if dark > 10 and not in_text:
            in_text = True
            text_top = y
        elif dark <= 3 and in_text:
            in_text = False
            text_bottom = y
            break
    if in_text:
        text_bottom = 1199
    
    print(f"  Text band: y={text_top}-{text_bottom}")
    
    # Now let's render the text at high resolution
    # Use 1:1 pixel mapping
    print(f"  Text rendering:")
    for y in range(text_top, text_bottom + 1):
        line = ""
        for x in range(x1, x2):
            r, g, b = get_pixel(pixels, w, x, y)
            gray = rgb_to_gray(r, g, b)
            if gray < 70:
                line += "#"
            elif gray < 130:
                line += "."
            elif gray < 200:
                line += " "
            else:
                line += " "
        # Only print non-empty lines
        if line.replace(" ", "").strip():
            print(f"    |{line}|")