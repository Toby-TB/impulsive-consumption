#!/usr/bin/env python3
"""Final comprehensive analysis and report generation."""

import numpy as np
from PIL import Image
import json, warnings
warnings.filterwarnings('ignore')

IMG_PATH = "/home/vaga/DSH_Projects/Project_impulsive consumption/tool/montage_new_1.png"
full = Image.open(IMG_PATH).convert("RGB")
W, H = full.size  # 1700 x 1200

COLS, ROWS = 4, 2
COL_W = W // COLS  # 425
ROW_H = H // ROWS  # 600
LABEL_H = 60

EXPECTED = {
    (0,0): ("standing-desk", "电动升降桌"),
    (0,1): ("led-desk-lamp", "LED 护眼台灯"),
    (0,2): ("memory-mattress", "记忆棉床垫"),
    (0,3): ("bookshelf", "六格书柜"),
    (1,0): ("storage-box", "加厚收纳箱三件套"),
    (1,1): ("nike-sneaker", "Nike 缓震运动鞋"),
    (1,2): ("adidas-hoodie", "Adidas 经典卫衣"),
    (1,3): ("levi-jeans", "Levi's 501 牛仔裤"),
}

# Load all analysis results
with open("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cell_analysis_v2.json") as f:
    v2 = json.load(f)
with open("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/label_analysis.json") as f:
    label = json.load(f)
with open("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/final_ocr_results.json") as f:
    ocr = json.load(f)

# ── Generate report ──────────────────────────────────────────────
print("=" * 80)
print("COMPREHENSIVE PRODUCT MONTAGE ANALYSIS REPORT")
print("=" * 80)
print(f"Image: {W}x{H}, Grid: {COLS}x{ROWS}, Cell size: {COL_W}x{ROW_H}")
print(f"Label height: {LABEL_H}px")
print()

