# Product Montage Analysis Report

**Image**: `montage_new_1.png` (1700×1200 px, 4×2 grid, each cell ~425×600 px, label height 60 px)

---

## Cell-by-Cell Analysis

### Cell [0,0] — standing-desk / 电动升降桌
**VERDICT: POSSIBLE MISMATCH**

| Metric | Value | Assessment |
|--------|-------|------------|
| Mean RGB | (193.6, 190.4, 185.3) | Very light, near-neutral |
| Brightness | 190.8 / 255 | Very bright |
| Saturation | 0.102 | Low (nearly gray) |
| Wood tone fraction | 0.084 (8.4%) | **Very low** — a standing desk should show wood grain or warm wood tones |
| Blue background fraction | 0.436 (43.6%) | High — suggests blue studio backdrop |
| Light pixel fraction | 0.689 (68.9%) | Mostly white/light background |
| Edge density | 0.043 | Low — smooth image, minimal detail |
| Largest contour | 400×400 px, 69% of area | Large central object, fairly circular (0.79) |
| Top flatness | 89.3 | Very flat top surface (consistent with desktop) |
| Color distance from expected wood | 100 (moderate) | Warmer/desaturated vs expected wood brown |
| OCR | None detected | — |

**Issues**: The image is mostly white/light with a blue background and very little wood tone (8.4%). A standing desk typically shows visible wood grain or at least warm brown tones. This could be a white melamine desk, but the near-absence of wood color is suspicious.

---

### Cell [0,1] — led-desk-lamp / LED 护眼台灯
**VERDICT: APPEARS TO MATCH**

| Metric | Value | Assessment |
|--------|-------|------------|
| Mean RGB | (190.7, 178.3, 169.8) | Warm, bright |
| Brightness | 181.0 / 255 | Bright |
| Bright spot fraction | 0.555 (55.5%) | **Very high** — consistent with a lit lamp |
| Wood tone fraction | 0.237 (23.7%) | Moderate — could be wooden lamp base |
| Red dominant fraction | 0.798 (79.8%) | Very high — warm light glow |
| Center brightness peak | +3.7 | Slight central brightness (light source) |
| Edge density | 0.130 | Moderate — lamp structure |
| Color distance from expected | 44 (good) | Close to white/warm light profile |
| OCR | None detected | — |

**Assessment**: The very high bright spot fraction (55.5%) and warm red-dominant color (79.8%) are strongly consistent with an illuminated LED desk lamp. The moderate wood tone could indicate a wooden lamp base. No significant mismatches detected.

---

### Cell [0,2] — memory-mattress / 记忆棉床垫
**VERDICT: POSSIBLE MISMATCH**

| Metric | Value | Assessment |
|--------|-------|------------|
| Mean RGB | (156.9, 148.3, 142.5) | Medium-dark, warm-gray |
| Brightness | 150.2 / 255 | Darker than expected for a mattress |
| Light pixel fraction | 0.407 (40.7%) | Only 41% light pixels — a mattress should be mostly white |
| Saturation | 0.196 | Moderate |
| Dark pixel fraction | 0.205 (20.5%) | High dark fraction for a mattress |
| Circularity | 0.789 | **High** — a mattress is rectangular, not circular |
| Uniformity | 0.659 | Moderate uniformity |
| Aspect ratio | 0.787 (portrait) | Unusual — mattresses are typically landscape |
| Color distance from expected white | 143 (poor) | **Far** from white/light gray |
| OCR | None detected | — |

**Issues**: A memory foam mattress should be predominantly white/light-colored, but this image is medium-dark (brightness 150) with only 41% light pixels. The high circularity (0.79) is also unusual for a rectangular mattress. The portrait aspect ratio (0.79) is atypical.

---

### Cell [0,3] — bookshelf / 六格书柜
**VERDICT: APPEARS TO MATCH**

| Metric | Value | Assessment |
|--------|-------|------------|
| Mean RGB | (159.6, 143.0, 130.1) | Warm brown — consistent with wood |
| Wood tone fraction | 0.195 (19.5%) | Moderate — wooden bookshelf |
| Dark pixel fraction | 0.274 (27.4%) | High — shadows in shelves |
| Contours | 166 | **Many** — consistent with books and compartments |
| Grid regularity | 672 (24 row peaks × 28 col peaks) | **Very grid-like** — strong bookshelf indicator |
| Circularity | 0.150 | **Very non-circular** — rectangular shelf structure |
| Edge density | 0.119 | Moderate-High |
| Color distance from expected wood brown | 69 (moderate) | Reasonable match |
| OCR | 'W 94 蠃`"颛# 9 D[]C!' | Garbled Chinese (OCR failed on Chinese chars) |

