package com.it.stock.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("market_data_history")
public class MarketDataHistory {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private String jsonData;

    private Integer clickTimes;

    private LocalDateTime createTime;
}
