package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.Region;
import com.regional.calendar.service.RegionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "地区模块")
@RestController
@RequestMapping("/v1/region")
public class RegionController {

    private final RegionService regionService;

    public RegionController(RegionService regionService) {
        this.regionService = regionService;
    }

    @Operation(summary = "获取地区列表")
    @GetMapping("/list")
    public R<List<Region>> list(
            @Parameter(description = "父级地区ID") @RequestParam(required = false) Long parentId,
            @Parameter(description = "搜索关键词") @RequestParam(required = false) String keyword) {
        if (keyword != null && !keyword.isBlank()) {
            return R.ok(regionService.search(keyword));
        }
        if (parentId != null) {
            return R.ok(regionService.getByParentId(parentId));
        }
        return R.ok(regionService.getProvinces());
    }

    @Operation(summary = "获取地区详情")
    @GetMapping("/{id}")
    public R<Region> detail(@PathVariable Long id) {
        Region region = regionService.getById(id);
        return region != null ? R.ok(region) : R.fail("地区不存在");
    }

    @Operation(summary = "获取热门地区")
    @GetMapping("/hot")
    public R<List<Region>> hot(
            @Parameter(description = "返回数量") @RequestParam(defaultValue = "10") int limit) {
        return R.ok(regionService.getHotRegions(limit));
    }
}
