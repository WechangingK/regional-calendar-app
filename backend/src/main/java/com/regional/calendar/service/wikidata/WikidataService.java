package com.regional.calendar.service.wikidata;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

import java.util.*;

/**
 * Wikidata SPARQL 查询服务
 * 用于获取中国少数民族节日数据
 */
@Slf4j
@Service
public class WikidataService {

    private static final String WIKIDATA_SPARQL_URL = "https://query.wikidata.org/sparql";
    private static final ObjectMapper objectMapper = new ObjectMapper();
    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * 查询中国少数民族节日
     */
    public List<WikidataFestival> fetchChineseMinorityFestivals() {
        String sparql = buildSparqlQuery();
        String jsonResponse = executeSparqlQuery(sparql);
        return parseFestivalResults(jsonResponse);
    }

    /**
     * 构建 SPARQL 查询语句
     */
    private String buildSparqlQuery() {
        return """
            SELECT DISTINCT
              ?festival
              ?festivalLabel
              ?festivalLabel_zh
              ?ethnicity
              ?ethnicityLabel
              ?startTime
              ?location
              ?locationLabel
              ?description
              ?image
            WHERE {
              # 查找中国的节日
              ?festival wdt:P31/wdt:P279* wd:Q132231.  # 实例为节日或其子类
              ?festival wdt:P17 wd:Q148.               # 位于中国

              # 可选：关联民族
              OPTIONAL { ?festival wdt:P172 ?ethnicity. }

              # 可选：开始时间
              OPTIONAL { ?festival wdt:P580 ?startTime. }

              # 可选：地点
              OPTIONAL { ?festival wdt:P276 ?location. }

              # 可选：描述
              OPTIONAL { ?festival schema:description ?description. FILTER(LANG(?description) = "zh") }

              # 可选：图片
              OPTIONAL { ?festival wdt:P18 ?image. }

              # 获取中文标签
              OPTIONAL { ?festival rdfs:label ?festivalLabel_zh. FILTER(LANG(?festivalLabel_zh) = "zh") }

              SERVICE wikibase:label { bd:serviceParam wikibase:language "zh,en". }
            }
            ORDER BY ?festivalLabel
            LIMIT 200
            """;
    }

    /**
     * 执行 SPARQL 查询
     */
    private String executeSparqlQuery(String sparql) {
        HttpHeaders headers = new HttpHeaders();
        headers.set("Accept", "application/sparql-results+json");
        headers.set("User-Agent", "RegionalCalendarApp/1.0 (contact@example.com)");

        HttpEntity<String> entity = new HttpEntity<>(headers);

        try {
            ResponseEntity<String> response = restTemplate.exchange(
                WIKIDATA_SPARQL_URL + "?query=" + java.net.URLEncoder.encode(sparql, java.nio.charset.StandardCharsets.UTF_8),
                HttpMethod.GET,
                entity,
                String.class
            );
            return response.getBody();
        } catch (Exception e) {
            log.error("Wikidata SPARQL 查询失败", e);
            return null;
        }
    }

    /**
     * 解析节日查询结果
     */
    private List<WikidataFestival> parseFestivalResults(String jsonResponse) {
        List<WikidataFestival> festivals = new ArrayList<>();

        if (jsonResponse == null) {
            return festivals;
        }

        try {
            JsonNode root = objectMapper.readTree(jsonResponse);
            JsonNode results = root.path("results").path("bindings");

            for (JsonNode binding : results) {
                WikidataFestival festival = new WikidataFestival();

                // 节日ID (Wikidata Q号)
                String festivalId = extractValue(binding, "festival");
                festival.setWikidataId(extractQId(festivalId));

                // 节日名称（中文）
                String nameZh = extractValue(binding, "festivalLabel_zh");
                String nameEn = extractValue(binding, "festivalLabel");
                festival.setNameZh(nameZh != null ? nameZh : nameEn);
                festival.setNameEn(nameEn);

                // 民族
                String ethnicityLabel = extractValue(binding, "ethnicityLabel");
                festival.setEthnicity(ethnicityLabel);

                // 时间
                String startTime = extractValue(binding, "startTime");
                festival.setStartTime(startTime);

                // 地点
                String location = extractValue(binding, "locationLabel");
                festival.setLocation(location);

                // 描述
                String description = extractValue(binding, "description");
                festival.setDescription(description);

                // 图片
                String image = extractValue(binding, "image");
                festival.setImageUrl(image);

                festivals.add(festival);
            }

            log.info("从Wikidata获取到 {} 个节日", festivals.size());
        } catch (Exception e) {
            log.error("解析Wikidata结果失败", e);
        }

        return festivals;
    }

    /**
     * 提取值
     */
    private String extractValue(JsonNode binding, String key) {
        JsonNode node = binding.path(key);
        if (node.isMissingNode() || node.isNull()) {
            return null;
        }
        return node.path("value").asText(null);
    }

    /**
     * 提取 Q 号
     */
    private String extractQId(String uri) {
        if (uri == null) return null;
        String[] parts = uri.split("/");
        return parts[parts.length - 1];
    }

    /**
     * 节日数据 DTO
     */
    @Data
    public static class WikidataFestival {
        private String wikidataId;
        private String nameZh;
        private String nameEn;
        private String ethnicity;
        private String startTime;
        private String location;
        private String description;
        private String imageUrl;
    }
}
