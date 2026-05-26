@echo off
chcp 65001 >/dev/null
title 启动系统
color 0A
echo ========================================
echo    股票监控系统 - 启动中
echo ========================================
echo.
cd C:\code\Stock
docker-compose up -d
echo.
echo ========================================
echo 系统启动完成！
echo ========================================
pause
