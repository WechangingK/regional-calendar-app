package com.regional.calendar.controller;

import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.HolidaySchedule;
import com.regional.calendar.service.HolidayScheduleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "放假安排模块")
@RestController
@RequestMapping("/v1/holiday")
public class HolidayScheduleController {

	private final HolidayScheduleService holidayScheduleService;

	public HolidayScheduleController(HolidayScheduleService holidayScheduleService) {
		this.holidayScheduleService = holidayScheduleService;
	}

	@Operation(summary = "获取放假安排")
	@GetMapping("/list")
	public R<List<HolidaySchedule>> list(
			@Parameter(description = "年份") @RequestParam(required = false) Integer year,
			@Parameter(description = "地区ID") @RequestParam(required = false) Long regionId) {
		if (year == null) {
			year = java.time.LocalDate.now().getYear();
		}
		if (regionId != null) {
			return R.ok(holidayScheduleService.getByYearAndRegion(year, regionId));
		}
		return R.ok(holidayScheduleService.getByYear(year));
	}

	@Operation(summary = "按年月查询放假安排（日历视图）")
	@GetMapping("/calendar")
	public R<List<HolidaySchedule>> calendar(
			@Parameter(description = "年份") @RequestParam int year,
			@Parameter(description = "月份") @RequestParam int month,
			@Parameter(description = "地区ID") @RequestParam(required = false) Long regionId) {
		return R.ok(holidayScheduleService.getByMonth(year, month, regionId));
	}
}
