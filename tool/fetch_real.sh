#!/usr/bin/env bash
# 从 dopamineshopping.com 下载真实商品图并合成 600×600 白底方图
set -euo pipefail
cd "$(dirname "$0")/.."
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120 Safari/537.36"
CHROME="${CHROME_EXECUTABLE:-google-chrome}"
mkdir -p tool/real_src

# newid|源文件名
LIST=(
"nvidia-rtx-4090|placa-de-video-nvidia-geforce-rtx-40-ser.png"
"gigabyte-rtx-5090|placa-de-video-gigabyte-geforce-rtx-5090.png"
"asus-rog-strix-4090|placa-de-video-asus-rog-strix-geforce-rt-3.png"
"zotac-rtx-5090|placa-de-video-zotac-geforce-rtx-5090-so.png"
"msi-gaming-trio-4090|placa-de-video-nvidia-msi-gaming-trio-ge.png"
"gigabyte-5090-aorus|placa-de-video-gigabyte-rtx-5090-aorus-m.png"
"inno3d-rtx-5090|placa-de-video-inno3d-geforce-rtx-5090-x.png"
"ps5-slim|ps5-v2.png"
"stern-pinball|maquina-de-pinball-stern-metallica-pro.png"
"airhockey-kids|mesa-air-game-air-hockey-air-kids-disk-p.png"
"airhockey-pro|air-hockey-profissional-tarifado-persona.png"
"fanatec-gt-extreme|fanatec-gran-turismo-extreme-15nm--d55d4.png"
"fanatec-f1-kit|kit-fanatec-clubsport-racing-wheel-f1-18.png"
"simagic-alpha-pro|combo-simagic-alpha-pro-base-direcao-vol.png"
"darth-vader-statue|estatua-darth-vader-mythos-star-wars-exc.png"
"fanatec-dd-plus|kit-fanatec-base-clubsport-dd-18nm-96701.png"
"pulse-bluepc|pc-gamer-pulse-bluepc-intel-i9-14900kf-r.png"
"aura-workstation|pc-gamer-workstation-aura-by-bluepc-inte.png"
"centella-cream|creme-facial-hidratante-com-centella-asi.png"
"roundlab-toner|tonico-facial-dokdo-round-lab-1025-190-m.png"
"somebymi-foam|espuma-anti-acne-milagrosa-de-30-dias-so.png"
"mask-set-6|kit-c-6-mascara-coreana-facial-skin-care.png"
"collagen-mask|mascara-facial-coreana-de-colageno-de-6-.png"
"joseon-sunscreen|a-beleza-de-joseon-arroz-fresco-com-agua.png"
"sleep-lip-mask|mascara-labial-para-dormir-20g-sc.png"
"medicube-mask|mascara-facial-medicube-pdrn-pink-mask-2.png"
"laneige-lipmask|laneige-labios-mascara-lips-sleeping-mas-2.png"
"roundlab-exfoliant|tonico-esfoliante-dokdo-1025-100ml-uso-d.png"
)

for entry in "${LIST[@]}"; do
  id="${entry%%|*}"
  src="${entry#*|}"
  # 1) 下载原图
  curl -sL -A "$UA" "https://dopamineshopping.com/produtos/$src" -o "tool/real_src/$id.raw.png"
  sz=$(stat -c%s "tool/real_src/$id.raw.png" 2>/dev/null || echo 0)
  if [ "$sz" -lt 5000 ]; then echo "FAIL download $id ($sz bytes)"; continue; fi
  # 2) 合成 600×600 白底方图
  cat > "tool/real_src/$id.html" <<HTML
<!DOCTYPE html><html><head><meta charset="utf-8"><style>
body{margin:0;width:600px;height:600px;background:#F6F4F1;display:flex;align-items:center;justify-content:center;overflow:hidden}
img{max-width:88%;max-height:88%;object-fit:contain}
</style></head><body><img src="$id.raw.png"></body></html>
HTML
  "$CHROME" --headless=new --disable-gpu --force-device-scale-factor=1 \
    --window-size=600,600 --screenshot="assets/images/products/$id.png" \
    "file://$PWD/tool/real_src/$id.html" >/dev/null 2>&1 || true
  echo "OK $id ($sz bytes -> assets/images/products/$id.png)"
done
echo "all fetched"
