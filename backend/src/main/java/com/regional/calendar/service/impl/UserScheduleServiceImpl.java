package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.UserSchedule;
import com.regional.calendar.mapper.UserScheduleMapper;
import com.regional.calendar.service.UserScheduleService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Service
public class UserScheduleServiceImpl extends ServiceImpl<UserScheduleMapper, UserSchedule> implements UserScheduleService {

    @Override
    public List<UserSchedule> getByUserIdAndTimeRange(Long userId, LocalDateTime start, LocalDateTime end) {
        return list(new LambdaQueryWrapper<UserSchedule>()
                .eq(UserSchedule::getUserId, userId)
                .eq(UserSchedule::getStatus, 1)
                .ge(UserSchedule::getStartTime, start)
                .le(UserSchedule::getStartTime, end)
                .orderByAsc(UserSchedule::getStartTime));
    }

    @Override
    public List<UserSchedule> getTodaySchedules(Long userId) {
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime todayEnd = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);
        return getByUserIdAndTimeRange(userId, todayStart, todayEnd);
    }

    @Override
    public void markCompleted(Long id) {
        lambdaUpdate()
                .eq(UserSchedule::getId, id)
                .set(UserSchedule::getIsCompleted, 1)
                .set(UserSchedule::getCompletedTime, LocalDateTime.now())
                .update();
    }
}
