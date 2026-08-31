#!/usr/bin/env python3
"""Final verification: analyze center regions and edge patterns for key cells."""

import numpy as np
from PIL import Image
import warnings
warnings.filterwarnings('ignore')

IMG_PATH = "/home/vaga/DSH_Projects/Project_impulsive consumption/tool/montage_new_1.png"
full = Image.open(IMG_PATH).convert("RGB")
W, H = full.size

COLS, ROWS = 4, 2
COL_W = W // COLS
ROW_H = H // ROWS
LABEL_H = 60

def analyze_center(arr, label):
    """Analyze center region of image."""
    h, w = arr.shape[:2]
    # Center 50% region
    ch, cw = h//4, w//4
    center = arr[ch:3*ch, cw:3*cw]

    r, g, b = center[:,:,0].astype(np.float64), center[:,:,1].astype(np.float64), center[:,:,2].astype(np.float64)
    gray = 0.299*r + 0.587*g + 0.114*b

    # Color analysis
    r_mean, g_mean, b_mean = r.mean(), g.mean(), b.mean()

    # Check for specific color patterns
    # Blue dominance (denim, sky, etc)
    blue_pixels = ((b > r) & (b > g) & (b - r > 15)).mean()
    # White/light pixels
    white_pixels = ((r > 200) & (g > 200) & (b > 200)).mean()
    # Wood/brown pixels
    brown_pixels = ((r > g) & (g > b) & (r - b > 40) & (r > 100)).mean()
    # Red pixels
    red_pixels = ((r > g) & (r > b) & (r > 120)).mean()
    # Green pixels
    green_pixels = ((g > r) & (g > b) & (g > 100)).mean()
    # Dark pixels
    dark_pixels = ((r < 70) & (g < 70) & (b < 70)).mean()

    # Edge density in center
    import cv2
    gray_u8 = np.clip(gray, 0, 255).astype(np.uint8)
    edges = cv2.Canny(gray_u8, 50, 150)
    edge_density = edges.mean() / 255.0

    print(f"  [{label}] Center analysis:")
    print(f"    RGB: ({r_mean:.0f}, {g_mean:.0f}, {b_mean:.0f})")
    print(f"    Blue: {blue_pixels:.1%}, White: {white_pixels:.1%}, Brown: {brown_pixels:.1%}")
    print(f"    Red: {red_pixels:.1%}, Green: {green_pixels:.1%}, Dark: {dark_pixels:.1%}")
    print(f"    Edge density: {edge_density:.4f}")

    return {
        "rgb": [round(r_mean, 0), round(g_mean, 0), round(b_mean, 0)],
        "blue": round(float(blue_pixels), 4),
        "white": round(float(white_pixels), 4),
        "brown": round(float(brown_pixels), 4),
        "red": round(float(red_pixels), 4),
        "green": round(float(green_pixels), 4),
        "dark": round(float(dark_pixels), 4),
        "edge_density": round(float(edge_density), 4),
    }

# Analyze all cells
print("=" * 60)
print("CENTER REGION ANALYSIS")
print("=" * 60)

for r in range(ROWS):
    for c in range(COLS):
        x0, y0 = c * COL_W, r * ROW_H
        cell = np.array(full.crop((x0, y0, x0+COL_W, y0+ROW_H)))
        img_area = cell[:-LABEL_H, :, :]
        analyze_center(img_area, f"Cell[{r},{c}]")

# Also analyze the full image area for key mismatch cells
print("\n" + "=" * 60)
print("KEY MISMATCH CELLS - DETAILED ANALYSIS")
print("=" * 60)

# Cell [1,0] - storage-box (suspected books)
print("\n--- Cell [1,0] (storage-box / 加厚收纳箱三件套) ---")
cell = np.array(full.crop((0, ROW_H, COL_W, ROW_H+ROW_H)))
img = cell[:-LABEL_H, :, :]
h, w = img.shape[:2]

# Split into top and bottom halves
top = img[:h//2, :, :]
bottom = img[h//2:, :, :]

for name, region in [("Top half", top), ("Bottom half", bottom)]:
    r, g, b = region[:,:,0].astype(np.float64), region[:,:,1].astype(np.float64), region[:,:,2].astype(np.float64)
    print(f"  {name}: RGB=({r.mean():.0f}, {g.mean():.0f}, {b.mean():.0f}), "
          f"bright={(0.299*r+0.587*g+0.114*b).mean():.0f}")

# Check for rectangular box shapes
import cv2
gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
_, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
boxes = []
for cnt in contours:
    area = cv2.contourArea(cnt)
    if area > 500:
        x, y, w_box, h_box = cv2.boundingRect(cnt)
        aspect = w_box / max(h_box, 1)
        if 0.5 < aspect < 2.0:  # box-like aspect ratio
            boxes.append((x, y, w_box, h_box, area))
print(f"  Box-like contours: {len(boxes)}")
for box in sorted(boxes, key=lambda x: -x[4])[:5]:
    print(f"    Box at ({box[0]},{box[1]}) {box[2]}x{box[3]}, area={box[4]:.0f}")

# Cell [1,3] - levi-jeans (suspected mismatch)
print("\n--- Cell [1,3] (levi-jeans / Levi's 501 牛仔裤) ---")
cell = np.array(full.crop((3*COL_W, ROW_H, 4*COL_W, ROW_H+ROW_H)))
img = cell[:-LABEL_H, :, :]

# Check for blue denim characteristics
r, g, b = img[:,:,0].astype(np.float64), img[:,:,1].astype(np.float64), img[:,:,2].astype(np.float64)
print(f"  Overall RGB: ({r.mean():.0f}, {g.mean():.0f}, {b.mean():.0f})")
print(f"  R-G: {r.mean()-g.mean():.1f}, B-R: {b.mean()-r.mean():.1f}")
print(f"  Saturation: {((r.max(axis=2)-r.min(axis=2))/np.maximum(r.max(axis=2),1)).mean():.3f}")

# Denim should have B > R by 30-70
blue_excess = b.mean() - r.mean()
print(f"  Blue excess (B-R): {blue_excess:.1f} (denim should be 30-70)")

# Check for fabric texture
gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
laplacian_var = cv2.Laplacian(gray, cv2.CV_64F).var()
print(f"  Laplacian variance (sharpness): {laplacian_var:.1f}")

# Cell [0,0] - standing-desk (check for wood)
print("\n--- Cell [0,0] (standing-desk / 电动升降桌) ---")
cell = np.array(full.crop((0, 0, COL_W, ROW_H)))
img = cell[:-LABEL_H, :, :]
r, g, b = img[:,:,0].astype(np.float64), img[:,:,1].astype(np.float64), img[:,:,2].astype(np.float64)
print(f"  Overall RGB: ({r.mean():.0f}, {g.mean():.0f}, {b.mean():.0f})")
print(f"  Wood tone check: R-B={r.mean()-b.mean():.1f}, R/G={r.mean()/max(g.mean(),1):.2f}")
# Wood: R > G > B, with R-B > 30
wood_mask = (r > g) & (g > b) & (r - b > 30) & (r > 100)
print(f"  Wood pixel fraction: {wood_mask.mean():.1%}")

print("\n=== VERIFICATION COMPLETE ===")