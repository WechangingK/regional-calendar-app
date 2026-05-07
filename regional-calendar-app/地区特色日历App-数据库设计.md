# 地区特色日历App - 详细数据库设计

## 1. 数据库概述

### 1.1 数据库选型
- **主数据库**：MySQL 8.0
- **缓存数据库**：Redis 7.0
- **字符集**：utf8mb4（支持emoji和少数民族文字）
- **排序规则**：utf8mb4_unicode_ci

### 1.2 数据库架构
```
┌─────────────────────────────────────────────────────────┐
│                    应用层 (Spring Boot)                   │
└─────────────────────────────────────────────────────────┘
                           │
            ┌──────────────┼──────────────┐
            ▼              ▼              ▼
      ┌──────────┐  ┌──────────┐  ┌──────────┐
      │  主库    │  │  从库    │  │   Redis  │
      │  写操作  │  │  读操作  │  │   缓存   │
      └──────────┘  └──────────┘  └──────────┘
            │              │
            └──────┬───────┘
                   ▼
            ┌──────────┐
            │  备份库  │
            └──────────┘
```

### 1.3 数据库规范
- 表名：小写字母+下划线，如 `user_favorite`
- 字段名：小写字母+下划线，如 `create_time`
- 主键：统一使用 `id`，BIGINT类型
- 时间字段：统一使用 DATETIME 类型
- 状态字段：统一使用 TINYINT 类型
- 软删除：使用 `status` 字段标记，不物理删除

---

## 2. 完整表结构设计

### 2.1 地区表 (region)

