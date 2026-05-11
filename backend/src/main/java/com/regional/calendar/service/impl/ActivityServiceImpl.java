package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.Activity;
import com.regional.calendar.mapper.ActivityMapper;
import com.regional.calendar.service.ActivityService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ActivityServiceImpl extends ServiceImpl<ActivityMapper, Activity> implements ActivityService {

	@Override
	public IPage<Activity> getPage(Page<Activity> page, Long regionId, Integer type, Integer status) {
		LambdaQueryWrapper<Activity> wrapper = new LambdaQueryWrapper<Activity>()
				.eq(regionId != null, Activity::getRegionId, regionId)
				.eq(type != null, Activity::getType, type)
				.eq(status != null, Activity::getStatus, status)
				.orderByDesc(Activity::getStartTime);
		return page(page, wrapper);
	}

	@Override
	public List<Activity> getUpcoming(Long regionId, int limit) {
		LambdaQueryWrapper<Activity> wrapper = new LambdaQueryWrapper<Activity>()
				.ge(Activity::getStartTime, LocalDateTime.now())
				.in(Activity::getStatus, 1, 2)
				.orderByAsc(Activity::getStartTime)
				.last("LIMIT " + limit);
		if (regionId != null) {
			wrapper.and(w -> w.eq(Activity::getRegionId, regionId).or().isNull(Activity::getRegionId));
		}
		return list(wrapper);
	}

	@Override
	public List<Activity> getHot(int limit, Long regionId) {
		LambdaQueryWrapper<Activity> wrapper = new LambdaQueryWrapper<Activity>()
				.eq(Activity::getIsHot, 1)
				.in(Activity::getStatus, 1, 2)
				.orderByDesc(Activity::getViewCount)
				.last("LIMIT " + limit);
		if (regionId != null) {
			wrapper.and(w -> w.eq(Activity::getRegionId, regionId).or().isNull(Activity::getRegionId));
		}
		return list(wrapper);
	}

	@Override
	public List<Activity> getRecommended(int limit, Long regionId) {
		LambdaQueryWrapper<Activity> wrapper = new LambdaQueryWrapper<Activity>()
				.eq(Activity::getIsRecommended, 1)
				.in(Activity::getStatus, 1, 2)
				.orderByDesc(Activity::getViewCount)
				.last("LIMIT " + limit);
		if (regionId != null) {
			wrapper.and(w -> w.eq(Activity::getRegionId, regionId).or().isNull(Activity::getRegionId));
		}
		return list(wrapper);
	}

	@Override
	public List<Activity> getByFestivalId(Long festivalId) {
		return list(new LambdaQueryWrapper<Activity>()
				.eq(Activity::getFestivalId, festivalId)
				.in(Activity::getStatus, 1, 2)
				.orderByAsc(Activity::getStartTime));
	}

	@Override
	public List<Activity> getByMonth(int year, int month, Long regionId) {
		LocalDateTime start = LocalDateTime.of(year, month, 1, 0, 0);
		LocalDateTime end = start.plusMonths(1);
		LambdaQueryWrapper<Activity> wrapper = new LambdaQueryWrapper<Activity>()
				.in(Activity::getStatus, 1, 2)
				.ge(Activity::getStartTime, start)
				.lt(Activity::getStartTime, end)
				.orderByAsc(Activity::getStartTime);
		if (regionId != null) {
			wrapper.and(w -> w.eq(Activity::getRegionId, regionId).or().isNull(Activity::getRegionId));
		}
		return list(wrapper);
	}

	@Override
	public void incrementViewCount(Long id) {
		lambdaUpdate()
				.eq(Activity::getId, id)
				.setSql("view_count = view_count + 1")
				.update();
	}
}
