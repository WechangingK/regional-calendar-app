package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.Content;
import com.regional.calendar.mapper.ContentMapper;
import com.regional.calendar.service.ContentService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;

@Service
public class ContentServiceImpl extends ServiceImpl<ContentMapper, Content> implements ContentService {

    @Override
    public IPage<Content> getPage(Page<Content> page, Integer type, Long regionId, Long festivalId) {
        LambdaQueryWrapper<Content> wrapper = new LambdaQueryWrapper<Content>()
                .eq(Content::getStatus, 1)
                .eq(type != null, Content::getType, type)
                .eq(regionId != null, Content::getRegionId, regionId)
                .eq(festivalId != null, Content::getFestivalId, festivalId)
                .orderByDesc(Content::getIsTop)
                .orderByDesc(Content::getPublishTime);
        return page(page, wrapper);
    }

    @Override
    public Content getDailyPush() {
        return getOne(new LambdaQueryWrapper<Content>()
                .eq(Content::getStatus, 1)
                .eq(Content::getIsDailyPush, 1)
                .eq(Content::getPushDate, LocalDate.now())
                .last("LIMIT 1"));
    }

    @Override
    public void incrementViewCount(Long id) {
        lambdaUpdate()
                .eq(Content::getId, id)
                .setSql("view_count = view_count + 1")
                .update();
    }
}
