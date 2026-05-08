package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.FestivalImage;
import com.regional.calendar.service.FestivalImageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "节日图片模块")
@RestController
@RequestMapping("/v1/festival-image")
public class FestivalImageController {

    private final FestivalImageService festivalImageService;

    public FestivalImageController(FestivalImageService festivalImageService) {
        this.festivalImageService = festivalImageService;
    }

    @Operation(summary = "获取节日图片列表")
    @GetMapping("/list")
    public R<List<FestivalImage>> list(
            @Parameter(description = "节日ID", required = true) @RequestParam Long festivalId,
            @Parameter(description = "图片类型：1封面 2活动 3美食 4服饰 5风景 6历史 7其他") @RequestParam(required = false) Integer imageType) {
        return R.ok(festivalImageService.getByFestivalId(festivalId, imageType));
    }
}
