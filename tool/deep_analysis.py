#!/usr/bin/env python3
"""Deep analysis: OCR with preprocessing, detailed color mapping, visual feature extraction."""

import numpy as np
from PIL import Image, ImageEnhance, ImageFilter
import json, warnings, cv2
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

# ── OCR with multiple preprocessing ──────────────────────────────
import easyocr
reader = easyocr.Reader(['en','ch_sim'], gpu=False)

def ocr_preprocess(arr):
    """Try multiple preprocessing approaches for OCR."""
    results = []

    # Convert to grayscale
    gray = 0.299*arr[:,:,0].astype(np.float64) + 0.587*arr[:,:,1].astype(np.float64) + 0.114*arr[:,:,2].astype(np.float64)
    gray_u8 = np.clip(gray, 0, 255).astype(np.uint8)

    approaches = []

    # 1. Raw grayscale upscaled
    img1 = Image.fromarray(gray_u8).resize((gray_u8.shape[1]*4, gray_u8.shape[0]*4), Image.LANCZOS)
    approaches.append(("raw_gray", img1))

    # 2. Inverted if dark
    if gray_u8.mean() < 128:
        img2 = Image.fromarray(255 - gray_u8).resize((gray_u8.shape[1]*4, gray_u8.shape[0]*4), Image.LANCZOS)
        approaches.append(("inverted", img2))

    # 3. Binary threshold
    _, binary = cv2.threshold(gray_u8, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    img3 = Image.fromarray(binary).resize((binary.shape[1]*4, binary.shape[0]*4), Image.LANCZOS)
    approaches.append(("binary_otsu", img3))

    # 4. Adaptive threshold
    adaptive = cv2.adaptiveThreshold(gray_u8, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 21, 5)
    img4 = Image.fromarray(adaptive).resize((adaptive.shape[1]*4, adaptive.shape[0]*4), Image.LANCZOS)
    approaches.append(("adaptive", img4))

    # 5. Contrast enhanced
    enhancer = ImageEnhance.Contrast(img1)
    img5 = enhancer.enhance(2.0)
    approaches.append(("contrast2x", img5))

    # 6. Sharpened
    img6 = img1.filter(ImageFilter.SHARPEN)
    approaches.append(("sharpened", img6))

    # 7. Edge enhanced (for outline text)
    kernel = np.array([[-1,-1,-1], [-1,9,-1], [-1,-1,-1]])
    sharp = cv2.filter2D(gray_u8, -1, kernel)
    img7 = Image.fromarray(np.clip(sharp, 0, 255)).resize((gray_u8.shape[1]*4, gray_u8.shape[0]*4), Image.LANCZOS)
    approaches.append(("edge_enhanced", img7))

    for name, img in approaches:
        tmp = f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/_ocr_{name}.png"
        img.save(tmp)
        try:
            texts = reader.readtext(tmp, detail=0, paragraph=False)
            text = " ".join(t.strip() for t in texts if t.strip())
            if text:
                results.append((name, text))
        except Exception as e:
            pass

    return results

# ── Detailed color region analysis ───────────────────────────────
def region_analysis(arr):
    """Analyze different regions of the image for color clues."""
    h, w = arr.shape[:2]
    regions = {}

    # Top-left quadrant
    tl = arr[:h//2, :w//2]
    regions["top_left"] = {
        "mean_rgb": [round(float(tl[:,:,i].mean()),1) for i in range(3)],
        "brightness": round(float((0.299*tl[:,:,0]+0.587*tl[:,:,1]+0.114*tl[:,:,2]).mean()),1),
    }
    # Top-right
    tr = arr[:h//2, w//2:]
    regions["top_right"] = {
        "mean_rgb": [round(float(tr[:,:,i].mean()),1) for i in range(3)],
        "brightness": round(float((0.299*tr[:,:,0]+0.587*tr[:,:,1]+0.114*tr[:,:,2]).mean()),1),
    }
    # Bottom-left
    bl = arr[h//2:, :w//2]
    regions["bottom_left"] = {
        "mean_rgb": [round(float(bl[:,:,i].mean()),1) for i in range(3)],
        "brightness": round(float((0.299*bl[:,:,0]+0.587*bl[:,:,1]+0.114*bl[:,:,2]).mean()),1),
    }
    # Bottom-right
    br = arr[h//2:, w//2:]
    regions["bottom_right"] = {
        "mean_rgb": [round(float(br[:,:,i].mean()),1) for i in range(3)],
        "brightness": round(float((0.299*br[:,:,0]+0.587*br[:,:,1]+0.114*br[:,:,2]).mean()),1),
    }
    # Center region
    ch, cw = h//4, w//4
    center = arr[ch:3*ch, cw:3*cw]
    regions["center"] = {
        "mean_rgb": [round(float(center[:,:,i].mean()),1) for i in range(3)],
        "brightness": round(float((0.299*center[:,:,0]+0.587*center[:,:,1]+0.114*center[:,:,2]).mean()),1),
    }

    return regions

# ── Color distance from expected product colors ─────────────────
def expected_color_distance(arr, product_type):
    """Compare image colors against expected colors for each product type."""
    r_mean = float(arr[:,:,0].mean())
    g_mean = float(arr[:,:,1].mean())
    b_mean = float(arr[:,:,2].mean())

    # Expected color profiles (approximate)
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

    if product_type not in profiles:
        return {"error": "unknown product type"}

    exp = profiles[product_type]
    dist = np.sqrt((r_mean - exp["r"])**2 + (g_mean - exp["g"])**2 + (b_mean - exp["b"])**2)

    return {
        "expected_desc": exp["desc"],
        "expected_rgb": [exp["r"], exp["g"], exp["b"]],
        "actual_rgb": [round(r_mean,1), round(g_mean,1), round(b_mean,1)],
        "color_distance": round(float(dist),1),
        "match_quality": "good" if dist < 60 else ("moderate" if dist < 120 else "poor"),
    }

# ── Edge orientation analysis ────────────────────────────────────
def edge_orientation_detail(arr):
    """Detailed edge orientation analysis."""
    gray = cv2.cvtColor(arr, cv2.COLOR_RGB2GRAY)
    edges = cv2.Canny(gray, 50, 150)

    # Sobel for orientation
    sobelx = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=3)
    sobely = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=3)
    mag = np.sqrt(sobelx**2 + sobely**2)

    edge_pts = np.where(edges > 0)
    if len(edge_pts[0]) < 10:
        return {"error": "too few edges"}

    angles = np.arctan2(sobely[edge_pts], sobelx[edge_pts]) * 180 / np.pi

    # Classify edges
    horizontal = np.sum(np.abs(angles) < 22.5) + np.sum(np.abs(angles) > 157.5)
    vertical = np.sum(np.abs(angles - 90) < 22.5) + np.sum(np.abs(angles + 90) < 22.5)
    diagonal = len(angles) - horizontal - vertical

    total = len(angles)
    return {
        "total_edges": total,
        "horizontal_pct": round(float(horizontal/total*100),1),
        "vertical_pct": round(float(vertical/total*100),1),
        "diagonal_pct": round(float(diagonal/total*100),1),
        "edge_density": round(float(edges.mean()/255),4),
    }

# ── Texture detail ───────────────────────────────────────────────
def texture_detail(arr):
    """Detailed texture analysis."""
    gray = cv2.cvtColor(arr, cv2.COLOR_RGB2GRAY)

    # Laplacian variance (sharpness)
    laplacian_var = cv2.Laplacian(gray, cv2.CV_64F).var()

    # Local binary pattern variance
    from skimage.feature import local_binary_pattern
    lbp = local_binary_pattern(gray, 8, 1, method='uniform')
    lbp_hist, _ = np.histogram(lbp, bins=10, range=(0,10))
    lbp_entropy = float(-sum((p/sum(lbp_hist)) * np.log2(p/sum(lbp_hist)) for p in lbp_hist if p > 0))

    # Gradient magnitude statistics
    sobelx = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=3)
    sobely = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=3)
    mag = np.sqrt(sobelx**2 + sobely**2)

    return {
        "laplacian_variance": round(float(laplacian_var),2),
        "lbp_entropy": round(lbp_entropy,3),
        "gradient_mean": round(float(mag.mean()),2),
        "gradient_std": round(float(mag.std()),2),
        "gradient_p95": round(float(np.percentile(mag, 95)),2),
    }

# ── Run deep analysis ────────────────────────────────────────────
print("Running deep analysis...\n")

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

        # OCR with preprocessing
        print("  OCR with preprocessing...")
        ocr_results = ocr_preprocess(label_area)
        print(f"  OCR results: {ocr_results}")

        # Region analysis
        print("  Region analysis...")
        regions = region_analysis(img_area)

        # Expected color distance
        print("  Color distance from expected...")
        color_dist = expected_color_distance(img_area, EXPECTED[(r,c)][0])

        # Edge orientation detail
        print("  Edge orientation detail...")
        edge_orient = edge_orientation_detail(img_area)

        # Texture detail
        print("  Texture detail...")
        texture_d = texture_detail(img_area)

        all_results[(r,c)] = {
            "expected": EXPECTED[(r,c)],
            "ocr_results": ocr_results,
            "regions": regions,
            "color_distance": color_dist,
            "edge_orientation": edge_orient,
            "texture_detail": texture_d,
        }

        print(f"\n  --- RESULTS ---")
        print(f"  OCR: {ocr_results}")
        print(f"  Color distance: {color_dist}")
        print(f"  Edge orientation: {edge_orient}")
        print(f"  Texture: {texture_d}")
        print(f"  Regions: {regions}")

# Save results
with open("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/deep_analysis.json", "w") as f:
    json.dump({f"{r},{c}": v for (r,c), v in all_results.items()}, f, indent=2, ensure_ascii=False, default=str)

print("\n\n=== DEEP ANALYSIS COMPLETE ===")