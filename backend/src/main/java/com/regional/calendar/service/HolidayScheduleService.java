package com.regional.calendar.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.regional.calendar.entity.HolidaySchedule;

import java.util.List;

public interface HolidayScheduleService extends IService<HolidaySchedule> {

    /**
     * 获取指定年份的放假安排
     */
    List<HolidaySchedule> getByYear(Integer year);

    /**
     * 获取指定年份和地区的放假安排
     */
    List<HolidaySchedule> getByYearAndRegion(Integer year, Long regionId);
}
