package com.regional.calendar.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("user")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String username;

    private String password;

    private String salt;

    private String nickname;

    private String avatar;

    private String phone;

    private Integer phoneVerified;

    private String email;

    private Integer emailVerified;

    private Integer gender;

    private LocalDate birthday;

    private Long regionId;

    private String regionName;

    private Long ethnicityId;

    private String ethnicityName;

    private String bio;

    private String wechatOpenid;

    private String wechatUnionid;

    private String qqOpenid;

    private String appleId;

    private String deviceToken;

    private Integer deviceType;

    private LocalDateTime lastLoginTime;

    private String lastLoginIp;

    private Integer loginCount;

    private Integer vipLevel;

    private LocalDateTime vipExpireTime;

    private Long points;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
