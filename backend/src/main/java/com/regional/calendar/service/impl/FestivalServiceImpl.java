package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.Festival;
import com.regional.calendar.mapper.FestivalMapper;
import com.regional.calendar.service.FestivalService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class FestivalServiceImpl extends ServiceImpl<FestivalMapper, Festival> implements FestivalService {

	@Override
	public IPage<Festival> getPage(Page<Festival> page, Integer type, Long regionId, Long ethnicityId) {
		LambdaQueryWrapper<Festival> wrapper = new LambdaQueryWrapper<Festival>()
				.eq(Festival::getStatus, 1)
				.eq(type != null, Festival::getType, type)
				.eq(regionId != null, Festival::getRegionId, regionId)
				.eq(ethnicityId != null, Festival::getEthnicityId, ethnicityId)
				.orderByAsc(Festival::getSortOrder);
		return page(page, wrapper);
	}

	@Override
	public List<Festival> getUpcoming(Long regionId, int limit) {
		String today = LocalDate.now().format(DateTimeFormatter.ofPattern("MM-dd"));
		LambdaQueryWrapper<Festival> wrapper = new LambdaQueryWrapper<Festival>()
				.eq(Festival::getStatus, 1)
				.ge(Festival::getStartDate, today)
				.orderByAsc(Festival::getStartDate)
				.last("LIMIT " + limit);
		if (regionId != null) {
			wrapper.and(w -> w.eq(Festival::getRegionId, regionId).or().isNull(Festival::getRegionId));
		}
		return list(wrapper);
	}

	@Override
	public List<Festival> getHot(Integer limit, Long regionId) {
		LambdaQueryWrapper<Festival> wrapper = new LambdaQueryWrapper<Festival>()
				.eq(Festival::getStatus, 1)
				.eq(Festival::getIsHot, 1)
				.orderByDesc(Festival::getViewCount)
				.last(limit != null ? "LIMIT " + limit : "LIMIT 10");
		if (regionId != null) {
			wrapper.and(w -> w.eq(Festival::getRegionId, regionId).or().isNull(Festival::getRegionId));
		}
		return list(wrapper);
	}

	@Override
	public List<Festival> getRecommended(Integer limit, Long regionId) {
		LambdaQueryWrapper<Festival> wrapper = new LambdaQueryWrapper<Festival>()
				.eq(Festival::getStatus, 1)
				.eq(Festival::getIsRecommended, 1)
				.orderByDesc(Festival::getViewCount)
				.last(limit != null ? "LIMIT " + limit : "LIMIT 10");
		if (regionId != null) {
			wrapper.and(w -> w.eq(Festival::getRegionId, regionId).or().isNull(Festival::getRegionId));
		}
		return list(wrapper);
	}

	@Override
	public List<Festival> getByRegion(Long regionId, Integer type) {
		LambdaQueryWrapper<Festival> wrapper = new LambdaQueryWrapper<Festival>()
				.eq(Festival::getStatus, 1)
				.eq(type != null, Festival::getType, type)
				.orderByAsc(Festival::getStartDate);
		if (regionId != null) {
			wrapper.and(w -> w.eq(Festival::getRegionId, regionId).or().isNull(Festival::getRegionId));
		}
		return list(wrapper);
	}

	@Override
	public List<Festival> search(String keyword) {
		return list(new LambdaQueryWrapper<Festival>()
				.eq(Festival::getStatus, 1)
				.and(w -> w.like(Festival::getName, keyword)
						.or()
						.like(Festival::getNameEnglish, keyword)
						.or()
						.like(Festival::getTags, keyword))
				.orderByDesc(Festival::getViewCount));
	}

	@Override
	public List<Festival> getByMonth(int year, int month, Long regionId) {
		String monthPrefix = String.format("%02d-", month);
		LambdaQueryWrapper<Festival> wrapper = new LambdaQueryWrapper<Festival>()
				.eq(Festival::getStatus, 1)
				.orderByAsc(Festival::getStartDate);
		if (regionId != null) {
			wrapper.and(w -> w.eq(Festival::getRegionId, regionId).or().isNull(Festival::getRegionId));
		}
		wrapper.and(w -> w.likeRight(Festival::getStartDate, monthPrefix)
				.or()
				.likeRight(Festival::getEndDate, monthPrefix));
		return list(wrapper);
	}

	@Override
	public void incrementViewCount(Long id) {
		lambdaUpdate()
				.eq(Festival::getId, id)
				.setSql("view_count = view_count + 1")
				.update();
	}
}
