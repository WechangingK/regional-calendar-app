package com.regional.calendar.service.region;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.regional.calendar.entity.Region;
import com.regional.calendar.mapper.RegionMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.util.*;

/**
 * 地区数据导入服务
 * 从开源数据源批量导入地区数据
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class RegionImportService {

    private final RegionMapper regionMapper;
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    // 数据源地址
    private static final String COUNTRIES_API = "https://restcountries.com/v3.1/all?fields=name,cca2,region,latlng,translations";
    private static final String CHINA_PROVINCES_URL = "https://raw.githubusercontent.com/modood/Administrative-divisions-of-China/master/dist/pcas-code.json";
    private static final String CHINA_CITIES_URL = "https://raw.githubusercontent.com/modood/Administrative-divisions-of-China/master/dist/pca-code.json";

    /**
     * 导入全球国家数据
     */
    @Transactional
    public ImportResult importCountries() {
        log.info("开始导入全球国家数据...");
        int added = 0;
        int skipped = 0;

        try {
            String json = restTemplate.getForObject(COUNTRIES_API, String.class);
            JsonNode countries = objectMapper.readTree(json);

            for (JsonNode country : countries) {
                try {
                    String nameZh = extractChineseName(country);
                    String nameEn = country.path("name").path("common").asText();
                    String cca2 = country.path("cca2").asText();
                    JsonNode latlng = country.path("latlng");

                    if (nameZh == null || nameZh.isEmpty()) {
                        nameZh = nameEn;
                    }

                    // 检查是否已存在
                    if (existsByCode("COUNTRY_" + cca2)) {
                        skipped++;
                        continue;
                    }

                    Region region = new Region();
                    region.setParentId(0L);
                    region.setName(nameZh);
                    region.setNameLocal(nameEn);
                    region.setNamePinyin(nameEn.toLowerCase());
                    region.setLevel(0); // 0=国家
                    region.setCode("COUNTRY_" + cca2);
                    region.setStatus(1);

                    if (latlng.isArray() && latlng.size() >= 2) {
                        region.setLatitude(latlng.get(0).decimalValue());
                        region.setLongitude(latlng.get(1).decimalValue());
                    }

                    String regionValue = country.path("region").asText();
                    if (regionValue != null) {
                        region.setDescription("所属大洲: " + regionValue);
                    }

                    regionMapper.insert(region);
                    added++;
                } catch (Exception e) {
                    log.warn("导入国家失败: {}", country.path("name").path("common").asText(), e);
                }
            }

            log.info("全球国家数据导入完成: 新增={}, 跳过={}", added, skipped);
            return new ImportResult(added, skipped, "全球国家");

        } catch (Exception e) {
            log.error("导入全球国家数据失败", e);
            return new ImportResult(added, skipped, "全球国家", e.getMessage());
        }
    }

    /**
     * 导入中国省份数据（从本地文件）
     */
    @Transactional
    public ImportResult importChinaProvinces() {
        log.info("开始导入中国省份数据...");
        int added = 0;
        int skipped = 0;

        try {
            // 从本地文件读取
            java.io.InputStream is = getClass().getResourceAsStream("/data/china_regions.json");
            if (is == null) {
                return new ImportResult(0, 0, "中国省份", "本地数据文件不存在");
            }
            JsonNode data = objectMapper.readTree(is);
            JsonNode provinces = data.path("provinces");

            // 先创建中国作为父级
            Long chinaId = getOrCreateChina();

            for (JsonNode province : provinces) {
                try {
                    String code = province.path("code").asText();
                    String name = province.path("name").asText();

                    if (existsByCode(code)) {
                        skipped++;
                        continue;
                    }

                    Region region = new Region();
                    region.setParentId(chinaId);
                    region.setName(name);
                    region.setNamePinyin(toPinyin(name));
                    region.setLevel(1); // 1=省
                    region.setCode(code);
                    region.setStatus(1);

                    regionMapper.insert(region);
                    added++;
                } catch (Exception e) {
                    log.warn("导入省份失败: {}", province.path("name").asText(), e);
                }
            }

            log.info("中国省份数据导入完成: 新增={}, 跳过={}", added, skipped);
            return new ImportResult(added, skipped, "中国省份");

        } catch (Exception e) {
            log.error("导入中国省份数据失败", e);
            return new ImportResult(added, skipped, "中国省份", e.getMessage());
        }
    }

    /**
     * 导入中国市级数据（从本地文件）
     */
    @Transactional
    public ImportResult importChinaCities() {
        log.info("开始导入中国市级数据...");
        int added = 0;
        int skipped = 0;

        try {
            // 从本地文件读取
            java.io.InputStream is = getClass().getResourceAsStream("/data/china_regions.json");
            if (is == null) {
                return new ImportResult(0, 0, "中国市级", "本地数据文件不存在");
            }
            JsonNode data = objectMapper.readTree(is);
            JsonNode cities = data.path("cities");

            for (JsonNode city : cities) {
                try {
                    String provinceCode = city.path("provinceCode").asText();
                    String cityCode = city.path("code").asText();
                    String cityName = city.path("name").asText();

                    // 获取省份ID
                    Long provinceId = getIdByCode(provinceCode);
                    if (provinceId == null) {
                        continue;
                    }

                    if (existsByCode(cityCode)) {
                        skipped++;
                        continue;
                    }

                    Region region = new Region();
                    region.setParentId(provinceId);
                    region.setName(cityName);
                    region.setNamePinyin(toPinyin(cityName));
                    region.setLevel(2); // 2=市
                    region.setCode(cityCode);
                    region.setStatus(1);

                    regionMapper.insert(region);
                    added++;
                } catch (Exception e) {
                    log.warn("导入城市失败: {}", city.path("name").asText(), e);
                }
            }

            log.info("中国市级数据导入完成: 新增={}, 跳过={}", added, skipped);
            return new ImportResult(added, skipped, "中国市级");

        } catch (Exception e) {
            log.error("导入中国市级数据失败", e);
            return new ImportResult(added, skipped, "中国市级", e.getMessage());
        }
    }

    /**
     * 一键导入所有地区数据
     */
    public List<ImportResult> importAll() {
        List<ImportResult> results = new ArrayList<>();

        // 1. 导入全球国家
        results.add(importCountries());

        // 2. 导入中国省份
        results.add(importChinaProvinces());

        // 3. 导入中国市级
        results.add(importChinaCities());

        return results;
    }

    /**
     * 获取或创建中国记录
     */
    private Long getOrCreateChina() {
        LambdaQueryWrapper<Region> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Region::getCode, "COUNTRY_CN");
        Region china = regionMapper.selectOne(wrapper);

        if (china != null) {
            return china.getId();
        }

        china = new Region();
        china.setParentId(0L);
        china.setName("中国");
        china.setNameLocal("China");
        china.setNamePinyin("zhongguo");
        china.setLevel(0);
        china.setCode("COUNTRY_CN");
        china.setLatitude(java.math.BigDecimal.valueOf(35.8617));
        china.setLongitude(java.math.BigDecimal.valueOf(104.1954));
        china.setDescription("中华人民共和国");
        china.setStatus(1);
        regionMapper.insert(china);

        return china.getId();
    }

    /**
     * 提取中文名称
     */
    private String extractChineseName(JsonNode country) {
        JsonNode translations = country.path("translations");
        JsonNode zh = translations.path("zho");
        if (!zh.isMissingNode() && zh.has("common")) {
            return zh.path("common").asText();
        }
        // 尝试从nativeName获取
        JsonNode nativeName = country.path("name").path("nativeName");
        if (nativeName.has("zho")) {
            return nativeName.path("zho").path("common").asText();
        }
        return null;
    }

    /**
     * 检查编码是否存在
     */
    private boolean existsByCode(String code) {
        LambdaQueryWrapper<Region> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Region::getCode, code);
        return regionMapper.selectCount(wrapper) > 0;
    }

    /**
     * 根据编码获取ID
     */
    private Long getIdByCode(String code) {
        LambdaQueryWrapper<Region> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Region::getCode, code);
        wrapper.select(Region::getId);
        Region region = regionMapper.selectOne(wrapper);
        return region != null ? region.getId() : null;
    }

    /**
     * 简单拼音转换（实际项目中应使用pinyin4j库）
     */
    private String toPinyin(String chinese) {
        // 简化处理，实际项目建议使用 pinyin4j 库
        return chinese.replaceAll("[^\\w\\s]", "").toLowerCase();
    }

    /**
     * 导入结果
     */
    public static class ImportResult {
        public String type;
        public int added;
        public int skipped;
        public String error;
        public boolean success;

        public ImportResult(int added, int skipped, String type) {
            this.added = added;
            this.skipped = skipped;
            this.type = type;
            this.success = true;
        }

        public ImportResult(int added, int skipped, String type, String error) {
            this(added, skipped, type);
            this.error = error;
            this.success = false;
        }
    }
}
