package com.it.stock.controller;

import com.it.stock.common.Result;
import com.it.stock.service.MarketDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/data")
@RequiredArgsConstructor
public class DataController {

    private final MarketDataService marketDataService;

    @GetMapping("/latest-market")
    public Result<Map<String, Object>> getLatestMarket() {
        try {
            Map<String, Object> data = marketDataService.getLatestMarketData();
            return Result.success(data);
        } catch (Exception e) {
            return Result.error("获取数据失败: " + e.getMessage());
        }
    }
}
