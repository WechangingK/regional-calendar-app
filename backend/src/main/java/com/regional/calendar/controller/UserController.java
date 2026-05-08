package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.User;
import com.regional.calendar.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

@Tag(name = "用户模块")
@RestController
@RequestMapping("/v1/user")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @Operation(summary = "用户注册")
    @PostMapping("/register")
    public R<User> register(
            @Parameter(description = "用户名") @RequestParam String username,
            @Parameter(description = "密码") @RequestParam String password,
            @Parameter(description = "手机号") @RequestParam(required = false) String phone) {
        User user = userService.register(username, password, phone);
        user.setPassword(null);
        user.setSalt(null);
        return R.ok(user);
    }

    @Operation(summary = "用户登录")
    @PostMapping("/login")
    public R<String> login(
            HttpServletRequest request,
            @Parameter(description = "用户名") @RequestParam String username,
            @Parameter(description = "密码") @RequestParam String password) {
        String ip = request.getRemoteAddr();
        String token = userService.login(username, password, ip);
        return R.ok(token);
    }

    @Operation(summary = "获取当前用户信息")
    @GetMapping("/info")
    public R<User> info(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            return R.fail(401, "未登录");
        }
        User user = userService.getById(userId);
        if (user != null) {
            user.setPassword(null);
            user.setSalt(null);
        }
        return R.ok(user);
    }

    @Operation(summary = "更新用户信息")
    @PutMapping("/info")
    public R<Void> updateInfo(
            HttpServletRequest request,
            @RequestBody User user) {
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            return R.fail(401, "未登录");
        }
        user.setId(userId);
        user.setPassword(null);
        user.setSalt(null);
        userService.updateById(user);
        return R.ok();
    }
}
