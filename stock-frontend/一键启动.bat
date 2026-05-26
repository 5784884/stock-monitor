@echo off
chcp 65001 >/dev/null
echo ========================================
echo 股票监控系统 - 一键启动
echo ========================================

cd /d C:\code\Stock

echo.
echo [1/6] 启动后端服务...
start /B cmd /c "mvn spring-boot:run > backend.log 2>&1"
echo 等待后端启动（30秒）...
timeout /t 30 /nobreak >/dev/null

echo.
echo [2/6] 启动后端内网穿透...
start /B cmd /c "cloudflared.exe tunnel --url http://localhost:8080 > cloudflared-backend.log 2>&1"
echo 等待隧道建立（10秒）...
timeout /t 10 /nobreak >/dev/null

echo.
echo [3/6] 提取后端地址并更新前端配置...
timeout /t 2 /nobreak >/dev/null
powershell -Command "$url = (Get-Content cloudflared-backend.log | Select-String 'https://.*trycloudflare.com' | Select-Object -First 1).Matches.Value; Write-Output \"VITE_API_BASE_URL=$url\" | Out-File -FilePath stock-frontend\.env.development -Encoding utf8; Write-Host \"后端地址: $url\""

echo.
echo [4/6] 启动前端服务...
cd stock-frontend
start /B cmd /c "npm run dev -- --host 0.0.0.0 --port 5176 > ..\frontend.log 2>&1"
echo 等待前端启动（10秒）...
timeout /t 10 /nobreak >/dev/null

echo.
echo [5/6] 启动前端内网穿透...
cd ..
start /B cmd /c "cloudflared.exe tunnel --url http://localhost:5176 > cloudflared-frontend.log 2>&1"
echo 等待隧道建立（10秒）...
timeout /t 10 /nobreak >/dev/null

echo.
echo [6/6] 获取访问地址...
timeout /t 2 /nobreak >/dev/null
powershell -Command "$url = (Get-Content cloudflared-frontend.log | Select-String 'https://.*trycloudflare.com' | Select-Object -First 1).Matches.Value; Write-Host \"`n========================================`n前端访问地址: $url`n========================================`n`n登录账号: admin / admin123`n\""

pause
