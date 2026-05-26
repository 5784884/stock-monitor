#!/bin/bash
# 一键部署脚本 - 复制粘贴到服务器执行

# 创建项目目录
mkdir -p /root/stock
cd /root/stock

echo "=========================================="
echo "  开始部署股票监控系统"
echo "=========================================="
echo ""

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo "安装Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl start docker
    systemctl enable docker
fi

# 检查Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "安装Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo "Docker环境准备完成"
echo ""
echo "=========================================="
echo "  请按照以下步骤操作："
echo "=========================================="
echo ""
echo "1. 使用阿里云控制台的'文件传输'功能"
echo "2. 上传以下文件到 /root/stock/ 目录："
echo "   - Dockerfile.optimized"
echo "   - docker-compose.prod.yml"
echo "   - pom.xml"
echo "   - init.sql"
echo "   - src/ (整个目录)"
echo "   - stock-frontend/ (整个目录)"
echo ""
echo "3. 上传完成后，执行："
echo "   cd /root/stock"
echo "   docker-compose -f docker-compose.prod.yml build"
echo "   docker-compose -f docker-compose.prod.yml up -d"
echo ""
