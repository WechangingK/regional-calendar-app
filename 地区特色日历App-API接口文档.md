# 地区特色日历App - API接口文档

## 基础信息

- **基础路径**: `/api/v1`
- **数据格式**: JSON
- **字符编码**: UTF-8
- **认证方式**: Bearer Token（JWT）

### 通用响应格式

```json
{
    "code": 200,
    "message": "success",
    "data": {},
    "timestamp": 1704067200000
}
```

### 通用错误码

| 错误码 | 说明 |
|-------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权/未登录 |
| 403 | 无权限 |
| 404 | 资源不存在 |
| 500 | 服务器内部错误 |
| 1001 | 用户名已存在 |
| 1002 | 手机号已注册 |
| 1003 | 邮箱已注册 |
| 1004 | 用户名或密码错误 |
| 1005 | 账号已被禁用 |

### 通用分页参数

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| page | int | 否 | 页码，默认1 |
| pageSize | int | 否 | 每页数量，默认20，最大100 |

### 通用分页响应

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [],
        "total": 100,
        "page": 1,
        "pageSize": 20,
        "totalPages": 5
    }
}
```

---

## 1. 地区模块 (Region)

### 1.1 获取地区列表

**请求方式**: `GET`

**请求路径**: `/region/list`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| parentId | long | 否 | 父级地区ID，不传返回顶级地区 |
| level | int | 否 | 地区级别：1省 2市 3区 |
| keyword | string | 否 | 搜索关键词（支持拼音） |

**响应示例**:

```json
{
    "code": 200,
    "data": [
        {
            "id": 1,
            "parentId": 0,
            "name": "北京市",
            "nameLocal": null,
            "level": 1,
            "code": "110000",
            "latitude": 39.9042,
            "longitude": 116.4074,
            "imageUrl": "/images/regions/beijing.jpg",
            "tags": "直辖市,政治中心",
            "status": 1
        }
    ]
}
```

### 1.2 获取地区详情

**请求方式**: `GET`

**请求路径**: `/region/{id}`

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 1,
        "parentId": 0,
        "name": "北京市",
        "nameLocal": null,
        "namePinyin": "beijing",
        "level": 1,
        "code": "110000",
        "zipCode": "100000",
        "areaCode": "010",
        "latitude": 39.9042,
        "longitude": 116.4074,
        "areaSize": 16410.54,
        "population": 21893095,
        "description": "中华人民共和国首都...",
        "imageUrl": "/images/regions/beijing.jpg",
        "gallery": ["/images/regions/beijing/1.jpg"],
        "tags": "直辖市,政治中心",
        "status": 1,
        "createTime": "2024-01-01 00:00:00",
        "updateTime": "2024-01-01 00:00:00"
    }
}
```

### 1.3 获取热门地区

**请求方式**: `GET`

**请求路径**: `/region/hot`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| limit | int | 否 | 返回数量，默认10 |

---

## 2. 民族模块 (Ethnicity)

### 2.1 获取民族列表

**请求方式**: `GET`

**请求路径**: `/ethnicity/list`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| keyword | string | 否 | 搜索关键词 |

**响应示例**:

```json
{
    "code": 200,
    "data": [
        {
            "id": 1,
            "name": "汉族",
            "nameLocal": "汉族",
            "code": "01",
            "population": 1286310000,
            "mainRegionIds": null,
            "language": "汉语",
            "description": "中国的主体民族...",
            "imageUrl": "/images/ethnicity/han.jpg",
            "status": 1
        }
    ]
}
```

### 2.2 获取民族详情

**请求方式**: `GET`

