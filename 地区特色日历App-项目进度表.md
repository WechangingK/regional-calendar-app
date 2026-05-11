# 地区特色日历App - 项目进度表

## 项目概述
- **项目名称**: 地区特色日历App
- **技术栈**: Java 21 + Spring Boot 3.2.5 + MyBatis-Plus 3.5.6 + MySQL + JWT + Flutter
- **GitHub仓库**: https://github.com/WechangingK/regional-calendar-app.git

---

## 第一阶段：需求与设计 ✅ 已完成

- [x] **产品需求文档 (PRD)**
  - 文件: 地区特色日历App-PRD.md

- [x] **数据库设计**
  - 文件: 地区特色日历App-数据库设计.md

- [x] **API接口文档**
  - 文件: 地区特色日历App-API接口文档.md

- [x] **开发计划**
  - 文件: 📅 地区特色日历App-开发计划.md

- [x] **GitHub仓库**
  - 仓库: regional-calendar-app

---

## 第二阶段：后端项目初始化 ✅ 已完成 (2026-05-07)

- [x] **Spring Boot 项目结构**
  - pom.xml 依赖配置完成
  - application.yml + application-dev.yml 配置完成

- [x] **数据库初始化**
  - 12张表: region, ethnicity, festival, festival_image, activity, holiday_schedule, user, user_favorite, user_schedule, content, user_view_log, sys_config
  - 初始数据: 20个民族、14个节日、16条系统配置

- [x] **通用模块 (common/)**
  - R.java — 统一响应封装
  - ResultCode.java — 响应状态码枚举
  - BusinessException.java — 业务异常
  - GlobalExceptionHandler.java — 全局异常处理

- [x] **配置类 (config/)**
  - MybatisPlusConfig — 分页插件 + 自动填充
  - RedisConfig — Redis 序列化配置
  - WebMvcConfig — CORS 跨域配置
  - SecurityConfig — Spring Security + BCryptPasswordEncoder
  - OpenApiConfig — Swagger/OpenAPI 配置

---

## 第三阶段：后端核心开发 ✅ 已完成 (2026-05-07 ~ 2026-05-08)

### 3.1 数据层
- [x] **Entity 层** — 12个实体类
- [x] **Mapper 层** — 12个接口

### 3.2 业务层 (Service)
- [x] **RegionService** — 按父级查询、省份列表、搜索、热门
- [x] **EthnicityService** — 全部启用、搜索
- [x] **FestivalService** — 分页、即将到来、热门、推荐、按地区、搜索
- [x] **FestivalImageService** — 按节日和类型查询
- [x] **ActivityService** — 分页、即将到来、热门、推荐、按节日
- [x] **HolidayScheduleService** — 按年份、按年份+地区
- [x] **UserService** — 注册、登录、按用户名/手机/邮箱查询
- [x] **UserFavoriteService** — 切换收藏、检查是否收藏、收藏列表
- [x] **UserScheduleService** — 按时间范围、当天日程、标记完成
- [x] **ContentService** — 分页、每日推送、增加浏览量
- [x] **UserViewLogService** — 记录浏览
- [x] **SysConfigService** — 按key获取配置值

### 3.3 接口层 (Controller)
- [x] **RegionController** — /v1/region (GET: list, detail, hot)
- [x] **EthnicityController** — /v1/ethnicity (GET: list, search)
- [x] **FestivalController** — /v1/festival (GET: list, detail, upcoming, hot, recommended, byRegion, search)
- [x] **FestivalImageController** — /v1/festival-image (GET: list)
- [x] **ActivityController** — /v1/activity (GET: list, detail, upcoming, hot, recommended, byFestival)
- [x] **HolidayScheduleController** — /v1/holiday (GET: byYear, byYearAndRegion)
- [x] **ContentController** — /v1/content (GET: list, daily)
- [x] **UserController** — /v1/user (POST: register, login; GET: info; PUT: info)
- [x] **UserFavoriteController** — /v1/favorite (POST: toggle; GET: check, list)
- [x] **UserScheduleController** — /v1/schedule (GET: list, today; POST: add; PUT: update, complete; DELETE: delete)
- [x] **SysConfigController** — /v1/config (GET: value)

### 3.4 JWT 认证体系 (2026-05-08)
- [x] **JwtUtil** — Token 生成/解析/验证，HMAC-SHA256 签名
- [x] **JwtAuthenticationFilter** — 拦截请求，验证 Token，设置 SecurityContext
- [x] **JwtAuthenticationEntryPoint** — 未认证返回 JSON 401 响应
- [x] **SecurityConfig** — JWT 过滤器注册 + 接口权限规则
- [x] **密码加密** — BCrypt 加密存储 + 校验

