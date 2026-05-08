package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("user_view_log")
public class UserViewLog {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private String deviceId;

    private Integer targetType;

    private Long targetId;

    private Integer viewDuration;

    private LocalDate viewDate;

    private String ip;

    private String userAgent;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