**请求路径**: `/ethnicity/{id}`

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 1,
        "name": "汉族",
        "nameLocal": "汉族",
        "nameEnglish": "Han",
        "code": "01",
        "population": 1286310000,
        "mainRegionIds": null,
        "languageFamily": "汉藏语系",
        "language": "汉语",
        "script": "汉字",
        "religion": "佛教、道教、儒教等",
        "description": "中国的主体民族...",
        "history": "汉族的历史...",
        "culture": "汉族文化...",
        "customs": "汉族风俗...",
        "clothingDesc": "汉服介绍...",
        "foodDesc": "汉族饮食...",
        "imageUrl": "/images/ethnicity/han.jpg",
        "flagImage": "/images/ethnicity/han_flag.jpg",
        "gallery": ["/images/ethnicity/han/1.jpg"],
        "videoUrl": "/videos/ethnicity/han.mp4",
        "tags": "主体民族",
        "status": 1
    }
}
```

---

## 3. 节日模块 (Festival)

### 3.1 获取节日列表

**请求方式**: `GET`

**请求路径**: `/festival/list`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| type | int | 否 | 节日类型：1法定假日 2传统节日 3民族节日 4节气 5纪念日 6地方节日 |
| regionId | long | 否 | 地区ID |
| ethnicityId | long | 否 | 民族ID |
| isLunar | int | 否 | 是否农历：0否 1是 |
| isHoliday | int | 否 | 是否法定假日：0否 1是 |
| keyword | string | 否 | 搜索关键词 |
| startDate | string | 否 | 开始日期（MM-DD） |
| endDate | string | 否 | 结束日期（MM-DD） |
| sortBy | string | 否 | 排序字段：start_date/hot/recommended |
| page | int | 否 | 页码 |
| pageSize | int | 否 | 每页数量 |

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "list": [
            {
                "id": 1,
                "name": "春节",
                "nameLocal": null,
                "type": 1,
                "regionId": null,
                "regionName": null,
                "ethnicityId": null,
                "ethnicityName": null,
                "startDate": "01-01",
                "endDate": "01-07",
                "duration": 7,
                "isLunar": 1,
                "isHoliday": 1,
                "holidayDays": 7,
                "description": "中国最重要的传统节日...",
                "imageUrl": "/images/festivals/chunjie.jpg",
                "color": "#FF0000",
                "tags": "传统节日,法定假日",
                "viewCount": 10000,
                "favoriteCount": 5000,
                "isHot": 1,
                "isRecommended": 1,
                "status": 1
            }
        ],
        "total": 50,
        "page": 1,
        "pageSize": 20
    }
}
```

### 3.2 获取节日详情

**请求方式**: `GET`

