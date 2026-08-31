#!/usr/bin/env python3
"""Deep analysis: extract center object, compare with known product images."""
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

def get_pixels(rows, w, h, bpp):
    pixels = []
    for row in rows:
        for x in range(w):
            off = x * bpp
            if bpp >= 3:
                pixels.append((row[off], row[off+1], row[off+2]))
            else:
                pixels.append((row[off], row[off], row[off]))
    return pixels

def analyze_object_region(path, margin_frac=0.15):
    """Analyze the central object region vs background."""
    w, h, bd, ct, raw = read_png(path)
    rows, bpp = unfilter_png(w, h, ct, raw)
    pixels = get_pixels(rows, w, h, bpp)
    
    mx = int(w * margin_frac)
    my = int(h * margin_frac)
    
    # Center region pixels
    center = []
    for y in range(my, h - my):
        for x in range(mx, w - mx):
            idx = y * w + x
            center.append(pixels[idx])
    
    # Corner (background) pixels
    corners = []
    for y in range(0, my):
        for x in range(0, w):
            idx = y * w + x
            corners.append(pixels[idx])
    for y in range(h - my, h):
        for x in range(0, w):
            idx = y * w + x
            corners.append(pixels[idx])
    for y in range(my, h - my):
        for x in range(0, mx):
            idx = y * w + x
            corners.append(pixels[idx])
        for x in range(w - mx, w):
            idx = y * w + x
            corners.append(pixels[idx])
    
    # Background color (most common in corners)
    corner_counter = Counter(corners)
    bg_color = corner_counter.most_common(1)[0][0]
    
    # Object pixels = center pixels that differ significantly from background
    obj_pixels = [p for p in center if abs(p[0]-bg_color[0]) + abs(p[1]-bg_color[1]) + abs(p[2]-bg_color[2]) > 40]
    
    obj_pct = len(obj_pixels) / len(center) * 100 if center else 0
    
    if not obj_pixels:
        return {'obj_pct': 0, 'note': 'No object detected'}
    
    # Object color analysis
    obj_brightness = sum((r+g+b)/3 for r,g,b in obj_pixels) / len(obj_pixels)
    
    # Object color categories
    obj_counter = Counter()
    for r, g, b in obj_pixels:
        qr, qg, qb = (r//32)*32, (g//32)*32, (b//32)*32
        obj_counter[(qr, qg, qb)] += 1
    
    obj_top = obj_counter.most_common(10)
    
    # Dominant hue analysis
    red_dominant = sum(1 for r,g,b in obj_pixels if r > g+20 and r > b+20)
    green_dominant = sum(1 for r,g,b in obj_pixels if g > r+20 and g > b+20)
    blue_dominant = sum(1 for r,g,b in obj_pixels if b > r+20 and b > g+20)
    warm = sum(1 for r,g,b in obj_pixels if r > b+20)  # red > blue = warm
    dark = sum(1 for r,g,b in obj_pixels if (r+g+b)/3 < 80)
    bright = sum(1 for r,g,b in obj_pixels if (r+g+b)/3 > 200)
    
    return {
        'bg_color': bg_color,
        'obj_pct': obj_pct,
        'obj_brightness': obj_brightness,
        'obj_top_colors': [(c, cnt, cnt/len(obj_pixels)*100) for c, cnt in obj_top[:5]],
        'red_dominant_pct': red_dominant / len(obj_pixels) * 100,
        'green_dominant_pct': green_dominant / len(obj_pixels) * 100,
        'blue_dominant_pct': blue_dominant / len(obj_pixels) * 100,
        'warm_pct': warm / len(obj_pixels) * 100,
        'dark_pct': dark / len(obj_pixels) * 100,
        'bright_pct': bright / len(obj_pixels) * 100,
        'obj_pixel_count': len(obj_pixels),
    }

# Known product images to compare against
KNOWN_IMAGES = {
    'nvidia-rtx-4090': 'assets/images/products/nvidia-rtx-4090.png',
    'ps5-slim': 'assets/images/products/ps5-slim.png',
    'centella-cream': 'assets/images/products/centella-cream.png',
    'iphone-15-pro': 'assets/images/products/iphone-15-pro.png',
    'dyson-v12': 'assets/images/products/dyson-v12.png',
    'adidas-hoodie': 'assets/images/products/adidas-hoodie.png',
    'air-fryer': 'assets/images/products/air-fryer.png',
    'instant-pot': 'assets/images/products/instant-pot.png',
}

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

print("=" * 80)
print("KNOWN PRODUCT IMAGES (baseline)")
print("=" * 80)
for name, path in KNOWN_IMAGES.items():
    r = analyze_object_region(path)
    print(f"\n{name}:")
    print(f"  BG: {r['bg_color']}, Obj%: {r['obj_pct']:.1f}%, Obj brightness: {r['obj_brightness']:.1f}")
    print(f"  Red dom: {r['red_dominant_pct']:.1f}%, Green dom: {r['green_dominant_pct']:.1f}%, Blue dom: {r['blue_dominant_pct']:.1f}%")
    print(f"  Warm: {r['warm_pct']:.1f}%, Dark: {r['dark_pct']:.1f}%, Bright: {r['bright_pct']:.1f}%")
    print(f"  Top colors: {r['obj_top_colors'][:3]}")

print("\n" + "=" * 80)
print("TARGET IMAGES (to inspect)")
print("=" * 80)
for name, path in TARGETS.items():
    r = analyze_object_region(path)
    print(f"\n{name} (label: {name.replace('-', ' ').title()}):")
    print(f"  BG: {r['bg_color']}, Obj%: {r['obj_pct']:.1f}%, Obj brightness: {r['obj_brightness']:.1f}")
    print(f"  Red dom: {r['red_dominant_pct']:.1f}%, Green dom: {r['green_dominant_pct']:.1f}%, Blue dom: {r['blue_dominant_pct']:.1f}%")
    print(f"  Warm: {r['warm_pct']:.1f}%, Dark: {r['dark_pct']:.1f}%, Bright: {r['bright_pct']:.1f}%")
    print(f"  Top colors: {r['obj_top_colors'][:5]}")
    print(f"  Obj pixels: {r['obj_pixel_count']}")