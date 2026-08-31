#!/usr/bin/env python3
"""Label area analysis - understand what's in the label strip of each cell."""

import numpy as np
from PIL import Image
import json, warnings, sys
warnings.filterwarnings('ignore')

IMG_PATH = "/home/vaga/DSH_Projects/Project_impulsive consumption/tool/montage_new_1.png"
full = Image.open(IMG_PATH).convert("RGB")
W, H = full.size

COLS, ROWS = 4, 2
COL_W = W // COLS
ROW_H = H // ROWS
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

# ── Analyze label area pixel patterns ────────────────────────────
def analyze_label_pattern(arr):
    """Analyze the pattern in the label strip to detect text presence and characteristics."""
    h, w = arr.shape[:2]
    gray = 0.299*arr[:,:,0].astype(np.float64) + 0.587*arr[:,:,1].astype(np.float64) + 0.114*arr[:,:,2].astype(np.float64)

    # Horizontal projection (sum across columns) - text creates dips/peaks
    row_proj = gray.mean(axis=1)
    col_proj = gray.mean(axis=0)

    # Text detection: look for high-frequency variation in column direction
    col_diff = np.abs(np.diff(col_proj))
    col_variation = col_diff.mean()
    col_variation_std = col_diff.std()

    # Count "text-like" transitions (sharp changes)
    text_transitions = np.sum(col_diff > 10)

    # Check if there's a clear background/text contrast
    bg_color = np.median(gray)
    text_color_range = (gray.min(), gray.max())
    contrast = gray.std()

    # Check for colored vs grayscale label
    r, g, b = arr[:,:,0].astype(np.float64), arr[:,:,1].astype(np.float64), arr[:,:,2].astype(np.float64)
    is_grayscale = np.allclose(r, g, atol=5) and np.allclose(g, b, atol=5)

    # Dominant color of label
    label_rgb = [round(float(arr[:,:,i].mean()),1) for i in range(3)]

    # Check if label has a solid color background
    unique_colors = len(np.unique(arr.reshape(-1, 3), axis=0))
    is_solid_bg = unique_colors < 100

    return {
        "label_rgb": label_rgb,
        "is_grayscale": bool(is_grayscale),
        "unique_colors": unique_colors,
        "is_solid_bg": is_solid_bg,
        "contrast": round(float(contrast),1),
        "col_variation": round(float(col_variation),2),
        "text_transitions": int(text_transitions),
        "bg_brightness": round(float(bg_color),1),
        "brightness_range": [round(float(gray.min()),1), round(float(gray.max()),1)],
        "row_profile": [round(float(v),1) for v in row_proj],
        "col_profile_sampled": [round(float(v),1) for v in col_proj[::20]],
    }

