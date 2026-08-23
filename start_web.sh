#!/usr/bin/env bash
# 冲动消费 Web 版一键启动（无需域名，本地即开即用）
set -euo pipefail
cd "$(dirname "$0")"
PORT="${1:-8080}"
if [ ! -f "build/web/index.html" ]; then
  echo "未找到 build/web，请先运行: flutter build web --release --base-href ./"
  exit 1
fi
if command -v python3 >/dev/null 2>&1; then
  echo "服务已启动: http://localhost:$PORT （按 Ctrl+C 停止）"
  python3 -m http.server "$PORT" --directory build/web
elif command -v python >/dev/null 2>&1; then
  echo "服务已启动: http://localhost:$PORT （按 Ctrl+C 停止）"
  python -m http.server "$PORT" --directory build/web
else
  echo "未找到 python3。请安装后重试；或安装 Node.js 后执行: npx serve build/web"
  exit 1
fi
