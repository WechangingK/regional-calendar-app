package com.regional.calendar.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.Activity;

import java.util.List;

public interface ActivityService extends IService<Activity> {

    /**
     * 分页查询活动列表
     */
    IPage<Activity> getPage(Page<Activity> page, Long regionId, Integer type, Integer status);

    /**
     * 获取即将开始的活动
     */
    List<Activity> getUpcoming(Long regionId, int limit);

    /**
     * 获取热门活动
     */
    List<Activity> getHot(int limit, Long regionId);

    /**
     * 获取推荐活动
     */
    List<Activity> getRecommended(int limit, Long regionId);

    /**
     * 按年月查询活动（日历视图）
     */
    List<Activity> getByMonth(int year, int month, Long regionId);

    /**
     * 按节日查询关联活动
     */
    List<Activity> getByFestivalId(Long festivalId);

    /**
     * 增加浏览次数
     */
    void incrementViewCount(Long id);
}
