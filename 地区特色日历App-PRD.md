# 地区特色日历App - 产品需求文档 (PRD)

## 1. 产品概述

### 1.1 产品名称
**节日历** - 地区特色文化日历

### 1.2 产品定位
一款专注于展示中国各地区（特别是少数民族地区）特色节日、文化活动和放假安排的日历应用。通过IP定位和手动切换地区，为用户提供个性化的节日信息服务。

### 1.3 核心价值
- **文化传承**：展示各地区独特的节日文化，促进文化多样性的传播
- **实用性强**：提供准确的放假安排和活动信息
- **个性化体验**：根据用户所在地区智能推荐相关内容

### 1.4 目标用户
| 用户群体 | 特征 | 需求 |
|---------|------|------|
| 本地居民 | 少数民族地区居民 | 了解本民族节日安排，参与本地活动 |
| 旅游爱好者 | 喜欢体验不同文化 | 规划行程，体验特色节日 |
| 文化研究者 | 对民俗文化感兴趣 | 了解各地区节日文化背景 |
| 普通用户 | 需要日历功能 | 替代系统日历，获取更多节日信息 |

---

## 2. 核心功能模块

### 2.1 基础日历功能
- **月视图**：展示当月日期，支持左右滑动切换月份
- **周视图**：展示本周日期，快速查看近期安排
- **日详情**：点击日期查看详情，包括节日、节气、历史事件等
- **农历显示**：支持农历日期显示
- **节日标记**：在日历上用特殊颜色/图标标记有节日的日期
- **日程管理**：支持用户添加个人日程（可选功能）

### 2.2 地区切换功能
- **自动定位**：根据IP自动识别用户所在地区
- **手动切换**：支持手动选择省/市/区/民族
- **地区收藏**：收藏常关注的地区，快速切换
- **历史记录**：记录用户查看过的地区

### 2.3 节日信息展示
- **节日列表**：按时间顺序展示当前地区的节日
- **节日详情**：
  - 节日名称（当地语言+汉语）
  - 节日起源和历史背景
  - 传统习俗和活动介绍
  - 放假安排（法定假日标注）
  - 特色美食和服饰
  - 相关图片和视频
- **倒计时**：距离下一个节日的倒计时
- **节日日历**：专门展示全年节日的时间轴视图

### 2.4 特色活动推荐
- **活动日历**：展示当前地区的特色活动
- **活动详情**：
  - 活动名称和时间
  - 活动地点和交通
  - 活动内容介绍
  - 参与方式和注意事项
- **活动提醒**：支持设置活动提醒

### 2.5 内容展示
- **图文并茂**：节日习俗的图文介绍
- **多媒体支持**：节日相关的图片、视频
- **文化小知识**：每日推送一条文化小知识
- **用户互动**：评论、分享功能（可选）

---

## 3. 技术架构设计

### 3.1 整体架构
```
┌─────────────────────────────────────────────────────────┐
│                    客户端 (Flutter)                       │
├─────────────────────────────────────────────────────────┤
│  UI层 │ 状态管理 │ 网络层 │ 本地存储 │ 工具类             │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│                   API网关 (Nginx)                        │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│               后端服务 (Spring Boot)                     │
├─────────────────────────────────────────────────────────┤
│  Controller层 │ Service层 │ Repository层 │ 配置层        │
└─────────────────────────────────────────────────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │  MySQL   │ │  Redis   │ │   OSS    │
        │  数据库   │ │   缓存   │ │ 文件存储  │
        └──────────┘ └──────────┘ └──────────┘
```

### 3.2 前端技术栈 (Flutter)
| 技术 | 用途 | 说明 |
|-----|------|------|
| Flutter 3.x | 跨平台框架 | 一套代码支持iOS/Android |
| Riverpod | 状态管理 | 官方推荐，类型安全 |
| Dio | 网络请求 | 支持拦截器、取消请求 |
| Hive | 本地存储 | 轻量级NoSQL数据库 |
| flutter_localizations | 国际化 | 支持多语言 |
| table_calendar | 日历组件 | 高度可定制的日历组件 |
| cached_network_image | 图片缓存 | 优化图片加载性能 |
| flutter_bloc | 业务逻辑 | 复杂状态管理（可选） |

