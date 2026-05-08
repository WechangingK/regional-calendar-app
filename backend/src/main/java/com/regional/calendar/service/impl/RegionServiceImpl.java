package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.Region;
import com.regional.calendar.mapper.RegionMapper;
import com.regional.calendar.service.RegionService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RegionServiceImpl extends ServiceImpl<RegionMapper, Region> implements RegionService {

    @Override
    public List<Region> getByParentId(Long parentId) {
        return list(new LambdaQueryWrapper<Region>()
                .eq(Region::getParentId, parentId)
                .eq(Region::getStatus, 1)
                .orderByAsc(Region::getSortOrder));
    }

    @Override
    public List<Region> getProvinces() {
        return list(new LambdaQueryWrapper<Region>()
                .eq(Region::getLevel, 1)
                .eq(Region::getStatus, 1)
                .orderByAsc(Region::getSortOrder));
    }

    @Override
    public List<Region> search(String keyword) {
        return list(new LambdaQueryWrapper<Region>()
                .eq(Region::getStatus, 1)
                .and(w -> w.like(Region::getName, keyword)
                        .or()
                        .like(Region::getNamePinyin, keyword))
                .orderByAsc(Region::getSortOrder));
    }

    @Override
    public List<Region> getHotRegions(int limit) {
        return list(new LambdaQueryWrapper<Region>()
                .eq(Region::getStatus, 1)
                .orderByDesc(Region::getSortOrder)
                .last("LIMIT " + limit));
    }
}
