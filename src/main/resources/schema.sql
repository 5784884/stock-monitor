CREATE DATABASE IF NOT EXISTS stock_monitor_db DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE stock_monitor_db;

CREATE TABLE `sys_user` (
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名/账号',
  `password` VARCHAR(255) NOT NULL COMMENT '密码(BCrypt加密存储)',
  `role` VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '角色: ADMIN(管理员), USER(普通用户)',
  `approved` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '审批状态: 0(待审批), 1(已审批), 2(已拒绝)',
  `expire_time` DATETIME COMMENT '账号有效截止时间',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 初始化一个超级管理员账号 (用户名: admin, 密码: admin123)
INSERT INTO `sys_user` (`username`, `password`, `role`, `approved`, `expire_time`)
VALUES ('admin', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN', 1, '2099-12-31 23:59:59');
