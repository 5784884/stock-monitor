package com.it.stock.controller;

import com.it.stock.common.Result;
import com.it.stock.entity.MarketDataHistory;
import com.it.stock.service.MarketDataService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
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

    @PostMapping("/save-market")
    public Result<Void> saveMarket(@RequestBody Map<String, Object> data) {
        try {
            marketDataService.saveMarketData(data);
            return Result.success(null);
        } catch (Exception e) {
            return Result.error("保存数据失败: " + e.getMessage());
        }
    }

    @GetMapping("/history-list")
    public Result<List<MarketDataHistory>> getHistoryList() {
        try {
            List<MarketDataHistory> list = marketDataService.getHistoryList();
            return Result.success(list);
        } catch (Exception e) {
            return Result.error("获取历史记录失败: " + e.getMessage());
        }
    }

    @GetMapping("/history/{id}")
    public Result<MarketDataHistory> getHistoryById(@PathVariable Long id) {
        try {
            MarketDataHistory history = marketDataService.getHistoryById(id);
            return Result.success(history);
        } catch (Exception e) {
            return Result.error("获取历史记录详情失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/history/{id}")
    public Result<Void> deleteHistory(@PathVariable Long id) {
        try {
            marketDataService.deleteHistory(id);
            return Result.success(null);
        } catch (Exception e) {
            return Result.error("删除历史记录失败: " + e.getMessage());
        }
    }
}
