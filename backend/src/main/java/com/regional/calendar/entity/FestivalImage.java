package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("festival_image")
public class FestivalImage {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long festivalId;

    private String imageUrl;

    private Integer imageType;

    private String title;

    private String description;

    private Integer width;

    private Integer height;

    private Long size;

    private String source;

    private String photographer;

    private Integer sortOrder;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
