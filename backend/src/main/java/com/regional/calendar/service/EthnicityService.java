package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.Ethnicity;

import java.util.List;

public interface EthnicityService extends IService<Ethnicity> {

    /**
     * 获取所有启用的民族
     */
    List<Ethnicity> getAllEnabled();

    /**
     * 根据名称搜索民族
     */
    List<Ethnicity> search(String keyword);
}
