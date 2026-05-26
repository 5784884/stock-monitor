@echo off
chcp 65001 >/dev/null
title 前端隧道
color 0C
echo ========================================
echo    前端隧道 - 启动中
echo ========================================
echo.
echo 【重要】此窗口必须保持打开！
echo.
cd C:\code\Stock
cloudflared.exe tunnel --url http://localhost:80 > frontend-tunnel.log 2>&1
