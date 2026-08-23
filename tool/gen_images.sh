#!/usr/bin/env bash
# 用 Chrome headless 光栅化 SVG（应用图标 + README 横幅）
# 真实商品图由 tool/fetch_real.sh 拉取合成；旧插画源在 tool/assets_src/legacy_illustrations/
# 用法: bash tool/gen_images.sh
set -euo pipefail
cd "$(dirname "$0")/.."
CHROME="${CHROME_EXECUTABLE:-google-chrome}"
mkdir -p assets/icon docs/images

# 应用图标
"$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
  --window-size=1024,1024 --screenshot="assets/icon/app_icon.png" \
  "file://$PWD/tool/assets_src/app_icon.svg" >/dev/null 2>&1 || \
"$CHROME" --headless --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
  --window-size=1024,1024 --screenshot="assets/icon/app_icon.png" \
  "file://$PWD/tool/assets_src/app_icon.svg" >/dev/null 2>&1
echo "OK app_icon -> assets/icon/app_icon.png"

# README 横幅（HTML 模板，含真实商品抠图）
"$CHROME" --headless=new --disable-gpu --allow-file-access-from-files --hide-scrollbars --force-device-scale-factor=1 \
  --window-size=1200,400 --screenshot="docs/images/banner.png" \
  "file://$PWD/tool/assets_src/banner.html" >/dev/null 2>&1 || \
"$CHROME" --headless --disable-gpu --allow-file-access-from-files --hide-scrollbars --force-device-scale-factor=1 \
  --window-size=1200,400 --screenshot="docs/images/banner.png" \
  "file://$PWD/tool/assets_src/banner.html" >/dev/null 2>&1
echo "OK banner -> docs/images/banner.png"
echo "all done"
