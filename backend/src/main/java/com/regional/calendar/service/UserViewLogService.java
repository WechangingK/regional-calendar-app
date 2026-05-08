package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.UserViewLog;

public interface UserViewLogService extends IService<UserViewLog> {

    /**
     * 记录浏览
     */
    void recordView(Long userId, String deviceId, Integer targetType, Long targetId, String ip, String userAgent);
}