### 3.3 后端技术栈 (Spring Boot)
| 技术 | 用途 | 说明 |
|-----|------|------|
| Spring Boot 3.x | 核心框架 | 快速开发、自动配置 |
| Spring Security | 安全框架 | 认证授权 |
| MyBatis-Plus | ORM框架 | 简化数据库操作 |
| Redis | 缓存 | 热点数据缓存 |
| MySQL 8.0 | 数据库 | 主数据存储 |
| MinIO/Aliyun OSS | 文件存储 | 图片、视频存储 |
| Swagger | API文档 | 接口文档自动生成 |
| XXL-JOB | 定时任务 | 数据同步、缓存更新 |

### 3.4 项目结构

#### Flutter项目结构
```
lib/
├── main.dart
├── app/
│   ├── routes/          # 路由配置
│   ├── theme/           # 主题配置
│   └── constants/       # 常量定义
├── core/
│   ├── network/         # 网络层
│   ├── storage/         # 本地存储
│   ├── utils/           # 工具类
│   └── exceptions/      # 异常处理
├── data/
│   ├── models/          # 数据模型
│   ├── repositories/    # 数据仓库
│   └── providers/       # 状态管理
├── presentation/
│   ├── screens/         # 页面
│   ├── widgets/         # 组件
│   └── dialogs/         # 弹窗
└── services/
    ├── location/        # 定位服务
    ├── notification/    # 通知服务
    └── analytics/       # 数据统计
```

#### Spring Boot项目结构
```
src/main/java/com/festivalcalendar/
├── config/              # 配置类
├── controller/          # 控制器
├── service/             # 服务层
│   └── impl/            # 服务实现
├── repository/          # 数据访问层
├── entity/              # 实体类
├── dto/                 # 数据传输对象
├── vo/                  # 视图对象
├── mapper/              # MyBatis映射器
├── common/              # 公共类
│   ├── enums/           # 枚举
│   ├── exception/       # 异常
│   └── utils/           # 工具类
└── resources/
    ├── mapper/          # XML映射文件
    └── application.yml  # 配置文件
```

---

## 4. 数据库设计

### 4.1 核心表结构

#### 地区表 (region)
```sql
CREATE TABLE region (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    parent_id BIGINT DEFAULT 0 COMMENT '父级地区ID',
    name VARCHAR(100) NOT NULL COMMENT '地区名称',
    name_local VARCHAR(100) COMMENT '当地语言名称',
    level TINYINT NOT NULL COMMENT '级别：1省 2市 3区/县',
    code VARCHAR(20) NOT NULL COMMENT '行政区划代码',
    latitude DECIMAL(10,7) COMMENT '纬度',
    longitude DECIMAL(10,7) COMMENT '经度',
    description TEXT COMMENT '地区简介',
    image_url VARCHAR(500) COMMENT '地区图片',
    status TINYINT DEFAULT 1 COMMENT '状态：0禁用 1启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_parent_id (parent_id),
    INDEX idx_code (code),
    INDEX idx_level (level)
) COMMENT '地区表';
```

#### 民族表 (ethnicity)
```sql
CREATE TABLE ethnicity (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL COMMENT '民族名称',
    name_local VARCHAR(50) COMMENT '民族语言名称',
    population INT COMMENT '人口数量',
    region_ids VARCHAR(500) COMMENT '主要分布地区ID，逗号分隔',
    language VARCHAR(100) COMMENT '语言',
    description TEXT COMMENT '民族简介',
    image_url VARCHAR(500) COMMENT '民族图片',
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '民族表';
```

