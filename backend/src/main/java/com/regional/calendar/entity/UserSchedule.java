package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("user_schedule")
public class UserSchedule {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String title;

    private String content;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private Integer isAllDay;

    private Integer isLunar;

    private Integer repeatType;

    private LocalDate repeatEndDate;

    private Integer remindType;

    private LocalDateTime remindTime;

    private String location;

    private String color;

    private String icon;

    private Integer isCompleted;

    private LocalDateTime completedTime;

    private Integer priority;

    private String tags;

    private String attachmentUrl;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
