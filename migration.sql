-- 添加审批状态字段
USE stock_monitor_db;


-- 添加 approved 字段（如果已存在会报错，可以忽略）
ALTER TABLE `sys_user`
ADD COLUMN `approved` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '审批状态: 0(待审批), 1(已审批), 2(已拒绝)'
AFTER `role`;

-- 更新现有用户的审批状态（管理员自动审批通过）
UPDATE `sys_user` SET `approved` = 1 WHERE `role` = 'ADMIN';

-- 查看更新结果
SELECT id, username, role, approved FROM `sys_user`;