for r in range(ROWS):
    for c in range(COLS):
        key = f"{r},{c}"
        exp_id, exp_label = EXPECTED[(r,c)]
        d = v2[key]
        l = label[key]
        o = ocr.get(key, [])

        img = d["image_area"]
        color = img["color"]
        edges = img["edges"]
        shape = img["shape"]
        sf = img["spatial_frequency"]
        bp = img["brightness_profile"]
        hist = img["histogram"]
        lp = l["label_pattern"]
        pf = l["product_features"]

        print(f"\n{'─'*80}")
        print(f"CELL [{r},{c}] | Expected: {exp_id} / {exp_label}")
        print(f"{'─'*80}")

        # OCR
        ocr_text = ", ".join(f"[{m}]: '{t}'" for m, t in o) if o else "NONE DETECTED"
        print(f"  OCR: {ocr_text}")

        # Label analysis
        print(f"  Label bg: RGB{lp['label_rgb']}, contrast={lp['contrast']}, "
              f"text_transitions={lp['text_transitions']}, "
              f"gray_range=[{lp['brightness_range'][0]:.0f}, {lp['brightness_range'][1]:.0f}]")

        # Color analysis
        print(f"  Color: RGB={color['mean_rgb']}, brightness={color['brightness_mean']}, "
              f"saturation={color['saturation_mean']}, colorfulness={color['colorfulness']}")
        print(f"  Color fractions: wood={color['wood_tone_frac']}, blue={color['blue_frac']}, "
              f"green={color['green_frac']}, light={color['light_frac']}, "
              f"dark={color['dark_frac']}, red_dom={color['red_dominant_frac']}")
        print(f"  Colorfulness: {color['colorfulness']}")

        # Expected color match (computed inline)
        profiles = {
            "standing-desk": {"desc": "wood/warm tones", "r": 180, "g": 140, "b": 100},
            "led-desk-lamp": {"desc": "white/metal/warm light", "r": 220, "g": 210, "b": 180},
            "memory-mattress": {"desc": "white/light gray", "r": 230, "g": 230, "b": 235},
            "bookshelf": {"desc": "wood brown", "r": 160, "g": 110, "b": 70},
            "storage-box": {"desc": "plastic various colors", "r": 150, "g": 150, "b": 150},
            "nike-sneaker": {"desc": "white/sport colors", "r": 200, "g": 200, "b": 200},
            "adidas-hoodie": {"desc": "fabric color", "r": 160, "g": 160, "b": 170},
            "levi-jeans": {"desc": "blue denim", "r": 70, "g": 90, "b": 140},
        }
        exp = profiles.get(exp_id, {"desc": "unknown", "r": 128, "g": 128, "b": 128})
        cd_dist = np.sqrt((color['mean_rgb'][0] - exp['r'])**2 + (color['mean_rgb'][1] - exp['g'])**2 + (color['mean_rgb'][2] - exp['b'])**2)
        cd_quality = "good" if cd_dist < 60 else ("moderate" if cd_dist < 120 else "poor")
        print(f"  Expected color: {exp['desc']} → RGB[{exp['r']},{exp['g']},{exp['b']}]")
        print(f"  Color distance: {cd_dist:.0f} ({cd_quality})")

        # Edge analysis
        print(f"  Edges: density={edges['edge_density']}, strong={edges['strong_edge_density']}, "
              f"h/v_ratio={edges['hv_ratio']}")
        print(f"  Edge orientation: H={edges['edge_orientation_hist'][0]}%, "
              f"V={edges['edge_orientation_hist'][2]}%, "
              f"D1={edges['edge_orientation_hist'][1]}%, "
              f"D2={edges['edge_orientation_hist'][3]}%")

        # Shape analysis
        if 'num_contours' in shape:
            print(f"  Shape: contours={shape['num_contours']}, "
                  f"fg_frac={shape['foreground_fraction']}, "
                  f"circularity={shape['largest_contour_circularity']}")
            bboxes = shape.get('top_contour_bboxes', [])
            if bboxes:
                top = bboxes[0]
                print(f"  Largest bbox: {top['w']}x{top['h']} at ({top['x']},{top['y']}), "
                      f"area_frac={top['area_frac']}")

        # Texture
        if 'contrast' in img['texture']:
            t = img['texture']
            print(f"  Texture: contrast={t['contrast']}, homogeneity={t['homogeneity']}, "
                  f"energy={t['energy']}, correlation={t['correlation']}")

        # Spatial frequency
        print(f"  Spatial freq: HF ratio={sf['high_freq_ratio']}")

        # Brightness profile
        print(f"  Brightness: top={bp['row_top_third']}, mid={bp['row_mid_third']}, "
              f"bot={bp['row_bottom_third']}, gradient={bp['row_gradient']}")

        # Histogram peaks
        print(f"  Histogram peaks: R{hist['r_peaks']}, G{hist['g_peaks']}, B{hist['b_peaks']}")

        # Product-specific features
        if pf:
            print(f"  Product features: {pf}")

        # Label text transitions vs expected
        char_counts = {
            "standing-desk": 5, "led-desk-lamp": 7, "memory-mattress": 5,
            "bookshelf": 4, "storage-box": 9, "nike-sneaker": 8,
            "adidas-hoodie": 8, "levi-jeans": 9,
        }
        expected_chars = char_counts.get(exp_id, '?')
        print(f"  Expected label chars: ~{expected_chars} (Chinese + English)")

        # ── Mismatch Assessment ──
        print(f"\n  --- MISMATCH ASSESSMENT ---")
        issues = []

        # Check 1: Color distance
        if cd_dist > 120:
            issues.append(f"Color distance {cd_dist:.0f} is very high (expected {exp['desc']})")

        # Check 2: Product-specific feature mismatches
        if exp_id == "standing-desk" and color['wood_tone_frac'] < 0.10:
            issues.append(f"Low wood tone ({color['wood_tone_frac']}) for a standing desk - expected wood grain")

        if exp_id == "led-desk-lamp" and color['brightness_mean'] < 150:
            issues.append(f"Low brightness ({color['brightness_mean']}) for a lamp - expected bright light source")

        if exp_id == "memory-mattress":
            if shape.get('largest_contour_circularity', 0) > 0.75:
                issues.append(f"High circularity ({shape['largest_contour_circularity']}) for a mattress - expected rectangular shape")
            if bp['row_top_third'] > bp['row_bottom_third'] + 30:
                issues.append(f"Top much brighter than bottom - unusual for mattress layout")

        if exp_id == "bookshelf":
            if shape.get('num_contours', 0) < 50:
                issues.append(f"Low contour count ({shape['num_contours']}) for a bookshelf - expected many compartments")

        if exp_id == "storage-box":
            if 'BB0K8' in str(o) or 'BOOK' in str(o).upper():
                issues.append(f"OCR detected 'BOOKS'-like text, not storage boxes")
            if color['green_frac'] > 0.15:
                issues.append(f"High green fraction ({color['green_frac']}) - unexpected for plastic storage boxes")

        if exp_id == "nike-sneaker":
            if pf.get('bottom_heavy', 0) < -30:
                issues.append(f"Bottom darker than top ({pf['bottom_heavy']}) - sneakers usually have bright white soles")

        if exp_id == "adidas-hoodie":
            if pf.get('edge_softness', 1) < 0.85:
                issues.append(f"Edge softness {pf['edge_softness']} - hoodie should have very soft edges")

        if exp_id == "levi-jeans":
            if color['saturation_mean'] < 0.10:
                issues.append(f"VERY low saturation ({color['saturation_mean']}) - Levi's 501 should be blue denim")
            if pf.get('denim_blue_frac', 1) < 0.15:
                issues.append(f"Very low denim blue fraction ({pf['denim_blue_frac']}) - expected blue denim")
            if abs(color['mean_rgb'][0] - color['mean_rgb'][2]) < 10:
                issues.append(f"R≈B ({color['mean_rgb'][0]} vs {color['mean_rgb'][2]}) - denim should have B > R")

        # Check 3: OCR mismatch
        if o and any('BOOK' in t.upper() or 'B00K' in t for _, t in o):
            if exp_id != "bookshelf":
                issues.append(f"OCR suggests 'BOOKS' but label says '{exp_id}'")

        if not issues:
            print("  No significant mismatches detected by metrics.")
        else:
            for i, issue in enumerate(issues, 1):
                print(f"  {i}. {issue}")

        # Verdict
        if len(issues) >= 3:
            verdict = "STRONG MISMATCH"
        elif len(issues) >= 1:
            verdict = "POSSIBLE MISMATCH"
        else:
            verdict = "APPEARS TO MATCH"
        print(f"  VERDICT: {verdict}")

print(f"\n{'='*80}")
print("END OF REPORT")
print(f"{'='*80}")