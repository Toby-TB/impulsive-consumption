#!/usr/bin/env python3
"""Comprehensive cell analysis v2 - fixed OCR, edges, texture."""

import numpy as np
from PIL import Image
import json, os, sys, warnings
warnings.filterwarnings('ignore')

# Initialize easyocr once
import easyocr
reader = easyocr.Reader(['en','ch_sim'], gpu=False)
print("easyocr reader ready.\n")

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

os.makedirs("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells", exist_ok=True)

cells = {}
for r in range(ROWS):
    for c in range(COLS):
        x0, y0 = c * COL_W, r * ROW_H
        cells[(r,c)] = full.crop((x0, y0, x0+COL_W, y0+ROW_H))

# ── OCR with easyocr ─────────────────────────────────────────────
def ocr_label(arr):
    """OCR using easyocr."""
    # Convert to PIL Image
    img = Image.fromarray(arr)
    gray = 0.299*arr[:,:,0].astype(np.float64) + 0.587*arr[:,:,1].astype(np.float64) + 0.114*arr[:,:,2].astype(np.float64)
    if gray.mean() < 128:
        img = Image.fromarray(255 - arr)
    img = img.resize((arr.shape[1]*3, arr.shape[0]*3), Image.LANCZOS)
    tmp = "/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/_tmp_label.png"
    img.save(tmp)
    try:
        results = reader.readtext(tmp, detail=0)
        return " ".join(results).strip()
    except Exception as e:
        return f"OCR_ERROR: {e}"

