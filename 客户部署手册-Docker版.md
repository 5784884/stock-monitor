# 股票监控系统 - 客户部署手册（Docker版）

## 📦 部署包准备（开发者操作）

### 第一步：打包项目文件

#### 1.1 项目目录
项目位于：`C:\code\Stock`

#### 1.2 必需文件清单
确保 `C:\code\Stock\` 目录包含以下文件：

**必需文件：**
- `docker-compose.yml` - Docker编排配置
- `Dockerfile` - 后端镜像构建文件
- `init.sql` - 数据库初始化脚本
- `pom.xml` - Maven配置
- `src/` - 后端源码目录（完整）
- `stock-frontend/` - 前端目录（完整）
- `cloudflared.exe` - 内网穿透工具
- `客户使用说明.txt` - 客户操作指南

**目录结构：**
```
C:\code\Stock\
├── docker-compose.yml
├── Dockerfile
├── pom.xml
├── init.sql
├── cloudflared.exe
├── 客户使用说明.txt
├── src/
│   └── main/
│       ├── java/
│       └── resources/
└── stock-frontend/
    ├── package.json
    ├── vite.config.js
    └── src/
```

#### 1.3 打包压缩
1. 右键 `C:\code\Stock` 文件夹
2. 选择"发送到" → "压缩(zipped)文件夹"
3. 重命名为 `Stock-v1.0.zip`

---

## 🚀 客户部署步骤

### 第一步：安装 Docker Desktop

#### 1.1 下载安装包
1. 访问：https://www.docker.com/products/docker-desktop/
2. 点击 **"Download for Windows"**
3. 下载完成后，双击安装

#### 1.2 安装配置
1. 勾选 **"Use WSL 2 instead of Hyper-V"**（推荐）
2. 点击 "OK"，等待安装完成
3. **重启电脑**

#### 1.3 启动验证
1. 重启后，打开 **Docker Desktop**
2. 接受服务条款
3. 等待 Docker 引擎启动（右下角图标变绿）
4. 打开命令提示符，输入：
```bash
docker --version
```
看到版本号说明安装成功。

---

### 第二步：解压部署包

#### 2.1 解压文件
1. 将 `Stock-v1.0.zip` 解压到 `C:\code\Stock\`
2. 确保目录结构正确

#### 2.2 验证文件
确认以下文件存在：
- `C:\code\Stock\docker-compose.yml`
- `C:\code\Stock\cloudflared.exe`
- `C:\code\Stock\客户使用说明.txt`

---

### 第三步：启动系统

#### 3.1 打开命令提示符
1. 按 `Win + R`
2. 输入 `cmd`，回车
3. 进入部署目录：
```bash
cd C:\code\Stock
```

#### 3.2 启动 Docker 容器
```bash
docker-compose up -d
```

**说明：**
- 首次运行需要下载镜像和构建（约 5-10 分钟）
- 看到 "done" 表示启动成功

#### 3.3 验证启动
```bash
docker-compose ps
```

应该看到 3 个容器都在运行：
- `stock-mysql` - 数据库
- `stock-backend` - 后端服务
- `stock-frontend` - 前端服务

#### 3.4 本地测试
打开浏览器访问：`http://localhost`

看到登录页面说明部署成功！

---

### 第四步：配置公网访问

#### 4.1 启动后端内网穿透
**新开一个命令提示符窗口**，执行：
```bash
cd C:\code\Stock
cloudflared.exe tunnel --url http://localhost:8080 > backend-tunnel.log 2>&1
```

**保持此窗口打开！**

#### 4.2 获取后端地址
**再开一个命令提示符窗口**，执行：
```bash
cd C:\code\Stock
findstr "trycloudflare.com" backend-tunnel.log
```

复制显示的地址，例如：`https://xxx-xxx-xxx.trycloudflare.com`

#### 4.3 更新前端配置
1. 用记事本打开：`C:\code\Stock\stock-frontend\.env.production`
2. 修改为（替换为你的后端地址）：
```
VITE_API_BASE_URL=https://xxx-xxx-xxx.trycloudflare.com
```
3. 保存文件

#### 4.4 重启前端容器
```bash
docker-compose restart frontend
```

等待 10 秒。

#### 4.5 启动前端内网穿透
**再开一个命令提示符窗口**，执行：
```bash
cd C:\code\Stock
cloudflared.exe tunnel --url http://localhost:80 > frontend-tunnel.log 2>&1
```

**保持此窗口打开！**

#### 4.6 获取前端访问地址
**再开一个命令提示符窗口**，执行：
```bash
cd C:\code\Stock
findstr "trycloudflare.com" frontend-tunnel.log
```

**这就是你的公网访问地址！** 例如：`https://yyy-yyy-yyy.trycloudflare.com`

---

### 第五步：分享给用户

将前端访问地址分享给用户：
- 访问地址：`https://yyy-yyy-yyy.trycloudflare.com`
- 登录账号：`admin`
- 登录密码：`admin123`

---

## 🔄 日常使用

### 启动系统（每次开机后）
1. 打开 Docker Desktop（等待启动完成）
2. 打开命令提示符：
```bash
cd C:\code\Stock
docker-compose up -d
```
3. 按照"第四步"配置公网访问

### 停止系统
```bash
cd C:\code\Stock
docker-compose down
```

同时关闭所有 cloudflared 窗口。

### 查看日志
```bash
# 查看所有日志
docker-compose logs

# 查看后端日志
docker-compose logs backend

# 实时查看日志
docker-compose logs -f
```

---

## ⚠️ 常见问题

### 问题1：Docker Desktop 无法启动
**解决：**
1. 以管理员身份打开 PowerShell
2. 运行：`wsl --install`
3. 重启电脑

### 问题2：端口被占用
**错误：** `port is already allocated`

**解决：**
修改 `docker-compose.yml` 中的端口：
```yaml
ports:
  - "8080:80"  # 将 80 改为 8080
```

### 问题3：容器启动失败
**解决：**
```bash
# 查看错误日志
docker-compose logs

# 重新构建
docker-compose up -d --build
```

### 问题4：无法获取公网地址
**解决：**
1. 确保 cloudflared 窗口保持打开
2. 等待 10-15 秒后再查询日志
3. 检查网络连接

---

## 📋 完整部署清单

### 客户需要准备：
- [ ] Windows 10/11 系统
- [ ] 稳定的网络连接
- [ ] 至少 4GB 可用内存
- [ ] 至少 10GB 可用磁盘空间

### 部署步骤：
- [ ] 安装 Docker Desktop
- [ ] 解压部署包到 C:\code\Stock
- [ ] 启动 Docker 容器
- [ ] 配置后端内网穿透
- [ ] 更新前端配置
- [ ] 配置前端内网穿透
- [ ] 获取公网地址并分享

---

## 🎯 优势

### Docker 部署的好处：
- ✅ **一键启动**：无需安装 Java、MySQL、Node.js
- ✅ **环境隔离**：不会与其他软件冲突
- ✅ **易于迁移**：复制文件夹即可换电脑
- ✅ **快速更新**：替换文件后重启即可
- ✅ **一键卸载**：删除容器和文件夹即可

---

## 📞 技术支持

遇到问题请提供：
1. 错误截图
2. 日志内容：`docker-compose logs`
3. Docker 版本：`docker --version`
