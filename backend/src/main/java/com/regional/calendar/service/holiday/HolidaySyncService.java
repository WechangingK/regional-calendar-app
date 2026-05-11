package com.regional.calendar.service.holiday;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.regional.calendar.entity.Festival;
import com.regional.calendar.entity.HolidaySchedule;
import com.regional.calendar.mapper.FestivalMapper;
import com.regional.calendar.mapper.HolidayScheduleMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 法定假日同步服务
 * 从 timor.tech API 同步法定假日数据
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class HolidaySyncService {

    private final FestivalMapper festivalMapper;
    private final HolidayScheduleMapper holidayScheduleMapper;
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    private static final String TIMOR_API = "https://timor.tech/api/holiday/year/";
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * 同步指定年份的法定假日数据（从本地文件）
     */
    @Transactional
    public SyncResult syncHolidayData(int year) {
        log.info("开始同步{}年法定假日数据...", year);
        int added = 0;
        int updated = 0;
        int skipped = 0;

        try {
            // 从本地文件读取
            java.io.InputStream is = getClass().getResourceAsStream("/data/holidays_" + year + ".json");
            if (is == null) {
                return new SyncResult(0, 0, 0, year + "年假日数据文件不存在");
            }

            JsonNode root = objectMapper.readTree(is);
            JsonNode holidays = root.path("holidays");

            for (JsonNode holiday : holidays) {
                try {
                    String name = holiday.path("name").asText();
                    String startDate = holiday.path("startDate").asText();
                    String endDate = holiday.path("endDate").asText();
                    int totalDays = holiday.path("totalDays").asInt(1);
                    String workDaysDesc = holiday.path("workDaysDesc").asText("");

                    // 查找或创建节日记录
                    Festival festival = findOrCreateFestival(name, year);
                    if (festival == null) continue;

                    // 查找或创建放假安排
                    LambdaQueryWrapper<HolidaySchedule> wrapper = new LambdaQueryWrapper<>();
                    wrapper.eq(HolidaySchedule::getYear, year)
                           .eq(HolidaySchedule::getFestivalId, festival.getId())
                           .eq(HolidaySchedule::getRegionId, 0);

                    HolidaySchedule existing = holidayScheduleMapper.selectOne(wrapper);

                    if (existing != null) {
                        skipped++;
                        continue;
                    }

                    // 创建新记录
                    HolidaySchedule schedule = new HolidaySchedule();
                    schedule.setYear(year);
                    schedule.setFestivalId(festival.getId());
                    schedule.setFestivalName(festival.getName());
                    schedule.setRegionId(0L);
                    schedule.setStartDate(LocalDate.parse(startDate));
                    schedule.setEndDate(LocalDate.parse(endDate));
                    schedule.setTotalDays(totalDays);
                    schedule.setWorkDaysDesc(workDaysDesc);
                    schedule.setIsOfficial(1);
                    schedule.setStatus(1);

                    holidayScheduleMapper.insert(schedule);
                    added++;
                } catch (Exception e) {
                    log.warn("同步假日失败: {}", holiday.path("name").asText(), e);
                }
            }

            log.info("{}年法定假日同步完成: 新增={}, 更新={}, 跳过={}", year, added, updated, skipped);
            return new SyncResult(added, updated, skipped, null);

        } catch (Exception e) {
            log.error("同步法定假日数据失败", e);
            return new SyncResult(added, updated, skipped, e.getMessage());
        }
    }

    /**
     * 查找或创建节日记录
     */
    private Festival findOrCreateFestival(String name, int year) {
        // 标准化名称
        String standardName = standardizeName(name);
        if (standardName == null) return null;

        // 查找现有节日
        LambdaQueryWrapper<Festival> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Festival::getName, standardName)
               .eq(Festival::getStatus, 1);
        Festival festival = festivalMapper.selectOne(wrapper);

        if (festival != null) {
            return festival;
        }

        // 创建新节日
        festival = new Festival();
        festival.setName(standardName);
        festival.setType(1); // 法定假日
        festival.setIsHoliday(1);
        festival.setStatus(1);
        festival.setIsHot(1);
        festival.setIsRecommended(1);

        // 设置描述
        festival.setDescription(getDescription(standardName));
        festival.setCustoms(getCustoms(standardName));
        festival.setFood(getFood(standardName));

        festivalMapper.insert(festival);
        return festival;
    }

    /**
     * 同步单个假日
     */
    private SyncResult syncSingleHoliday(int year, Festival festival, String dateStr, String wage, String target) {
        LocalDate date = LocalDate.parse(dateStr, DATE_FMT);

        LambdaQueryWrapper<HolidaySchedule> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(HolidaySchedule::getYear, year)
               .eq(HolidaySchedule::getFestivalId, festival.getId())
               .eq(HolidaySchedule::getRegionId, 0); // 全国统一

        HolidaySchedule existing = holidayScheduleMapper.selectOne(wrapper);

        if (existing != null) {
            // 更新现有记录
            return new SyncResult(0, 0, 1, "skipped");
        }

        // 创建新记录
        HolidaySchedule schedule = new HolidaySchedule();
        schedule.setYear(year);
        schedule.setFestivalId(festival.getId());
        schedule.setFestivalName(festival.getName());
        schedule.setRegionId(0L); // 全国统一
        schedule.setStartDate(date);
        schedule.setEndDate(date); // 单日假日，后续可合并
        schedule.setTotalDays(1);
        schedule.setIsOfficial(1);
        schedule.setStatus(1);

        // 设置调休信息
        if (target != null && !target.isEmpty()) {
            schedule.setWorkDaysDesc("调休日期: " + target);
        }

        holidayScheduleMapper.insert(schedule);
        return new SyncResult(1, 0, 0, "added");
    }

    /**
     * 标准化节日名称
     */
    private String standardizeName(String name) {
        if (name == null) return null;

        // 去除年份和空格
        name = name.replaceAll("\\d{4}年?", "").trim();

        // 标准化映射
        Map<String, String> nameMap = new HashMap<>();
        nameMap.put("元旦", "元旦");
        nameMap.put("春节", "春节");
        nameMap.put("清明节", "清明节");
        nameMap.put("清明", "清明节");
        nameMap.put("劳动节", "劳动节");
        nameMap.put("五一", "劳动节");
        nameMap.put("端午节", "端午节");
        nameMap.put("端午", "端午节");
        nameMap.put("中秋节", "中秋节");
        nameMap.put("中秋", "中秋节");
        nameMap.put("国庆节", "国庆节");
        nameMap.put("国庆", "国庆节");

        for (Map.Entry<String, String> entry : nameMap.entrySet()) {
            if (name.contains(entry.getKey())) {
                return entry.getValue();
            }
        }

        return name;
    }

    /**
     * 获取节日描述
     */
    private String getDescription(String name) {
        return switch (name) {
            case "元旦" -> "公历新年第一天，世界多数国家通行的节日";
            case "春节" -> "中国最重要的传统节日，农历新年";
            case "清明节" -> "二十四节气之一，也是传统祭祀节日";
            case "劳动节" -> "国际劳动节，全世界劳动人民共同的节日";
            case "端午节" -> "纪念屈原的传统节日";
            case "中秋节" -> "团圆的节日，与春节、端午、清明并称四大传统节日";
            case "国庆节" -> "中华人民共和国成立纪念日";
            default -> "";
        };
    }

    /**
     * 获取节日习俗
     */
    private String getCustoms(String name) {
        return switch (name) {
            case "元旦" -> "跨年倒计时、烟花表演、新年祝福";
            case "春节" -> "贴春联、放鞭炮、拜年、发红包、舞龙舞狮";
            case "清明节" -> "扫墓祭祖、踏青、插柳、放风筝";
            case "劳动节" -> "放假休息、旅游出行";
            case "端午节" -> "赛龙舟、吃粽子、挂艾草、佩香囊";
            case "中秋节" -> "赏月、吃月饼、猜灯谜、拜月";
            case "国庆节" -> "阅兵、升旗仪式、旅游出行";
            default -> "";
        };
    }

    /**
     * 获取节日美食
     */
    private String getFood(String name) {
        return switch (name) {
            case "元旦" -> "饺子、年糕";
            case "春节" -> "饺子、年糕、汤圆、鱼";
            case "清明节" -> "青团、艾粄";
            case "端午节" -> "粽子、雄黄酒";
            case "中秋节" -> "月饼、桂花酒、柚子";
            default -> "";
        };
    }

    /**
     * 每年1月1日自动同步当年假日
     */
    @Scheduled(cron = "0 0 0 1 1 *")
    public void autoSyncCurrentYear() {
        int year = LocalDate.now().getYear();
        syncHolidayData(year);
    }

    /**
     * 同步结果
     */
    public static class SyncResult {
        public int added;
        public int updated;
        public int skipped;
        public String type;
        public String error;
        public boolean success;

        public SyncResult(int added, int updated, int skipped, String error) {
            this.added = added;
            this.updated = updated;
            this.skipped = skipped;
            this.error = error;
            this.success = error == null;
            this.type = added > 0 ? "added" : (updated > 0 ? "updated" : "skipped");
        }
    }
}