**请求路径**: `/festival/{id}`

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 2,
        "name": "春节",
        "nameLocal": null,
        "nameEnglish": "Spring Festival",
        "type": 1,
        "subType": "春节类",
        "regionId": null,
        "regionName": null,
        "ethnicityId": null,
        "ethnicityName": null,
        "startDate": "01-01",
        "endDate": "01-07",
        "duration": 7,
        "isLunar": 1,
        "lunarMonth": 1,
        "lunarDay": 1,
        "isHoliday": 1,
        "holidayDays": 7,
        "description": "中国最重要的传统节日...",
        "origin": "春节起源于...",
        "history": "春节的历史...",
        "customs": "贴春联、放鞭炮、拜年...",
        "taboos": "不宜扫地、不宜打碎碗...",
        "food": "饺子、年糕、汤圆、鱼",
        "foodImages": ["/images/festivals/spring/food/1.jpg"],
        "clothing": "新衣服、唐装...",
        "clothingImages": ["/images/festivals/spring/clothing/1.jpg"],
        "activities": "庙会、灯会...",
        "symbols": "团圆、喜庆、祥和",
        "poems": "爆竹声中一岁除...",
        "songs": "恭喜恭喜...",
        "imageUrl": "/images/festivals/chunjie.jpg",
        "iconUrl": "/images/festivals/chunjie_icon.png",
        "bannerUrl": "/images/festivals/chunjie_banner.jpg",
        "videoUrl": "/videos/festivals/chunjie.mp4",
        "gallery": ["/images/festivals/chunjie/1.jpg"],
        "color": "#FF0000",
        "tags": "传统节日,法定假日",
        "viewCount": 10000,
        "favoriteCount": 5000,
        "shareCount": 2000,
        "isHot": 1,
        "isRecommended": 1,
        "status": 1
    }
}
```

### 3.3 获取节日日历

**请求方式**: `GET`

**请求路径**: `/festival/calendar`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| year | int | 是 | 年份 |
| month | int | 是 | 月份（1-12） |
| regionId | long | 否 | 地区ID，不传返回全国节日 |

**响应示例**:

```json
{
    "code": 200,
    "data": [
        {
            "date": "2024-01-01",
            "festivals": [
                {
                    "id": 1,
                    "name": "元旦",
                    "type": 1,
                    "color": "#FF4444",
                    "iconUrl": "/images/festivals/yuandan_icon.png",
                    "isHoliday": 1
                }
            ]
        }
    ]
}
```

### 3.4 获取即将到来的节日

**请求方式**: `GET`

**请求路径**: `/festival/upcoming`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| regionId | long | 否 | 地区ID |
| limit | int | 否 | 返回数量，默认5 |

**响应示例**:

```json
{
    "code": 200,
    "data": [
        {
            "id": 5,
            "name": "端午节",
            "type": 1,
            "startDate": "05-05",
            "duration": 3,
            "isHoliday": 1,
            "imageUrl": "/images/festivals/duanwu.jpg",
            "color": "#006400",
            "daysLeft": 15
        }
    ]
}
```

### 3.5 获取热门节日

**请求方式**: `GET`

**请求路径**: `/festival/hot`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| limit | int | 否 | 返回数量，默认10 |

---

## 4. 活动模块 (Activity)

### 4.1 获取活动列表

**请求方式**: `GET`

**请求路径**: `/activity/list`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| regionId | long | 否 | 地区ID |
| festivalId | long | 否 | 节日ID |
| type | int | 否 | 活动类型：1庆典 2祭祀 3比赛 4表演 5展览 6庙会 7游行 8其他 |
| status | int | 否 | 状态：1待开始 2进行中 3已结束 |
| startDate | string | 否 | 开始日期（yyyy-MM-dd） |
| endDate | string | 否 | 结束日期（yyyy-MM-dd） |
| keyword | string | 否 | 搜索关键词 |
| sortBy | string | 否 | 排序：start_time/hot/rating |
| page | int | 否 | 页码 |
| pageSize | int | 否 | 每页数量 |

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "list": [
            {
                "id": 1,
                "name": "2024年春节庙会",
                "festivalId": 2,
                "regionId": 1,
                "regionName": "北京市",
                "type": 6,
                "startTime": "2024-02-10 09:00:00",
                "endTime": "2024-02-17 21:00:00",
                "durationDays": 7,
                "location": "地坛公园",
                "address": "北京市东城区安定门外大街",
                "latitude": 39.9484,
                "longitude": 116.4187,
                "description": "一年一度的春节庙会...",
                "ticketPrice": 10.00,
                "capacity": 50000,
                "registeredCount": 30000,
                "imageUrl": "/images/activities/miaohui.jpg",
                "tags": "庙会,春节",
                "viewCount": 5000,
                "favoriteCount": 2000,
                "rating": 4.5,
                "isHot": 1,
                "status": 2
            }
        ],
        "total": 100,
        "page": 1,
        "pageSize": 20
    }
}
```

### 4.2 获取活动详情

**请求方式**: `GET`

