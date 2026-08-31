#!/usr/bin/env python3
"""Pure Python PNG analyzer - decodes PNG and extracts color/feature data."""
import struct, zlib, sys, os
from collections import Counter

def read_png(path):
    with open(path, 'rb') as f:
        data = f.read()
    if data[:8] != b'\x89PNG\r\n\x1a\n':
        raise ValueError('Not a PNG file')
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
    """Unfilter PNG scanlines. color_type: 2=RGB, 6=RGBA, 0=grayscale"""
    if color_type == 2:
        bpp = 3
    elif color_type == 6:
        bpp = 4
    elif color_type == 0:
        bpp = 1
    else:
        raise ValueError(f'Unsupported color_type: {color_type}')
    stride = width * bpp
    rows = []
    prev = bytearray(stride)
    pos = 0
    for y in range(height):
        filter_type = raw[pos]
        pos += 1
        line = bytearray(raw[pos:pos+stride])
        pos += stride
        if filter_type == 1:  # Sub
            for i in range(bpp, stride):
                line[i] = (line[i] + line[i-bpp]) & 0xFF
        elif filter_type == 2:  # Up
            for i in range(stride):
                line[i] = (line[i] + prev[i]) & 0xFF
        elif filter_type == 3:  # Average
            for i in range(stride):
                left = line[i-bpp] if i >= bpp else 0
                up = prev[i]
                line[i] = (line[i] + (left + up)//2) & 0xFF
        elif filter_type == 4:  # Paeth
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

def analyze(path):
    w, h, bd, ct, raw = read_png(path)
    rows, bpp = unfilter_png(w, h, ct, raw)
    
    # Collect all pixels
    pixels = []
    for row in rows:
        for x in range(w):
            off = x * bpp
            if bpp == 3:
                pixels.append((row[off], row[off+1], row[off+2]))
            elif bpp == 4:
                pixels.append((row[off], row[off+1], row[off+2]))
            elif bpp == 1:
                pixels.append((row[off], row[off], row[off]))
    
    # Color analysis
    # Quantize to reduce noise
    q_counter = Counter()
    for r, g, b in pixels:
        qr = (r // 32) * 32
        qg = (g // 32) * 32
        qb = (b // 32) * 32
        q_counter[(qr, qg, qb)] += 1
    
    # Brightness analysis
    brightness = [(r+g+b)/3 for r,g,b in pixels]
    avg_brightness = sum(brightness) / len(brightness)
    
    # Color dominance
    total = len(pixels)
    top_colors = []
    for color, count in q_counter.most_common(15):
        pct = count / total * 100
        top_colors.append((color, count, pct))
    
    # Edge detection (simple horizontal difference)
    edge_count = 0
    for y in range(h):
        for x in range(1, w):
            off_prev = (x-1) * bpp
            off_curr = x * bpp
            row = rows[y]
            diff = abs(row[off_curr] - row[off_prev])
            if diff > 30:
                edge_count += 1
    
    # Check if image is mostly one color (placeholder)
    unique_colors = len(q_counter)
    top_pct = top_colors[0][2] if top_colors else 0
    
    # Check center region vs edges (for centered objects)
    center_pixels = []
    margin = w // 5
    for y in range(margin, h - margin):
        for x in range(margin, w - margin):
            off = x * bpp
            row = rows[y]
            center_pixels.append((row[off], row[off+1], row[off+2]))
    
    center_brightness = sum((r+g+b)/3 for r,g,b in center_pixels) / len(center_pixels) if center_pixels else 0
    
    # Background (corners) analysis
    corner_pixels = []
    for y in [0, h-1]:
        for x in [0, w-1]:
            for dy in range(3):
                for dx in range(3):
                    yy, xx = min(y+dy, h-1), min(x+dx, w-1)
                    off = xx * bpp
                    row = rows[yy]
                    corner_pixels.append((row[off], row[off+1], row[off+2]))
    
    corner_avg = tuple(sum(c[i] for c in corner_pixels)//len(corner_pixels) for i in range(3))
    
    return {
        'size': (w, h),
        'bpp': bpp,
        'avg_brightness': avg_brightness,
        'center_brightness': center_brightness,
        'corner_color': corner_avg,
        'unique_colors': unique_colors,
        'top_color_pct': top_pct,
        'edge_density': edge_count / total,
        'top_colors': top_colors,
    }

def classify(result):
    """Classify image type based on features."""
    cues = []
    
    # Check for placeholder/blank
    if result['unique_colors'] < 10:
        cues.append('PLACEHOLDER (very few colors)')
    elif result['top_color_pct'] > 80:
        cues.append('LIKELY_PLACEHOLDER (one color dominates)')
    
    # Check brightness
    if result['avg_brightness'] > 230:
        cues.append('VERY_BRIGHT (white background likely)')
    elif result['avg_brightness'] < 25:
        cues.append('VERY_DARK (black background likely)')
    
    # Check edge density
    if result['edge_density'] < 0.01:
        cues.append('SMOOTH (low detail)')
    elif result['edge_density'] > 0.15:
        cues.append('HIGH_DETAIL (lots of edges)')
    
    # Check center vs corner
    cb = result['corner_color']
    center_b = result['center_brightness']
    corner_b = sum(cb)/3
    if abs(center_b - corner_b) > 40:
        cues.append('CENTER_DIFFERS_FROM_CORNERS (object in center)')
    
    # Analyze dominant colors for product type hints
    top = result['top_colors']
    
    # Check for brown tones (coffee, chocolate, wood)
    brown_count = sum(cnt for color, cnt, pct in top if 80 < color[0] < 180 and 40 < color[1] < 120 and 10 < color[2] < 80)

    # Check for green (tea, olive oil, yoga mat)
    green_count = sum(cnt for color, cnt, pct in top if color[1] > color[0] and color[1] > color[2] and color[1] > 60)

    # Check for white/light gray (canvas, porcelain)
    white_count = sum(cnt for color, cnt, pct in top if color[0] > 200 and color[1] > 200 and color[2] > 200)

    # Check for dark colors (dark chocolate, electronics)
    dark_count = sum(cnt for color, cnt, pct in top if color[0] < 60 and color[1] < 60 and color[2] < 60)
    
    cues.append(f'BROWN_PX={brown_count}')
    cues.append(f'GREEN_PX={green_count}')
    cues.append(f'WHITE_PX={white_count}')
    cues.append(f'DARK_PX={dark_count}')
    
    return cues

if __name__ == '__main__':
    files = sys.argv[1:]
    for f in files:
        if not os.path.exists(f):
            print(f'{f}: FILE NOT FOUND')
            continue
        try:
            r = analyze(f)
            c = classify(r)
            print(f'\n=== {os.path.basename(f)} ===')
            print(f'Size: {r["size"][0]}x{r["size"][1]}, BPP: {r["bpp"]}')
            print(f'Avg brightness: {r["avg_brightness"]:.1f}')
            print(f'Center brightness: {r["center_brightness"]:.1f}')
            print(f'Corner color (RGB): {r["corner_color"]}')
            print(f'Unique quantized colors: {r["unique_colors"]}')
            print(f'Top color pct: {r["top_color_pct"]:.1f}%')
            print(f'Edge density: {r["edge_density"]:.4f}')
            print(f'Top 5 colors (quantized):')
            for color, cnt, pct in r['top_colors'][:5]:
                print(f'  RGB{color}: {cnt}px ({pct:.1f}%)')
            print(f'Classification cues: {", ".join(c)}')
        except Exception as e:
            print(f'\n=== {os.path.basename(f)} ===')
            print(f'ERROR: {e}')