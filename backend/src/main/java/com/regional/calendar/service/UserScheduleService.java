package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.UserSchedule;

import java.time.LocalDateTime;
import java.util.List;

public interface UserScheduleService extends IService<UserSchedule> {

    /**
     * 获取用户日程列表（按时间范围）
     */
    List<UserSchedule> getByUserIdAndTimeRange(Long userId, LocalDateTime start, LocalDateTime end);

    /**
     * 获取用户当天日程
     */
    List<UserSchedule> getTodaySchedules(Long userId);

    /**
     * 标记日程完成
     */
    void markCompleted(Long id);
}
