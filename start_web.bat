@echo off
rem 冲动消费 Web 版一键启动（无需域名，本地即开即用）
cd /d "%~dp0"
set PORT=8080
if not exist "build\web\index.html" (
  echo 未找到 build\web，请先运行: flutter build web --release --base-href ./
  pause
  exit /b 1
)
where py >nul 2>nul
if %errorlevel%==0 (
  echo 服务已启动: http://localhost:%PORT%   （按 Ctrl+C 停止）
  start "" "http://localhost:%PORT%"
  py -m http.server %PORT% --directory build\web
  goto :eof
)
where python >nul 2>nul
if %errorlevel%==0 (
  echo 服务已启动: http://localhost:%PORT%   （按 Ctrl+C 停止）
  start "" "http://localhost:%PORT%"
  python -m http.server %PORT% --directory build\web
  goto :eof
)
echo 未找到 Python。请安装 Python（https://www.python.org/downloads/）后重试；
echo 或者安装 Node.js 后执行: npx serve build\web
pause