#### 节日表 (festival)
```sql
CREATE TABLE festival (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '节日名称',
    name_local VARCHAR(100) COMMENT '当地语言名称',
    name_english VARCHAR(100) COMMENT '英文名称',
    type TINYINT NOT NULL COMMENT '类型：1法定假日 2传统节日 3民族节日 4节气 5纪念日',
    region_id BIGINT COMMENT '关联地区ID，NULL表示全国性节日',
    ethnicity_id BIGINT COMMENT '关联民族ID',
    start_date VARCHAR(10) COMMENT '开始日期（格式：MM-DD或农历日期）',
    end_date VARCHAR(10) COMMENT '结束日期',
    duration INT DEFAULT 1 COMMENT '持续天数',
    is_lunar TINYINT DEFAULT 0 COMMENT '是否农历：0否 1是',
    is_holiday TINYINT DEFAULT 0 COMMENT '是否放假：0否 1是',
    holiday_days INT COMMENT '放假天数',
    description TEXT COMMENT '节日介绍',
    history TEXT COMMENT '历史由来',
    customs TEXT COMMENT '传统习俗',
    food TEXT COMMENT '特色美食',
    clothing TEXT COMMENT '特色服饰',
    activities TEXT COMMENT '相关活动',
    image_url VARCHAR(500) COMMENT '节日主图',
    video_url VARCHAR(500) COMMENT '节日视频',
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_type (type),
    INDEX idx_region_id (region_id),
    INDEX idx_ethnicity_id (ethnicity_id),
    INDEX idx_start_date (start_date)
) COMMENT '节日表';
```

#### 节日图片表 (festival_image)
```sql
CREATE TABLE festival_image (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    festival_id BIGINT NOT NULL COMMENT '节日ID',
    image_url VARCHAR(500) NOT NULL COMMENT '图片URL',
    image_type TINYINT DEFAULT 1 COMMENT '类型：1封面 2活动 3美食 4服饰 5其他',
    sort_order INT DEFAULT 0 COMMENT '排序',
    description VARCHAR(200) COMMENT '图片描述',
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_festival_id (festival_id)
) COMMENT '节日图片表';
```

#### 活动表 (activity)
```sql
CREATE TABLE activity (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    festival_id BIGINT COMMENT '关联节日ID',
    region_id BIGINT NOT NULL COMMENT '地区ID',
    name VARCHAR(200) NOT NULL COMMENT '活动名称',
    name_local VARCHAR(200) COMMENT '当地语言名称',
    type TINYINT DEFAULT 1 COMMENT '类型：1庆典 2祭祀 3比赛 4表演 5展览 6其他',
    start_time DATETIME NOT NULL COMMENT '开始时间',
    end_time DATETIME COMMENT '结束时间',
    location VARCHAR(500) COMMENT '活动地点',
    address VARCHAR(500) COMMENT '详细地址',
    latitude DECIMAL(10,7) COMMENT '纬度',
    longitude DECIMAL(10,7) COMMENT '经度',
    description TEXT COMMENT '活动介绍',
    content TEXT COMMENT '活动详情',
    organizer VARCHAR(200) COMMENT '主办方',
    contact VARCHAR(100) COMMENT '联系方式',
    ticket_info TEXT COMMENT '门票信息',
    image_url VARCHAR(500) COMMENT '活动图片',
    status TINYINT DEFAULT 1 COMMENT '状态：0下架 1上线 2进行中 3已结束',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_festival_id (festival_id),
    INDEX idx_region_id (region_id),
    INDEX idx_start_time (start_time),
    INDEX idx_status (status)
) COMMENT '活动表';
```

#### 放假安排表 (holiday_schedule)
```sql
CREATE TABLE holiday_schedule (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    year INT NOT NULL COMMENT '年份',
    festival_id BIGINT NOT NULL COMMENT '节日ID',
    region_id BIGINT COMMENT '地区ID，NULL表示全国',
    start_date DATE NOT NULL COMMENT '放假开始日期',
    end_date DATE NOT NULL COMMENT '放假结束日期',
    total_days INT NOT NULL COMMENT '放假总天数',
    work_days VARCHAR(200) COMMENT '调休工作日，逗号分隔',
    description VARCHAR(500) COMMENT '放假说明',
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE INDEX idx_year_festival_region (year, festival_id, region_id)
) COMMENT '放假安排表';
```

