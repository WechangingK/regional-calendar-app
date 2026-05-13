package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("holiday_schedule")
public class HolidaySchedule {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Integer year;

    private Long festivalId;

    private String festivalName;

    private Long regionId;

    private String regionName;

    private LocalDate startDate;

    private LocalDate endDate;

    private Integer totalDays;

    private String workDays;

    private String workDaysDesc;

    private Integer isOfficial;

    private String announcement;

    private String source;

    private String sourceUrl;

    private String remark;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