**Assessment**: The very grid-like structure (24 horizontal × 28 vertical edge peaks), high contour count (166), and very low circularity (0.15) are all strong indicators of a bookshelf with multiple compartments. The warm brown color matches wood. The garbled OCR output contains Chinese characters, consistent with the Chinese label.

---

### Cell [1,0] — storage-box / 加厚收纳箱三件套
**VERDICT: STRONG MISMATCH**

| Metric | Value | Assessment |
|--------|-------|------------|
| Mean RGB | (153.5, 147.5, 128.4) | Medium, slightly warm |
| Green fraction | 0.192 (19.2%) | **Highest green of all cells** — suggests plants/nature |
| OCR (raw) | **'BB0K8'** | Looks like "BOOKS" in leetspeak |
| OCR (upscaled 4x) | **'BB00K8'** | Even clearer "BOOKS" |
| OCR (high contrast) | '眺B0K8' | Partial "BOOKS" |
| Contours | 114 | Many objects |
| Two large horizontal bands | 400×267 and 400×218 | **Two shelf-like rows** |
| Box-like contours | 5 | A few rectangular shapes |
| Label text transitions | 82 (2nd highest) | Lots of text in label |
| Color distance from expected | 22 (good) | Neutral color matches plastic |

**Issues**: 
1. **OCR consistently reads "BOOKS"** (BB0K8 / BB00K8) — this is English text, not the expected Chinese label "加厚收纳箱三件套"
2. The image shows **two large horizontal shelf-like bands** (400×267 and 400×218 px), consistent with bookshelves, not stacked storage boxes
3. **Highest green fraction (19.2%)** of all 8 cells — suggests plants or nature background, unusual for plastic storage boxes
4. The label has the second-most text transitions (82), consistent with a longer English label

**Conclusion**: This cell very likely contains a **bookshelf with books** (possibly the same product as cell [0,3]), not storage boxes. The label may be swapped or the image is wrong.

---

### Cell [1,1] — nike-sneaker / Nike 缓震运动鞋
**VERDICT: POSSIBLE MISMATCH**

| Metric | Value | Assessment |
|--------|-------|------------|
| Mean RGB | (159.2, 149.8, 146.9) | Medium, warm-gray |
| Red dominant fraction | 0.603 (60.3%) | Moderate red — could be red/white sneaker |
| Circularity | 0.121 | **Very non-circular** — consistent with shoe shape |
| Bottom brightness | 131.9 | Darker bottom |
| Top brightness | 172.5 | Brighter top |
| Bottom-heavy | **-40.6** | **Bottom is DARKER than top** — unusual for sneakers |
| Contours | 132 | Many contours |
| Center white fraction | 0.701 (70.1%) | Very white center — could be white sneaker |
| Color distance from expected | 84 (moderate) | Somewhat distant from white/sport profile |
| OCR | None detected | — |

**Issues**: The bottom of the image is significantly darker than the top (−40.6 difference). Sneakers typically have bright white soles that would make the bottom brighter, not darker. This could indicate a shoe photographed from an unusual angle, or the image might show something else. The very white center (70.1% white pixels) is consistent with a white sneaker though.

---

### Cell [1,2] — adidas-hoodie / Adidas 经典卫衣
**VERDICT: APPEARS TO MATCH**

| Metric | Value | Assessment |
|--------|-------|------------|
| Mean RGB | (166.6, 171.0, 172.2) | Slightly blue-gray |
| Blue fraction | 0.361 (36.1%) | High — blue hoodie |
| Green fraction | 0.198 (19.8%) | Moderate |
| Red dominant fraction | 0.356 (35.6%) | Low — not red |
| Edge softness | 0.925 | **Very soft** — consistent with fabric |
| Low frequency ratio | 9.07 | **Strong low-frequency** — smooth fabric texture |
| Circularity | 0.655 | Moderately round — folded hoodie |
| Spatial frequency HF ratio | 0.32 | Low detail — smooth fabric |
| Color distance from expected | 13 (good) | Close to fabric color profile |
| OCR | None detected | — |

