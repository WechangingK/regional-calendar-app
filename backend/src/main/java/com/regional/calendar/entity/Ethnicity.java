package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("ethnicity")
public class Ethnicity {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String nameLocal;

    private String nameEnglish;

    private String code;

    private Long population;

    private String mainRegionIds;

    private String languageFamily;

    private String language;

    private String script;

    private String religion;

    private String description;

    private String history;

    private String culture;

    private String customs;

    private String clothingDesc;

    private String foodDesc;

    private String imageUrl;

    private String flagImage;

    private String gallery;

    private String videoUrl;

    private String tags;

    private Integer sortOrder;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
