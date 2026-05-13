package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.UserFavorite;
import com.regional.calendar.service.UserFavoriteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "用户收藏模块")
@RestController
@RequestMapping("/v1/favorite")
public class UserFavoriteController {

    private final UserFavoriteService userFavoriteService;

    public UserFavoriteController(UserFavoriteService userFavoriteService) {
        this.userFavoriteService = userFavoriteService;
    }

    @Operation(summary = "切换收藏状态")
    @PostMapping("/toggle")
    public R<Boolean> toggle(
            HttpServletRequest request,
            @Parameter(description = "收藏类型：1地区 2节日 3活动 4内容") @RequestParam Integer targetType,
            @Parameter(description = "目标ID") @RequestParam Long targetId) {
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            return R.fail(401, "未登录");
        }
        boolean isFavorite = userFavoriteService.toggleFavorite(userId, targetType, targetId);
        return R.ok(isFavorite);
    }

    @Operation(summary = "检查是否已收藏")
    @GetMapping("/check")
    public R<Boolean> check(
            HttpServletRequest request,
            @Parameter(description = "收藏类型") @RequestParam Integer targetType,
            @Parameter(description = "目标ID") @RequestParam Long targetId) {
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            return R.ok(false);
        }
        return R.ok(userFavoriteService.isFavorite(userId, targetType, targetId));
    }

    @Operation(summary = "获取收藏列表")
    @GetMapping("/list")
    public R<List<UserFavorite>> list(
            HttpServletRequest request,
            @Parameter(description = "收藏类型") @RequestParam(required = false) Integer targetType) {
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            return R.fail(401, "未登录");
        }
        return R.ok(userFavoriteService.getByUserId(userId, targetType));
    }
}