#### 用户表 (user)
```sql
CREATE TABLE user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    nickname VARCHAR(50) COMMENT '昵称',
    avatar VARCHAR(500) COMMENT '头像',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    region_id BIGINT COMMENT '当前选择的地区ID',
    ethnicity_id BIGINT COMMENT '民族ID',
    status TINYINT DEFAULT 1,
    last_login_time DATETIME COMMENT '最后登录时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE INDEX uk_username (username),
    UNIQUE INDEX uk_phone (phone)
) COMMENT '用户表';
```

#### 用户收藏表 (user_favorite)
```sql
CREATE TABLE user_favorite (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    target_type TINYINT NOT NULL COMMENT '收藏类型：1地区 2节日 3活动',
    target_id BIGINT NOT NULL COMMENT '目标ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE INDEX uk_user_target (user_id, target_type, target_id)
) COMMENT '用户收藏表';
```

#### 用户日程表 (user_schedule)
```sql
CREATE TABLE user_schedule (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    title VARCHAR(200) NOT NULL COMMENT '日程标题',
    content TEXT COMMENT '日程内容',
    start_time DATETIME NOT NULL COMMENT '开始时间',
    end_time DATETIME COMMENT '结束时间',
    is_all_day TINYINT DEFAULT 0 COMMENT '是否全天',
    remind_type TINYINT DEFAULT 1 COMMENT '提醒类型：1不提醒 2准时 3提前5分钟 4提前15分钟 5提前1小时 6提前1天',
    color VARCHAR(20) COMMENT '颜色标记',
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_start_time (start_time)
) COMMENT '用户日程表';
```

### 4.2 数据库ER图
```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│   region    │       │  ethnicity  │       │   festival  │
├─────────────┤       ├─────────────┤       ├─────────────┤
│ id          │◄──┐   │ id          │◄──┐   │ id          │
│ parent_id   │   │   │ name        │   │   │ name        │
│ name        │   │   │ region_ids  │   │   │ type        │
│ ...         │   │   │ ...         │   │   │ region_id   │──┐
└─────────────┘   │   └─────────────┘   │   │ ethnicity_id│──┤
                  │                     │   │ ...         │  │
                  │   ┌─────────────┐   │   └─────────────┘  │
                  │   │   user      │   │           │        │
                  │   ├─────────────┤   │           ▼        │
                  │   │ id          │   │   ┌─────────────┐  │
                  │   │ region_id   │───┘   │  activity   │  │
                  │   │ ethnicity_id│───┘   ├─────────────┤  │
                  │   │ ...         │       │ id          │  │
                  │   └─────────────┘       │ festival_id │  │
                  │           │             │ region_id   │──┘
                  │           ▼             │ ...         │
                  │   ┌─────────────┐       └─────────────┘
                  │   │user_favorite│
                  │   ├─────────────┤
                  │   │ user_id     │
                  │   │ target_type │
                  │   │ target_id   │
                  │   └─────────────┘
                  │
                  └──────────────────────────────────────────
```

---

## 5. API接口设计

### 5.1 接口规范
- **基础路径**：`/api/v1`
- **请求格式**：JSON
- **响应格式**：JSON
- **认证方式**：JWT Token
- **状态码**：
  - 200：成功
  - 400：请求参数错误
  - 401：未认证
  - 403：权限不足
  - 404：资源不存在
  - 500：服务器内部错误

### 5.2 响应格式
```json
{
    "code": 200,
    "message": "success",
    "data": {},
    "timestamp": 1715000000000
}
```

### 5.3 核心接口列表

