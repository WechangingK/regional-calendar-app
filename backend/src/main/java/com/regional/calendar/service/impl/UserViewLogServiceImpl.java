package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.UserViewLog;
import com.regional.calendar.mapper.UserViewLogMapper;
import com.regional.calendar.service.UserViewLogService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
public class UserViewLogServiceImpl extends ServiceImpl<UserViewLogMapper, UserViewLog> implements UserViewLogService {

    @Override
    public void recordView(Long userId, String deviceId, Integer targetType, Long targetId, String ip, String userAgent) {
        UserViewLog log = new UserViewLog();
        log.setUserId(userId);
        log.setDeviceId(deviceId);
        log.setTargetType(targetType);
        log.setTargetId(targetId);
        log.setViewDate(LocalDate.now());
        log.setIp(ip);
        log.setUserAgent(userAgent);
        log.setCreateTime(LocalDateTime.now());
        save(log);
    }
}
