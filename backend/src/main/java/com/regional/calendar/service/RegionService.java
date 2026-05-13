package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.Region;

import java.util.List;

public interface RegionService extends IService<Region> {

    /**
     * 根据父级ID获取子地区列表
     */
    List<Region> getByParentId(Long parentId);

    /**
     * 获取所有省份（一级地区）
     */
    List<Region> getProvinces();

    /**
     * 搜索地区（按名称或拼音）
     */
    List<Region> search(String keyword);

    /**
     * 获取热门地区
     */
    List<Region> getHotRegions(int limit);
}
