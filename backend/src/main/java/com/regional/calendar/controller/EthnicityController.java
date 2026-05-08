package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.Ethnicity;
import com.regional.calendar.service.EthnicityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "民族模块")
@RestController
@RequestMapping("/v1/ethnicity")
public class EthnicityController {

    private final EthnicityService ethnicityService;

    public EthnicityController(EthnicityService ethnicityService) {
        this.ethnicityService = ethnicityService;
    }

    @Operation(summary = "获取民族列表")
    @GetMapping("/list")
    public R<List<Ethnicity>> list(
            @Parameter(description = "搜索关键词") @RequestParam(required = false) String keyword) {
        if (keyword != null && !keyword.isBlank()) {
            return R.ok(ethnicityService.search(keyword));
        }
        return R.ok(ethnicityService.getAllEnabled());
    }

    @Operation(summary = "获取民族详情")
    @GetMapping("/{id}")
    public R<Ethnicity> detail(@PathVariable Long id) {
        Ethnicity ethnicity = ethnicityService.getById(id);
        return ethnicity != null ? R.ok(ethnicity) : R.fail("民族不存在");
    }
}