**Assessment**: The very soft edges (0.925) and strong low-frequency content (9.07) are characteristic of fabric/clothing. The blue color (36.1% blue pixels) suggests a blue hoodie. The moderate circularity (0.655) is consistent with a folded garment. No significant mismatches.

---

### Cell [1,3] — levi-jeans / Levi's 501 牛仔裤
**VERDICT: STRONG MISMATCH**

| Metric | Value | Assessment |
|--------|-------|------------|
| Mean RGB | (154.6, 153.5, 153.9) | **Nearly perfect gray** (R≈G≈B) |
| Saturation | **0.079** | **Extremely low** — almost completely desaturated |
| Colorfulness | **12.5** | **Lowest of all 8 cells** |
| Blue fraction | 0.364 (36.4%) | High blue-dominant pixels... but see below |
| Denim blue fraction | **0.067 (6.7%)** | **Extremely low** — denim should be 50%+ |
| Blue excess (B−R) | **−0.7** | **B is LESS than R** — denim must have B > R |
| Edge density | **0.156** | **Highest of all 8 cells** — very detailed |
| Contours | **313** | **Highest contour count** — lots of small details |
| Spatial frequency HF ratio | **0.70** | **Highest detail level** |
| Edge diagonal strength | 55.34 | High diagonal edges |
| Center white fraction | 0.576 (57.6%) | Mostly white/light center |
| Center blue fraction | **0.9%** | **Essentially zero blue in center** |
| Color distance from expected blue denim | 107 (moderate) | Far from denim profile |

**Issues**:
1. **Saturation is only 0.079** — Levi's 501 jeans are iconic blue denim with high color saturation. This image is nearly grayscale.
2. **R ≈ B** (154.6 vs 153.9) — denim must have B > R (blue channel higher than red). Here they're equal.
3. **Denim blue fraction is 6.7%** — a pair of blue jeans should have 50%+ blue-dominant pixels.
4. **Center has only 0.9% blue pixels** — the main subject area has essentially no blue color.
5. The image is extremely detailed (highest edge density, contour count, and HF ratio) but the detail is grayscale, not denim texture.

**Conclusion**: This is a **strong mismatch**. The image appears to be a grayscale/neutral-toned highly-detailed image (possibly fabric texture, metal, or other material), not blue denim jeans. The near-total absence of blue color where blue denim should dominate is conclusive.

---

## Summary Table

| Cell | Label | Verdict | Key Issue |
|------|-------|---------|-----------|
| [0,0] | standing-desk | ⚠️ POSSIBLE MISMATCH | Very low wood tone (8.4%), mostly white image |
| [0,1] | led-desk-lamp | ✅ MATCH | Bright spots (55%), warm glow — consistent with lamp |
| [0,2] | memory-mattress | ⚠️ POSSIBLE MISMATCH | Dark image (brightness 150), high circularity, not white |
| [0,3] | bookshelf | ✅ MATCH | Grid structure (24×28 peaks), wood color, many contours |
| [1,0] | storage-box | ❌ STRONG MISMATCH | OCR reads "BOOKS", shelf-like structure, high green fraction |
| [1,1] | nike-sneaker | ⚠️ POSSIBLE MISMATCH | Bottom darker than top (−40.6), unusual for sneakers |
| [1,2] | adidas-hoodie | ✅ MATCH | Soft edges, low-frequency fabric texture, blue color |
| [1,3] | levi-jeans | ❌ STRONG MISMATCH | Saturation 0.079, denim blue 6.7%, R≈B — not blue denim |

---

## Most Likely Mismatches

1. **Cell [1,3] — levi-jeans → NOT JEANS**: The image is nearly grayscale (saturation 0.079) with essentially no blue color (denim blue fraction 6.7%, center blue 0.9%). This is the clearest mismatch. The image may show a different product entirely (possibly grayscale fabric or another material).

2. **Cell [1,0] — storage-box → POSSIBLY BOOKS**: OCR consistently reads "BOOKS" (BB0K8/BB00K8), the image shows two shelf-like horizontal bands, and the green fraction (19.2%) suggests plants. This cell likely contains a bookshelf image with a swapped or incorrect label.

3. **Cell [0,0] — standing-desk → POSSIBLY WRONG**: The near-absence of wood tone (8.4%) for a product labeled as a standing desk is suspicious. The image is mostly white with a blue background, which could be a different product.

4. **Cell [0,2] — memory-mattress → POSSIBLY WRONG**: The image is too dark (brightness 150) and too circular (0.79) for a mattress, which should be white and rectangular.