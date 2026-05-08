package com.regional.calendar.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.Activity;
import com.regional.calendar.service.ActivityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "活动模块")
@RestController
@RequestMapping("/v1/activity")
public class ActivityController {

    private final ActivityService activityService;

    public ActivityController(ActivityService activityService) {
        this.activityService = activityService;
    }

    @Operation(summary = "分页查询活动列表")
    @GetMapping("/list")
    public R<IPage<Activity>> list(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "20") int pageSize,
            @Parameter(description = "地区ID") @RequestParam(required = false) Long regionId,
            @Parameter(description = "活动类型") @RequestParam(required = false) Integer type,
            @Parameter(description = "活动状态") @RequestParam(required = false) Integer status) {
        return R.ok(activityService.getPage(new Page<>(page, pageSize), regionId, type, status));
    }

    @Operation(summary = "获取活动详情")
    @GetMapping("/{id}")
    public R<Activity> detail(@PathVariable Long id) {
        Activity activity = activityService.getById(id);
        if (activity == null) {
            return R.fail("活动不存在");
        }
        activityService.incrementViewCount(id);
        return R.ok(activity);
    }

    @Operation(summary = "获取即将开始的活动")
    @GetMapping("/upcoming")
    public R<List<Activity>> upcoming(
            @Parameter(description = "地区ID") @RequestParam(required = false) Long regionId,
            @Parameter(description = "返回数量") @RequestParam(defaultValue = "10") int limit) {
        return R.ok(activityService.getUpcoming(regionId, limit));
    }

    @Operation(summary = "获取热门活动")
    @GetMapping("/hot")
    public R<List<Activity>> hot(
            @Parameter(description = "返回数量") @RequestParam(defaultValue = "10") int limit) {
        return R.ok(activityService.getHot(limit));
    }

    @Operation(summary = "获取推荐活动")
    @GetMapping("/recommended")
    public R<List<Activity>> recommended(
            @Parameter(description = "返回数量") @RequestParam(defaultValue = "10") int limit) {
        return R.ok(activityService.getRecommended(limit));
    }

    @Operation(summary = "按节日查询关联活动")
    @GetMapping("/festival/{festivalId}")
    public R<List<Activity>> byFestival(@PathVariable Long festivalId) {
        return R.ok(activityService.getByFestivalId(festivalId));
    }
}
