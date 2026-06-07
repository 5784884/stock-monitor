package com.it.stock.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.it.stock.entity.MarketDataHistory;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MarketDataHistoryMapper extends BaseMapper<MarketDataHistory> {
}
