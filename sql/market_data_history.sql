CREATE TABLE IF NOT EXISTS `market_data_history` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` VARCHAR(255) DEFAULT NULL COMMENT '标题',
  `json_data` LONGTEXT DEFAULT NULL COMMENT 'JSON数据',
  `click_times` INT(11) DEFAULT NULL COMMENT '点击次数',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='股票市场历史数据表';
