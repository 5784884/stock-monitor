@echo off
chcp 65001 >/dev/null
title 停止系统
color 0C
echo ========================================
echo    停止系统
echo ========================================
echo.
echo 正在停止所有服务...
cd C:\code\Stock
docker-compose down
taskkill /F /IM cloudflared.exe 2>/dev/null
echo.
echo ========================================
echo 系统已停止！
echo ========================================
pause
