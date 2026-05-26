#!/bin/bash

echo "==================================="
echo "股票市场监控系统 - 快速启动脚本"
echo "==================================="

# 检查MySQL是否运行
echo ""
echo "1. 检查MySQL..."
if docker ps | grep -q mysql; then
    echo "✓ MySQL已运行"
else
    echo "✗ MySQL未运行，正在启动..."
    docker compose up -d mysql
    echo "等待MySQL启动..."
    sleep 10
fi

# 启动后端
echo ""
echo "2. 启动后端..."
cd /c/code/Stock
./gradlew bootRun &
BACKEND_PID=$!
echo "后端正在启动... (PID: $BACKEND_PID)"
echo "后端地址: http://localhost:8080"

# 等待后端启动
echo "等待后端启动完成..."
sleep 15

# 启动前端
echo ""
echo "3. 启动前端..."
cd stock-frontend
npm run dev &
FRONTEND_PID=$!
echo "前端正在启动... (PID: $FRONTEND_PID)"
echo "前端地址: http://localhost:5173"

echo ""
echo "==================================="
echo "✓ 系统启动完成！"
echo "==================================="
echo "前端访问地址: http://localhost:5173"
echo "后端API地址: http://localhost:8080"
echo ""
echo "默认管理员账号:"
echo "  用户名: admin"
echo "  密码: admin123"
echo ""
echo "按 Ctrl+C 停止所有服务"
echo "==================================="

# 等待用户中断
wait
