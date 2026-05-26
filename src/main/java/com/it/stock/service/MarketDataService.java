package com.it.stock.service;

import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class MarketDataService {

    @Value("${market.api.url:https://vgp-api.2te.cc/api/v1/frontend/message/latest}")
    private String apiUrl;

    @Value("${market.api.token:}")
    private String apiToken;

    public Map<String, Object> getLatestMarketData() {
        try {
            // 发起HTTP请求
            HttpResponse response = HttpRequest.get(apiUrl)
                    .header("authorization", "Bearer " + apiToken)
                    .header("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
                    .execute();

            String responseBody = response.body();
            JSONObject jsonResponse = JSON.parseObject(responseBody);

            // 解析数据
            JSONObject data = jsonResponse.getJSONObject("data");
            if (data == null) {
                return Collections.emptyMap();
            }

            JSONObject jsonData = data.getJSONObject("jsonData");
            if (jsonData == null) {
                return Collections.emptyMap();
            }

            // 直接返回原始 jsonData，不进行字段转换
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("jsonData", jsonData);
            result.put("title", data.getString("title"));
            result.put("clickTimes", data.getInteger("clickTimes"));

            return result;

        } catch (Exception e) {
            throw new RuntimeException("获取股市数据失败: " + e.getMessage(), e);
        }
    }

    private Map<String, Object> transformMarketData(JSONObject jsonData) {
        Map<String, Object> result = new LinkedHashMap<>();

        // 字段映射关系
        Map<String, String> sectionMapping = new LinkedHashMap<>();
        sectionMapping.put("FirstBoard", "首板");
        sectionMapping.put("SecondBoard", "二板");
        sectionMapping.put("OneToTwo", "一进二");
        sectionMapping.put("TwoToThree", "二进三");
        sectionMapping.put("ThreeToFour", "三进四");
        sectionMapping.put("FourToFive", "四进五");
        sectionMapping.put("FiveToSix", "五进六");
        sectionMapping.put("HighBoard", "高板");

        // 字段名映射
        Map<String, String> fieldMapping = new LinkedHashMap<>();
        fieldMapping.put("MC", "名称");
        fieldMapping.put("ZF", "涨幅");
        fieldMapping.put("ZT", "涨停");
        fieldMapping.put("LB", "连板");
        fieldMapping.put("FDE", "封单额");
        fieldMapping.put("FDL", "封单量");
        fieldMapping.put("HS", "换手");
        fieldMapping.put("LTS", "流通市值");
        fieldMapping.put("ZGB", "总股本");
        fieldMapping.put("HY", "行业");

        // 遍历每个板块
        for (Map.Entry<String, String> entry : sectionMapping.entrySet()) {
            String originalKey = entry.getKey();
            String chineseKey = entry.getValue();

            if (jsonData.containsKey(originalKey)) {
                Object sectionData = jsonData.get(originalKey);

                if (sectionData instanceof List) {
                    List<Map<String, Object>> transformedList = new ArrayList<>();

                    for (Object item : (List<?>) sectionData) {
                        if (item instanceof Map) {
                            Map<String, Object> stockData = (Map<String, Object>) item;
                            Map<String, Object> transformedStock = new LinkedHashMap<>();

                            // 转换字段名
                            for (Map.Entry<String, String> fieldEntry : fieldMapping.entrySet()) {
                                String originalField = fieldEntry.getKey();
                                String chineseField = fieldEntry.getValue();

                                if (stockData.containsKey(originalField)) {
                                    transformedStock.put(chineseField, stockData.get(originalField));
                                }
                            }

                            // 特殊处理：拼接封单额和封单量
                            if (stockData.containsKey("FDE") && stockData.containsKey("FDL")) {
                                String fde = String.valueOf(stockData.get("FDE"));
                                String fdl = String.valueOf(stockData.get("FDL"));
                                transformedStock.put("封单额|量", fde + " | " + fdl);
                                transformedStock.remove("封单额");
                                transformedStock.remove("封单量");
                            }

                            transformedList.add(transformedStock);
                        }
                    }

                    result.put(chineseKey, transformedList);
                }
            }
        }

        return result;
    }
}
