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
- [x] **测试数据补充** — 8个活动、7篇内容、6条放假安排
- [x] **地区数据批量导入** — 全球250个国家 + 中国34省 + 306城市 = 590个地区
  - RegionImportService — 地区数据导入服务
  - REST Countries API — 全球国家数据
  - 本地 china_regions.json — 中国省市区数据
- [x] **Wikidata 数据同步** — 从 Wikidata 获取少数民族节日数据
  - WikidataService — SPARQL 查询服务
  - FestivalSyncService — 定时同步任务（每月1号凌晨2点）
  - DataSyncController — 手动触发同步接口
- [x] **数据源策略** — 法定假日用 timor.tech API，民族节日用 Wikidata

---

## 第五阶段：测试与优化 🔄 进行中 (2026-05-11)

### 5.1 联调测试 ✅ 已完成
- [x] **前后端联调** — 后端API + Flutter Web联调
- [x] **Bug修复（第一轮）** — 修复联调发现的三个问题
  - 数据获取：修复分页响应解析（IPage格式）
  - 登录注册：分离界面，完善功能
  - 我的页面：所有菜单项添加功能实现

### 5.2 Bug修复（第二轮） ✅ 已完成 (2026-05-11)
- [x] **Bug 1: 注册功能增强**
  - 后端：创建 RegisterRequest DTO，注册支持 username/password/nickname/phone/email/gender/regionId
  - 后端：登录接口返回 token + 用户信息（user字段）
  - 前端：注册页添加邮箱、性别选择字段
  - 前端：User 模型扩展（gender、regionName、birthday、bio、vipLevel、points）
- [x] **Bug 2: 区域切换过滤**
  - 后端：热门/推荐节日和活动接口添加 regionId 过滤参数
  - 前端：hot/recommended Provider 传递当前地区 ID
  - 前端：添加 HolidayRepository + holidayProvider，首页展示放假安排
- [x] **Bug 3: 日历显示节日活动**
  - 后端：添加 /v1/festival/calendar、/v1/activity/calendar、/v1/holiday/calendar 按月查询接口
  - 前端：CalendarPage 使用 eventLoader 在日历上标记节日/活动/放假
  - 前端：HomePage 日历也显示标记点
  - 前端：点击日期显示当天实际节日、活动列表（非占位文本）

### 5.3 Bug修复（第三轮） ✅ 已完成 (2026-05-11)
- [x] **Bug 1: 日历页 initState 报错**
  - 前端：initState 中 ref.invalidate 改为 addPostFrameCallback
- [x] **Bug 2: 登录无法使用**
  - 后端：创建 LoginRequest DTO，登录接口 @RequestBody 替代 @RequestParam
  - 前端：添加 catch 块显示登录失败提示
- [x] **Bug 3: 地区过滤真正生效**
  - 后端：查询改为 if(regionId!=null) 条件追加，消除 .and() 链式重复条件
  - 后端：修复 FestivalServiceImpl / ActivityServiceImpl / HolidayScheduleServiceImpl 查询逻辑
- [x] **Bug 4: 节日和放假地区数据错误**
  - 数据：fix_data.py 脚本 — 45条节日 region_id 基于 ethnicity.main_region_ids 映射
  - 数据：9条放假安排 region_id 从测试值(4/5/7/8/9/10)修正为实际地区ID
  - 数据：删除5条 regionId=0 的重复放假记录
- [x] **快捷启动脚本**
  - start.py — TCP socket 检测 MySQL/Redis，自动清理端口，新窗口启动前后端

### 5.4 明日待办 (2026-05-12)
- [ ] **Android 虚拟机测试** — 创建模拟器，修改 API 地址（localhost→10.0.2.2），真机测试
- [ ] **API 地址多环境配置** — 区分 localhost / 10.0.2.2 / 生产域名
- [ ] 单元测试
- [ ] 集成测试
- [ ] 性能优化

---

## 第六阶段：部署上线 ⏳ 待开始

- [ ] 服务器准备
- [ ] CI/CD 配置
- [ ] 上线发布

---

## 当前进度

**总进度**: 92% (后端完成 + 前端完成 + 数据修复 + 三轮Bug修复)

**当前阶段**: 第五阶段 🔄 进行中

**下一步**: Android 虚拟机测试、多环境配置、完善测试、部署上线

---

## 项目统计

| 类别 | 数量 | 说明 |
|------|------|------|
| 后端 Java 文件 | 81个 | +1 (LoginRequest DTO) |
| 前端 Dart 文件 | ~35个 | +2 (HolidayRepository, holidayProvider) |
| 数据库表 | 12张 | - |
| API 接口 | 52个 | +3 (日历月视图) |
| 已实现页面 | 11个 | 首页、日历、节日/活动/内容列表+详情、个人中心、登录、地区选择 |
| 地区数据 | 590条 | 250国家 + 34省 + 306城市 |
| 节日数据 | 59条 | 14条全局 + 45条地区 |
| 放假安排 | 14条 | 6条全国 + 8条地区 |

**测试状态**: Maven 编译通过，flutter analyze 零错误零警告，API 接口测试通过

---

## 数据源策略

| 数据类型 | 数据源 | 更新频率 |
|---------|--------|---------|
| 法定假日 | timor.tech API | 每年1月1日自动拉取 |
| 少数民族节日 | Wikidata SPARQL | 每月1号凌晨2点同步 |
| 地方活动 | 各地文旅局 | 人工录入 |
| 文化内容 | 人工编辑 + 爬虫 | 持续更新 |

---

**文档版本**: v5.2
**更新时间**: 2026-05-11 (晚间)
**维护人**: 开发团队
