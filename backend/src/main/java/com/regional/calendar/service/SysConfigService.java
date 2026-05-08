package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.SysConfig;

public interface SysConfigService extends IService<SysConfig> {

    /**
     * 根据配置键获取配置值
     */
    String getConfigValue(String key);

    /**
     * 根据配置键获取配置值（带默认值）
     */
    String getConfigValue(String key, String defaultValue);
}
