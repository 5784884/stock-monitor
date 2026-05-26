@echo off
chcp 65001 >/dev/null
title 后端隧道
color 0B
echo ========================================
echo    后端隧道 - 启动中
echo ========================================
echo.
echo 【重要】此窗口必须保持打开！
echo.
cd C:\code\Stock
cloudflared.exe tunnel --url http://localhost:8080 > backend-tunnel.log 2>&1
