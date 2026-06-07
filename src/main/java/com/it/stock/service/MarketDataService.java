package com.it.stock.service;

import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.it.stock.entity.MarketDataHistory;
import com.it.stock.mapper.MarketDataHistoryMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class MarketDataService {

    private final MarketDataHistoryMapper historyMapper;

    @Value("${market.api.url}")
    private String apiUrl;

    @Value("${market.api.token}")
    private String apiToken;

    @Value("${market.api.key:vgp_secret_key_2024}")
    private String apiKey;

    @Value("${market.api.device-id:device_noydyd_mpuo18sn}")
    private String deviceId;

    @Value("${market.api.login-url}")
    private String loginUrl;

    @Value("${market.api.username}")
    private String username;

    @Value("${market.api.password}")
    private String password;

    public Map<String, Object> getLatestMarketData() {
        try {
            return fetchData(apiToken);
        } catch (TokenExpiredException e) {
            String newToken = login();
            apiToken = newToken;
            return fetchData(newToken);
        }
    }

    public void saveMarketData(Map<String, Object> data) {
        MarketDataHistory history = new MarketDataHistory();
        history.setTitle((String) data.get("title"));
        history.setJsonData(JSON.toJSONString(data.get("jsonData")));
        history.setClickTimes((Integer) data.get("clickTimes"));
        history.setCreateTime(LocalDateTime.now());
        historyMapper.insert(history);
    }

    public List<MarketDataHistory> getHistoryList() {
        return historyMapper.selectList(null);
    }

    public MarketDataHistory getHistoryById(Long id) {
        return historyMapper.selectById(id);
    }

    public void deleteHistory(Long id) {
        historyMapper.deleteById(id);
    }

    private Map<String, Object> fetchData(String token) {
        HttpResponse response = HttpRequest.get(apiUrl)
                .header("Authorization", "Bearer " + token)
                .header("Device-Id", deviceId)
                .header("X-Referer-Token", "vgp3-internal-referer-2026")
                .header("Origin", "http://vgp.2te.cc")
                .header("Referer", "http://vgp.2te.cc/")
                .header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36")
                .execute();

        JSONObject jsonResponse = JSON.parseObject(response.body());
        int code = jsonResponse.getIntValue("code");
        if (code == 401 || "登录已过期，请重新登录".equals(jsonResponse.getString("msg"))) {
            throw new TokenExpiredException();
        }
        if (code != 200) {
            throw new RuntimeException("接口返回错误: " + jsonResponse.getString("msg"));
        }

        Object dataField = jsonResponse.get("data");
        JSONObject data;
        if (dataField instanceof String) {
            data = JSON.parseObject(decrypt((String) dataField));
        } else {
            data = jsonResponse.getJSONObject("data");
        }

        Object jsonDataField = data.get("jsonData");
        JSONObject jsonData;
        if (jsonDataField instanceof String) {
            jsonData = JSON.parseObject((String) jsonDataField);
        } else {
            jsonData = data.getJSONObject("jsonData");
        }

        if (jsonData == null) {
            return Collections.emptyMap();
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("jsonData", jsonData);
        result.put("title", data.getString("title"));
        result.put("clickTimes", data.getInteger("clickTimes"));
        return result;
    }

    private String login() {
        JSONObject body = new JSONObject();
        body.put("username", username);
        body.put("password", password);
        body.put("deviceId", deviceId);
        body.put("remember", false);

        HttpResponse response = HttpRequest.post(loginUrl)
                .header("Content-Type", "application/json")
                .header("Device-Id", deviceId)
                .header("X-Referer-Token", "vgp3-internal-referer-2026")
                .header("Origin", "http://vgp.2te.cc")
                .header("Referer", "http://vgp.2te.cc/")
                .header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36")
                .body(body.toJSONString())
                .execute();

        JSONObject jsonResponse = JSON.parseObject(response.body());
        if (jsonResponse.getIntValue("code") != 200) {
            throw new RuntimeException("登录失败: " + jsonResponse.getString("msg"));
        }
        return jsonResponse.getJSONObject("data").getString("token");
    }

    private String decrypt(String encryptedData) {
        byte[] raw = Base64.getDecoder().decode(encryptedData);
        byte[] keyBytes = apiKey.getBytes(StandardCharsets.UTF_8);
        byte[] decrypted = new byte[raw.length];
        for (int i = 0; i < raw.length; i++) {
            decrypted[i] = (byte) (raw[i] ^ keyBytes[i % keyBytes.length]);
        }
        return new String(decrypted, StandardCharsets.UTF_8);
    }

    private static class TokenExpiredException extends RuntimeException {}
}
