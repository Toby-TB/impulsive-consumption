#!/usr/bin/env bash
# 用 Chrome headless 把 tool/assets_src/*.svg 光栅化为 PNG
# 用法: bash tool/gen_images.sh
set -euo pipefail
cd "$(dirname "$0")/.."
CHROME="${CHROME_EXECUTABLE:-google-chrome}"
mkdir -p assets/images/products assets/icon
for f in tool/assets_src/*.svg; do
  id="$(basename "$f" .svg)"
  if [ "$id" = "app_icon" ]; then
    out="assets/icon/app_icon.png"; size=1024
  else
    out="assets/images/products/$id.png"; size=600
  fi
  url="file://$PWD/$f"
  if ! "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
       --window-size="$size,$size" --screenshot="$out" "$url" >/dev/null 2>&1; then
    "$CHROME" --headless --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
       --window-size="$size,$size" --screenshot="$out" "$url" >/dev/null 2>&1
  fi
  echo "OK $id -> $out"
done
echo "all done"
