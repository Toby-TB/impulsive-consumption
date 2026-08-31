#!/usr/bin/env python3
"""Comprehensive cell analysis for 4x2 product montage."""

import numpy as np
from PIL import Image
import json, os, sys

# ── Load full image ──────────────────────────────────────────────
IMG_PATH = "/home/vaga/DSH_Projects/Project_impulsive consumption/tool/montage_new_1.png"
full = Image.open(IMG_PATH).convert("RGB")
W, H = full.size  # 1700 x 1200
print(f"Full image: {W}x{H}")

# ── Grid parameters ──────────────────────────────────────────────
COLS, ROWS = 4, 2
COL_W = W // COLS  # 425
ROW_H = H // ROWS  # 600
LABEL_H = 60       # bottom label area

# ── Expected labels ──────────────────────────────────────────────
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

# ── Crop and save cells ──────────────────────────────────────────
os.makedirs("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells", exist_ok=True)

cells = {}
for r in range(ROWS):
    for c in range(COLS):
        x0, y0 = c * COL_W, r * ROW_H
        x1, y1 = x0 + COL_W, y0 + ROW_H
        cell_img = full.crop((x0, y0, x1, y1))
        cells[(r,c)] = cell_img
        cell_img.save(f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/cell_{r}_{c}.png")

# ── Analysis functions ───────────────────────────────────────────

def color_analysis(arr):
    """Comprehensive color analysis."""
    arr_f = arr.astype(np.float64)
    mean_rgb = arr_f.mean(axis=(0,1))
    std_rgb = arr_f.std(axis=(0,1))
    median_rgb = np.median(arr_f, axis=(0,1))

    # Dominant colors (quantized)
    q = (arr // 32).reshape(-1, 3)
    colors, counts = np.unique(q, axis=0, return_counts=True)
    top_idx = np.argsort(-counts)[:5]
    dominant = [(tuple(colors[i]), int(counts[i])) for i in top_idx]

    # Colorfulness (Hasler-Susstrunk)
    rg = arr_f[:,:,0] - arr_f[:,:,1]
    yb = 0.5 * (arr_f[:,:,0] + arr_f[:,:,1]) - arr_f[:,:,2]
    std_rg, std_yb = rg.std(), yb.std()
    mean_rg, mean_yb = rg.mean(), yb.mean()
    colorfulness = np.sqrt(std_rg**2 + std_yb**2) + 0.3 * np.sqrt(mean_rg**2 + mean_yb**2)

    # Brightness
    gray = 0.299 * arr_f[:,:,0] + 0.587 * arr_f[:,:,1] + 0.114 * arr_f[:,:,2]
    brightness_mean = gray.mean()
    brightness_std = gray.std()

    # Saturation
    max_c = arr_f.max(axis=2)
    min_c = arr_f.min(axis=2)
    sat = np.where(max_c > 0, (max_c - min_c) / np.maximum(max_c, 1), 0)
    sat_mean = sat.mean()

    # Warmth (R-B)
    warmth = (arr_f[:,:,0] - arr_f[:,:,2]).mean()

    # Channel-specific: check for wood tones (high R, medium G, low B)
    r_ch = arr_f[:,:,0]
    g_ch = arr_f[:,:,1]
    b_ch = arr_f[:,:,2]
    wood_mask = (r_ch > 120) & (r_ch > g_ch) & (g_ch > b_ch) & (r_ch - b_ch > 30)
    wood_frac = wood_mask.mean()

    # Blue dominance (for sky/water/background)
    blue_mask = (b_ch > r_ch) & (b_ch > g_ch)
    blue_frac = blue_mask.mean()

    # Green dominance
    green_mask = (g_ch > r_ch) & (g_ch > b_ch)
    green_frac = green_mask.mean()

    # White/light gray dominance
    light_mask = (r_ch > 200) & (g_ch > 200) & (b_ch > 200)
    light_frac = light_mask.mean()

    # Dark dominance
    dark_mask = (r_ch < 60) & (g_ch < 60) & (b_ch < 60)
    dark_frac = dark_mask.mean()

    return {
        "mean_rgb": [round(v, 1) for v in mean_rgb],
        "std_rgb": [round(v, 1) for v in std_rgb],
        "median_rgb": [round(v, 1) for v in median_rgb],
        "dominant_quantized": [(list(c), cnt) for c, cnt in dominant],
        "colorfulness": round(colorfulness, 2),
        "brightness_mean": round(brightness_mean, 1),
        "brightness_std": round(brightness_std, 1),
        "saturation_mean": round(sat_mean, 3),
        "warmth": round(warmth, 1),
        "wood_tone_frac": round(wood_frac, 4),
        "blue_frac": round(blue_frac, 4),
        "green_frac": round(green_frac, 4),
        "light_frac": round(light_frac, 4),
        "dark_frac": round(dark_frac, 4),
    }

def edge_analysis(arr):
    """Edge detection and analysis."""
    gray = 0.299 * arr[:,:,0].astype(np.float64) + 0.587 * arr[:,:,1].astype(np.float64) + 0.114 * arr[:,:,2].astype(np.float64)
    gray_u8 = np.clip(gray, 0, 255).astype(np.uint8)

    from scipy.ndimage import sobel, gaussian_filter
    sx = sobel(gray_u8, axis=1)
    sy = sobel(gray_u8, axis=0)
    mag = np.sqrt(sx**2 + sy**2)

    edges = mag > mag.mean() + mag.std()
    edge_density = edges.mean()

    # Edge orientation
    angles = np.arctan2(sy[edges], sx[edges]) * 180 / np.pi
    bins = ((angles + 180) // 45).astype(int) % 8
    hist, _ = np.histogram(bins, bins=8, range=(0,8))
    hist_pct = (hist / hist.sum() * 100).round(1).tolist() if hist.sum() > 0 else [0]*8

    strong_edges = mag > mag.mean() + 2 * mag.std()
    strong_density = strong_edges.mean()

    # Horizontal vs vertical edge dominance
    h_edges = np.abs(sx).mean()
    v_edges = np.abs(sy).mean()

    return {
        "edge_density": round(edge_density, 4),
        "edge_magnitude_mean": round(mag.mean(), 2),
        "edge_magnitude_std": round(mag.std(), 2),
        "edge_orientation_hist": hist_pct,
        "strong_edge_density": round(strong_density, 4),
        "horizontal_edge_energy": round(h_edges, 2),
        "vertical_edge_energy": round(v_edges, 2),
        "hv_ratio": round(h_edges / max(v_edges, 0.01), 2),
    }

def texture_analysis(arr):
    """Texture analysis via GLCM."""
    from skimage.feature import graycomatrix, graycoprops
    gray = 0.299 * arr[:,:,0].astype(np.float64) + 0.587 * arr[:,:,1].astype(np.float64) + 0.114 * arr[:,:,2].astype(np.float64)
    gray_u8 = np.clip(gray, 0, 255).astype(np.uint8)

    h, w = gray_u8.shape
    if max(h, w) > 400:
        scale = 400 / max(h, w)
        gray_u8 = np.array(Image.fromarray(gray_u8).resize((int(w*scale), int(h*scale))))

    glcm = graycomatrix(gray_u8, distances=[1], angles=[0, np.pi/4, np.pi/2, 3*np.pi/4],
                         levels=64, symmetric=True, normalized=True)

    return {
        "contrast": round(graycoprops(glcm, 'contrast').mean(), 4),
        "dissimilarity": round(graycoprops(glcm, 'dissimilarity').mean(), 4),
        "homogeneity": round(graycoprops(glcm, 'homogeneity').mean(), 4),
        "energy": round(graycoprops(glcm, 'energy').mean(), 6),
        "correlation": round(graycoprops(glcm, 'correlation').mean(), 4),
    }

def shape_analysis(arr):
    """Shape characteristics from contours."""
    import cv2
    gray = cv2.cvtColor(arr, cv2.COLOR_RGB2GRAY)
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)

    _, thresh = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if not contours:
        return {"num_contours": 0, "note": "no contours found"}

    areas = [cv2.contourArea(c) for c in contours]
    areas_sorted = sorted(areas, reverse=True)
    total_area = gray.shape[0] * gray.shape[1]

    top_contours = sorted(contours, key=cv2.contourArea, reverse=True)[:5]
    bboxes = []
    for c in top_contours:
        x, y, w, h = cv2.boundingRect(c)
        bboxes.append({"x": x, "y": y, "w": w, "h": h,
                       "area_frac": round(cv2.contourArea(c)/total_area, 4)})

    aspects = []
    for c in top_contours:
        x, y, w, h = cv2.boundingRect(c)
        if h > 0:
            aspects.append(round(w/h, 3))

    hu = []
    for c in top_contours[:3]:
        moments = cv2.moments(c)
        hu_m = cv2.HuMoments(moments).flatten()
        hu.append([round(h, 6) for h in hu_m])

    # Circularity of largest contour
    largest = contours[np.argmax(areas)]
    perimeter = cv2.arcLength(largest, True)
    area_largest = cv2.contourArea(largest)
    circularity = (4 * np.pi * area_largest) / (perimeter * perimeter) if perimeter > 0 else 0

    return {
        "num_contours": len(contours),
        "largest_contour_area_frac": round(areas_sorted[0]/total_area, 4) if areas_sorted else 0,
        "largest_contour_circularity": round(circularity, 4),
        "top_contour_bboxes": bboxes,
        "top_contour_aspects": aspects,
        "hu_moments_top3": hu,
        "foreground_fraction": round(1 - (thresh == 0).mean(), 4),
    }

def label_ocr(arr):
    """OCR on the label area."""
    import pytesseract
    gray = 0.299 * arr[:,:,0].astype(np.float64) + 0.587 * arr[:,:,1].astype(np.float64) + 0.114 * arr[:,:,2].astype(np.float64)
    gray_u8 = np.clip(gray, 0, 255).astype(np.uint8)

    if gray_u8.mean() < 128:
        gray_u8 = 255 - gray_u8

    h, w = gray_u8.shape
    gray_u8 = np.array(Image.fromarray(gray_u8).resize((w*3, h*3), Image.LANCZOS))

    configs = [
        '--psm 7 -c tessedit_char_whitelist=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ',
        '--psm 6',
        '--psm 8',
        '--psm 13',
    ]
    texts = []
    for cfg in configs:
        try:
            t = pytesseract.image_to_string(gray_u8, config=cfg).strip()
            if t:
                texts.append(t)
        except:
            pass
    return texts

def brightness_profile(arr):
    """Horizontal and vertical brightness profiles."""
    gray = 0.299 * arr[:,:,0].astype(np.float64) + 0.587 * arr[:,:,1].astype(np.float64) + 0.114 * arr[:,:,2].astype(np.float64)
    row_means = gray.mean(axis=1)
    col_means = gray.mean(axis=0)
    return {
        "row_means_sampled": [round(v, 1) for v in row_means[::15]],
        "col_means_sampled": [round(v, 1) for v in col_means[::15]],
        "row_gradient": round(abs(row_means[-1] - row_means[0]), 1),
        "col_gradient": round(abs(col_means[-1] - col_means[0]), 1),
        "row_top_third": round(gray[:gray.shape[0]//3].mean(), 1),
        "row_mid_third": round(gray[gray.shape[0]//3:2*gray.shape[0]//3].mean(), 1),
        "row_bottom_third": round(gray[2*gray.shape[0]//3:].mean(), 1),
    }

def spatial_frequency(arr):
    """Spatial frequency analysis - high frequency content."""
    gray = 0.299 * arr[:,:,0].astype(np.float64) + 0.587 * arr[:,:,1].astype(np.float64) + 0.114 * arr[:,:,2].astype(np.float64)
    # 2D FFT
    f = np.fft.fft2(gray)
    fshift = np.fft.fftshift(f)
    magnitude = np.abs(fshift)

    h, w = magnitude.shape
    # High frequency energy (outer 30% of spectrum)
    cy, cx = h//2, w//2
    mask = np.ones((h, w), dtype=bool)
    mask[cy-int(h*0.35):cy+int(h*0.35), cx-int(w*0.35):cx+int(w*0.35)] = False
    hf_energy = (magnitude[mask].mean() / max(magnitude.mean(), 0.01))

    return {
        "high_freq_ratio": round(hf_energy, 2),
        "total_fft_energy": round(magnitude.mean(), 2),
    }

# ── Run analysis ─────────────────────────────────────────────────
results = {}

for r in range(ROWS):
    for c in range(COLS):
        print(f"\n{'='*60}")
        print(f"CELL [{r},{c}] — Expected: {EXPECTED[(r,c)][0]} / {EXPECTED[(r,c)][1]}")
        print(f"{'='*60}")

        cell_img = cells[(r,c)]
        arr = np.array(cell_img)

        img_area = arr[:-LABEL_H, :, :]
        label_area = arr[-LABEL_H:, :, :]

        Image.fromarray(img_area).save(f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/cell_{r}_{c}_img.png")
        Image.fromarray(label_area).save(f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/cell_{r}_{c}_label.png")

        print(f"  Image area: {img_area.shape}, Label area: {label_area.shape}")

        print("  Color analysis...")
        color = color_analysis(img_area)

        print("  Edge analysis...")
        edges = edge_analysis(img_area)

        print("  Texture analysis...")
        try:
            texture = texture_analysis(img_area)
        except Exception as e:
            texture = {"error": str(e)}
            print(f"  Texture error: {e}")

        print("  Shape analysis...")
        try:
            shape = shape_analysis(img_area)
        except Exception as e:
            shape = {"error": str(e)}
            print(f"  Shape error: {e}")

        print("  Brightness profile...")
        bp = brightness_profile(img_area)

        print("  Spatial frequency...")
        sf = spatial_frequency(img_area)

        print("  Label OCR...")
        ocr_texts = label_ocr(label_area)
        label_color = color_analysis(label_area)

        label_gray = 0.299 * label_area[:,:,0].astype(np.float64) + 0.587 * label_area[:,:,1].astype(np.float64) + 0.114 * label_area[:,:,2].astype(np.float64)
        label_edge_density = (np.abs(np.diff(label_gray, axis=1)) > 10).mean()

        results[(r,c)] = {
            "expected_id": EXPECTED[(r,c)][0],
            "expected_label": EXPECTED[(r,c)][1],
            "image_area": {
                "color": color,
                "edges": edges,
                "texture": texture,
                "shape": shape,
                "brightness_profile": bp,
                "spatial_frequency": sf,
            },
            "label_area": {
                "ocr_texts": ocr_texts,
                "color": label_color,
                "edge_density": round(label_edge_density, 4),
                "mean_brightness": round(label_gray.mean(), 1),
            },
        }

        print(f"\n  --- SUMMARY ---")
        print(f"  OCR texts: {ocr_texts}")
        print(f"  Color: mean_rgb={color['mean_rgb']}, brightness={color['brightness_mean']}, sat={color['saturation_mean']}")
        print(f"  Color fractions: wood={color['wood_tone_frac']}, blue={color['blue_frac']}, green={color['green_frac']}, light={color['light_frac']}, dark={color['dark_frac']}")
        print(f"  Edges: density={edges['edge_density']}, strong={edges['strong_edge_density']}, h/v={edges['hv_ratio']}")
        if 'contrast' in texture:
            print(f"  Texture: contrast={texture['contrast']}, homogeneity={texture['homogeneity']}, energy={texture['energy']}")
        if 'num_contours' in shape:
            print(f"  Shape: contours={shape['num_contours']}, fg_frac={shape.get('foreground_fraction', 'N/A')}, circularity={shape.get('largest_contour_circularity', 'N/A')}")
        print(f"  Spatial freq: hf_ratio={sf['high_freq_ratio']}")
        print(f"  Brightness thirds: top={bp['row_top_third']}, mid={bp['row_mid_third']}, bot={bp['row_bottom_third']}")

# ── Save results ─────────────────────────────────────────────────
with open("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cell_analysis.json", "w") as f:
    json.dump({f"{r},{c}": v for (r,c), v in results.items()}, f, indent=2, ensure_ascii=False, default=str)

print("\n\n=== ANALYSIS COMPLETE ===")
print("Results saved to cell_analysis.json")