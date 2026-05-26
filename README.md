# 股票市场监控系统 (SaaS订阅版)

一个完整的全栈应用，支持用户订阅管理和实时股市数据展示。

## 技术栈

### 后端
- Java 17
- Spring Boot 3.4.0
- Spring Security + JWT
- MyBatis-Plus
- MySQL 8.0
- Hutool (HTTP客户端)
- FastJSON2

### 前端
- Vue 3
- Vite
- Element Plus
- Vue Router
- Axios

## 功能特性

### 用户端
- 用户注册/登录（JWT认证）
- 基于expire_time的订阅到期控制
- 实时股市数据展示（一进二、首板、二板等）
- 数据自动格式化和中文化

### 管理员端
- 用户列表管理
- 用户续期功能
- 重置用户密码
- 添加/删除用户

## 快速开始

### 1. 启动MySQL数据库

确保Docker已安装并运行，然后执行：

```bash
docker compose up -d mysql
```

或者手动配置MySQL，创建数据库：

```bash
mysql -u root -p
```

执行SQL脚本：

```sql
CREATE DATABASE IF NOT EXISTS stock_monitor_db DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE stock_monitor_db;

CREATE TABLE `sys_user` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名/账号',
  `password` VARCHAR(255) NOT NULL COMMENT '密码(BCrypt加密存储)',
  `role` VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '角色: ADMIN(管理员), USER(普通用户)',
  `expire_time` DATETIME COMMENT '账号有效截止时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';
```

### 2. 配置第三方API Token

编辑 `src/main/resources/application.yml`，替换你的Bearer Token：

```yaml
market:
  api:
    url: https://vgp-api.2te.cc/api/v1/frontend/message/latest
    token: YOUR_BEARER_TOKEN_HERE  # 替换为你的实际Token
```

### 3. 初始化管理员账号

使用BCrypt生成密码（例如密码为 `admin123`）：

```java
// 可以使用在线BCrypt工具或运行以下Java代码
BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
String encoded = encoder.encode("admin123");
System.out.println(encoded);
```

然后插入管理员账号：

```sql
INSERT INTO `sys_user` (`username`, `password`, `role`, `expire_time`)
VALUES ('admin', '$2a$10$生成的密码哈希', 'ADMIN', '2099-12-31 23:59:59');
```

### 4. 启动后端

```bash
# 编译项目
./gradlew build -x test

# 运行项目
./gradlew bootRun
```

后端将在 `http://localhost:8080` 启动。

### 5. 启动前端

```bash
cd stock-frontend

# 安装依赖（如果还没安装）
npm install

# 启动开发服务器
npm run dev
```

前端将在 `http://localhost:5173` 启动。

## API接口文档

### 认证接口

#### 注册
```
POST /api/auth/register
Content-Type: application/json

{
  "username": "test",
  "password": "123456",
  "durationMonths": 1
}
```

#### 登录
```
POST /api/auth/login
Content-Type: application/json

{
  "username": "test",
  "password": "123456"
}

响应：
{
  "code": 200,
  "message": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "username": "test",
    "role": "USER",
    "expireTime": "2024-06-25 13:00:00"
  }
}
```

### 数据接口

#### 获取股市数据
```
GET /api/data/latest-market
Authorization: Bearer {token}

响应：
{
  "code": 200,
  "message": "success",
  "data": {
    "首板": [...],
    "二板": [...],
    "一进二": [...]
  }
}
```

### 管理员接口

#### 获取所有用户
```
GET /api/admin/users
Authorization: Bearer {admin_token}
```

#### 添加用户
```
POST /api/admin/users
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "username": "newuser",
  "password": "123456",
  "role": "USER",
  "durationMonths": 1
}
```

#### 续期
```
PUT /api/admin/users/{id}/expire
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "durationMonths": 1
}
```

#### 重置密码
```
PUT /api/admin/users/{id}/password
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "newPassword": "newpass123"
}
```

#### 删除用户
```
DELETE /api/admin/users/{id}
Authorization: Bearer {admin_token}
```

## 项目结构

```
Stock/
├── src/
│   ├── main/
│   │   ├── java/com/it/stock/
│   │   │   ├── config/          # 配置类（Security、CORS）
│   │   │   ├── controller/      # 控制器
│   │   │   ├── dto/             # 数据传输对象
│   │   │   ├── entity/          # 实体类
│   │   │   ├── filter/          # JWT过滤器
│   │   │   ├── mapper/          # MyBatis Mapper
│   │   │   ├── service/         # 业务逻辑
│   │   │   ├── util/            # 工具类
│   │   │   └── common/          # 通用类
│   │   └── resources/
│   │       ├── application.yml  # 应用配置
│   │       └── schema.sql       # 数据库脚本
│   └── test/
├── stock-frontend/
│   ├── src/
│   │   ├── router/              # 路由配置
│   │   ├── utils/               # 工具类（Axios封装）
│   │   ├── views/               # 页面组件
│   │   ├── App.vue
│   │   └── main.js
│   └── package.json
├── build.gradle                 # Gradle配置
└── README.md
```

## 使用说明

### 普通用户流程
1. 访问 `http://localhost:5173`
2. 点击"注册"，选择开通时长（1/2/6/12个月）
3. 注册成功后登录
4. 进入数据大盘，查看股市数据
5. 点击"刷新数据"获取最新数据

### 管理员流程
1. 使用管理员账号登录（默认：admin / admin123）
2. 自动跳转到用户管理页面
3. 可以添加用户、续期、改密、删除用户
4. 点击"数据大盘"可查看股市数据

## 注意事项

1. **JWT密钥安全**：生产环境请修改 `application.yml` 中的 `jwt.secret` 为更强的密钥
2. **数据库密码**：修改 `application.yml` 中的数据库密码
3. **CORS配置**：如果前端部署到其他域名，需要在 `SecurityConfig.java` 中添加允许的域名
4. **第三方API Token**：必须配置有效的Bearer Token才能获取股市数据
5. **时区设置**：系统使用 `Asia/Shanghai` 时区，如需修改请在 `application.yml` 中调整

## 故障排查

### 后端无法启动
- 检查MySQL是否运行
- 检查数据库连接配置是否正确
- 检查端口8080是否被占用

### 前端无法访问后端
- 检查后端是否启动成功
- 检查CORS配置
- 打开浏览器控制台查看错误信息

### 登录后提示账号过期
- 检查数据库中用户的 `expire_time` 字段
- 使用管理员账号为用户续期

## 开发者

- 后端：Spring Boot 3 + MyBatis-Plus
- 前端：Vue 3 + Element Plus
- 数据库：MySQL 8.0

## 许可证

MIT License