```sql
-- 地区表
CREATE TABLE `region` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `parent_id` BIGINT NOT NULL DEFAULT 0 COMMENT '父级地区ID，0表示顶级',
    `name` VARCHAR(100) NOT NULL COMMENT '地区名称（汉语）',
    `name_local` VARCHAR(100) DEFAULT NULL COMMENT '当地语言名称',
    `name_pinyin` VARCHAR(200) DEFAULT NULL COMMENT '拼音',
    `level` TINYINT NOT NULL COMMENT '级别：1省/自治区 2市/州 3区/县/旗',
    `code` VARCHAR(20) NOT NULL COMMENT '行政区划代码（6位）',
    `zip_code` VARCHAR(10) DEFAULT NULL COMMENT '邮政编码',
    `area_code` VARCHAR(10) DEFAULT NULL COMMENT '电话区号',
    `latitude` DECIMAL(10,7) DEFAULT NULL COMMENT '纬度',
    `longitude` DECIMAL(10,7) DEFAULT NULL COMMENT '经度',
    `area_size` DECIMAL(12,2) DEFAULT NULL COMMENT '面积（平方公里）',
    `population` BIGINT DEFAULT NULL COMMENT '人口数量',
    `description` TEXT COMMENT '地区简介',
    `image_url` VARCHAR(500) DEFAULT NULL COMMENT '地区图片URL',
    `gallery` JSON DEFAULT NULL COMMENT '图片集，JSON数组',
    `tags` VARCHAR(500) DEFAULT NULL COMMENT '标签，逗号分隔',
    `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序权重',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_code` (`code`),
    KEY `idx_parent_id` (`parent_id`),
    KEY `idx_level` (`level`),
    KEY `idx_name` (`name`),
    KEY `idx_name_pinyin` (`name_pinyin`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='地区表';
```

### 2.2 民族表 (ethnicity)

```sql
-- 民族表
CREATE TABLE `ethnicity` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `name` VARCHAR(50) NOT NULL COMMENT '民族名称（汉语）',
    `name_local` VARCHAR(50) DEFAULT NULL COMMENT '民族自称',
    `name_english` VARCHAR(100) DEFAULT NULL COMMENT '英文名称',
    `code` VARCHAR(10) NOT NULL COMMENT '民族代码',
    `population` BIGINT DEFAULT NULL COMMENT '人口数量（最新统计）',
    `main_region_ids` VARCHAR(500) DEFAULT NULL COMMENT '主要分布地区ID，逗号分隔',
    `language_family` VARCHAR(100) DEFAULT NULL COMMENT '语系',
    `language` VARCHAR(200) DEFAULT NULL COMMENT '语言',
    `script` VARCHAR(100) DEFAULT NULL COMMENT '文字',
    `religion` VARCHAR(200) DEFAULT NULL COMMENT '宗教信仰',
    `description` TEXT COMMENT '民族简介',
    `history` TEXT COMMENT '民族历史',
    `culture` TEXT COMMENT '文化特色',
    `customs` TEXT COMMENT '风俗习惯',
    `clothing_desc` TEXT COMMENT '服饰介绍',
    `food_desc` TEXT COMMENT '饮食介绍',
    `image_url` VARCHAR(500) DEFAULT NULL COMMENT '民族图片URL',
    `flag_image` VARCHAR(500) DEFAULT NULL COMMENT '民族标志图片',
    `gallery` JSON DEFAULT NULL COMMENT '图片集',
    `video_url` VARCHAR(500) DEFAULT NULL COMMENT '介绍视频URL',
    `tags` VARCHAR(500) DEFAULT NULL COMMENT '标签',
    `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_code` (`code`),
    KEY `idx_name` (`name`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='民族表';
```

### 2.3 节日表 (festival)

```sql
-- 节日表
CREATE TABLE `festival` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `name` VARCHAR(100) NOT NULL COMMENT '节日名称（汉语）',
    `name_local` VARCHAR(100) DEFAULT NULL COMMENT '当地语言名称',
    `name_english` VARCHAR(100) DEFAULT NULL COMMENT '英文名称',
    `type` TINYINT NOT NULL COMMENT '类型：1法定假日 2传统节日 3民族节日 4节气 5纪念日 6地方节日',
    `sub_type` VARCHAR(50) DEFAULT NULL COMMENT '子类型，如：春节类、祭祀类等',
    `region_id` BIGINT DEFAULT NULL COMMENT '关联地区ID，NULL表示全国性节日',
    `region_name` VARCHAR(100) DEFAULT NULL COMMENT '地区名称（冗余）',
    `ethnicity_id` BIGINT DEFAULT NULL COMMENT '关联民族ID',
    `ethnicity_name` VARCHAR(50) DEFAULT NULL COMMENT '民族名称（冗余）',
    `start_date` VARCHAR(10) NOT NULL COMMENT '开始日期（公历MM-DD或农历格式）',
    `end_date` VARCHAR(10) DEFAULT NULL COMMENT '结束日期',
    `duration` INT NOT NULL DEFAULT 1 COMMENT '持续天数',
    `is_lunar` TINYINT NOT NULL DEFAULT 0 COMMENT '是否农历日期：0否 1是',
    `lunar_month` INT DEFAULT NULL COMMENT '农历月（is_lunar=1时有效）',
    `lunar_day` INT DEFAULT NULL COMMENT '农历日（is_lunar=1时有效）',
    `is_holiday` TINYINT NOT NULL DEFAULT 0 COMMENT '是否法定假日：0否 1是',
    `holiday_days` INT DEFAULT NULL COMMENT '放假天数',
    `is_solar_term` TINYINT NOT NULL DEFAULT 0 COMMENT '是否节气：0否 1是',
    `solar_term_angle` DECIMAL(6,2) DEFAULT NULL COMMENT '节气太阳黄经角度',
    `description` TEXT COMMENT '节日详细介绍',
    `origin` TEXT COMMENT '节日起源',
    `history` TEXT COMMENT '历史沿革',
    `customs` TEXT COMMENT '传统习俗',
    `taboos` TEXT COMMENT '禁忌事项',
    `food` TEXT COMMENT '特色美食',
    `food_images` JSON DEFAULT NULL COMMENT '美食图片',
    `clothing` TEXT COMMENT '特色服饰',
    `clothing_images` JSON DEFAULT NULL COMMENT '服饰图片',
    `activities` TEXT COMMENT '相关活动',
    `symbols` TEXT COMMENT '象征意义',
    `poems` TEXT COMMENT '相关诗词',
    `songs` TEXT COMMENT '相关歌曲',
    `image_url` VARCHAR(500) DEFAULT NULL COMMENT '节日主图',
    `icon_url` VARCHAR(500) DEFAULT NULL COMMENT '节日图标',
    `banner_url` VARCHAR(500) DEFAULT NULL COMMENT '横幅图片',
    `video_url` VARCHAR(500) DEFAULT NULL COMMENT '节日视频',
    `gallery` JSON DEFAULT NULL COMMENT '图片集',
    `color` VARCHAR(20) DEFAULT NULL COMMENT '主题颜色',
    `tags` VARCHAR(500) DEFAULT NULL COMMENT '标签',
    `view_count` BIGINT NOT NULL DEFAULT 0 COMMENT '浏览次数',
    `favorite_count` BIGINT NOT NULL DEFAULT 0 COMMENT '收藏次数',
    `share_count` BIGINT NOT NULL DEFAULT 0 COMMENT '分享次数',
    `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序',
    `is_hot` TINYINT NOT NULL DEFAULT 0 COMMENT '是否热门：0否 1是',
    `is_recommended` TINYINT NOT NULL DEFAULT 0 COMMENT '是否推荐：0否 1是',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1启用',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_type` (`type`),
    KEY `idx_region_id` (`region_id`),
    KEY `idx_ethnicity_id` (`ethnicity_id`),
    KEY `idx_start_date` (`start_date`),
    KEY `idx_is_lunar` (`is_lunar`),
    KEY `idx_is_holiday` (`is_holiday`),
    KEY `idx_is_hot` (`is_hot`),
    KEY `idx_status` (`status`),
    KEY `idx_type_region` (`type`, `region_id`),
    KEY `idx_type_date` (`type`, `start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='节日表';
```

### 2.4 节日图片表 (festival_image)

```sql
-- 节日图片表
CREATE TABLE `festival_image` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `festival_id` BIGINT NOT NULL COMMENT '节日ID',
    `image_url` VARCHAR(500) NOT NULL COMMENT '图片URL',
    `image_type` TINYINT NOT NULL DEFAULT 1 COMMENT '类型：1封面 2活动 3美食 4服饰 5风景 6历史 7其他',
    `title` VARCHAR(200) DEFAULT NULL COMMENT '图片标题',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '图片描述',
    `width` INT DEFAULT NULL COMMENT '图片宽度',
    `height` INT DEFAULT NULL COMMENT '图片高度',
    `size` BIGINT DEFAULT NULL COMMENT '图片大小（字节）',
    `source` VARCHAR(200) DEFAULT NULL COMMENT '图片来源',
    `photographer` VARCHAR(100) DEFAULT NULL COMMENT '摄影师',
    `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_festival_id` (`festival_id`),
    KEY `idx_image_type` (`image_type`),
    KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='节日图片表';
```

### 2.5 活动表 (activity)

```sql
-- 活动表
CREATE TABLE `activity` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `festival_id` BIGINT DEFAULT NULL COMMENT '关联节日ID',
    `region_id` BIGINT NOT NULL COMMENT '地区ID',
    `region_name` VARCHAR(100) DEFAULT NULL COMMENT '地区名称（冗余）',
    `name` VARCHAR(200) NOT NULL COMMENT '活动名称',
    `name_local` VARCHAR(200) DEFAULT NULL COMMENT '当地语言名称',
    `type` TINYINT NOT NULL DEFAULT 1 COMMENT '类型：1庆典 2祭祀 3比赛 4表演 5展览 6庙会 7游行 8其他',
    `sub_type` VARCHAR(50) DEFAULT NULL COMMENT '子类型',
    `start_time` DATETIME NOT NULL COMMENT '开始时间',
    `end_time` DATETIME COMMENT '结束时间',
    `duration_days` INT DEFAULT NULL COMMENT '持续天数',
    `location` VARCHAR(500) COMMENT '活动地点',
    `address` VARCHAR(500) COMMENT '详细地址',
    `latitude` DECIMAL(10,7) COMMENT '纬度',
    `longitude` DECIMAL(10,7) COMMENT '经度',
    `transportation` TEXT COMMENT '交通指南',
    `parking_info` VARCHAR(500) COMMENT '停车信息',
    `description` TEXT COMMENT '活动简介',
    `content` TEXT COMMENT '活动详情（富文本）',
    `highlights` TEXT COMMENT '活动亮点',
    `schedule` JSON COMMENT '活动日程安排',
    `organizer` VARCHAR(200) COMMENT '主办方',
    `co_organizer` VARCHAR(200) COMMENT '协办方',
    `sponsor` VARCHAR(200) COMMENT '赞助商',
    `contact_name` VARCHAR(100) COMMENT '联系人',
    `contact_phone` VARCHAR(20) COMMENT '联系电话',
    `contact_email` VARCHAR(100) COMMENT '联系邮箱',
    `website` VARCHAR(500) COMMENT '官方网站',
    `ticket_info` TEXT COMMENT '门票信息',
    `ticket_price` DECIMAL(10,2) COMMENT '票价（元）',
    `ticket_url` VARCHAR(500) COMMENT '购票链接',
    `capacity` INT COMMENT '容纳人数',
    `registered_count` INT DEFAULT 0 COMMENT '已报名人数',
    `min_age` INT COMMENT '最小年龄限制',
    `max_age` INT COMMENT '最大年龄限制',
    `weather_note` VARCHAR(500) COMMENT '天气提示',
    `dress_code` VARCHAR(500) COMMENT '着装建议',
    `tips` TEXT COMMENT '参加提示',
    `image_url` VARCHAR(500) COMMENT '活动主图',
    `banner_url` VARCHAR(500) COMMENT '横幅图片',
    `video_url` VARCHAR(500) COMMENT '活动视频',
    `gallery` JSON COMMENT '图片集',
    `tags` VARCHAR(500) COMMENT '标签',
    `view_count` BIGINT DEFAULT 0 COMMENT '浏览次数',
    `favorite_count` BIGINT DEFAULT 0 COMMENT '收藏次数',
    `share_count` BIGINT DEFAULT 0 COMMENT '分享次数',
    `rating` DECIMAL(3,2) DEFAULT 0 COMMENT '评分',
    `rating_count` INT DEFAULT 0 COMMENT '评分人数',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `is_hot` TINYINT DEFAULT 0 COMMENT '是否热门',
    `is_recommended` TINYINT DEFAULT 0 COMMENT '是否推荐',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1待开始 2进行中 3已结束 4已取消',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_festival_id` (`festival_id`),
    KEY `idx_region_id` (`region_id`),
    KEY `idx_type` (`type`),
    KEY `idx_start_time` (`start_time`),
    KEY `idx_end_time` (`end_time`),
    KEY `idx_status` (`status`),
    KEY `idx_is_hot` (`is_hot`),
    KEY `idx_region_time` (`region_id`, `start_time`),
    KEY `idx_status_time` (`status`, `start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动表';
```

### 2.6 放假安排表 (holiday_schedule)

```sql
-- 放假安排表
CREATE TABLE `holiday_schedule` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `year` INT NOT NULL COMMENT '年份',
    `festival_id` BIGINT NOT NULL COMMENT '节日ID',
    `festival_name` VARCHAR(100) NOT NULL COMMENT '节日名称（冗余）',
    `region_id` BIGINT DEFAULT NULL COMMENT '地区ID，NULL表示全国统一安排',
    `region_name` VARCHAR(100) DEFAULT NULL COMMENT '地区名称（冗余）',
    `start_date` DATE NOT NULL COMMENT '放假开始日期',
    `end_date` DATE NOT NULL COMMENT '放假结束日期',
    `total_days` INT NOT NULL COMMENT '放假总天数',
    `work_days` JSON COMMENT '调休工作日列表，如["2024-02-04","2024-02-18"]',
    `work_days_desc` VARCHAR(500) COMMENT '调休说明',
    `is_official` TINYINT NOT NULL DEFAULT 1 COMMENT '是否官方发布：0否 1是',
    `announcement` TEXT COMMENT '官方公告内容',
    `source` VARCHAR(200) COMMENT '信息来源',
    `source_url` VARCHAR(500) COMMENT '来源链接',
    `remark` VARCHAR(500) COMMENT '备注',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0草稿 1已发布 2已过期',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_year_festival_region` (`year`, `festival_id`, `region_id`),
    KEY `idx_year` (`year`),
    KEY `idx_festival_id` (`festival_id`),
    KEY `idx_region_id` (`region_id`),
    KEY `idx_start_date` (`start_date`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='放假安排表';
```

### 2.7 用户表 (user)

```sql
-- 用户表
CREATE TABLE `user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `username` VARCHAR(50) NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码（BCrypt加密）',
    `salt` VARCHAR(50) NOT NULL COMMENT '密码盐值',
    `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
    `avatar` VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
    `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
    `phone_verified` TINYINT DEFAULT 0 COMMENT '手机是否验证：0否 1是',
    `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `email_verified` TINYINT DEFAULT 0 COMMENT '邮箱是否验证：0否 1是',
    `gender` TINYINT DEFAULT 0 COMMENT '性别：0未知 1男 2女',
    `birthday` DATE DEFAULT NULL COMMENT '生日',
    `region_id` BIGINT DEFAULT NULL COMMENT '当前选择的地区ID',
    `region_name` VARCHAR(100) DEFAULT NULL COMMENT '地区名称（冗余）',
    `ethnicity_id` BIGINT DEFAULT NULL COMMENT '民族ID',
    `ethnicity_name` VARCHAR(50) DEFAULT NULL COMMENT '民族名称（冗余）',
    `bio` VARCHAR(500) DEFAULT NULL COMMENT '个人简介',
    `wechat_openid` VARCHAR(100) DEFAULT NULL COMMENT '微信OpenID',
    `wechat_unionid` VARCHAR(100) DEFAULT NULL COMMENT '微信UnionID',
    `qq_openid` VARCHAR(100) DEFAULT NULL COMMENT 'QQ OpenID',
    `apple_id` VARCHAR(100) DEFAULT NULL COMMENT 'Apple ID',
    `device_token` VARCHAR(200) DEFAULT NULL COMMENT '推送设备Token',
    `device_type` TINYINT DEFAULT NULL COMMENT '设备类型：1iOS 2Android',
    `last_login_time` DATETIME DEFAULT NULL COMMENT '最后登录时间',
    `last_login_ip` VARCHAR(50) DEFAULT NULL COMMENT '最后登录IP',
    `login_count` INT DEFAULT 0 COMMENT '登录次数',
    `vip_level` TINYINT DEFAULT 0 COMMENT 'VIP等级：0普通 1VIP 2SVIP',
    `vip_expire_time` DATETIME DEFAULT NULL COMMENT 'VIP过期时间',
    `points` BIGINT DEFAULT 0 COMMENT '积分',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0禁用 1正常 2待验证',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    UNIQUE KEY `uk_phone` (`phone`),
    UNIQUE KEY `uk_email` (`email`),
    UNIQUE KEY `uk_wechat_openid` (`wechat_openid`),
    KEY `idx_region_id` (`region_id`),
    KEY `idx_ethnicity_id` (`ethnicity_id`),
    KEY `idx_status` (`status`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
```

### 2.8 用户收藏表 (user_favorite)

```sql
-- 用户收藏表
CREATE TABLE `user_favorite` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `target_type` TINYINT NOT NULL COMMENT '收藏类型：1地区 2节日 3活动 4内容',
    `target_id` BIGINT NOT NULL COMMENT '目标ID',
    `target_name` VARCHAR(200) DEFAULT NULL COMMENT '目标名称（冗余）',
    `target_image` VARCHAR(500) DEFAULT NULL COMMENT '目标图片（冗余）',
    `remark` VARCHAR(200) DEFAULT NULL COMMENT '备注',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0取消 1有效',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_target` (`user_id`, `target_type`, `target_id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_target_type` (`target_type`),
    KEY `idx_target_id` (`target_id`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户收藏表';
```

### 2.9 用户日程表 (user_schedule)

```sql
-- 用户日程表
CREATE TABLE `user_schedule` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `title` VARCHAR(200) NOT NULL COMMENT '日程标题',
    `content` TEXT COMMENT '日程内容',
    `start_time` DATETIME NOT NULL COMMENT '开始时间',
    `end_time` DATETIME COMMENT '结束时间',
    `is_all_day` TINYINT NOT NULL DEFAULT 0 COMMENT '是否全天：0否 1是',
    `is_lunar` TINYINT NOT NULL DEFAULT 0 COMMENT '是否农历：0否 1是',
    `repeat_type` TINYINT NOT NULL DEFAULT 0 COMMENT '重复类型：0不重复 1每天 2每周 3每月 4每年',
    `repeat_end_date` DATE COMMENT '重复结束日期',
    `remind_type` TINYINT NOT NULL DEFAULT 1 COMMENT '提醒类型：1不提醒 2准时 3提前5分钟 4提前15分钟 5提前30分钟 6提前1小时 7提前1天 8提前1周',
    `remind_time` DATETIME COMMENT '提醒时间',
    `location` VARCHAR(500) COMMENT '地点',
    `color` VARCHAR(20) DEFAULT '#1890FF' COMMENT '颜色标记',
    `icon` VARCHAR(50) DEFAULT NULL COMMENT '图标',
    `is_completed` TINYINT NOT NULL DEFAULT 0 COMMENT '是否完成：0否 1是',
    `completed_time` DATETIME COMMENT '完成时间',
    `priority` TINYINT NOT NULL DEFAULT 0 COMMENT '优先级：0普通 1重要 2紧急',
    `tags` VARCHAR(200) COMMENT '标签',
    `attachment_url` VARCHAR(500) COMMENT '附件URL',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0删除 1正常',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_start_time` (`start_time`),
    KEY `idx_end_time` (`end_time`),
    KEY `idx_is_all_day` (`is_all_day`),
    KEY `idx_status` (`status`),
    KEY `idx_user_time` (`user_id`, `start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户日程表';
```

### 2.10 内容表 (content)

```sql
-- 内容表（文化知识、文章等）
CREATE TABLE `content` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `title` VARCHAR(200) NOT NULL COMMENT '标题',
    `sub_title` VARCHAR(200) DEFAULT NULL COMMENT '副标题',
    `type` TINYINT NOT NULL COMMENT '类型：1文化知识 2节日介绍 3活动报道 4攻略 5故事 6诗词',
    `region_id` BIGINT DEFAULT NULL COMMENT '关联地区',
    `festival_id` BIGINT DEFAULT NULL COMMENT '关联节日',
    `ethnicity_id` BIGINT DEFAULT NULL COMMENT '关联民族',
    `summary` TEXT COMMENT '摘要',
    `content` LONGTEXT COMMENT '正文内容（富文本）',
    `content_text` LONGTEXT COMMENT '纯文本内容（用于搜索）',
    `author` VARCHAR(100) DEFAULT NULL COMMENT '作者',
    `author_avatar` VARCHAR(500) DEFAULT NULL COMMENT '作者头像',
    `source` VARCHAR(200) DEFAULT NULL COMMENT '来源',
    `source_url` VARCHAR(500) DEFAULT NULL COMMENT '来源链接',
    `cover_image` VARCHAR(500) DEFAULT NULL COMMENT '封面图片',
    `gallery` JSON DEFAULT NULL COMMENT '图片集',
    `video_url` VARCHAR(500) DEFAULT NULL COMMENT '视频URL',
    `audio_url` VARCHAR(500) DEFAULT NULL COMMENT '音频URL（用于语音朗读）',
    `word_count` INT DEFAULT 0 COMMENT '字数',
    `read_time` INT DEFAULT 0 COMMENT '预计阅读时间（分钟）',
    `tags` VARCHAR(500) DEFAULT NULL COMMENT '标签',
    `view_count` BIGINT DEFAULT 0 COMMENT '浏览次数',
    `like_count` BIGINT DEFAULT 0 COMMENT '点赞次数',
    `favorite_count` BIGINT DEFAULT 0 COMMENT '收藏次数',
    `share_count` BIGINT DEFAULT 0 COMMENT '分享次数',
    `comment_count` BIGINT DEFAULT 0 COMMENT '评论次数',
    `is_daily_push` TINYINT DEFAULT 0 COMMENT '是否每日推送：0否 1是',
    `push_date` DATE DEFAULT NULL COMMENT '推送日期',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `is_top` TINYINT DEFAULT 0 COMMENT '是否置顶',
    `is_recommended` TINYINT DEFAULT 0 COMMENT '是否推荐',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0草稿 1已发布 2已下架',
    `publish_time` DATETIME DEFAULT NULL COMMENT '发布时间',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_type` (`type`),
    KEY `idx_region_id` (`region_id`),
    KEY `idx_festival_id` (`festival_id`),
    KEY `idx_ethnicity_id` (`ethnicity_id`),
    KEY `idx_is_daily_push` (`is_daily_push`),
    KEY `idx_push_date` (`push_date`),
    KEY `idx_status` (`status`),
    KEY `idx_publish_time` (`publish_time`),
    FULLTEXT KEY `ft_title_content` (`title`, `content_text`) WITH PARSER ngram
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='内容表';
```

### 2.11 用户浏览记录表 (user_view_log)

```sql
-- 用户浏览记录表
CREATE TABLE `user_view_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT DEFAULT NULL COMMENT '用户ID（未登录为NULL）',
    `device_id` VARCHAR(100) DEFAULT NULL COMMENT '设备ID',
    `target_type` TINYINT NOT NULL COMMENT '目标类型：1节日 2活动 3内容',
    `target_id` BIGINT NOT NULL COMMENT '目标ID',
    `view_duration` INT DEFAULT 0 COMMENT '浏览时长（秒）',
    `view_date` DATE NOT NULL COMMENT '浏览日期',
    `ip` VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
    `user_agent` VARCHAR(500) DEFAULT NULL COMMENT 'UserAgent',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_device_id` (`device_id`),
    KEY `idx_target` (`target_type`, `target_id`),
    KEY `idx_view_date` (`view_date`),
    KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户浏览记录表';
```

### 2.12 系统配置表 (sys_config)

```sql
-- 系统配置表
CREATE TABLE `sys_config` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `config_key` VARCHAR(100) NOT NULL COMMENT '配置键',
    `config_value` TEXT COMMENT '配置值',
    `config_type` VARCHAR(50) DEFAULT 'string' COMMENT '值类型：string/number/boolean/json',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '配置说明',
    `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';
```

---

## 3. 初始数据

### 3.1 民族初始数据

```sql
INSERT INTO `ethnicity` (`name`, `name_local`, `code`, `population`, `main_region_ids`, `language`, `description`) VALUES
('汉族', '汉族', '01', 1286310000, NULL, '汉语', '中国的主体民族，占全国人口的91.11%'),
('壮族', 'Bouxcuengh', '02', 16926381, '45,44', '壮语', '中国人口最多的少数民族'),
('满族', '满族', '03', 10387958, '21,22,23', '满语（濒危）', '清朝的建立民族'),
('回族', '回族', '04', 10586087, '64,62,65', '汉语', '中国分布最广的少数民族'),
('苗族', 'Hmongb', '05', 9426007, '52,43,53', '苗语', '中国最古老的民族之一'),
('维吾尔族', 'ئۇيغۇر', '06', 11774538, '65', '维吾尔语', '新疆的主体民族'),
('土家族', 'Bizika', '07', 8353912, '42,43,50', '土家语', '主要分布在湘鄂渝黔交界地带'),
('彝族', 'ꆈꌠ', '08', 8714393, '51,53,52', '彝语', '拥有古老文字的民族'),
('蒙古族', 'ᠮᠣᠩᠭᠣᠯ', '09', 5981840, '15,21,65', '蒙古语', '马背上的民族'),
('藏族', 'བོད་པ', '10', 6282187, '54,63,51', '藏语', '主要分布在青藏高原'),
('布依族', 'Buxqyaix', '11', 3576752, '52', '布依语', '主要聚居在贵州'),
('侗族', 'Gaeml', '12', 2879974, '52,43,45', '侗语', '以鼓楼和风雨桥闻名'),
('瑶族', 'Mienh', '13', 2796003, '45,43,53', '瑶语', '以盘王节著称'),
('朝鲜族', '조선족', '14', 1830929, '22', '朝鲜语', '主要分布在东北地区'),
('白族', 'Baipho', '15', 1933510, '53', '白语', '以三月街闻名'),
('哈尼族', 'Haqniq', '16', 1660932, '53', '哈尼语', '以梯田文化著称'),
('哈萨克族', 'قازاق', '17', 1462588, '65', '哈萨克语', '游牧民族'),
('黎族', 'Hlai', '18', 1463064, '46', '黎语', '海南岛原住民'),
('傣族', 'Tai', '19', 1261311, '53', '傣语', '以泼水节闻名'),
('畲族', 'Sa', '20', 708651, '35,33,44', '畲语', '主要分布在东南沿海');
```

### 3.2 节日初始数据

```sql
INSERT INTO `festival` (`name`, `type`, `start_date`, `duration`, `is_lunar`, `lunar_month`, `lunar_day`, `is_holiday`, `holiday_days`, `description`, `customs`, `food`, `image_url`, `color`) VALUES
('元旦', 1, '01-01', 3, 0, NULL, NULL, 1, 3, '公历新年第一天，世界多数国家通行的节日', '跨年倒计时、烟花表演、新年祝福', '饺子、年糕', '/images/festivals/yuandan.jpg', '#FF4444'),
('春节', 1, '01-01', 7, 1, 1, 1, 1, 7, '中国最重要的传统节日，农历新年', '贴春联、放鞭炮、拜年、发红包、舞龙舞狮', '饺子、年糕、汤圆、鱼', '/images/festivals/chunjie.jpg', '#FF0000'),
('元宵节', 2, '01-15', 1, 1, 1, 15, 0, NULL, '农历正月十五，春节后的第一个重要节日', '赏花灯、猜灯谜、吃元宵、舞龙灯', '元宵/汤圆', '/images/festivals/yuanxiaojie.jpg', '#FFD700'),
('清明节', 1, '04-04', 3, 0, NULL, NULL, 1, 3, '二十四节气之一，也是传统祭祀节日', '扫墓祭祖、踏青、插柳、放风筝', '青团、艾粄', '/images/festivals/qingming.jpg', '#228B22'),
('端午节', 1, '05-05', 3, 1, 5, 5, 1, 3, '纪念屈原的传统节日', '赛龙舟、吃粽子、挂艾草、佩香囊', '粽子、雄黄酒', '/images/festivals/duanwu.jpg', '#006400'),
('中秋节', 1, '08-15', 3, 1, 8, 15, 1, 3, '团圆的节日，与春节、端午、清明并称四大传统节日', '赏月、吃月饼、猜灯谜、拜月', '月饼、桂花酒、柚子', '/images/festivals/zhongqiu.jpg', '#FF8C00'),
('重阳节', 2, '09-09', 1, 1, 9, 9, 0, NULL, '农历九月初九，老人节', '登高、赏菊、插茱萸、吃重阳糕', '重阳糕、菊花酒', '/images/festivals/chongyang.jpg', '#8B4513'),
('泼水节', 3, '04-13', 3, 0, NULL, NULL, 0, NULL, '傣族新年，也是傣族最隆重的传统节日', '浴佛、泼水狂欢、赛龙舟、放孔明灯', '菠萝紫米饭、香竹饭', '/images/festivals/poshuijie.jpg', '#00CED1'),
('火把节', 3, '06-24', 3, 0, NULL, NULL, 0, NULL, '彝族、白族、纳西族等民族的传统节日', '点燃火把、歌舞狂欢、斗牛、摔跤', '坨坨肉、荞麦粑粑', '/images/festivals/huobajie.jpg', '#FF4500'),
('那达慕', 3, '07-11', 7, 0, NULL, NULL, 0, NULL, '蒙古族传统节日，意为"游戏"或"娱乐"', '赛马、摔跤、射箭、歌舞', '手把肉、奶茶、奶酪', '/images/festivals/nadamu.jpg', '#4169E1'),
('三月三', 3, '03-03', 3, 0, NULL, NULL, 0, NULL, '壮族传统歌节', '对歌、抛绣球、抢花炮、碰彩蛋', '五色糯米饭', '/images/festivals/sanyuesan.jpg', '#FF69B4'),
('雪顿节', 3, '07-01', 7, 1, 7, 1, 0, NULL, '藏族传统节日，意为"酸奶宴"', '晒大佛、藏戏表演、赛马', '酸奶、青稞酒、酥油茶', '/images/festivals/xuedunjie.jpg', '#FFFFFF'),
('古尔邦节', 3, '12-10', 3, 1, 12, 10, 0, NULL, '伊斯兰教重要节日', '宰牲、礼拜、走亲访友', '手抓羊肉、油香、馓子', '/images/festivals/guerbangjie.jpg', '#008000'),
('开斋节', 3, '10-01', 3, 1, 10, 1, 0, NULL, '伊斯兰教重要节日，斋月结束后的庆祝', '礼拜、走亲访友、施舍', '油香、馓子、糕点', '/images/festivals/kaizhaijie.jpg', '#008000');
```

### 3.3 系统配置初始数据

```sql
INSERT INTO `sys_config` (`config_key`, `config_value`, `config_type`, `description`) VALUES
('app_name', '节日历', 'string', '应用名称'),
('app_version', '1.0.0', 'string', '应用版本'),
('app_slogan', '发现每个节日的故事', 'string', '应用标语'),
('api_version', 'v1', 'string', 'API版本'),
('page_size', '20', 'number', '默认分页大小'),
('max_page_size', '100', 'number', '最大分页大小'),
('cache_ttl_region', '86400', 'number', '地区缓存时间（秒）'),
('cache_ttl_festival', '3600', 'number', '节日缓存时间（秒）'),
('cache_ttl_activity', '1800', 'number', '活动缓存时间（秒）'),
('daily_push_time', '08:00', 'string', '每日推送时间'),
('upload_max_size', '10485760', 'number', '上传文件最大大小（字节）'),
('image_quality', '80', 'number', '图片压缩质量'),
('enable_third_login', 'true', 'boolean', '是否启用第三方登录'),
('enable_push', 'true', 'boolean', '是否启用推送'),
('privacy_policy_url', 'https://example.com/privacy', 'string', '隐私政策链接'),
('user_agreement_url', 'https://example.com/agreement', 'string', '用户协议链接');
```

---

## 4. 数据字典

### 4.1 节日类型 (festival.type)
| 值 | 说明 | 示例 |
|---|------|------|
| 1 | 法定假日 | 元旦、春节、清明、端午、中秋、国庆 |
| 2 | 传统节日 | 元宵、七夕、重阳、腊八、小年 |
| 3 | 民族节日 | 泼水节、火把节、那达慕、三月三 |
| 4 | 节气 | 立春、雨水、惊蛰、春分... |
| 5 | 纪念日 | 劳动节、青年节、儿童节、建党节 |
| 6 | 地方节日 | 哈尔滨冰雪节、洛阳牡丹节 |

### 4.2 活动类型 (activity.type)
| 值 | 说明 |
|---|------|
| 1 | 庆典 |
| 2 | 祭祀 |
| 3 | 比赛 |
| 4 | 表演 |
| 5 | 展览 |
| 6 | 庙会 |
| 7 | 游行 |
| 8 | 其他 |

### 4.3 活动状态 (activity.status)
| 值 | 说明 |
|---|------|
| 0 | 禁用 |
| 1 | 待开始 |
| 2 | 进行中 |
| 3 | 已结束 |
| 4 | 已取消 |

### 4.4 用户状态 (user.status)
| 值 | 说明 |
|---|------|
| 0 | 禁用 |
| 1 | 正常 |
| 2 | 待验证 |

### 4.5 提醒类型 (user_schedule.remind_type)
| 值 | 说明 |
|---|------|
| 1 | 不提醒 |
| 2 | 准时提醒 |
| 3 | 提前5分钟 |
| 4 | 提前15分钟 |
| 5 | 提前30分钟 |
| 6 | 提前1小时 |
| 7 | 提前1天 |
| 8 | 提前1周 |

---

## 5. 索引设计说明

### 5.1 索引策略
- **主键索引**：所有表使用自增BIGINT作为主键
- **唯一索引**：业务唯一字段（如username、phone、code等）
- **普通索引**：常用查询条件字段
- **联合索引**：多条件组合查询场景
- **全文索引**：内容搜索场景（使用ngram解析器支持中文）

### 5.2 索引命名规范
- 唯一索引：`uk_字段名`
- 普通索引：`idx_字段名`
- 联合索引：`idx_字段1_字段2`
- 全文索引：`ft_字段名`

### 5.3 核心查询场景索引

| 查询场景 | 索引 | 说明 |
|---------|------|------|
| 按地区查节日 | `idx_type_region` | 节日类型+地区联合索引 |
| 按日期查节日 | `idx_type_date` | 节日类型+日期联合索引 |
| 用户日程查询 | `idx_user_time` | 用户ID+时间范围联合索引 |
| 活动日历 | `idx_region_time` | 地区+时间联合索引 |
| 内容搜索 | `ft_title_content` | 标题+内容全文索引 |

---

## 6. Redis缓存设计

### 6.1 缓存Key设计

| Key格式 | 说明 | TTL |
|---------|------|-----|
| `region:{id}` | 地区详情 | 24h |
| `region:list:{parentId}` | 子地区列表 | 24h |
| `region:hot` | 热门地区 | 1h |
| `festival:{id}` | 节日详情 | 1h |
| `festival:calendar:{regionId}:{year}:{month}` | 节日日历 | 30min |
| `festival:upcoming:{regionId}` | 即将到来的节日 | 30min |
| `activity:{id}` | 活动详情 | 30min |
| `activity:upcoming:{regionId}` | 即将开始的活动 | 15min |
| `holiday:{year}:{regionId}` | 放假安排 | 24h |
| `user:{id}` | 用户信息 | 30min |
| `content:daily` | 每日推送内容 | 24h |
| `content:{id}` | 内容详情 | 1h |
| `hot:festivals` | 热门节日榜单 | 1h |
| `hot:activities` | 热门活动榜单 | 30min |
| `config:{key}` | 系统配置 | 24h |

### 6.2 缓存更新策略
- **主动更新**：数据变更时删除相关缓存
- **被动更新**：缓存过期后重新加载
- **定时更新**：定时任务更新热点数据
- **预热策略**：系统启动时预加载基础数据

### 6.3 缓存穿透防护
- 使用布隆过滤器过滤无效请求
- 空值缓存，设置较短TTL
- 接口参数校验

### 6.4 缓存雪崩防护
- TTL添加随机偏移量
- 多级缓存策略
- 热点数据永不过期+异步更新

---

## 7. 数据迁移和备份

### 7.1 数据迁移策略
1. **初始化数据**：SQL脚本导入
2. **地区数据**：从国家统计局获取
3. **节日数据**：人工整理+网络采集
4. **活动数据**：合作渠道获取+人工录入

### 7.2 备份策略
- **全量备份**：每天凌晨3点
- **增量备份**：每小时
- **binlog备份**：实时
- **备份保留**：本地7天，云端30天

### 7.3 恢复策略
- **RTO**：< 1小时
- **RPO**：< 1小时
- **恢复演练**：每季度一次

---

## 8. 性能优化建议

### 8.1 查询优化
- 避免SELECT *，只查询需要的字段
- 使用覆盖索引减少回表
- 分页查询使用游标分页
- 大数据量使用流式查询

### 8.2 写入优化
- 批量操作使用批量插入
- 非关键数据异步写入
- 使用INSERT ON DUPLICATE KEY UPDATE

### 8.3 表设计优化
- 适当冗余常用字段（如name）
- 大字段分离到扩展表
- 历史数据归档

### 8.4 分库分表预案
当单表数据量超过1000万时考虑：
- 用户表：按用户ID哈希分表
- 浏览记录表：按时间范围分表
- 日程表：按用户ID分表

---

**文档版本**：v1.0
**最后更新**：2024年1月
**维护人**：开发团队
