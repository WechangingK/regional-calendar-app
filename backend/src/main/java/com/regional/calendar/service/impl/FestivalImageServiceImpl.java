package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.FestivalImage;
import com.regional.calendar.mapper.FestivalImageMapper;
import com.regional.calendar.service.FestivalImageService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FestivalImageServiceImpl extends ServiceImpl<FestivalImageMapper, FestivalImage> implements FestivalImageService {

    @Override
    public List<FestivalImage> getByFestivalId(Long festivalId, Integer imageType) {
        return list(new LambdaQueryWrapper<FestivalImage>()
                .eq(FestivalImage::getFestivalId, festivalId)
                .eq(FestivalImage::getStatus, 1)
                .eq(imageType != null, FestivalImage::getImageType, imageType)
                .orderByAsc(FestivalImage::getSortOrder));
    }
}
