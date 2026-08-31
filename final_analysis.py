#!/usr/bin/env python3
"""Final detailed analysis of questionable images."""
import struct, zlib, os
from collections import Counter

def read_png(path):
    with open(path, 'rb') as f:
        data = f.read()
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

def detailed_color_analysis(path, label):
    w, h, bd, ct, raw = read_png(path)
    rows, bpp = unfilter_png(w, h, ct, raw)
    
    # Get all pixels
    all_pixels = []
    for y in range(h):
        row = rows[y]
        for x in range(w):
            off = x * bpp
            all_pixels.append((row[off], row[off+1], row[off+2]))
    
    # Background is (246, 244, 241) - near white
    bg_r, bg_g, bg_b = 246, 244, 241
    
    # Object pixels (differ from bg)
    obj_pixels = [(r,g,b) for r,g,b in all_pixels 
                  if abs(r-bg_r)+abs(g-bg_g)+abs(b-bg_b) > 40]
    
    total = len(all_pixels)
    obj_count = len(obj_pixels)
    
    print(f"\n{'='*60}")
    print(f"DETAILED ANALYSIS: {label}")
    print(f"{'='*60}")
    print(f"Total pixels: {total}, Object pixels: {obj_count} ({obj_count/total*100:.1f}%)")
    
    if not obj_pixels:
        print("NO OBJECT PIXELS FOUND!")
        return
    
    # Full color histogram (every 16 levels)
    hist = Counter()
    for r, g, b in obj_pixels:
        hist[(r//16*16, g//16*16, b//16*16)] += 1
    
    print(f"\nColor histogram (quantized to 16):")
    for color, count in hist.most_common(20):
        pct = count / obj_count * 100
        r, g, b = color
        # Classify color
        if r > 200 and g > 200 and b > 200:
            ctag = "WHITE"
        elif r < 40 and g < 40 and b < 40:
            ctag = "BLACK"
        elif r > g and r > b and r > 100:
            ctag = "RED"
        elif g > r and g > b and g > 100:
            ctag = "GREEN"
        elif b > r and b > g and b > 100:
            ctag = "BLUE"
        elif r > 100 and g > 80 and b < 80 and r > b + 30:
            ctag = "BROWN"
        elif r > 100 and g > 100 and b < 80:
            ctag = "YELLOW/GOLD"
        elif abs(r-g) < 30 and abs(g-b) < 30:
            if r > 180:
                ctag = "LIGHT_GRAY"
            elif r > 100:
                ctag = "MID_GRAY"
            else:
                ctag = "DARK_GRAY"
        else:
            ctag = "OTHER"
        print(f"  RGB({r:3d},{g:3d},{b:3d}) {ctag:12s}: {count:6d} px ({pct:5.1f}%)")
    
    # Hue analysis
    red_hue = sum(1 for r,g,b in obj_pixels if r > g+30 and r > b+30)
    green_hue = sum(1 for r,g,b in obj_pixels if g > r+30 and g > b+30)
    blue_hue = sum(1 for r,g,b in obj_pixels if b > r+30 and b > g+30)
    yellow_hue = sum(1 for r,g,b in obj_pixels if r > 100 and g > 100 and b < 80 and abs(r-g) < 60)
    brown_hue = sum(1 for r,g,b in obj_pixels if r > 80 and g > 40 and g < 150 and b < 80 and r > b + 30)
    gray_hue = sum(1 for r,g,b in obj_pixels if abs(r-g) < 25 and abs(g-b) < 25 and abs(r-b) < 25)
    
    print(f"\nHue distribution:")
    print(f"  Red-dominant:   {red_hue/obj_count*100:5.1f}%")
    print(f"  Green-dominant: {green_hue/obj_count*100:5.1f}%")
    print(f"  Blue-dominant:  {blue_hue/obj_count*100:5.1f}%")
    print(f"  Yellow/Gold:    {yellow_hue/obj_count*100:5.1f}%")
    print(f"  Brown:          {brown_hue/obj_count*100:5.1f}%")
    print(f"  Gray/Neutral:   {gray_hue/obj_count*100:5.1f}%")
    
    # Brightness distribution
    dark = sum(1 for r,g,b in obj_pixels if (r+g+b)/3 < 60)
    mid = sum(1 for r,g,b in obj_pixels if 60 <= (r+g+b)/3 < 160)
    bright = sum(1 for r,g,b in obj_pixels if (r+g+b)/3 >= 160)
    
    print(f"\nBrightness distribution:")
    print(f"  Dark (<60):   {dark/obj_count*100:5.1f}%")
    print(f"  Mid (60-160): {mid/obj_count*100:5.1f}%")
    print(f"  Bright (160+): {bright/obj_count*100:5.1f}%")

# Analyze the questionable images
targets = [
    ('canvas-tote.png', 'canvas-tote · Canvas Tote Bag'),
    ('espresso-beans.png', 'espresso-beans · Coffee Beans'),
    ('longjing-tea.png', 'longjing-tea · Longjing Green Tea'),
    ('dark-chocolate.png', 'dark-chocolate · Dark Chocolate'),
    ('olive-oil.png', 'olive-oil · Extra Virgin Olive Oil'),
    ('yoga-mat.png', 'yoga-mat · Yoga Mat'),
    ('dumbbell-set.png', 'dumbbell-set · Dumbbell Set'),
    ('thermos-bottle.png', 'thermos-bottle · Insulated Water Bottle'),
]

# Also analyze some known images for comparison
known = [
    ('nvidia-rtx-4090.png', 'KNOWN: NVIDIA RTX 4090 GPU'),
    ('centella-cream.png', 'KNOWN: Centella Cream'),
    ('dyson-v12.png', 'KNOWN: Dyson V12 Vacuum'),
]

for fname, label in known + targets:
    path = 'assets/images/products/' + fname
    if os.path.exists(path):
        detailed_color_analysis(path, label)