#### 5.3.1 地区相关
| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 获取地区列表 | GET | /api/v1/regions | 支持分页、筛选 |
| 获取地区详情 | GET | /api/v1/regions/{id} | 地区详细信息 |
| 获取子地区 | GET | /api/v1/regions/{id}/children | 获取下级地区 |
| 搜索地区 | GET | /api/v1/regions/search | 关键词搜索 |
| 根据IP定位 | GET | /api/v1/regions/locate | 根据IP获取地区 |

#### 5.3.2 节日相关
| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 获取节日列表 | GET | /api/v1/festivals | 支持地区、类型筛选 |
| 获取节日详情 | GET | /api/v1/festivals/{id} | 节日详细信息 |
| 获取节日图片 | GET | /api/v1/festivals/{id}/images | 节日相关图片 |
| 获取本月节日 | GET | /api/v1/festivals/current-month | 当月节日列表 |
| 获取节日日历 | GET | /api/v1/festivals/calendar | 日历视图数据 |
| 搜索节日 | GET | /api/v1/festivals/search | 关键词搜索 |

#### 5.3.3 活动相关
| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 获取活动列表 | GET | /api/v1/activities | 支持地区、时间筛选 |
| 获取活动详情 | GET | /api/v1/activities/{id} | 活动详细信息 |
| 获取近期活动 | GET | /api/v1/activities/upcoming | 即将开始的活动 |
| 获取活动日历 | GET | /api/v1/activities/calendar | 活动日历数据 |

#### 5.3.4 放假安排
| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 获取放假安排 | GET | /api/v1/holidays | 按年份、地区筛选 |
| 获取当年放假 | GET | /api/v1/holidays/current-year | 当年放假安排 |
| 获取调休安排 | GET | /api/v1/holidays/adjustments | 调休工作日 |

#### 5.3.5 用户相关
| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 用户注册 | POST | /api/v1/users/register | 注册新用户 |
| 用户登录 | POST | /api/v1/users/login | 登录获取Token |
| 获取用户信息 | GET | /api/v1/users/profile | 当前用户信息 |
| 更新用户信息 | PUT | /api/v1/users/profile | 更新个人信息 |
| 切换地区 | PUT | /api/v1/users/region | 切换当前地区 |
| 获取收藏列表 | GET | /api/v1/users/favorites | 用户收藏 |
| 添加收藏 | POST | /api/v1/users/favorites | 添加收藏 |
| 取消收藏 | DELETE | /api/v1/users/favorites/{id} | 取消收藏 |
| 获取日程列表 | GET | /api/v1/users/schedules | 用户日程 |
| 添加日程 | POST | /api/v1/users/schedules | 添加日程 |
| 更新日程 | PUT | /api/v1/users/schedules/{id} | 更新日程 |
| 删除日程 | DELETE | /api/v1/users/schedules/{id} | 删除日程 |

#### 5.3.6 内容相关
| 接口 | 方法 | 路径 | 说明 |
|-----|------|------|------|
| 获取文化小知识 | GET | /api/v1/culture/today | 每日文化知识 |
| 获取内容列表 | GET | /api/v1/contents | 图文内容列表 |
| 获取内容详情 | GET | /api/v1/contents/{id} | 内容详情 |

### 5.4 接口详细设计示例

#### 获取节日日历接口
**请求**
```http
GET /api/v1/festivals/calendar?regionId=1&year=2024&month=1
Authorization: Bearer {token}
```

**响应**
```json
{
    "code": 200,
    "message": "success",
    "data": {
        "year": 2024,
        "month": 1,
        "region": {
            "id": 1,
            "name": "云南省"
        },
        "festivals": [
            {
                "date": "2024-01-01",
                "lunarDate": "十一月二十",
                "festivals": [
                    {
                        "id": 1,
                        "name": "元旦",
                        "type": 1,
                        "isHoliday": true,
                        "color": "#FF0000"
                    }
                ]
            },
            {
                "date": "2024-01-10",
                "lunarDate": "十一月廿九",
                "festivals": [
                    {
                        "id": 15,
                        "name": "腊八节",
                        "type": 2,
                        "isHoliday": false,
                        "color": "#00FF00"
                    }
                ]
            }
        ]
    }
}
```

