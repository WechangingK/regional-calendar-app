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

## 第四阶段：前端开发 ⏳ 待开始

### 4.1 基础框架
- [ ] **Flutter 项目初始化**
- [ ] 配置路由
- [ ] 配置状态管理
- [ ] 封装请求工具

### 4.2 页面开发
- [ ] 首页
- [ ] 节日模块
- [ ] 活动模块
- [ ] 地区模块
- [ ] 用户模块
- [ ] 内容模块

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

**总进度**: 55% (后端核心开发完成)

**当前阶段**: 第三阶段 ✅ 已完成 → 第四阶段 待开始

**下一步**: Flutter 前端项目初始化

---

## 项目统计
- **后端 Java 文件**: 73个
- **数据库表**: 12张
- **API 接口**: 43个
- **测试状态**: Maven 编译通过，JWT 认证功能测试通过

---

**文档版本**: v2.0
**更新时间**: 2026-05-08
**维护人**: 开发团队