### 3.5 Swagger 配置 (2026-05-08)
- [x] **OpenApiConfig** — API 标题、描述、Bearer Token 认证方案
- [x] 访问地址: http://localhost:8080/api/swagger-ui.html

---

## 第四阶段：前端开发 + 数据建设 ✅ 已完成 (2026-05-09 ~ 2026-05-11)

### 4.1 基础框架 ✅ 已完成
- [x] **Flutter 项目初始化** — Flutter 3.41.9 + Android SDK 36.1.0
- [x] **核心依赖配置** — Riverpod、Dio、go_router、table_calendar等
- [x] **项目目录结构** — app/core/data/presentation/services
- [x] **配置路由** — go_router，底部导航 + 页面路由
- [x] **配置状态管理** — Riverpod，地区/节日/用户 Provider
- [x] **封装请求工具** — Dio + JWT拦截器 + ApiResponse封装
- [x] **本地存储封装** — SharedPreferences（Token/用户/地区）
- [x] **数据模型** — Region、Festival、Activity、User、HolidaySchedule
- [x] **Repository层** — FestivalRepository、RegionRepository、UserRepository
- [x] **主题配置** — 中国传统色彩（中国红/青瓷绿/琉璃金）

### 4.2 页面开发 ✅ 已完成
- [x] **首页** — 日历组件 + 近期节日 + 近期活动 + 每日文化 + 快捷入口
- [x] **日历页** — 月/周视图切换 + 日期详情
- [x] **节日列表页** — 即将到来/热门/推荐三个Tab
- [x] **节日详情页** — SliverAppBar + 介绍/习俗/美食/服饰/活动
- [x] **活动列表页** — 即将开始/热门/推荐三个Tab + 活动卡片
- [x] **活动详情页** — SliverAppBar + 时间地点 + 介绍 + 联系方式 + 门票
- [x] **内容列表页** — 每日推荐 + 分类导航 + 内容列表
- [x] **内容详情页** — SliverAppBar + 元信息 + 摘要 + 正文
- [x] **个人中心页** — 用户信息 + 地区选择 + 功能菜单
- [x] **登录/注册页** — 登录注册切换
- [x] **地区选择页** — 省份列表 + 搜索

### 4.3 数据层扩展 ✅ 已完成
- [x] **Content模型** — 内容数据模型 + JSON序列化
- [x] **ActivityRepository** — 活动API封装（列表/详情/热门/推荐）
- [x] **ContentRepository** — 内容API封装（列表/详情/每日推荐）
- [x] **ActivityProvider** — 活动状态管理
- [x] **ContentProvider** — 内容状态管理

### 4.4 数据建设 ✅ 已完成 (2026-05-11)
- [x] **测试数据补充** — 15个省份、8个活动、7篇内容、6条放假安排
- [x] **Wikidata 数据同步** — 从 Wikidata 获取少数民族节日数据
  - WikidataService — SPARQL 查询服务
  - FestivalSyncService — 定时同步任务（每月1号凌晨2点）
  - DataSyncController — 手动触发同步接口
- [x] **数据源分析** — 法定假日用 timor.tech API，民族节日用 Wikidata

---

## 第五阶段：测试与优化 ⏳ 待开始

- [ ] 单元测试
- [ ] 接口测试
- [ ] Bug修复与性能优化

---

## 第六阶段：部署上线 ⏳ 待开始

- [ ] 服务器准备
- [ ] CI/CD 配置
- [ ] 上线发布

---

## 当前进度

**总进度**: 85% (后端完成 + 前端页面完成 + 数据建设完成)

**当前阶段**: 第四阶段 ✅ 已完成 → 第五阶段 待开始

**下一步**: 前后端联调测试、第五阶段测试与优化

---

## 项目统计

| 类别 | 数量 | 说明 |
|------|------|------|
| 后端 Java 文件 | 76个 | +3 (Wikidata同步相关) |
| 前端 Dart 文件 | ~30个 | 11个页面 |
| 数据库表 | 12张 | - |
| API 接口 | 45个 | +2 (数据同步接口) |
| 已实现页面 | 11个 | 首页、日历、节日/活动/内容列表+详情、个人中心、登录、地区选择 |
| 测试数据 | 36条 | 15地区 + 8活动 + 7内容 + 6放假安排 |

**测试状态**: Maven 编译通过，JWT 认证功能测试通过，flutter analyze 通过

---

## 数据源策略

| 数据类型 | 数据源 | 更新频率 |
|---------|--------|---------|
| 法定假日 | timor.tech API | 每年1月1日自动拉取 |
| 少数民族节日 | Wikidata SPARQL | 每月1号凌晨2点同步 |
| 地方活动 | 各地文旅局 | 人工录入 |
| 文化内容 | 人工编辑 + 爬虫 | 持续更新 |

---

**文档版本**: v5.0
**更新时间**: 2026-05-11
**维护人**: 开发团队