**请求路径**: `/activity/{id}`

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 1,
        "festivalId": 2,
        "regionId": 1,
        "regionName": "北京市",
        "name": "2024年春节庙会",
        "nameLocal": null,
        "type": 6,
        "startTime": "2024-02-10 09:00:00",
        "endTime": "2024-02-17 21:00:00",
        "durationDays": 7,
        "location": "地坛公园",
        "address": "北京市东城区安定门外大街",
        "latitude": 39.9484,
        "longitude": 116.4187,
        "transportation": "地铁2号线安定门站...",
        "parkingInfo": "地坛公园停车场...",
        "description": "一年一度的春节庙会...",
        "content": "<p>详细介绍...</p>",
        "highlights": "传统表演、特色小吃...",
        "schedule": [
            {"time": "09:00", "event": "开门迎客"},
            {"time": "10:00", "event": "舞龙表演"}
        ],
        "organizer": "北京市文化和旅游局",
        "contactPhone": "010-12345678",
        "website": "https://example.com",
        "ticketInfo": "门票10元，学生半价",
        "ticketPrice": 10.00,
        "capacity": 50000,
        "registeredCount": 30000,
        "weatherNote": "注意保暖",
        "dressCode": "建议穿着舒适",
        "tips": "建议早到，避开高峰...",
        "imageUrl": "/images/activities/miaohui.jpg",
        "bannerUrl": "/images/activities/miaohui_banner.jpg",
        "videoUrl": "/videos/activities/miaohui.mp4",
        "gallery": ["/images/activities/miaohui/1.jpg"],
        "tags": "庙会,春节",
        "viewCount": 5000,
        "favoriteCount": 2000,
        "shareCount": 1000,
        "rating": 4.5,
        "ratingCount": 200,
        "isHot": 1,
        "status": 2
    }
}
```

### 4.3 获取即将到来的活动

**请求方式**: `GET`

**请求路径**: `/activity/upcoming`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| regionId | long | 否 | 地区ID |
| limit | int | 否 | 返回数量，默认5 |

### 4.4 获取热门活动

**请求方式**: `GET`

**请求路径**: `/activity/hot`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| limit | int | 否 | 返回数量，默认10 |

---

## 5. 放假安排模块 (HolidaySchedule)

### 5.1 获取放假安排列表

**请求方式**: `GET`

**请求路径**: `/holiday/list`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| year | int | 是 | 年份 |
| regionId | long | 否 | 地区ID，不传返回全国安排 |

**响应示例**:

```json
{
    "code": 200,
    "data": [
        {
            "id": 1,
            "year": 2024,
            "festivalId": 2,
            "festivalName": "春节",
            "regionId": null,
            "regionName": null,
            "startDate": "2024-02-10",
            "endDate": "2024-02-17",
            "totalDays": 7,
            "workDays": ["2024-02-04", "2024-02-18"],
            "workDaysDesc": "2月4日（星期日）、2月18日（星期日）上班",
            "isOfficial": 1,
            "announcement": "国务院办公厅关于2024年春节放假安排的通知",
            "source": "国务院办公厅",
            "status": 1
        }
    ]
}
```

### 5.2 获取放假安排详情

**请求方式**: `GET`

**请求路径**: `/holiday/{id}`

---

## 6. 用户模块 (User)

### 6.1 用户注册

**请求方式**: `POST`

**请求路径**: `/user/register`

**请求参数**:

```json
{
    "username": "zhangsan",
    "password": "123456",
    "nickname": "张三",
    "phone": "13800138000",
    "email": "zhangsan@example.com",
    "smsCode": "123456"
}
```

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| username | string | 是 | 用户名（5-50位，字母数字下划线） |
| password | string | 是 | 密码（6-50位） |
| nickname | string | 否 | 昵称 |
| phone | string | 否 | 手机号 |
| email | string | 否 | 邮箱 |
| smsCode | string | 条件 | 手机注册时必填 |

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 1,
        "username": "zhangsan",
        "nickname": "张三",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "tokenExpire": 1704153600000
    }
}
```

### 6.2 用户登录

**请求方式**: `POST`

**请求路径**: `/user/login`

**请求参数**:

