package com.regional.calendar.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.regional.calendar.common.result.R;
import com.regional.calendar.entity.Festival;
import com.regional.calendar.service.FestivalService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "节日模块")
@RestController
@RequestMapping("/v1/festival")
public class FestivalController {

	private final FestivalService festivalService;

	public FestivalController(FestivalService festivalService) {
		this.festivalService = festivalService;
	}

	@Operation(summary = "分页查询节日列表")
	@GetMapping("/list")
	public R<IPage<Festival>> list(
			@Parameter(description = "页码") @RequestParam(defaultValue = "1") int page,
			@Parameter(description = "每页数量") @RequestParam(defaultValue = "20") int pageSize,
			@Parameter(description = "节日类型") @RequestParam(required = false) Integer type,
			@Parameter(description = "地区ID") @RequestParam(required = false) Long regionId,
			@Parameter(description = "民族ID") @RequestParam(required = false) Long ethnicityId) {
		return R.ok(festivalService.getPage(new Page<>(page, pageSize), type, regionId, ethnicityId));
	}

	@Operation(summary = "获取节日详情")
	@GetMapping("/{id}")
	public R<Festival> detail(@PathVariable Long id) {
		Festival festival = festivalService.getById(id);
		if (festival == null) {
			return R.fail("节日不存在");
		}
		festivalService.incrementViewCount(id);
		return R.ok(festival);
	}

	@Operation(summary = "获取即将到来的节日")
	@GetMapping("/upcoming")
	public R<List<Festival>> upcoming(
			@Parameter(description = "地区ID") @RequestParam(required = false) Long regionId,
			@Parameter(description = "返回数量") @RequestParam(defaultValue = "10") int limit) {
		return R.ok(festivalService.getUpcoming(regionId, limit));
	}

	@Operation(summary = "获取热门节日")
	@GetMapping("/hot")
	public R<List<Festival>> hot(
			@Parameter(description = "返回数量") @RequestParam(defaultValue = "10") int limit,
			@Parameter(description = "地区ID") @RequestParam(required = false) Long regionId) {
		return R.ok(festivalService.getHot(limit, regionId));
	}

	@Operation(summary = "获取推荐节日")
	@GetMapping("/recommended")
	public R<List<Festival>> recommended(
			@Parameter(description = "返回数量") @RequestParam(defaultValue = "10") int limit,
			@Parameter(description = "地区ID") @RequestParam(required = false) Long regionId) {
		return R.ok(festivalService.getRecommended(limit, regionId));
	}

	@Operation(summary = "按地区查询节日")
	@GetMapping("/region/{regionId}")
	public R<List<Festival>> byRegion(
			@PathVariable Long regionId,
			@Parameter(description = "节日类型") @RequestParam(required = false) Integer type) {
		return R.ok(festivalService.getByRegion(regionId, type));
	}

	@Operation(summary = "搜索节日")
	@GetMapping("/search")
	public R<List<Festival>> search(
			@Parameter(description = "搜索关键词") @RequestParam String keyword) {
		return R.ok(festivalService.search(keyword));
	}

	@Operation(summary = "按年月查询节日（日历视图）")
	@GetMapping("/calendar")
	public R<List<Festival>> calendar(
			@Parameter(description = "年份") @RequestParam int year,
			@Parameter(description = "月份") @RequestParam int month,
			@Parameter(description = "地区ID") @RequestParam(required = false) Long regionId) {
		return R.ok(festivalService.getByMonth(year, month, regionId));
	}
}
