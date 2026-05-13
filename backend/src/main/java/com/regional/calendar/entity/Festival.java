package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("festival")
public class Festival {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String nameLocal;

    private String nameEnglish;

    private Integer type;

    private String subType;

    private Long regionId;

    private String regionName;

    private Long ethnicityId;

    private String ethnicityName;

    private String startDate;

    private String endDate;

    private Integer duration;

    private Integer isLunar;

    private Integer lunarMonth;

    private Integer lunarDay;

    private Integer isHoliday;

    private Integer holidayDays;

    private Integer isSolarTerm;

    private BigDecimal solarTermAngle;

    private String description;

    private String origin;

    private String history;

    private String customs;

    private String taboos;

    private String food;

    private String foodImages;

    private String clothing;

    private String clothingImages;

    private String activities;

    private String symbols;

    private String poems;

    private String songs;

    private String imageUrl;

    private String iconUrl;

    private String bannerUrl;

    private String videoUrl;

    private String gallery;

    private String color;

    private String tags;

    private Long viewCount;

    private Long favoriteCount;

    private Long shareCount;

    private Integer sortOrder;

    private Integer isHot;

    private Integer isRecommended;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
