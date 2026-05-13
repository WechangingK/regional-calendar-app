package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.Ethnicity;
import com.regional.calendar.mapper.EthnicityMapper;
import com.regional.calendar.service.EthnicityService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EthnicityServiceImpl extends ServiceImpl<EthnicityMapper, Ethnicity> implements EthnicityService {

    @Override
    public List<Ethnicity> getAllEnabled() {
        return list(new LambdaQueryWrapper<Ethnicity>()
                .eq(Ethnicity::getStatus, 1)
                .orderByAsc(Ethnicity::getSortOrder));
    }

    @Override
    public List<Ethnicity> search(String keyword) {
        return list(new LambdaQueryWrapper<Ethnicity>()
                .eq(Ethnicity::getStatus, 1)
                .and(w -> w.like(Ethnicity::getName, keyword)
                        .or()
                        .like(Ethnicity::getNameEnglish, keyword))
                .orderByAsc(Ethnicity::getSortOrder));
    }
}
