@echo off
chcp 65001 >nul
echo ========================================
echo   Jekyll 部落格開發伺服器 (Windows)
echo ========================================
echo.
echo 正在啟動 Jekyll 開發伺服器...
echo 網址: http://127.0.0.1:4000
echo 網址: http://localhost:4000
echo.
echo 按 Ctrl+C 可停止伺服器
echo ========================================
echo.

docker run --rm -it ^
  --name jekyll-blog ^
  --volume="%cd%":/srv/jekyll ^
  -p 4000:4000 ^
  -p 35729:35729 ^
  jekyll/jekyll:4 ^
  jekyll serve --config _config.yml,_config_dev.yml --watch --force_polling --host 0.0.0.0 --incremental --livereload

echo.
echo 伺服器已停止
pause
