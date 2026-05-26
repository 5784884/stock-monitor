@echo off
echo ========================================
echo 启动 Cloudflare 固定隧道
echo ========================================

cd /d C:\code\Stock

echo 启动隧道服务...
start /B cmd /c "cloudflared.exe tunnel --config cloudflared-config.yml run stock-system > cloudflared.log 2>&1"

echo.
echo 隧道已启动！
echo.
echo 访问地址：
echo 前端：https://stock.你的域名.com
echo 后端：https://api.你的域名.com
echo.
echo 登录账号：admin / admin123
echo ========================================
pause