---

## 6. 开发计划

### 6.1 开发阶段划分

#### 第一阶段：基础框架搭建（2周）
**目标**：完成项目初始化和基础架构

| 任务 | 时间 | 产出 |
|-----|------|------|
| 项目初始化 | 1天 | Flutter项目、Spring Boot项目 |
| 数据库设计 | 2天 | 数据库脚本、实体类 |
| 基础框架搭建 | 3天 | 网络层、状态管理、工具类 |
| API基础框架 | 2天 | 统一响应、异常处理、JWT认证 |
| CI/CD配置 | 2天 | 自动构建、部署脚本 |

#### 第二阶段：核心功能开发（4周）
**目标**：完成日历和节日核心功能

| 任务 | 时间 | 说明 |
|-----|------|------|
| 日历组件开发 | 3天 | 月视图、周视图、日期选择 |
| 地区选择功能 | 2天 | 地区列表、搜索、切换 |
| 节日列表页面 | 3天 | 节日展示、筛选、搜索 |
| 节日详情页面 | 3天 | 详情展示、图片轮播 |
| 放假安排展示 | 2天 | 放假时间轴、调休提醒 |
| 后端API开发 | 5天 | 地区、节日、活动接口 |

#### 第三阶段：特色功能开发（3周）
**目标**：完成特色功能和用户体验优化

| 任务 | 时间 | 说明 |
|-----|------|------|
| IP定位功能 | 2天 | 自动识别地区 |
| 活动日历功能 | 3天 | 活动展示、详情 |
| 文化内容展示 | 3天 | 图文内容、小知识推送 |
| 用户系统 | 3天 | 注册登录、个人中心 |
| 收藏功能 | 2天 | 地区、节日收藏 |

#### 第四阶段：完善和优化（2周）
**目标**：功能完善、性能优化、测试修复

| 任务 | 时间 | 说明 |
|-----|------|------|
| 用户日程功能 | 3天 | 日程添加、提醒设置 |
| 性能优化 | 3天 | 缓存策略、加载优化 |
| UI美化 | 3天 | 动画效果、主题适配 |
| Bug修复 | 3天 | 问题修复、边界处理 |

#### 第五阶段：测试和上线（2周）
**目标**：全面测试、准备上线

| 任务 | 时间 | 说明 |
|-----|------|------|
| 单元测试 | 3天 | 核心功能测试 |
| 集成测试 | 3天 | 接口联调测试 |
| 用户测试 | 3天 | 内测反馈收集 |
| 上线准备 | 3天 | 应用商店提交、服务器部署 |

### 6.2 里程碑计划
```
2024 Q1
├── M1: 基础框架完成 (第2周末)
├── M2: 核心功能完成 (第6周末)
├── M3: 特色功能完成 (第9周末)
├── M4: 功能完善完成 (第11周末)
└── M5: 正式上线 (第13周末)
```

### 6.3 详细开发排期

#### 第1周：项目初始化
- [ ] 创建Flutter项目，配置依赖
- [ ] 创建Spring Boot项目，配置依赖
- [ ] 设计数据库表结构
- [ ] 编写数据库初始化脚本
- [ ] 配置Git仓库和分支策略

#### 第2周：基础框架
- [ ] Flutter: 网络层封装（Dio）
- [ ] Flutter: 状态管理配置（Riverpod）
- [ ] Flutter: 路由配置
- [ ] Spring Boot: 统一响应封装
- [ ] Spring Boot: 全局异常处理
- [ ] Spring Boot: JWT认证实现

#### 第3周：日历功能
- [ ] 日历月视图组件
- [ ] 日历周视图组件
- [ ] 日期选择和切换
- [ ] 农历显示功能
- [ ] 节日标记显示

