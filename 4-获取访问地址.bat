@echo off
chcp 65001 >/dev/null
title 获取访问地址
color 0E
echo ========================================
echo    获取访问地址
echo ========================================
echo.
echo 正在获取地址，请稍候...
cd C:\code\Stock
timeout /t 3 /nobreak >/dev/null
echo.
echo ========================================
echo 后端地址（用于配置前端）：
echo ========================================
findstr "https://" backend-tunnel.log | findstr "trycloudflare.com" | findstr /V "INF"
echo.
echo ========================================
echo 前端访问地址（分享给用户）：
echo ========================================
findstr "https://" frontend-tunnel.log | findstr "trycloudflare.com" | findstr /V "INF"
echo.
echo ========================================
echo 登录账号：admin
echo 登录密码：admin123
echo ========================================
echo.
pause
