#!/usr/bin/env python3
"""Spatial analysis: check for object shapes, patterns, and specific features."""
import struct, zlib, sys, os
from collections import Counter

def read_png(path):
    with open(path, 'rb') as f:
        data = f.read()
    if data[:8] != b'\x89PNG\r\n\x1a\n':
        raise ValueError('Not a PNG')
    pos = 8
    width = height = bit_depth = color_type = None
    idat_data = b''
    while pos < len(data):
        length = struct.unpack('>I', data[pos:pos+4])[0]
        chunk_type = data[pos+4:pos+8].decode('ascii', errors='replace')
        chunk_data = data[pos+8:pos+8+length]
        if chunk_type == 'IHDR':
            width, height, bit_depth, color_type = struct.unpack('>IIBB', chunk_data[:10])
        elif chunk_type == 'IDAT':
            idat_data += chunk_data
        pos += 12 + length
    raw = zlib.decompress(idat_data)
    return width, height, bit_depth, color_type, raw

def unfilter_png(width, height, color_type, raw):
    if color_type == 2: bpp = 3
    elif color_type == 6: bpp = 4
    elif color_type == 0: bpp = 1
    else: raise ValueError(f'Unsupported color_type: {color_type}')
    stride = width * bpp
    rows = []
    prev = bytearray(stride)
    pos = 0
    for y in range(height):
        filter_type = raw[pos]
        pos += 1
        line = bytearray(raw[pos:pos+stride])
        pos += stride
        if filter_type == 1:
            for i in range(bpp, stride):
                line[i] = (line[i] + line[i-bpp]) & 0xFF
        elif filter_type == 2:
            for i in range(stride):
                line[i] = (line[i] + prev[i]) & 0xFF
        elif filter_type == 3:
            for i in range(stride):
                left = line[i-bpp] if i >= bpp else 0
                up = prev[i]
                line[i] = (line[i] + (left + up)//2) & 0xFF
        elif filter_type == 4:
            for i in range(stride):
                a = line[i-bpp] if i >= bpp else 0
                b = prev[i]
                c = prev[i-bpp] if i >= bpp else 0
                p = a + b - c
                pa, pb, pc = abs(p-a), abs(p-b), abs(p-c)
                pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                line[i] = (line[i] + pr) & 0xFF
        rows.append(bytes(line))
        prev = line
    return rows, bpp

def spatial_map(path, grid=10):
    """Create a coarse spatial color map."""
    w, h, bd, ct, raw = read_png(path)
    rows, bpp = unfilter_png(w, h, ct, raw)
    
    cell_w = w // grid
    cell_h = h // grid
    
    # Background color from corners
    bg_r, bg_g, bg_b = 246, 244, 241
    
    grid_data = []
    for gy in range(grid):
        row_data = []
        for gx in range(grid):
            # Sample pixels in this cell
            cell_pixels = []
            for y in range(gy*cell_h, min((gy+1)*cell_h, h)):
                row = rows[y]
                for x in range(gx*cell_w, min((gx+1)*cell_w, w)):
                    off = x * bpp
                    cell_pixels.append((row[off], row[off+1], row[off+2]))
            
            if not cell_pixels:
                row_data.append({'type': 'empty'})
                continue
            
            # Check if this cell is background or object
            bg_match = sum(1 for r,g,b in cell_pixels if abs(r-bg_r)+abs(g-bg_g)+abs(b-bg_b) < 30)
            bg_pct = bg_match / len(cell_pixels) * 100
            
            if bg_pct > 80:
                row_data.append({'type': 'bg', 'bg_pct': bg_pct})
            else:
                # Object cell - analyze its colors
                obj_px = [(r,g,b) for r,g,b in cell_pixels if abs(r-bg_r)+abs(g-bg_g)+abs(b-bg_b) >= 30]
                if obj_px:
                    avg_r = sum(p[0] for p in obj_px) / len(obj_px)
                    avg_g = sum(p[1] for p in obj_px) / len(obj_px)
                    avg_b = sum(p[2] for p in obj_px) / len(obj_px)
                    bright = (avg_r + avg_g + avg_b) / 3
                    row_data.append({
                        'type': 'obj',
                        'avg_rgb': (round(avg_r), round(avg_g), round(avg_b)),
                        'brightness': round(bright, 1),
                        'obj_pct': round(len(obj_px)/len(cell_pixels)*100, 1)
                    })
                else:
                    row_data.append({'type': 'bg', 'bg_pct': 100})
        grid_data.append(row_data)
    return grid_data

def print_grid(grid_data, label):
    print(f"\n{'='*60}")
    print(f"SPATIAL MAP: {label}")
    print(f"{'='*60}")
    for row in grid_data:
        line = ""
        for cell in row:
            if cell['type'] == 'bg':
                line += " · "
            elif cell['type'] == 'obj':
                r, g, b = cell['avg_rgb']
                bright = cell['brightness']
                # Use different symbols based on color
                if r > g and r > b and r > 100:
                    line += " R "  # Reddish
                elif g > r and g > b and g > 80:
                    line += " G "  # Greenish
                elif b > r and b > g and b > 80:
                    line += " B "  # Blueish
                elif bright > 200:
                    line += " W "  # White/light
                elif bright < 50:
                    line += " D "  # Dark
                elif r > 100 and g > 80 and b < 80:
                    line += " O "  # Orange/brown
                elif r > 100 and g > 100 and b < 80:
                    line += " Y "  # Yellow
                else:
                    line += " ? "  # Other
            else:
                line += " ? "
        print(line)

# Target images to analyze
TARGETS = {
    'canvas-tote': 'assets/images/products/canvas-tote.png',
    'espresso-beans': 'assets/images/products/espresso-beans.png',
    'longjing-tea': 'assets/images/products/longjing-tea.png',
    'dark-chocolate': 'assets/images/products/dark-chocolate.png',
    'olive-oil': 'assets/images/products/olive-oil.png',
    'yoga-mat': 'assets/images/products/yoga-mat.png',
    'dumbbell-set': 'assets/images/products/dumbbell-set.png',
    'thermos-bottle': 'assets/images/products/thermos-bottle.png',
}

for name, path in TARGETS.items():
    grid = spatial_map(path, grid=12)
    print_grid(grid, name)