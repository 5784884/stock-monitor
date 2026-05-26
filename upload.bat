@echo off
chcp 65001 >nul
echo ==========================================
echo   股票监控系统 - 文件上传脚本
echo ==========================================
echo.

set SERVER_IP=47.236.199.133
set SERVER_USER=root
set SERVER_PATH=/root/stock
set LOCAL_PATH=C:\code\Stock

echo 准备上传文件到服务器...
echo 服务器: %SERVER_IP%
echo 目标路径: %SERVER_PATH%
echo.

echo [1/7] 上传 Dockerfile.optimized...
scp "%LOCAL_PATH%\Dockerfile.optimized" %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%/

echo [2/7] 上传 docker-compose.prod.yml...
scp "%LOCAL_PATH%\docker-compose.prod.yml" %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%/

echo [3/7] 上传 deploy.sh...
scp "%LOCAL_PATH%\deploy.sh" %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%/

echo [4/7] 上传 pom.xml...
scp "%LOCAL_PATH%\pom.xml" %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%/

echo [5/7] 上传 init.sql...
scp "%LOCAL_PATH%\init.sql" %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%/

echo [6/7] 上传 src 目录...
scp -r "%LOCAL_PATH%\src" %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%/

echo [7/7] 上传 stock-frontend 目录...
scp -r "%LOCAL_PATH%\stock-frontend" %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%/

echo.
echo ==========================================
echo   上传完成！
echo ==========================================
echo.
echo 下一步：
echo 1. 使用阿里云网页终端连接服务器
echo 2. 执行以下命令：
echo    cd /root/stock
echo    chmod +x deploy.sh
echo    ./deploy.sh
echo.
pause
