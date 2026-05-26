#!/bin/bash
# 股票监控系统 - 服务器部署脚本
# 适用于 1GB 内存的阿里云香港服务器

set -e  # 遇到错误立即退出

echo "=========================================="
echo "  股票监控系统 - 自动部署脚本"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}请使用 root 用户运行此脚本${NC}"
    exit 1
fi

# 1. 检查Docker和Docker Compose
echo -e "${YELLOW}[1/8] 检查 Docker 环境...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker 未安装，正在安装...${NC}"
    curl -fsSL https://get.docker.com | sh
    systemctl start docker
    systemctl enable docker
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose 未安装，正在安装...${NC}"
    curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo -e "${GREEN}✓ Docker 版本: $(docker --version)${NC}"
echo -e "${GREEN}✓ Docker Compose 版本: $(docker-compose --version)${NC}"
echo ""

# 2. 检查项目文件
echo -e "${YELLOW}[2/8] 检查项目文件...${NC}"
cd /root/stock

REQUIRED_FILES=("pom.xml" "init.sql" "Dockerfile.optimized" "docker-compose.prod.yml")
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}✗ 缺少文件: $file${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ 找到文件: $file${NC}"
done

if [ ! -d "src" ]; then
    echo -e "${RED}✗ 缺少 src 目录${NC}"
    exit 1
fi

if [ ! -d "stock-frontend" ]; then
    echo -e "${RED}✗ 缺少 stock-frontend 目录${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 所有必需文件已就绪${NC}"
echo ""

# 3. 停止旧容器
echo -e "${YELLOW}[3/8] 停止旧容器（如果存在）...${NC}"
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true
echo -e "${GREEN}✓ 旧容器已停止${NC}"
echo ""

# 4. 清理旧镜像（可选）
echo -e "${YELLOW}[4/8] 清理未使用的镜像...${NC}"
docker image prune -f
echo -e "${GREEN}✓ 清理完成${NC}"
echo ""

# 5. 构建镜像
echo -e "${YELLOW}[5/8] 构建 Docker 镜像（这可能需要 10-15 分钟）...${NC}"
docker-compose -f docker-compose.prod.yml build --no-cache
echo -e "${GREEN}✓ 镜像构建完成${NC}"
echo ""

# 6. 启动容器
echo -e "${YELLOW}[6/8] 启动容器...${NC}"
docker-compose -f docker-compose.prod.yml up -d
echo -e "${GREEN}✓ 容器已启动${NC}"
echo ""

# 7. 等待服务启动
echo -e "${YELLOW}[7/8] 等待服务启动（约60秒）...${NC}"
sleep 10

for i in {1..12}; do
    echo -n "."
    sleep 5
done
echo ""
echo -e "${GREEN}✓ 等待完成${NC}"
echo ""

# 8. 健康检查
echo -e "${YELLOW}[8/8] 健康检查...${NC}"
echo ""

# 检查容器状态
echo "容器运行状态："
docker-compose -f docker-compose.prod.yml ps
echo ""

# 检查后端健康
echo "检查后端服务..."
if curl -f http://localhost:8080/actuator/health 2>/dev/null; then
    echo -e "${GREEN}✓ 后端服务正常${NC}"
else
    echo -e "${YELLOW}⚠ 后端服务可能还在启动中，请稍后检查${NC}"
fi
echo ""

# 检查前端
echo "检查前端服务..."
if curl -f http://localhost:80 2>/dev/null > /dev/null; then
    echo -e "${GREEN}✓ 前端服务正常${NC}"
else
    echo -e "${RED}✗ 前端服务异常${NC}"
fi
echo ""

# 9. 显示访问信息
echo "=========================================="
echo -e "${GREEN}  部署完成！${NC}"
echo "=========================================="
echo ""
echo "访问地址："
echo "  前端: http://47.236.199.133"
echo "  后端API: http://47.236.199.133:8080"
echo ""
echo "默认账号："
echo "  用户名: admin"
echo "  密码: admin123"
echo ""
echo "常用命令："
echo "  查看日志: docker-compose -f docker-compose.prod.yml logs -f"
echo "  重启服务: docker-compose -f docker-compose.prod.yml restart"
echo "  停止服务: docker-compose -f docker-compose.prod.yml down"
echo "  查看状态: docker-compose -f docker-compose.prod.yml ps"
echo ""
echo "如遇问题，请查看日志："
echo "  后端日志: docker-compose -f docker-compose.prod.yml logs backend"
echo "  数据库日志: docker-compose -f docker-compose.prod.yml logs mysql"
echo "  前端日志: docker-compose -f docker-compose.prod.yml logs frontend"
echo ""
echo "=========================================="