```json
{
    "username": "zhangsan",
    "password": "123456",
    "deviceId": "device_123"
}
```

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| username | string | 是 | 用户名/手机号/邮箱 |
| password | string | 是 | 密码 |
| deviceId | string | 否 | 设备ID（用于推送） |

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 1,
        "username": "zhangsan",
        "nickname": "张三",
        "avatar": "/images/avatars/1.jpg",
        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        "tokenExpire": 1704153600000,
        "vipLevel": 0,
        "regionId": 1,
        "regionName": "北京市"
    }
}
```

### 6.3 第三方登录

**请求方式**: `POST`

**请求路径**: `/user/login/{type}`

**路径参数**:

| 参数 | 类型 | 说明 |
|-----|------|------|
| type | string | 登录类型：wechat/qq/apple |

**请求参数**:

```json
{
    "code": "authorization_code",
    "deviceId": "device_123"
}
```

### 6.4 发送短信验证码

**请求方式**: `POST`

**请求路径**: `/user/sms/send`

**请求参数**:

```json
{
    "phone": "13800138000",
    "type": "register"
}
```

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| phone | string | 是 | 手机号 |
| type | string | 是 | 类型：register/login/reset |

### 6.5 获取用户信息

**请求方式**: `GET`

**请求路径**: `/user/info`

**请求头**: `Authorization: Bearer {token}`

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 1,
        "username": "zhangsan",
        "nickname": "张三",
        "avatar": "/images/avatars/1.jpg",
        "phone": "138****8000",
        "phoneVerified": 1,
        "email": "zhang***@example.com",
        "emailVerified": 1,
        "gender": 1,
        "birthday": "1990-01-01",
        "regionId": 1,
        "regionName": "北京市",
        "ethnicityId": 1,
        "ethnicityName": "汉族",
        "bio": "热爱传统文化",
        "vipLevel": 0,
        "vipExpireTime": null,
        "points": 100,
        "status": 1,
        "createTime": "2024-01-01 00:00:00"
    }
}
```

### 6.6 更新用户信息

**请求方式**: `PUT`

**请求路径**: `/user/info`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

```json
{
    "nickname": "新昵称",
    "avatar": "/images/avatars/new.jpg",
    "gender": 1,
    "birthday": "1990-01-01",
    "regionId": 1,
    "ethnicityId": 1,
    "bio": "新的个人简介"
}
```

### 6.7 修改密码

**请求方式**: `PUT`

**请求路径**: `/user/password`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

```json
{
    "oldPassword": "123456",
    "newPassword": "654321"
}
```

### 6.8 重置密码

**请求方式**: `POST`

**请求路径**: `/user/password/reset`

**请求参数**:

```json
{
    "phone": "13800138000",
    "smsCode": "123456",
    "newPassword": "654321"
}
```

### 6.9 退出登录

**请求方式**: `POST`

**请求路径**: `/user/logout`

**请求头**: `Authorization: Bearer {token}`

---

## 7. 用户收藏模块 (UserFavorite)

### 7.1 添加收藏

**请求方式**: `POST`

**请求路径**: `/favorite/add`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

```json
{
    "targetType": 2,
    "targetId": 1
}
```

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| targetType | int | 是 | 收藏类型：1地区 2节日 3活动 4内容 |
| targetId | long | 是 | 目标ID |

### 7.2 取消收藏

**请求方式**: `DELETE`

**请求路径**: `/favorite/remove`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| targetType | int | 是 | 收藏类型 |
| targetId | long | 是 | 目标ID |

### 7.3 检查是否已收藏

**请求方式**: `GET`

**请求路径**: `/favorite/check`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| targetType | int | 是 | 收藏类型 |
| targetId | long | 是 | 目标ID |

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "isFavorite": true
    }
}
```

### 7.4 获取收藏列表

**请求方式**: `GET`

**请求路径**: `/favorite/list`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| targetType | int | 否 | 收藏类型，不传返回全部 |
| page | int | 否 | 页码 |
| pageSize | int | 否 | 每页数量 |

---

## 8. 用户日程模块 (UserSchedule)

### 8.1 创建日程

**请求方式**: `POST`

**请求路径**: `/schedule/add`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

```json
{
    "title": "春节家庭聚餐",
    "content": "去爷爷奶奶家吃年夜饭",
    "startTime": "2024-02-10 18:00:00",
    "endTime": "2024-02-10 21:00:00",
    "isAllDay": 0,
    "isLunar": 0,
    "repeatType": 0,
    "remindType": 5,
    "location": "爷爷奶奶家",
    "color": "#FF0000",
    "priority": 1,
    "tags": "家庭,聚餐"
}
```

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| title | string | 是 | 日程标题 |
| content | string | 否 | 日程内容 |
| startTime | string | 是 | 开始时间 |
| endTime | string | 否 | 结束时间 |
| isAllDay | int | 否 | 是否全天：0否 1是，默认0 |
| isLunar | int | 否 | 是否农历：0否 1是，默认0 |
| repeatType | int | 否 | 重复类型：0不重复 1每天 2每周 3每月 4每年，默认0 |
| repeatEndDate | string | 否 | 重复结束日期 |
| remindType | int | 否 | 提醒类型，见数据字典，默认1 |
| location | string | 否 | 地点 |
| color | string | 否 | 颜色标记，默认#1890FF |
| priority | int | 否 | 优先级：0普通 1重要 2紧急，默认0 |
| tags | string | 否 | 标签，逗号分隔 |

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 1,
        "title": "春节家庭聚餐",
        "startTime": "2024-02-10 18:00:00",
        "endTime": "2024-02-10 21:00:00",
        "remindTime": "2024-02-10 17:30:00",
        "status": 1,
        "createTime": "2024-01-01 00:00:00"
    }
}
```

