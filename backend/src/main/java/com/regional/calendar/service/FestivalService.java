package com.regional.calendar.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.Festival;

import java.util.List;

public interface FestivalService extends IService<Festival> {

    /**
     * 分页查询节日列表
     */
    IPage<Festival> getPage(Page<Festival> page, Integer type, Long regionId, Long ethnicityId);

    /**
     * 获取即将到来的节日
     */
    List<Festival> getUpcoming(Long regionId, int limit);

    /**
     * 获取热门节日
     */
    List<Festival> getHot(Integer limit, Long regionId);

    /**
     * 获取推荐节日
     */
    List<Festival> getRecommended(Integer limit, Long regionId);

    /**
     * 按年月查询节日（日历视图）
     */
    List<Festival> getByMonth(int year, int month, Long regionId);

    /**
     * 按地区查询节日
     */
    List<Festival> getByRegion(Long regionId, Integer type);

    /**
     * 搜索节日
     */
    List<Festival> search(String keyword);

    /**
     * 增加浏览次数
     */
    void incrementViewCount(Long id);
}