#### 第4周：地区功能
- [ ] 地区数据导入
- [ ] 地区列表页面
- [ ] 地区搜索功能
- [ ] 地区切换功能
- [ ] 地区API开发

#### 第5-6周：节日功能
- [ ] 节日数据导入
- [ ] 节日列表页面
- [ ] 节日详情页面
- [ ] 节日筛选功能
- [ ] 放假安排展示
- [ ] 节日API开发

#### 第7-8周：活动和内容
- [ ] 活动数据导入
- [ ] 活动列表页面
- [ ] 活动详情页面
- [ ] 文化内容展示
- [ ] 每日知识推送
- [ ] 活动API开发

#### 第9周：用户功能
- [ ] 用户注册登录
- [ ] 个人中心页面
- [ ] 收藏功能
- [ ] 用户API开发

#### 第10-11周：完善优化
- [ ] 日程管理功能
- [ ] 性能优化
- [ ] UI美化
- [ ] Bug修复

#### 第12-13周：测试上线
- [ ] 单元测试编写
- [ ] 集成测试
- [ ] 用户测试
- [ ] 应用商店提交

---

## 7. UI/UX设计要点

### 7.1 设计风格
- **主题色**：采用中国传统色彩，如中国红、青瓷蓝、水墨黑
- **字体**：支持显示少数民族文字
- **图标**：使用具有民族特色的图标元素
- **动画**：流畅的过渡动画，增强用户体验

### 7.2 核心页面设计

#### 7.2.1 日历主页
```
┌─────────────────────────────────────┐
│  ◀ 2024年1月 ▶        📍 云南省    │
├─────────────────────────────────────┤
│  日  一  二  三  四  五  六         │
│  ..  ..  ..  ..  ..  ..  1         │
│  2   3   4   5   6   7   8         │
│  9  10  11  12  13  14  15         │
│ 16  17  18  19  20  21  22         │
│ 23  24  25  26  27  28  29         │
│ 30  31                             │
├─────────────────────────────────────┤
│ 🎉 近期节日                        │
│ ┌─────────────────────────────────┐ │
│ │ 🏮 春节           2月10日      │ │
│ │    放假7天                      │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 🎊 元宵节         2月24日      │ │
│ │    传统节日                     │ │
│ └─────────────────────────────────┘ │
├─────────────────────────────────────┤
│ 📅 今日：腊月初八                   │
│ 💡 腊八节喝腊八粥是传统习俗...     │
├─────────────────────────────────────┤
│  🏠    📅    🎉    👤              │
│  首页  日历  节日  我的             │
└─────────────────────────────────────┘
```

