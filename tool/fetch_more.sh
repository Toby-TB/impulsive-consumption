#!/usr/bin/env bash
# 从 Wikimedia Commons 拉取新增商品图并合成 600×600 白底方图
# 用法: bash tool/fetch_more.sh
set -euo pipefail
cd "$(dirname "$0")/.."
CHROME="${CHROME_EXECUTABLE:-google-chrome}"
UA="ImpulsiveConsumptionDemo/1.0 (educational demo)"
mkdir -p tool/real_src
# id|Commons搜索词
LIST=(
"iphone-15-pro|Apple iPhone 15 Pro"
"samsung-galaxy-s24|Samsung Galaxy S24"
"macbook-air|MacBook Air M3"
"airpods-pro|AirPods Pro 2"
"ipad-air|iPad Air"
"sony-wh1000-xm5|Sony WH-1000XM5"
"kindle-paperwhite|Amazon Kindle Paperwhite"
"laser-printer|laser printer"
"dyson-v12|Dyson V12 vacuum"
"instant-pot|Instant Pot pressure cooker"
"air-fryer|air fryer"
"robot-vacuum|robot vacuum cleaner"
"espresso-machine|espresso machine"
"water-purifier|water purifier"
"electric-kettle|electric kettle"
"induction-cooker|induction cooktop"
"ergo-chair|office chair"
"standing-desk|standing desk"
"led-desk-lamp|desk lamp"
"memory-mattress|mattress"
"bookshelf|bookshelf"
"storage-box|storage box"
"nike-sneaker|Nike running shoes"
"adidas-hoodie|Adidas hoodie"
"levi-jeans|Levi's jeans"
"canvas-tote|canvas tote bag"
"espresso-beans|coffee beans"
"longjing-tea|Longjing green tea"
"dark-chocolate|dark chocolate"
"olive-oil|extra virgin olive oil"
"yoga-mat|yoga mat"
"dumbbell-set|dumbbells"
"thermos-bottle|insulated water bottle"
)
for entry in "${LIST[@]}"; do
  id="${entry%%|*}"; q="${entry#*|}"
  # 取 Commons 首张 600px 缩略图
  url=$(curl -s -A "$UA" "https://commons.wikimedia.org/w/api.php?action=query&generator=search&gsrsearch=filetype:bitmap%20$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$q")&gsrnamespace=6&gsrlimit=1&prop=imageinfo&iiprop=url&iiurlwidth=600&format=json" \
      | python3 -c "import sys,json;d=json.load(sys.stdin);p=list(d.get('query',{}).get('pages',{}).values());print((p[0]['imageinfo'][0].get('thumburl') or '') if p else '')")
  if [ -z "$url" ]; then echo "FAIL search $id"; continue; fi
  # 去掉 utm 参数
  url="${url%%\?*}"
  curl -sL -A "$UA" "$url" -o "tool/real_src/$id.raw"
  sz=$(stat -c%s "tool/real_src/$id.raw" 2>/dev/null || echo 0)
  if [ "$sz" -lt 5000 ]; then echo "FAIL download $id ($sz)"; continue; fi
  cat > "tool/real_src/$id.html" <<HTML
<!DOCTYPE html><html><head><meta charset="utf-8"><style>
body{margin:0;width:600px;height:600px;background:#F6F4F1;display:flex;align-items:center;justify-content:center;overflow:hidden}
img{max-width:88%;max-height:88%;object-fit:contain}
</style></head><body><img src="$id.raw"></body></html>
HTML
  "$CHROME" --headless=new --disable-gpu --force-device-scale-factor=1 \
    --window-size=600,600 --screenshot="assets/images/products/$id.png" \
    "file://$PWD/tool/real_src/$id.html" >/dev/null 2>&1 || true
  echo "OK $id ($sz)"
done
echo "all fetched"