### 8.2 更新日程

**请求方式**: `PUT`

**请求路径**: `/schedule/{id}`

**请求头**: `Authorization: Bearer {token}`

**请求参数**: 同创建日程

### 8.3 删除日程

**请求方式**: `DELETE`

**请求路径**: `/schedule/{id}`

**请求头**: `Authorization: Bearer {token}`

### 8.4 获取日程列表

**请求方式**: `GET`

**请求路径**: `/schedule/list`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| startDate | string | 是 | 开始日期（yyyy-MM-dd） |
| endDate | string | 是 | 结束日期（yyyy-MM-dd） |
| priority | int | 否 | 优先级筛选 |
| isCompleted | int | 否 | 是否已完成：0否 1是 |
| keyword | string | 否 | 搜索关键词 |
| page | int | 否 | 页码 |
| pageSize | int | 否 | 每页数量 |

### 8.5 获取日程详情

**请求方式**: `GET`

**请求路径**: `/schedule/{id}`

**请求头**: `Authorization: Bearer {token}`

### 8.6 标记日程完成

**请求方式**: `PUT`

**请求路径**: `/schedule/{id}/complete`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

```json
{
    "isCompleted": 1
}
```

---

## 9. 内容模块 (Content)

### 9.1 获取内容列表

**请求方式**: `GET`

**请求路径**: `/content/list`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| type | int | 否 | 类型：1文化知识 2节日介绍 3活动报道 4攻略 5故事 6诗词 |
| regionId | long | 否 | 地区ID |
| festivalId | long | 否 | 节日ID |
| ethnicityId | long | 否 | 民族ID |
| keyword | string | 否 | 搜索关键词 |
| isRecommended | int | 否 | 是否推荐 |
| sortBy | string | 否 | 排序：publish_time/view_count/like_count |
| page | int | 否 | 页码 |
| pageSize | int | 否 | 每页数量 |

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "list": [
            {
                "id": 1,
                "title": "春节的由来",
                "subTitle": "了解中国传统新年的历史",
                "type": 2,
                "summary": "春节是中国最隆重的传统节日...",
                "author": "文化小助手",
                "authorAvatar": "/images/authors/1.jpg",
                "coverImage": "/images/content/spring.jpg",
                "wordCount": 2000,
                "readTime": 5,
                "tags": "春节,传统文化",
                "viewCount": 10000,
                "likeCount": 5000,
                "favoriteCount": 2000,
                "commentCount": 100,
                "isTop": 0,
                "isRecommended": 1,
                "publishTime": "2024-01-01 10:00:00"
            }
        ],
        "total": 200,
        "page": 1,
        "pageSize": 20
    }
}
```

### 9.2 获取内容详情

**请求方式**: `GET`

**请求路径**: `/content/{id}`

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 1,
        "title": "春节的由来",
        "subTitle": "了解中国传统新年的历史",
        "type": 2,
        "regionId": null,
        "festivalId": 2,
        "ethnicityId": null,
        "summary": "春节是中国最隆重的传统节日...",
        "content": "<p>春节的详细内容...</p>",
        "author": "文化小助手",
        "authorAvatar": "/images/authors/1.jpg",
        "source": "国家博物馆",
        "coverImage": "/images/content/spring.jpg",
        "gallery": ["/images/content/spring/1.jpg"],
        "videoUrl": "/videos/content/spring.mp4",
        "audioUrl": "/audios/content/spring.mp3",
        "wordCount": 2000,
        "readTime": 5,
        "tags": "春节,传统文化",
        "viewCount": 10001,
        "likeCount": 5000,
        "favoriteCount": 2000,
        "shareCount": 1000,
        "commentCount": 100,
        "isDailyPush": 0,
        "isTop": 0,
        "isRecommended": 1,
        "status": 1,
        "publishTime": "2024-01-01 10:00:00"
    }
}
```

