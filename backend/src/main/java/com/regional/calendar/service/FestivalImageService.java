package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.FestivalImage;

import java.util.List;

public interface FestivalImageService extends IService<FestivalImage> {

    /**
     * 获取节日的图片列表
     */
    List<FestivalImage> getByFestivalId(Long festivalId, Integer imageType);
}
