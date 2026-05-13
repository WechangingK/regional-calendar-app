package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.service.holiday.HolidaySyncService;
import com.regional.calendar.service.region.RegionImportService;
import com.regional.calendar.service.region.RegionImportService.ImportResult;
import com.regional.calendar.service.wikidata.FestivalSyncService;
import com.regional.calendar.service.wikidata.WikidataService;
import com.regional.calendar.service.wikidata.WikidataService.WikidataFestival;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 数据同步控制器
 * 用于手动触发数据同步和查看同步状态
 */
@Tag(name = "数据同步", description = "数据同步接口")
@RestController
@RequestMapping("/v1/sync")
@RequiredArgsConstructor
public class DataSyncController {

    private final FestivalSyncService festivalSyncService;
    private final WikidataService wikidataService;
    private final RegionImportService regionImportService;
    private final HolidaySyncService holidaySyncService;

    // ==================== 地区数据导入 ====================

    /**
     * 一键导入所有地区数据
     */
    @Operation(summary = "导入所有地区", description = "一键导入全球国家+中国省市区数据")
    @PostMapping("/regions/all")
    public R<List<ImportResult>> importAllRegions() {
        try {
            List<ImportResult> results = regionImportService.importAll();
            return R.ok(results);
        } catch (Exception e) {
            return R.fail("导入失败: " + e.getMessage());
        }
    }

    /**
     * 导入全球国家数据
     */
    @Operation(summary = "导入全球国家", description = "从 REST Countries API 导入全球国家数据")
    @PostMapping("/regions/countries")
    public R<ImportResult> importCountries() {
        try {
            ImportResult result = regionImportService.importCountries();
            return R.ok(result);
        } catch (Exception e) {
            return R.fail("导入失败: " + e.getMessage());
        }
    }

    /**
     * 导入中国省份数据
     */
    @Operation(summary = "导入中国省份", description = "从开源数据集导入中国省份数据")
    @PostMapping("/regions/china/provinces")
    public R<ImportResult> importChinaProvinces() {
        try {
            ImportResult result = regionImportService.importChinaProvinces();
            return R.ok(result);
        } catch (Exception e) {
            return R.fail("导入失败: " + e.getMessage());
        }
    }

    /**
     * 导入中国市级数据
     */
    @Operation(summary = "导入中国城市", description = "从开源数据集导入中国市级数据")
    @PostMapping("/regions/china/cities")
    public R<ImportResult> importChinaCities() {
        try {
            ImportResult result = regionImportService.importChinaCities();
            return R.ok(result);
        } catch (Exception e) {
            return R.fail("导入失败: " + e.getMessage());
        }
    }

    // ==================== 节日数据同步 ====================

    /**
     * 同步法定假日数据
     */
    @Operation(summary = "同步法定假日", description = "从 timor.tech API 同步法定假日数据")
    @PostMapping("/holidays/{year}")
    public R<HolidaySyncService.SyncResult> syncHolidays(@PathVariable int year) {
        try {
            HolidaySyncService.SyncResult result = holidaySyncService.syncHolidayData(year);
            return R.ok(result);
        } catch (Exception e) {
            return R.fail("同步失败: " + e.getMessage());
        }
    }

    /**
     * 手动触发节日数据同步
     */
    @Operation(summary = "同步少数民族节日", description = "从 Wikidata 同步少数民族节日数据到数据库")
    @PostMapping("/festivals")
    public R<String> syncFestivals() {
        try {
            festivalSyncService.syncFestivalsFromWikidata();
            return R.ok("同步任务已执行，请查看日志了解详情");
        } catch (Exception e) {
            return R.fail("同步失败: " + e.getMessage());
        }
    }

    /**
     * 预览 Wikidata 节日数据（不入库）
     */
    @Operation(summary = "预览节日数据", description = "从 Wikidata 获取少数民族节日数据预览，不写入数据库")
    @GetMapping("/festivals/preview")
    public R<List<WikidataFestival>> previewFestivals() {
        try {
            List<WikidataFestival> festivals = wikidataService.fetchChineseMinorityFestivals();
            return R.ok(festivals);
        } catch (Exception e) {
            return R.fail("获取预览数据失败: " + e.getMessage());
        }
    }
}
