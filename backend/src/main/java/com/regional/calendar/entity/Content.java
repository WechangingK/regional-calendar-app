package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("content")
public class Content {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private String subTitle;

    private Integer type;

    private Long regionId;

    private Long festivalId;

    private Long ethnicityId;

    private String summary;

    private String content;

    private String contentText;

    private String author;

    private String authorAvatar;

    private String source;

    private String sourceUrl;

    private String coverImage;

    private String gallery;

    private String videoUrl;

    private String audioUrl;

    private Integer wordCount;

    private Integer readTime;

    private String tags;

    private Long viewCount;

    private Long likeCount;

    private Long favoriteCount;

    private Long shareCount;

    private Long commentCount;

    private Integer isDailyPush;

    private LocalDate pushDate;

    private Integer sortOrder;

    private Integer isTop;

    private Integer isRecommended;

    private Integer status;

    private LocalDateTime publishTime;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
