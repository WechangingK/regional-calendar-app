package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
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
@Tag(name = "数据同步", description = "Wikidata 数据同步接口")
@RestController
@RequestMapping("/v1/sync")
@RequiredArgsConstructor
public class DataSyncController {

    private final FestivalSyncService festivalSyncService;
    private final WikidataService wikidataService;

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
