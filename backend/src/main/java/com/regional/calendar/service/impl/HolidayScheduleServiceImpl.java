package com.regional.calendar.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.regional.calendar.entity.HolidaySchedule;
import com.regional.calendar.mapper.HolidayScheduleMapper;
import com.regional.calendar.service.HolidayScheduleService;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class HolidayScheduleServiceImpl extends ServiceImpl<HolidayScheduleMapper, HolidaySchedule> implements HolidayScheduleService {

	@Override
	public List<HolidaySchedule> getByYear(Integer year) {
		return list(new LambdaQueryWrapper<HolidaySchedule>()
				.eq(HolidaySchedule::getYear, year)
				.eq(HolidaySchedule::getStatus, 1)
				.orderByAsc(HolidaySchedule::getStartDate));
	}

	@Override
	public List<HolidaySchedule> getByYearAndRegion(Integer year, Long regionId) {
		return list(new LambdaQueryWrapper<HolidaySchedule>()
				.eq(HolidaySchedule::getYear, year)
				.eq(HolidaySchedule::getStatus, 1)
				.and(w -> w.isNull(HolidaySchedule::getRegionId).or().eq(HolidaySchedule::getRegionId, regionId))
				.orderByAsc(HolidaySchedule::getStartDate));
	}

	@Override
	public List<HolidaySchedule> getByMonth(int year, int month, Long regionId) {
		LocalDate start = LocalDate.of(year, month, 1);
		LocalDate end = start.plusMonths(1);
		return list(new LambdaQueryWrapper<HolidaySchedule>()
				.eq(HolidaySchedule::getStatus, 1)
				.and(w -> w.isNull(HolidaySchedule::getRegionId).or().eq(regionId != null, HolidaySchedule::getRegionId, regionId))
				.lt(HolidaySchedule::getStartDate, end)
				.ge(HolidaySchedule::getEndDate, start)
				.orderByAsc(HolidaySchedule::getStartDate));
	}
}
