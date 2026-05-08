package com.regional.calendar.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.Content;
import com.regional.calendar.service.ContentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

@Tag(name = "内容模块")
@RestController
@RequestMapping("/v1/content")
public class ContentController {

    private final ContentService contentService;

    public ContentController(ContentService contentService) {
        this.contentService = contentService;
    }

    @Operation(summary = "分页查询内容列表")
    @GetMapping("/list")
    public R<IPage<Content>> list(
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") int page,
            @Parameter(description = "每页数量") @RequestParam(defaultValue = "20") int pageSize,
            @Parameter(description = "内容类型") @RequestParam(required = false) Integer type,
            @Parameter(description = "地区ID") @RequestParam(required = false) Long regionId,
            @Parameter(description = "节日ID") @RequestParam(required = false) Long festivalId) {
        return R.ok(contentService.getPage(new Page<>(page, pageSize), type, regionId, festivalId));
    }

    @Operation(summary = "获取内容详情")
    @GetMapping("/{id}")
    public R<Content> detail(@PathVariable Long id) {
        Content content = contentService.getById(id);
        if (content == null) {
            return R.fail("内容不存在");
        }
        contentService.incrementViewCount(id);
        return R.ok(content);
    }

    @Operation(summary = "获取每日推送内容")
    @GetMapping("/daily")
    public R<Content> daily() {
        Content content = contentService.getDailyPush();
        return content != null ? R.ok(content) : R.ok();
    }
}