# ── Quick OCR with pytesseract ──────────────────────────────────
def quick_ocr(arr):
    """Quick OCR attempt with basic preprocessing."""
    import pytesseract
    gray = 0.299*arr[:,:,0].astype(np.float64) + 0.587*arr[:,:,1].astype(np.float64) + 0.114*arr[:,:,2].astype(np.float64)
    gray_u8 = np.clip(gray, 0, 255).astype(np.uint8)

    # Try different thresholds
    results = []

    # Method 1: Otsu binary
    import cv2
    _, binary = cv2.threshold(gray_u8, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    # Check which polarity has more black (text)
    if (binary == 0).mean() > 0.5:
        binary = 255 - binary

    img = Image.fromarray(binary).resize((binary.shape[1]*3, binary.shape[0]*3), Image.NEAREST)
    tmp = "/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/_quick_ocr.png"
    img.save(tmp)

    for psm in [6, 7, 8, 11, 12, 13]:
        try:
            t = pytesseract.image_to_string(tmp, config=f'--psm {psm}').strip()
            if t and len(t) > 1:
                results.append((f"psm{psm}", t))
        except:
            pass

    # Method 2: Raw grayscale
    img2 = Image.fromarray(gray_u8).resize((gray_u8.shape[1]*3, gray_u8.shape[0]*3), Image.LANCZOS)
    img2.save(tmp)
    for psm in [6, 7, 8]:
        try:
            t = pytesseract.image_to_string(tmp, config=f'--psm {psm}').strip()
            if t and len(t) > 1:
                results.append((f"gray_psm{psm}", t))
        except:
            pass

    return results

# ── Analyze image area for product-specific features ────────────
def product_features(arr, product_id):
    """Check for features specific to each product type."""
    import cv2
    gray = cv2.cvtColor(arr, cv2.COLOR_RGB2GRAY)
    h, w = gray.shape

    features = {}

    if product_id == "standing-desk":
        # Desk: look for horizontal lines (desktop), vertical lines (legs)
        edges = cv2.Canny(gray, 50, 150)
        # Count horizontal vs vertical lines using projection
        row_edges = edges.mean(axis=1)
        col_edges = edges.mean(axis=0)
        features["horizontal_line_strength"] = round(float(row_edges.mean()), 2)
        features["vertical_line_strength"] = round(float(col_edges.mean()), 2)
        # Check for large flat area at top (desktop)
        top_third = gray[:h//3, :]
        features["top_flatness"] = round(float(top_third.std()), 1)

    elif product_id == "led-desk-lamp":
        # Lamp: look for concentrated bright spots (light source)
        _, bright = cv2.threshold(gray, 200, 255, cv2.THRESH_BINARY)
        bright_frac = bright.mean() / 255.0
        features["bright_spot_fraction"] = round(float(bright_frac), 4)
        # Look for vertical structure (lamp stand)
        col_proj = gray.mean(axis=0)
        features["center_brightness_peak"] = round(float(col_proj[w//2] - col_proj.mean()), 1)

    elif product_id == "memory-mattress":
        # Mattress: large rectangular shape, horizontal orientation
        features["aspect_ratio"] = round(float(w/h), 3)
        # Check for large uniform area (mattress surface)
        features["uniformity"] = round(float(1 - gray.std()/255), 4)

    elif product_id == "bookshelf":
        # Bookshelf: grid-like structure, many vertical/horizontal lines
        edges = cv2.Canny(gray, 50, 150)
        row_edges = edges.mean(axis=1)
        col_edges = edges.mean(axis=0)
        # Count peaks in edge projections (shelf boards, vertical dividers)
        from scipy.signal import find_peaks
        row_peaks, _ = find_peaks(row_edges, height=row_edges.mean(), distance=10)
        col_peaks, _ = find_peaks(col_edges, height=col_edges.mean(), distance=10)
        features["row_edge_peaks"] = len(row_peaks)
        features["col_edge_peaks"] = len(col_peaks)
        features["grid_regularity"] = round(float(len(row_peaks) * len(col_peaks)), 1)

    elif product_id == "storage-box":
        # Storage boxes: rectangular shapes, possibly stacked
        features["aspect_ratio"] = round(float(w/h), 3)

    elif product_id == "nike-sneaker":
        # Sneaker: irregular shape, typically in lower portion of image
        # Check bottom-heavy distribution
        bottom_half = gray[h//2:, :]
        top_half = gray[:h//2, :]
        features["bottom_brightness"] = round(float(bottom_half.mean()), 1)
        features["top_brightness"] = round(float(top_half.mean()), 1)
        features["bottom_heavy"] = round(float(bottom_half.mean() - top_half.mean()), 1)

    elif product_id == "adidas-hoodie":
        # Hoodie: fabric texture, soft edges
        features["edge_softness"] = round(float(1 - cv2.Canny(gray, 50, 150).mean()/255), 4)
        # Check for fabric-like texture (low frequency content)
        f = np.fft.fft2(gray)
        fshift = np.fft.fftshift(f)
        mag = np.abs(fshift)
        cy, cx = h//2, w//2
        low_freq = mag[cy-20:cy+20, cx-20:cx+20].mean()
        high_freq = mag[cy-100:cy+100, cx-100:cx+100].mean()
        features["low_freq_ratio"] = round(float(low_freq/max(high_freq, 0.01)), 2)

    elif product_id == "levi-jeans":
        # Jeans: blue denim color, fabric texture
        r, g, b = arr[:,:,0].astype(np.float64), arr[:,:,1].astype(np.float64), arr[:,:,2].astype(np.float64)
        # Denim blue: B > R, moderate saturation
        blue_denim = ((b > r) & (b > g) & (b - r > 10) & (b - r < 80)).mean()
        features["denim_blue_frac"] = round(float(blue_denim), 4)
        # Check for diagonal twill lines
        features["edge_diagonal_strength"] = round(float(np.abs(np.diff(gray, axis=0)).mean()), 2)

    return features

# ── Run analysis ─────────────────────────────────────────────────
print("Running label and feature analysis...\n")

all_results = {}

for r in range(ROWS):
    for c in range(COLS):
        print(f"\n{'='*60}")
        print(f"CELL [{r},{c}] — {EXPECTED[(r,c)][0]} / {EXPECTED[(r,c)][1]}")
        print(f"{'='*60}")

        x0, y0 = c * COL_W, r * ROW_H
        cell = np.array(full.crop((x0, y0, x0+COL_W, y0+ROW_H)))
        img_area = cell[:-LABEL_H, :, :]
        label_area = cell[-LABEL_H:, :, :]

        # Label analysis
        print("  Label pattern analysis...")
        label_pattern = analyze_label_pattern(label_area)
        print(f"  Label: rgb={label_pattern['label_rgb']}, gray={label_pattern['is_grayscale']}, "
              f"solid={label_pattern['is_solid_bg']}, contrast={label_pattern['contrast']}, "
              f"transitions={label_pattern['text_transitions']}")

        # Quick OCR
        print("  Quick OCR...")
        ocr_results = quick_ocr(label_area)
        print(f"  OCR: {ocr_results}")

        # Product-specific features
        print("  Product-specific features...")
        features = product_features(img_area, EXPECTED[(r,c)][0])
        print(f"  Features: {features}")

        all_results[(r,c)] = {
            "expected": EXPECTED[(r,c)],
            "label_pattern": label_pattern,
            "ocr_results": ocr_results,
            "product_features": features,
        }

# Save results
with open("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/label_analysis.json", "w") as f:
    json.dump({f"{r},{c}": v for (r,c), v in all_results.items()}, f, indent=2, ensure_ascii=False, default=str)

print("\n\n=== LABEL ANALYSIS COMPLETE ===")