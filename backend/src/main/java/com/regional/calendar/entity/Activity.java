package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("activity")
public class Activity {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long festivalId;

    private Long regionId;

    private String regionName;

    private String name;

    private String nameLocal;

    private Integer type;

    private String subType;

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private Integer durationDays;

    private String location;

    private String address;

    private BigDecimal latitude;

    private BigDecimal longitude;

    private String transportation;

    private String parkingInfo;

    private String description;

    private String content;

    private String highlights;

    private String schedule;

    private String organizer;

    private String coOrganizer;

    private String sponsor;

    private String contactName;

    private String contactPhone;

    private String contactEmail;

    private String website;

    private String ticketInfo;

    private BigDecimal ticketPrice;

    private String ticketUrl;

    private Integer capacity;

    private Integer registeredCount;

    private Integer minAge;

    private Integer maxAge;

    private String weatherNote;

    private String dressCode;

    private String tips;

    private String imageUrl;

    private String bannerUrl;

    private String videoUrl;

    private String gallery;

    private String tags;

    private Long viewCount;

    private Long favoriteCount;

    private Long shareCount;

    private BigDecimal rating;

    private Integer ratingCount;

    private Integer sortOrder;

    private Integer isHot;

    private Integer isRecommended;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
