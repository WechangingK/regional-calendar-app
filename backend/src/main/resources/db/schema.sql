-- ========================================
-- 地区特色日历App - 数据库初始化脚本
-- ========================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `regional_calendar`
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE `regional_calendar`;

-- ----------------------------------------
-- 1. 地区表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `region` (
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

-- ----------------------------------------
-- 2. 民族表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `ethnicity` (
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

-- ----------------------------------------
-- 3. 节日表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `festival` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `name` VARCHAR(100) NOT NULL COMMENT '节日名称（汉语）',
    `name_local` VARCHAR(100) DEFAULT NULL COMMENT '当地语言名称',
    `name_english` VARCHAR(100) DEFAULT NULL COMMENT '英文名称',
    `type` TINYINT NOT NULL COMMENT '类型：1法定假日 2传统节日 3民族节日 4节气 5纪念日 6地方节日',
    `sub_type` VARCHAR(50) DEFAULT NULL COMMENT '子类型',
    `region_id` BIGINT DEFAULT NULL COMMENT '关联地区ID，NULL表示全国性节日',
    `region_name` VARCHAR(100) DEFAULT NULL COMMENT '地区名称（冗余）',
    `ethnicity_id` BIGINT DEFAULT NULL COMMENT '关联民族ID',
    `ethnicity_name` VARCHAR(50) DEFAULT NULL COMMENT '民族名称（冗余）',
    `start_date` VARCHAR(10) NOT NULL COMMENT '开始日期（公历MM-DD或农历格式）',
    `end_date` VARCHAR(10) DEFAULT NULL COMMENT '结束日期',
    `duration` INT NOT NULL DEFAULT 1 COMMENT '持续天数',
    `is_lunar` TINYINT NOT NULL DEFAULT 0 COMMENT '是否农历日期：0否 1是',
    `lunar_month` INT DEFAULT NULL COMMENT '农历月',
    `lunar_day` INT DEFAULT NULL COMMENT '农历日',
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

-- ----------------------------------------
-- 4. 节日图片表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `festival_image` (
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

-- ----------------------------------------
-- 5. 活动表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `activity` (
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

-- ----------------------------------------
-- 6. 放假安排表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `holiday_schedule` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `year` INT NOT NULL COMMENT '年份',
    `festival_id` BIGINT NOT NULL COMMENT '节日ID',
    `festival_name` VARCHAR(100) NOT NULL COMMENT '节日名称（冗余）',
    `region_id` BIGINT DEFAULT NULL COMMENT '地区ID，NULL表示全国统一安排',
    `region_name` VARCHAR(100) DEFAULT NULL COMMENT '地区名称（冗余）',
    `start_date` DATE NOT NULL COMMENT '放假开始日期',
    `end_date` DATE NOT NULL COMMENT '放假结束日期',
    `total_days` INT NOT NULL COMMENT '放假总天数',
    `work_days` JSON COMMENT '调休工作日列表',
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

-- ----------------------------------------
-- 7. 用户表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `user` (
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

-- ----------------------------------------
-- 8. 用户收藏表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `user_favorite` (
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

-- ----------------------------------------
-- 9. 用户日程表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `user_schedule` (
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

-- ----------------------------------------
-- 10. 内容表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `content` (
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
    `audio_url` VARCHAR(500) DEFAULT NULL COMMENT '音频URL',
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

-- ----------------------------------------
-- 11. 用户浏览记录表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `user_view_log` (
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

-- ----------------------------------------
-- 12. 系统配置表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS `sys_config` (
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
