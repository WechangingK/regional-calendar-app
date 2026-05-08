package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.UserSchedule;
import com.regional.calendar.service.UserScheduleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Tag(name = "用户日程模块")
@RestController
@RequestMapping("/v1/schedule")
public class UserScheduleController {

    private final UserScheduleService userScheduleService;

    public UserScheduleController(UserScheduleService userScheduleService) {
        this.userScheduleService = userScheduleService;
    }

    @Operation(summary = "获取日程列表")
    @GetMapping("/list")
    public R<List<UserSchedule>> list(
            HttpServletRequest request,
            @Parameter(description = "开始日期") @RequestParam(required = false) LocalDate startDate,
            @Parameter(description = "结束日期") @RequestParam(required = false) LocalDate endDate) {
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            return R.fail(401, "未登录");
        }
        if (startDate == null) {
            startDate = LocalDate.now().withDayOfMonth(1);
        }
        if (endDate == null) {
            endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());
        }
        LocalDateTime start = LocalDateTime.of(startDate, LocalTime.MIN);
        LocalDateTime end = LocalDateTime.of(endDate, LocalTime.MAX);
        return R.ok(userScheduleService.getByUserIdAndTimeRange(userId, start, end));
    }

    @Operation(summary = "获取今日日程")
    @GetMapping("/today")
    public R<List<UserSchedule>> today(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            return R.fail(401, "未登录");
        }
        return R.ok(userScheduleService.getTodaySchedules(userId));
    }

    @Operation(summary = "添加日程")
    @PostMapping("/add")
    public R<UserSchedule> add(HttpServletRequest request, @RequestBody UserSchedule schedule) {
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            return R.fail(401, "未登录");
        }
        schedule.setUserId(userId);
        schedule.setStatus(1);
        userScheduleService.save(schedule);
        return R.ok(schedule);
    }

    @Operation(summary = "更新日程")
    @PutMapping("/{id}")
    public R<Void> update(@PathVariable Long id, @RequestBody UserSchedule schedule) {
        schedule.setId(id);
        userScheduleService.updateById(schedule);
        return R.ok();
    }

    @Operation(summary = "删除日程")
    @DeleteMapping("/{id}")
    public R<Void> delete(@PathVariable Long id) {
        userScheduleService.lambdaUpdate()
                .eq(UserSchedule::getId, id)
                .set(UserSchedule::getStatus, 0)
                .update();
        return R.ok();
    }

    @Operation(summary = "标记日程完成")
    @PutMapping("/{id}/complete")
    public R<Void> complete(@PathVariable Long id) {
        userScheduleService.markCompleted(id);
        return R.ok();
    }
}
