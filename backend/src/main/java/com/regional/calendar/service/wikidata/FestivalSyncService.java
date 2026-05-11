package com.regional.calendar.service.wikidata;

import com.regional.calendar.entity.Festival;
import com.regional.calendar.entity.Ethnicity;
import com.regional.calendar.mapper.FestivalMapper;
import com.regional.calendar.mapper.EthnicityMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * 节日数据同步服务
 * 从 Wikidata 同步少数民族节日数据到数据库
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class FestivalSyncService {

    private final WikidataService wikidataService;
    private final FestivalMapper festivalMapper;
    private final EthnicityMapper ethnicityMapper;

    // Wikidata ID 到本地民族ID的映射
    private static final Map<String, Long> ETHNICITY_WIKIDATA_MAP = new HashMap<>() {{
        put("Q17430", 2L);   // 壮族
        put("Q163754", 5L);  // 苗族
        put("Q459074", 8L);  // 彝族
        put("Q46360", 9L);   // 蒙古族
        put("Q170780", 10L); // 藏族
        put("Q865501", 19L); // 傣族
        put("Q170496", 20L); // 畲族
        put("Q46611", 14L);  // 朝鲜族
        put("Q170595", 12L); // 侗族
        put("Q170471", 13L); // 瑶族
        put("Q46613", 15L);  // 白族
        put("Q46617", 16L);  // 哈尼族
        put("Q46621", 17L);  // 哈萨克族
        put("Q170678", 18L); // 黎族
        put("Q170594", 11L); // 布依族
    }};

    // 已知的少数民族节日类型映射
    private static final Map<String, Integer> FESTIVAL_TYPE_MAP = new HashMap<>() {{
        put("泼水节", 3);   // 民族节日
        put("火把节", 3);
        put("那达慕", 3);
        put("三月三", 3);
        put("雪顿节", 3);
        put("古尔邦节", 3);
        put("开斋节", 3);
        put("赶秋节", 3);
    }};

    /**
     * 从 Wikidata 同步节日数据
     * 每月1号凌晨2点执行
     */
    @Scheduled(cron = "0 0 2 1 * *")
    @Transactional
    public void syncFestivalsFromWikidata() {
        log.info("开始从 Wikidata 同步少数民族节日数据...");

        try {
            // 1. 从 Wikidata 获取节日数据
            List<WikidataService.WikidataFestival> wikidataFestivals = wikidataService.fetchChineseMinorityFestivals();

            if (wikidataFestivals.isEmpty()) {
                log.warn("未从 Wikidata 获取到节日数据");
                return;
            }

            // 2. 过滤出少数民族节日
            List<WikidataService.WikidataFestival> minorityFestivals = filterMinorityFestivals(wikidataFestivals);
            log.info("筛选出 {} 个少数民族节日", minorityFestivals.size());

            // 3. 同步到数据库
            int added = 0;
            int updated = 0;
            int skipped = 0;

            for (WikidataService.WikidataFestival wf : minorityFestivals) {
                try {
                    SyncResult result = syncSingleFestival(wf);
                    switch (result) {
                        case ADDED -> added++;
                        case UPDATED -> updated++;
                        case SKIPPED -> skipped++;
                    }
                } catch (Exception e) {
                    log.error("同步节日失败: {}", wf.getNameZh(), e);
                }
            }

            log.info("Wikidata 节日同步完成: 新增={}, 更新={}, 跳过={}", added, updated, skipped);

        } catch (Exception e) {
            log.error("Wikidata 节日同步异常", e);
        }
    }

    /**
     * 过滤少数民族节日
     */
    private List<WikidataService.WikidataFestival> filterMinorityFestivals(List<WikidataService.WikidataFestival> allFestivals) {
        return allFestivals.stream()
            .filter(f -> f.getEthnicity() != null && !f.getEthnicity().isEmpty())
            .filter(f -> {
                // 过滤掉汉族节日和全国性节日
                String ethnicity = f.getEthnicity();
                return !ethnicity.contains("汉族") &&
                       !ethnicity.contains("Chinese") &&
                       (f.getNameZh() != null && isMinorityFestival(f.getNameZh()));
            })
            .toList();
    }

    /**
     * 判断是否为少数民族节日
     */
    private boolean isMinorityFestival(String name) {
        String[] minorityFestivals = {
            "泼水节", "火把节", "那达慕", "三月三", "雪顿节",
            "古尔邦节", "开斋节", "赶秋节", "花山节", "姊妹节",
            "芦笙节", "龙船节", "吃新节", "苗年", "侗年",
            "盘王节", "达努节", "目瑙纵歌", "刀杆节",
            "仙女节", "酥油花灯节", "转山会", "旺果节"
        };

        for (String festival : minorityFestivals) {
            if (name.contains(festival)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 同步单个节日
     */
    private SyncResult syncSingleFestival(WikidataService.WikidataFestival wf) {
        // 检查是否已存在（通过名称和民族匹配）
        LambdaQueryWrapper<Festival> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Festival::getName, wf.getNameZh())
               .eq(Festival::getType, 3); // 民族节日类型

        Festival existing = festivalMapper.selectOne(wrapper);

        if (existing != null) {
            // 更新现有记录的 Wikidata 信息
            updateFestivalFromWikidata(existing, wf);
            festivalMapper.updateById(existing);
            return SyncResult.UPDATED;
        }

        // 创建新记录
        Festival festival = createFestivalFromWikidata(wf);
        if (festival != null) {
            festivalMapper.insert(festival);
            return SyncResult.ADDED;
        }

        return SyncResult.SKIPPED;
    }

    /**
     * 从 Wikidata 创建节日记录
     */
    private Festival createFestivalFromWikidata(WikidataService.WikidataFestival wf) {
        Festival festival = new Festival();
        festival.setName(wf.getNameZh());
        festival.setNameEnglish(wf.getNameEn());
        festival.setType(3); // 民族节日
        festival.setStatus(1);

        // 匹配民族
        Long ethnicityId = matchEthnicity(wf.getEthnicity());
        if (ethnicityId != null) {
            festival.setEthnicityId(ethnicityId);
            festival.setEthnicityName(wf.getEthnicity());
        }

        // 设置描述
        if (wf.getDescription() != null) {
            festival.setDescription(wf.getDescription());
        }

        // 设置图片
        if (wf.getImageUrl() != null) {
            festival.setImageUrl(wf.getImageUrl());
        }

        // 设置地区（根据民族推断）
        if (ethnicityId != null) {
            setRegionByEthnicity(festival, ethnicityId);
        }

        // 设置时间（如果有）
        if (wf.getStartTime() != null) {
            festival.setStartDate(wf.getStartTime());
        }

        return festival;
    }

    /**
     * 更新现有节日的 Wikidata 信息
     */
    private void updateFestivalFromWikidata(Festival existing, WikidataService.WikidataFestival wf) {
        // 只更新空字段
        if (existing.getNameEnglish() == null && wf.getNameEn() != null) {
            existing.setNameEnglish(wf.getNameEn());
        }
        if (existing.getDescription() == null && wf.getDescription() != null) {
            existing.setDescription(wf.getDescription());
        }
        if (existing.getImageUrl() == null && wf.getImageUrl() != null) {
            existing.setImageUrl(wf.getImageUrl());
        }
    }

    /**
     * 匹配民族
     */
    private Long matchEthnicity(String ethnicityName) {
        if (ethnicityName == null) return null;

        // 通过名称匹配
        LambdaQueryWrapper<Ethnicity> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(Ethnicity::getName, ethnicityName.replace("族", ""));
        Ethnicity ethnicity = ethnicityMapper.selectOne(wrapper);

        return ethnicity != null ? ethnicity.getId() : null;
    }

    /**
     * 根据民族设置地区
     */
    private void setRegionByEthnicity(Festival festival, Long ethnicityId) {
        // 常见民族-地区映射
        Map<Long, String> ethnicityRegionMap = new HashMap<>() {{
            put(2L, "广西");    // 壮族
            put(5L, "贵州");    // 苗族
            put(8L, "四川");    // 彝族
            put(9L, "内蒙古");  // 蒙古族
            put(10L, "西藏");   // 藏族
            put(11L, "贵州");   // 布依族
            put(12L, "贵州");   // 侗族
            put(13L, "广西");   // 瑶族
            put(14L, "吉林");   // 朝鲜族
            put(15L, "云南");   // 白族
            put(16L, "云南");   // 哈尼族
            put(17L, "新疆");   // 哈萨克族
            put(18L, "海南");   // 黎族
            put(19L, "云南");   // 傣族
            put(20L, "福建");   // 畲族
        }};

        String region = ethnicityRegionMap.get(ethnicityId);
        if (region != null) {
            festival.setRegionName(region);
        }
    }

    /**
     * 同步结果枚举
     */
    private enum SyncResult {
        ADDED, UPDATED, SKIPPED
    }
}
