package com.regional.calendar.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.Content;

public interface ContentService extends IService<Content> {

    /**
     * 分页查询内容列表
     */
    IPage<Content> getPage(Page<Content> page, Integer type, Long regionId, Long festivalId);

    /**
     * 获取每日推送内容
     */
    Content getDailyPush();

    /**
     * 增加浏览次数
     */
    void incrementViewCount(Long id);
}
