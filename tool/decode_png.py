#!/usr/bin/env python3
"""Decode PNG manually using zlib + struct, then analyze montage cells."""
import zlib, struct, sys
from collections import Counter

def decode_png(path):
    with open(path, 'rb') as f:
        header = f.read(8)
        assert header == b'\x89PNG\r\n\x1a\n', 'Not a PNG'
        idat_data = b''
        w = h = bit_depth = color_type = None
        while True:
            lb = f.read(4)
            if len(lb) < 4:
                break
            length = struct.unpack('>I', lb)[0]
            ctype = f.read(4)
            data = f.read(length)
            crc = f.read(4)
            if ctype == b'IHDR':
                w, h, bit_depth, color_type = struct.unpack('>IIBB', data[:10])
            elif ctype == b'IDAT':
                idat_data += data
            elif ctype == b'IEND':
                break
        raw = zlib.decompress(idat_data)
        # color_type 2 = RGB, 3 bytes per pixel
        bpp = 3  # bytes per pixel for RGB
        stride = w * bpp
        # Unfilter
        pixels = bytearray()
        prev_row = bytearray(stride)
        pos = 0
        for y in range(h):
            filter_type = raw[pos]
            pos += 1
            row = bytearray(raw[pos:pos + stride])
            pos += stride
            if filter_type == 0:
                pass
            elif filter_type == 1:  # Sub
                for i in range(bpp, stride):
                    row[i] = (row[i] + row[i - bpp]) & 0xFF
            elif filter_type == 2:  # Up
                for i in range(stride):
                    row[i] = (row[i] + prev_row[i]) & 0xFF
            elif filter_type == 3:  # Average
                for i in range(stride):
                    left = row[i - bpp] if i >= bpp else 0
                    up = prev_row[i]
                    row[i] = (row[i] + (left + up) // 2) & 0xFF
            elif filter_type == 4:  # Paeth
                for i in range(stride):
                    a = row[i - bpp] if i >= bpp else 0
                    b = prev_row[i]
                    c = prev_row[i - bpp] if i >= bpp else 0
                    p = a + b - c
                    pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                    if pa <= pb and pa <= pc:
                        pr = a
                    elif pb <= pc:
                        pr = b
                    else:
                        pr = c
                    row[i] = (row[i] + pr) & 0xFF
            pixels.extend(row)
            prev_row = row
        return w, h, pixels

def get_pixel(pixels, w, x, y):
    """Get RGB tuple at (x, y)."""
    idx = (y * w + x) * 3
    return (pixels[idx], pixels[idx+1], pixels[idx+2])

def rgb_to_gray(r, g, b):
    return 0.299 * r + 0.587 * g + 0.114 * b

def analyze_region(pixels, w, x1, y1, x2, y2, label=""):
    """Analyze a rectangular region: print color stats and detect if it's text on solid bg."""
    colors = []
    gray_vals = []
    for y in range(y1, min(y2, h)):
        for x in range(x1, min(x2, w)):
            r, g, b = get_pixel(pixels, w, x, y)
            colors.append((r, g, b))
            gray_vals.append(rgb_to_gray(r, g, b))
    if not colors:
        return
    # Dominant colors
    color_counts = Counter(colors)
    top5 = color_counts.most_common(5)
    avg_gray = sum(gray_vals) / len(gray_vals)
    min_gray = min(gray_vals)
    max_gray = max(gray_vals)
    std_gray = (sum((g - avg_gray)**2 for g in gray_vals) / len(gray_vals)) ** 0.5
    
    print(f"\n--- {label} ---")
    print(f"  Region: ({x1},{y1})-({x2},{y2}), {len(colors)} pixels")
    print(f"  Avg gray: {avg_gray:.1f}, Min: {min_gray:.0f}, Max: {max_gray:.0f}, Std: {std_gray:.1f}")
    print(f"  Top colors: {[(c, n) for c, n in top5[:3]]}")
    
    # Detect text: dark pixels on light background
    dark_pixels = sum(1 for g in gray_vals if g < 100)
    light_pixels = sum(1 for g in gray_vals if g > 180)
    mid_pixels = len(gray_vals) - dark_pixels - light_pixels
    print(f"  Dark(<100): {dark_pixels}, Light(>180): {light_pixels}, Mid: {mid_pixels}")
    
    # Try to detect if there's a horizontal divider (solid line)
    # Check rows for uniformity
    row_uniformity = []
    for y in range(y1, min(y2, h)):
        row_colors = []
        for x in range(x1, min(x2, w)):
            r, g, b = get_pixel(pixels, w, x, y)
            row_colors.append((r, g, b))
        uniq = len(set(row_colors))
        row_uniformity.append(uniq)
    
    # Find rows that are very uniform (potential dividers or solid areas)
    uniform_rows = [(y1 + i, u) for i, u in enumerate(row_uniformity) if u <= 3]
    if uniform_rows:
        print(f"  Uniform rows (<=3 colors): {uniform_rows[:10]}...")

def detect_text_region(pixels, w, h, x1, y1, x2, y2):
    """Try to find text by looking for dark pixels on light background."""
    # Scan horizontal strips
    for y in range(y1, y2, 5):
        dark_count = 0
        for x in range(x1, x2):
            r, g, b = get_pixel(pixels, w, x, y)
            gray = rgb_to_gray(r, g, b)
            if gray < 80:
                dark_count += 1
        if dark_count > 10:
            print(f"  Row {y}: {dark_count} dark pixels")

# Main
w, h, pixels = decode_png('/home/vaga/DSH_Projects/Project_impulsive consumption/tool/montage_new_1.png')
print(f"Decoded: {w}x{h}, {len(pixels)} bytes")

# 4 columns, each ~425px wide (1700/4)
col_width = w // 4  # 425
print(f"Column width: {col_width}")

# The image is 1200px tall. Let's figure out the layout.
# Typically: product image on top, label at bottom.
# Let's scan the bottom portion of each column for labels.

# First, let's look at the overall structure by sampling
print("\n=== Overall structure scan ===")
for y in range(0, h, 100):
    row_info = []
    for col in range(4):
        cx = col * col_width + col_width // 2
        r, g, b = get_pixel(pixels, w, cx, y)
        row_info.append(f"({r},{g},{b})")
    print(f"  y={y}: col0={row_info[0]} col1={row_info[1]} col2={row_info[2]} col3={row_info[3]}")

# Let's find the label area - look for dark text on light background in bottom portion
print("\n=== Scanning for text/labels in bottom 200px ===")
for col in range(4):
    x1 = col * col_width
    x2 = x1 + col_width
    print(f"\n--- Column {col+1} (x: {x1}-{x2}) ---")
    detect_text_region(pixels, w, h, x1, h-250, x2, h)

# Now let's do a more detailed analysis of the bottom portion
print("\n=== Detailed bottom region analysis (y: 1000-1200) ===")
for col in range(4):
    x1 = col * col_width + 5
    x2 = x1 + col_width - 10
    analyze_region(pixels, w, x1, 1000, x2, 1200, f"Column {col+1} bottom")

# Let's also check for horizontal dividers between cells
print("\n=== Looking for dividers/borders ===")
for y in range(0, h, 50):
    # Check if this row is mostly one color (divider)
    row_colors = []
    for x in range(0, w, 10):
        r, g, b = get_pixel(pixels, w, x, y)
        row_colors.append((r, g, b))
    uniq = len(set(row_colors))
    if uniq <= 5:
        print(f"  Row y={y}: {uniq} unique colors - possible divider")

# Check vertical dividers
for x in range(0, w, 10):
    col_colors = []
    for y in range(0, h, 10):
        r, g, b = get_pixel(pixels, w, x, y)
        col_colors.append((r, g, b))
    uniq = len(set(col_colors))
    if uniq <= 5:
        print(f"  Col x={x}: {uniq} unique colors - possible divider")