# ── Color analysis ───────────────────────────────────────────────
def color_analysis(arr):
    arr_f = arr.astype(np.float64)
    mean_rgb = arr_f.mean(axis=(0,1))
    std_rgb = arr_f.std(axis=(0,1))

    q = (arr // 32).reshape(-1, 3)
    colors, counts = np.unique(q, axis=0, return_counts=True)
    top_idx = np.argsort(-counts)[:5]
    dominant = [(list(colors[i]), int(counts[i])) for i in top_idx]

    rg = arr_f[:,:,0] - arr_f[:,:,1]
    yb = 0.5 * (arr_f[:,:,0] + arr_f[:,:,1]) - arr_f[:,:,2]
    colorfulness = np.sqrt(rg.std()**2 + yb.std()**2) + 0.3 * np.sqrt(rg.mean()**2 + yb.mean()**2)

    gray = 0.299*arr_f[:,:,0] + 0.587*arr_f[:,:,1] + 0.114*arr_f[:,:,2]
    brightness_mean = gray.mean()
    brightness_std = gray.std()

    max_c = arr_f.max(axis=2)
    min_c = arr_f.min(axis=2)
    sat = np.where(max_c > 0, (max_c - min_c) / np.maximum(max_c, 1), 0)

    r_ch, g_ch, b_ch = arr_f[:,:,0], arr_f[:,:,1], arr_f[:,:,2]
    wood = ((r_ch > 120) & (r_ch > g_ch) & (g_ch > b_ch) & (r_ch - b_ch > 30)).mean()
    blue = ((b_ch > r_ch) & (b_ch > g_ch)).mean()
    green = ((g_ch > r_ch) & (g_ch > b_ch)).mean()
    light = ((r_ch > 200) & (g_ch > 200) & (b_ch > 200)).mean()
    dark = ((r_ch < 60) & (g_ch < 60) & (b_ch < 60)).mean()
    # Red dominance (for sneakers, hoodies, etc.)
    red_dom = ((r_ch > g_ch) & (r_ch > b_ch) & (r_ch > 100)).mean()

    return {
        "mean_rgb": [round(float(v),1) for v in mean_rgb],
        "std_rgb": [round(float(v),1) for v in std_rgb],
        "colorfulness": round(float(colorfulness),2),
        "brightness_mean": round(float(brightness_mean),1),
        "brightness_std": round(float(brightness_std),1),
        "saturation_mean": round(float(sat.mean()),3),
        "wood_tone_frac": round(float(wood),4),
        "blue_frac": round(float(blue),4),
        "green_frac": round(float(green),4),
        "light_frac": round(float(light),4),
        "dark_frac": round(float(dark),4),
        "red_dominant_frac": round(float(red_dom),4),
    }

# ── Edge analysis ────────────────────────────────────────────────
def edge_analysis(arr):
    import cv2
    gray = cv2.cvtColor(arr, cv2.COLOR_RGB2GRAY)
    # Canny edge detection
    edges = cv2.Canny(gray, 30, 100)
    edge_density = edges.mean() / 255.0

    # Sobel magnitudes
    sobelx = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=3)
    sobely = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=3)
    mag = np.sqrt(sobelx**2 + sobely**2)

    # Edge orientation from Canny edges
    edge_pts = np.where(edges > 0)
    if len(edge_pts[0]) > 10:
        angles = np.arctan2(sobely[edge_pts], sobelx[edge_pts]) * 180 / np.pi
        bins = ((angles + 180) // 45).astype(int) % 8
        hist, _ = np.histogram(bins, bins=8, range=(0,8))
        hist_pct = (hist / hist.sum() * 100).round(1).tolist()
    else:
        hist_pct = [0]*8

    strong = mag > (mag.mean() + 2*mag.std())
    strong_density = strong.mean()

    return {
        "edge_density": round(float(edge_density),4),
        "edge_magnitude_mean": round(float(mag.mean()),2),
        "edge_magnitude_std": round(float(mag.std()),2),
        "edge_orientation_hist": hist_pct,
        "strong_edge_density": round(float(strong_density),4),
        "horizontal_edge_energy": round(float(np.abs(sobelx).mean()),2),
        "vertical_edge_energy": round(float(np.abs(sobely).mean()),2),
        "hv_ratio": round(float(np.abs(sobelx).mean() / max(np.abs(sobely).mean(), 0.01)),2),
    }

# ── Texture analysis ─────────────────────────────────────────────
def texture_analysis(arr):
    from skimage.feature import graycomatrix, graycoprops
    gray = 0.299*arr[:,:,0].astype(np.float64) + 0.587*arr[:,:,1].astype(np.float64) + 0.114*arr[:,:,2].astype(np.float64)
    gray_u8 = np.clip(gray, 0, 255).astype(np.uint8)
    h, w = gray_u8.shape
    if max(h, w) > 400:
        s = 400/max(h,w)
        gray_u8 = np.array(Image.fromarray(gray_u8).resize((int(w*s), int(h*s))))
    glcm = graycomatrix(gray_u8, distances=[1], angles=[0, np.pi/4, np.pi/2, 3*np.pi/4],
                         levels=64, symmetric=True)
    return {
        "contrast": round(float(graycoprops(glcm,'contrast').mean()),4),
        "dissimilarity": round(float(graycoprops(glcm,'dissimilarity').mean()),4),
        "homogeneity": round(float(graycoprops(glcm,'homogeneity').mean()),4),
        "energy": round(float(graycoprops(glcm,'energy').mean()),6),
        "correlation": round(float(graycoprops(glcm,'correlation').mean()),4),
    }

# ── Shape analysis ───────────────────────────────────────────────
def shape_analysis(arr):
    import cv2
    gray = cv2.cvtColor(arr, cv2.COLOR_RGB2GRAY)
    blurred = cv2.GaussianBlur(gray, (5,5), 0)
    _, thresh = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    contours, hierarchy = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    if not contours:
        return {"num_contours": 0}
    areas = sorted([cv2.contourArea(c) for c in contours], reverse=True)
    total = gray.shape[0] * gray.shape[1]
    top5 = sorted(contours, key=cv2.contourArea, reverse=True)[:5]
    bboxes = []
    for c in top5:
        x,y,w,h = cv2.boundingRect(c)
        bboxes.append({"x":x,"y":y,"w":w,"h":h,"area_frac":round(cv2.contourArea(c)/total,4)})
    aspects = []
    for c in top5:
        x,y,w,h = cv2.boundingRect(c)
        if h>0: aspects.append(round(w/h,3))
    hu = []
    for c in top5[:3]:
        m = cv2.moments(c)
        hu.append([round(float(h),6) for h in cv2.HuMoments(m).flatten()])
    largest = contours[np.argmax([cv2.contourArea(c) for c in contours])]
    perim = cv2.arcLength(largest, True)
    area_l = cv2.contourArea(largest)
    circ = (4*np.pi*area_l)/(perim*perim) if perim>0 else 0
    return {
        "num_contours": len(contours),
        "largest_contour_area_frac": round(areas[0]/total,4) if areas else 0,
        "largest_contour_circularity": round(float(circ),4),
        "top_contour_bboxes": bboxes,
        "top_contour_aspects": aspects,
        "hu_moments_top3": hu,
        "foreground_fraction": round(float(1-(thresh==0).mean()),4),
    }

# ── Brightness profile ───────────────────────────────────────────
def brightness_profile(arr):
    gray = 0.299*arr[:,:,0].astype(np.float64) + 0.587*arr[:,:,1].astype(np.float64) + 0.114*arr[:,:,2].astype(np.float64)
    h = gray.shape[0]
    return {
        "row_means_sampled": [round(float(v),1) for v in gray.mean(axis=1)[::15]],
        "col_means_sampled": [round(float(v),1) for v in gray.mean(axis=0)[::15]],
        "row_gradient": round(float(abs(gray.mean(axis=1)[-1]-gray.mean(axis=1)[0])),1),
        "col_gradient": round(float(abs(gray.mean(axis=0)[-1]-gray.mean(axis=0)[0])),1),
        "row_top_third": round(float(gray[:h//3].mean()),1),
        "row_mid_third": round(float(gray[h//3:2*h//3].mean()),1),
        "row_bottom_third": round(float(gray[2*h//3:].mean()),1),
    }

# ── Spatial frequency ────────────────────────────────────────────
def spatial_frequency(arr):
    gray = 0.299*arr[:,:,0].astype(np.float64) + 0.587*arr[:,:,1].astype(np.float64) + 0.114*arr[:,:,2].astype(np.float64)
    f = np.fft.fft2(gray)
    fshift = np.fft.fftshift(f)
    mag = np.abs(fshift)
    h,w = mag.shape
    cy,cx = h//2, w//2
    mask = np.ones((h,w), dtype=bool)
    mask[cy-int(h*0.35):cy+int(h*0.35), cx-int(w*0.35):cx+int(w*0.35)] = False
    return {
        "high_freq_ratio": round(float(mag[mask].mean()/max(mag.mean(),0.01)),2),
        "total_fft_energy": round(float(mag.mean()),2),
    }

# ── Color histogram analysis ─────────────────────────────────────
def histogram_analysis(arr):
    """Detailed color histogram analysis."""
    r = arr[:,:,0].flatten()
    g = arr[:,:,1].flatten()
    b = arr[:,:,2].flatten()

    # Compute histogram peaks
    hist_r, bins_r = np.histogram(r, bins=32, range=(0,256))
    hist_g, bins_g = np.histogram(g, bins=32, range=(0,256))
    hist_b, bins_b = np.histogram(b, bins=32, range=(0,256))

    # Find peaks
    def find_peaks(hist, bins):
        peaks = []
        for i in range(1, len(hist)-1):
            if hist[i] > hist[i-1] and hist[i] > hist[i+1] and hist[i] > hist.max()*0.1:
                peaks.append((round(bins[i]+(bins[i+1]-bins[i])/2), int(hist[i])))
        return sorted(peaks, key=lambda x: -x[1])[:3]

    return {
        "r_peaks": find_peaks(hist_r, bins_r),
        "g_peaks": find_peaks(hist_g, bins_g),
        "b_peaks": find_peaks(hist_b, bins_b),
        "r_mean": round(float(r.mean()),1),
        "g_mean": round(float(g.mean()),1),
        "b_mean": round(float(b.mean()),1),
        "r_std": round(float(r.std()),1),
        "g_std": round(float(g.std()),1),
        "b_std": round(float(b.std()),1),
    }

# ── Run analysis ─────────────────────────────────────────────────
results = {}

for r in range(ROWS):
    for c in range(COLS):
        print(f"\n{'='*60}")
        print(f"CELL [{r},{c}] — Expected: {EXPECTED[(r,c)][0]} / {EXPECTED[(r,c)][1]}")
        print(f"{'='*60}")

        arr = np.array(cells[(r,c)])
        img_area = arr[:-LABEL_H, :, :]
        label_area = arr[-LABEL_H:, :, :]

        Image.fromarray(img_area).save(f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/cell_{r}_{c}_img.png")
        Image.fromarray(label_area).save(f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/cell_{r}_{c}_label.png")

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
        print("  Histogram analysis...")
        hist = histogram_analysis(img_area)
        print("  Label OCR...")
        ocr_text = ocr_label(label_area)
        label_color = color_analysis(label_area)

        label_gray = 0.299*label_area[:,:,0].astype(np.float64) + 0.587*label_area[:,:,1].astype(np.float64) + 0.114*label_area[:,:,2].astype(np.float64)
        label_edge_density = float((np.abs(np.diff(label_gray, axis=1)) > 10).mean())

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
                "histogram": hist,
            },
            "label_area": {
                "ocr_text": ocr_text,
                "color": label_color,
                "edge_density": round(label_edge_density, 4),
                "mean_brightness": round(float(label_gray.mean()), 1),
            },
        }

        print(f"\n  --- SUMMARY ---")
        print(f"  OCR: '{ocr_text}'")
        print(f"  Color: rgb={color['mean_rgb']}, bright={color['brightness_mean']}, sat={color['saturation_mean']}")
        print(f"  Fractions: wood={color['wood_tone_frac']}, blue={color['blue_frac']}, green={color['green_frac']}, light={color['light_frac']}, dark={color['dark_frac']}, red={color['red_dominant_frac']}")
        print(f"  Edges: density={edges['edge_density']}, strong={edges['strong_edge_density']}, h/v={edges['hv_ratio']}")
        print(f"  Edges orient: {edges['edge_orientation_hist']}")
        if 'contrast' in texture:
            print(f"  Texture: contrast={texture['contrast']}, homogeneity={texture['homogeneity']}, energy={texture['energy']}")
        if 'num_contours' in shape:
            print(f"  Shape: contours={shape['num_contours']}, fg_frac={shape.get('foreground_fraction','?')}, circ={shape.get('largest_contour_circularity','?')}")
            print(f"  Top bboxes: {shape.get('top_contour_bboxes',[])}")
        print(f"  Spatial freq: hf_ratio={sf['high_freq_ratio']}")
        print(f"  Brightness: top={bp['row_top_third']}, mid={bp['row_mid_third']}, bot={bp['row_bottom_third']}")
        print(f"  Histogram peaks: R={hist['r_peaks']}, G={hist['g_peaks']}, B={hist['b_peaks']}")

with open("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cell_analysis_v2.json", "w") as f:
    json.dump({f"{r},{c}": v for (r,c), v in results.items()}, f, indent=2, ensure_ascii=False, default=str)

print("\n\n=== ANALYSIS COMPLETE ===")