### 9.3 获取每日推送内容

**请求方式**: `GET`

**请求路径**: `/content/daily`

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "id": 100,
        "title": "今日端午：粽子的故事",
        "summary": "端午节为什么要吃粽子？",
        "coverImage": "/images/content/daily/duanwu.jpg",
        "readTime": 3,
        "publishTime": "2024-06-10 08:00:00"
    }
}
```

### 9.4 点赞内容

**请求方式**: `POST`

**请求路径**: `/content/{id}/like`

**请求头**: `Authorization: Bearer {token}`

---

## 10. 用户浏览记录模块 (UserViewLog)

### 10.1 记录浏览

**请求方式**: `POST`

**请求路径**: `/view-log/record`

**请求参数**:

```json
{
    "userId": 1,
    "deviceId": "device_123",
    "targetType": 1,
    "targetId": 1,
    "viewDuration": 120,
    "ip": "192.168.1.1",
    "userAgent": "Mozilla/5.0..."
}
```

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| userId | long | 否 | 用户ID（未登录可不传） |
| deviceId | string | 否 | 设备ID |
| targetType | int | 是 | 目标类型：1节日 2活动 3内容 |
| targetId | long | 是 | 目标ID |
| viewDuration | int | 否 | 浏览时长（秒） |

### 10.2 获取浏览历史

**请求方式**: `GET`

**请求路径**: `/view-log/list`

**请求头**: `Authorization: Bearer {token}`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| targetType | int | 否 | 目标类型筛选 |
| page | int | 否 | 页码 |
| pageSize | int | 否 | 每页数量 |

---

## 11. 系统配置模块 (SysConfig)

### 11.1 获取系统配置

**请求方式**: `GET`

**请求路径**: `/config/list`

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "appName": "节日历",
        "appVersion": "1.0.0",
        "appSlogan": "发现每个节日的故事",
        "enableThirdLogin": true,
        "enablePush": true,
        "privacyPolicyUrl": "https://example.com/privacy",
        "userAgreementUrl": "https://example.com/agreement"
    }
}
```

---

## 12. 文件上传模块

### 12.1 上传图片

**请求方式**: `POST`

**请求路径**: `/upload/image`

**请求头**: `Authorization: Bearer {token}`

**请求格式**: `multipart/form-data`

**请求参数**:

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| file | File | 是 | 图片文件（jpg/png/gif，最大10MB） |
| type | string | 否 | 用途：avatar/content/festival/activity |

**响应示例**:

```json
{
    "code": 200,
    "data": {
        "url": "/images/upload/2024/01/01/abc123.jpg",
        "width": 800,
        "height": 600,
        "size": 102400
    }
}
```

---

## 附录：数据字典

### 节日类型 (festival.type)

| 值 | 说明 |
|---|------|
| 1 | 法定假日 |
| 2 | 传统节日 |
| 3 | 民族节日 |
| 4 | 节气 |
| 5 | 纪念日 |
| 6 | 地方节日 |

### 活动类型 (activity.type)

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

### 活动状态 (activity.status)

| 值 | 说明 |
|---|------|
| 0 | 禁用 |
| 1 | 待开始 |
| 2 | 进行中 |
| 3 | 已结束 |
| 4 | 已取消 |

### 用户状态 (user.status)

| 值 | 说明 |
|---|------|
| 0 | 禁用 |
| 1 | 正常 |
| 2 | 待验证 |

### 提醒类型 (user_schedule.remind_type)

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

**文档版本**: v1.0
**最后更新**: 2024年1月
**维护人**: 开发团队
