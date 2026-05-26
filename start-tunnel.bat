@echo off
echo ========================================
echo Cloudflare Quick Tunnel 启动脚本
echo ========================================
echo.
echo 请确保已下载 cloudflared.exe 到当前目录
echo.
echo 启动隧道中...
echo.

cloudflared.exe tunnel --url http://localhost:5176

pause
