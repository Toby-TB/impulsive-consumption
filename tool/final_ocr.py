#!/usr/bin/env python3
"""Final OCR attempt with easyocr on raw label areas."""

import numpy as np
from PIL import Image
import json, warnings, sys, os
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

# Initialize easyocr
import easyocr
reader = easyocr.Reader(['en','ch_sim'], gpu=False)
print("Reader ready")

# Try OCR with different preprocessing
def ocr_with_preprocessing(arr, cell_name):
    results = []

    # Save raw label
    raw = Image.fromarray(arr)
    raw_path = f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/{cell_name}_label_raw.png"
    raw.save(raw_path)

    # Try 1: Raw image
    try:
        r = reader.readtext(raw_path, detail=0)
        text = " ".join(t.strip() for t in r if t.strip())
        if text:
            results.append(("raw", text))
    except Exception as e:
        pass

    # Try 2: Inverted
    gray = 0.299*arr[:,:,0].astype(np.float64) + 0.587*arr[:,:,1].astype(np.float64) + 0.114*arr[:,:,2].astype(np.float64)
    if gray.mean() < 128:
        inv = Image.fromarray(255 - arr)
        inv_path = f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/{cell_name}_label_inv.png"
        inv.save(inv_path)
        try:
            r = reader.readtext(inv_path, detail=0)
            text = " ".join(t.strip() for t in r if t.strip())
            if text:
                results.append(("inverted", text))
        except:
            pass

    # Try 3: High contrast
    from PIL import ImageEnhance
    enhancer = ImageEnhance.Contrast(raw)
    high_contrast = enhancer.enhance(3.0)
    hc_path = f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/{cell_name}_label_hc.png"
    high_contrast.save(hc_path)
    try:
        r = reader.readtext(hc_path, detail=0)
        text = " ".join(t.strip() for t in r if t.strip())
        if text:
            results.append(("high_contrast", text))
    except:
        pass

    # Try 4: Upscaled 4x
    big = raw.resize((arr.shape[1]*4, arr.shape[0]*4), Image.LANCZOS)
    big_path = f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/{cell_name}_label_big.png"
    big.save(big_path)
    try:
        r = reader.readtext(big_path, detail=0)
        text = " ".join(t.strip() for t in r if t.strip())
        if text:
            results.append(("upscaled4x", text))
    except:
        pass

    # Try 5: Binary threshold
    import cv2
    gray_u8 = np.clip(gray, 0, 255).astype(np.uint8)
    _, binary = cv2.threshold(gray_u8, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    if (binary == 0).mean() > 0.5:
        binary = 255 - binary
    bin_img = Image.fromarray(binary).resize((binary.shape[1]*3, binary.shape[0]*3), Image.NEAREST)
    bin_path = f"/home/vaga/DSH_Projects/Project_impulsive consumption/tool/cells/{cell_name}_label_bin.png"
    bin_img.save(bin_path)
    try:
        r = reader.readtext(bin_path, detail=0)
        text = " ".join(t.strip() for t in r if t.strip())
        if text:
            results.append(("binary", text))
    except:
        pass

    return results

all_ocr = {}
for r in range(ROWS):
    for c in range(COLS):
        x0, y0 = c * COL_W, r * ROW_H
        cell = np.array(full.crop((x0, y0, x0+COL_W, y0+ROW_H)))
        label_area = cell[-LABEL_H:, :, :]

        print(f"\nCell [{r},{c}] OCR...")
        results = ocr_with_preprocessing(label_area, f"cell_{r}_{c}")
        all_ocr[f"{r},{c}"] = results
        print(f"  Results: {results}")

# Also try to detect text presence by analyzing pixel patterns
print("\n\n=== TEXT PRESENCE DETECTION ===")
for r in range(ROWS):
    for c in range(COLS):
        x0, y0 = c * COL_W, r * ROW_H
        cell = np.array(full.crop((x0, y0, x0+COL_W, y0+ROW_H)))
        label_area = cell[-LABEL_H:, :, :]
        gray = 0.299*label_area[:,:,0].astype(np.float64) + 0.587*label_area[:,:,1].astype(np.float64) + 0.114*label_area[:,:,2].astype(np.float64)

        # Count sharp transitions (text edges)
        col_profile = gray.mean(axis=0)
        transitions = np.sum(np.abs(np.diff(col_profile)) > 5)

        # Check if there's a clear text pattern
        # Text usually creates periodic high-frequency content
        from scipy.fft import fft
        fft_vals = np.abs(fft(col_profile - col_profile.mean()))
        # High frequency energy ratio
        hf_energy = fft_vals[len(fft_vals)//4:].sum()
        total_energy = fft_vals.sum()
        hf_ratio = hf_energy / total_energy if total_energy > 0 else 0

        print(f"Cell [{r},{c}]: transitions={transitions}, hf_ratio={hf_ratio:.3f}, "
              f"gray_range=[{gray.min():.0f}, {gray.max():.0f}], "
              f"mean={gray.mean():.0f}, std={gray.std():.0f}")

with open("/home/vaga/DSH_Projects/Project_impulsive consumption/tool/final_ocr_results.json", "w") as f:
    json.dump(all_ocr, f, indent=2, ensure_ascii=False)

print("\n=== DONE ===")