#### 7.2.2 节日详情页
```
┌─────────────────────────────────────┐
│  ← 返回              ⭐ 收藏       │
├─────────────────────────────────────┤
│  ┌─────────────────────────────────┐│
│  │                                 ││
│  │      [节日主图]                 ││
│  │                                 ││
│  └─────────────────────────────────┘│
│  🏮 泼水节                          │
│  傣语：⠀⠀⠀⠀⠀⠀⠀⠀⠀          │
│  ⏰ 2024年4月13日-15日              │
│  📍 云南省西双版纳                   │
├─────────────────────────────────────┤
│  📖 节日介绍                        │
│  泼水节是傣族的新年，也是傣族最隆重 │
│  的传统节日...                      │
├─────────────────────────────────────┤
│  🎭 传统习俗                        │
│  • 浴佛仪式                         │
│  • 泼水狂欢                         │
│  • 赛龙舟                           │
│  • 放孔明灯                         │
├─────────────────────────────────────┤
│  🍜 特色美食                        │
│  • 菠萝紫米饭                       │
│  • 香竹饭                           │
│  • 酸笋煮鱼                         │
├─────────────────────────────────────┤
│  📸 精彩瞬间                        │
│  [图片1] [图片2] [图片3]            │
├─────────────────────────────────────┤
│  📅 相关活动                        │
│  ┌─────────────────────────────────┐│
│  │ 西双版纳泼水节庆典              ││
│  │ 4月13日-15日 | 告庄西双景      ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

### 7.3 交互设计
- **手势操作**：左右滑动切换月份，上下滑动查看节日列表
- **动画效果**：节日图标微动画，页面切换过渡动画
- **反馈机制**：操作反馈、加载状态、空状态提示
- **无障碍设计**：支持大字体、高对比度模式

---

## 8. 数据采集方案

### 8.1 数据来源
| 数据类型 | 来源 | 更新频率 |
|---------|------|---------|
| 法定假日 | 国务院公告 | 每年更新 |
| 传统节日 | 文化部资料、地方志 | 季度更新 |
| 民族节日 | 民族事务委员会、地方统计 | 半年更新 |
| 节气数据 | 天文台数据 | 固定不变 |
| 活动信息 | 地方政府、旅游部门 | 实时更新 |
| 地区数据 | 国家统计局 | 年度更新 |

### 8.2 数据采集流程
1. **官方渠道**：政府部门、官方发布
2. **合作渠道**：地方文化馆、旅游局
3. **网络采集**：公开信息、新闻报道
4. **用户贡献**：UGC内容审核
5. **人工整理**：专业团队编辑

### 8.3 数据质量保障
- 多源数据交叉验证
- 专家审核机制
- 用户反馈纠错
- 定期数据巡检

---

## 9. 运营和推广策略

### 9.1 初期运营
- **内容填充**：优先覆盖5个少数民族聚居省份
- **种子用户**：邀请民族文化爱好者内测
- **社区建设**：建立用户交流群
- **内容更新**：每周更新节日和活动内容

### 9.2 推广渠道
- **应用商店优化**：ASO优化，关键词覆盖
- **社交媒体**：微信公众号、微博、抖音
- **内容营销**：节日文化文章、短视频
- **合作推广**：与旅游平台、文化机构合作

### 9.3 用户增长
- **口碑传播**：优质内容驱动分享
- **节日营销**：在重要节日进行推广
- **功能驱动**：独特功能吸引用户
- **地域拓展**：逐步覆盖更多地区

---

## 10. 风险评估和应对

### 10.1 技术风险
| 风险 | 影响 | 应对措施 |
|-----|------|---------|
| 数据准确性 | 高 | 多源验证、专家审核、用户反馈 |
| 性能问题 | 中 | 缓存策略、CDN加速、代码优化 |
| 兼容性问题 | 中 | 充分测试、渐进式发布 |
| 安全问题 | 高 | 安全审计、数据加密、权限控制 |

### 10.2 运营风险
| 风险 | 影响 | 应对措施 |
|-----|------|---------|
| 内容不足 | 高 | 优先核心内容、UGC激励 |
| 用户增长慢 | 中 | 多渠道推广、功能迭代 |
| 竞品出现 | 中 | 持续创新、深耕垂直领域 |
| 政策变化 | 低 | 关注政策、及时调整 |

### 10.3 法律风险
- **版权问题**：确保内容授权合规
- **隐私保护**：遵守个人信息保护法
- **数据安全**：符合网络安全要求

---

## 11. 附录

### 11.1 术语表
| 术语 | 说明 |
|-----|------|
| 农历 | 中国传统历法，又称阴历 |
| 节气 | 中国传统节气，共24个 |
| 法定假日 | 国家规定的放假节日 |
| 民族节日 | 各少数民族传统节日 |
| 调休 | 将工作日调整为休息日 |

### 11.2 参考资料
- 国务院办公厅关于节假日安排的通知
- 中国少数民族节日大全
- 各省旅游局官方资料
- 国家统计局行政区划数据

### 11.3 版本历史
| 版本 | 日期 | 说明 |
|-----|------|------|
| v1.0 | 2024-01-01 | 初稿完成 |

---

**文档维护人**：产品团队
**最后更新**：2024年1月
**文档状态**：初稿
