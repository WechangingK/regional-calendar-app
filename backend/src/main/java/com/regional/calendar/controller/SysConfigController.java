package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.service.SysConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

@Tag(name = "系统配置模块")
@RestController
@RequestMapping("/v1/config")
public class SysConfigController {

    private final SysConfigService sysConfigService;

    public SysConfigController(SysConfigService sysConfigService) {
        this.sysConfigService = sysConfigService;
    }

    @Operation(summary = "获取配置值")
    @GetMapping("/{key}")
    public R<String> getConfig(@PathVariable String key) {
        String value = sysConfigService.getConfigValue(key);
        return value != null ? R.ok(value) : R.fail("配置不存在");
    }
}
