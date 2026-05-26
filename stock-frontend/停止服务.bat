@echo off
echo 正在停止所有服务...

taskkill /F /IM java.exe 2>/dev/null
taskkill /F /IM node.exe 2>/dev/null
taskkill /F /IM cloudflared.exe 2>/dev/null

echo.
echo 所有服务已停止！
pause
