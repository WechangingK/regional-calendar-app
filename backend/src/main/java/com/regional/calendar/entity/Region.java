package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("region")
public class Region {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long parentId;

    private String name;

    private String nameLocal;

    private String namePinyin;

    private Integer level;

    private String code;

    private String zipCode;

    private String areaCode;

    private BigDecimal latitude;

    private BigDecimal longitude;

    private BigDecimal areaSize;

    private Long population;

    private String description;

    private String imageUrl;

    private String gallery;

    private String tags;

    private Integer sortOrder;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
