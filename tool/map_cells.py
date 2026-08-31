#!/usr/bin/env python3
"""Map the cell positions in the montage image."""
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

# The HTML has 4 columns, 4 rows
# Let's find the actual cell boundaries by looking at the cell background color (42,42,51)
# and the gap color (28,28,34)

# First, let's find the grid area by looking for the cell background
print("=== Finding grid boundaries ===")
# Scan for the cell background color (42,42,51) which is #2a2a33
cell_bg_count = 0
for y in range(0, h, 5):
    for x in range(0, w, 5):
        r, g, b = get_pixel(pixels, w, x, y)
        if abs(r-42) < 5 and abs(g-42) < 5 and abs(b-51) < 5:
            cell_bg_count += 1
print(f"Cell background pixels: {cell_bg_count}")

# Let's look at the image in a different way
# Sample a grid of points and classify them
print("\n=== Grid sampling (every 50px) ===")
for y in range(0, h, 50):
    row_info = []
    for x in range(0, w, 50):
        r, g, b = get_pixel(pixels, w, x, y)
        gray = rgb_to_gray(r, g, b)
        if gray < 40:
            row_info.append("DARK")
        elif gray < 100:
            row_info.append("cell")
        elif gray > 200:
            row_info.append("LIGHT")
        else:
            row_info.append(f"({r},{g},{b})")
    print(f"y={y:4d}: {' | '.join(row_info)}")

# Now let's try to find the exact cell boundaries
# The cell background is (42,42,51) and the gap is (28,28,34)
# Let's scan a horizontal line to find column boundaries
print("\n=== Column boundaries (scanning y=200) ===")
y = 200
in_cell = False
cell_starts = []
for x in range(w):
    r, g, b = get_pixel(pixels, w, x, y)
    # Check if this is cell background or gap
    is_cell_bg = abs(r-42) < 10 and abs(g-42) < 10 and abs(b-51) < 15
    is_gap = abs(r-28) < 10 and abs(g-28) < 10 and abs(b-34) < 10
    
    if is_cell_bg and not in_cell:
        cell_starts.append(x)
        in_cell = True
    elif not is_cell_bg and in_cell:
        print(f"  Cell: {cell_starts[-1]}-{x}")
        in_cell = False

# Also scan vertically
print("\n=== Row boundaries (scanning x=200) ===")
x = 200
in_cell = False
cell_starts = []
for y in range(h):
    r, g, b = get_pixel(pixels, w, x, y)
    is_cell_bg = abs(r-42) < 10 and abs(g-42) < 10 and abs(b-51) < 15
    is_gap = abs(r-28) < 10 and abs(g-28) < 10 and abs(b-34) < 10
    
    if is_cell_bg and not in_cell:
        cell_starts.append(y)
        in_cell = True
    elif not is_cell_bg and in_cell:
        print(f"  Cell: {cell_starts[-1]}-{y}")
        in_cell = False