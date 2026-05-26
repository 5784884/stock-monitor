# 股票监控系统 - 文件上传脚本 (PowerShell)
# 使用方法：右键点击此文件 -> "使用PowerShell运行"

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  股票监控系统 - 文件上传脚本" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$SERVER_IP = "47.236.199.133"
$SERVER_USER = "root"
$SERVER_PASSWORD = "Hr%rK+3!x3B_4Bi"
$SERVER_PATH = "/root/stock"
$LOCAL_PATH = "C:\code\Stock"

Write-Host "服务器信息：" -ForegroundColor Yellow
Write-Host "  IP: $SERVER_IP"
Write-Host "  用户: $SERVER_USER"
Write-Host "  目标路径: $SERVER_PATH"
Write-Host ""

# 检查必需文件
Write-Host "[检查] 验证必需文件..." -ForegroundColor Yellow
$requiredFiles = @(
    "Dockerfile.optimized",
    "docker-compose.prod.yml",
    "deploy.sh",
    "pom.xml",
    "init.sql"
)

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $LOCAL_PATH $file
    if (Test-Path $filePath) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ✗ 缺少文件: $file" -ForegroundColor Red
        exit 1
    }
}

if (Test-Path (Join-Path $LOCAL_PATH "src")) {
    Write-Host "  ✓ src/" -ForegroundColor Green
} else {
    Write-Host "  ✗ 缺少 src 目录" -ForegroundColor Red
    exit 1
}

if (Test-Path (Join-Path $LOCAL_PATH "stock-frontend")) {
    Write-Host "  ✓ stock-frontend/" -ForegroundColor Green
} else {
    Write-Host "  ✗ 缺少 stock-frontend 目录" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "所有文件检查通过！" -ForegroundColor Green
Write-Host ""

# 提示用户
Write-Host "===========================================" -ForegroundColor Yellow
Write-Host "  准备上传文件到服务器" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "由于PowerShell无法直接使用密码进行SCP，" -ForegroundColor Cyan
Write-Host "请按照以下步骤手动上传：" -ForegroundColor Cyan
Write-Host ""

Write-Host "方法一：使用阿里云控制台上传（推荐）" -ForegroundColor Green
Write-Host "--------------------------------------"
Write-Host "1. 登录阿里云控制台"
Write-Host "2. 进入服务器管理页面"
Write-Host "3. 点击 '文件传输'"
Write-Host "4. 上传以下文件到 /root/stock/ 目录："
Write-Host "   - Dockerfile.optimized"
Write-Host "   - docker-compose.prod.yml"
Write-Host "   - deploy.sh"
Write-Host "   - pom.xml"
Write-Host "   - init.sql"
Write-Host "   - src/ (整个目录)"
Write-Host "   - stock-frontend/ (整个目录)"
Write-Host ""

Write-Host "方法二：使用WinSCP工具" -ForegroundColor Green
Write-Host "--------------------------------------"
Write-Host "1. 下载WinSCP: https://winscp.net/eng/download.php"
Write-Host "2. 连接信息："
Write-Host "   主机: $SERVER_IP"
Write-Host "   用户名: $SERVER_USER"
Write-Host "   密码: $SERVER_PASSWORD"
Write-Host "3. 将 C:\code\Stock 的文件拖拽到 /root/stock/"
Write-Host ""

Write-Host "方法三：使用命令行（需要手动输入密码）" -ForegroundColor Green
Write-Host "--------------------------------------"
Write-Host "在PowerShell中依次执行以下命令（每次需要输入密码）："
Write-Host ""
Write-Host "cd C:\code\Stock" -ForegroundColor Cyan
Write-Host "scp Dockerfile.optimized root@47.236.199.133:/root/stock/" -ForegroundColor Cyan
Write-Host "scp docker-compose.prod.yml root@47.236.199.133:/root/stock/" -ForegroundColor Cyan
Write-Host "scp deploy.sh root@47.236.199.133:/root/stock/" -ForegroundColor Cyan
Write-Host "scp pom.xml root@47.236.199.133:/root/stock/" -ForegroundColor Cyan
Write-Host "scp init.sql root@47.236.199.133:/root/stock/" -ForegroundColor Cyan
Write-Host "scp -r src root@47.236.199.133:/root/stock/" -ForegroundColor Cyan
Write-Host "scp -r stock-frontend root@47.236.199.133:/root/stock/" -ForegroundColor Cyan
Write-Host ""

Write-Host "===========================================" -ForegroundColor Yellow
Write-Host "  上传完成后，在服务器执行：" -ForegroundColor Yellow
Write-Host "===========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "cd /root/stock" -ForegroundColor Cyan
Write-Host "chmod +x deploy.sh" -ForegroundColor Cyan
Write-Host "./deploy.sh" -ForegroundColor Cyan
Write-Host ""

Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
