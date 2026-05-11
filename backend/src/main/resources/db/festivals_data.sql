-- ========================================
-- 补充完整的节日数据
-- ========================================

USE `regional_calendar`;

-- ----------------------------------------
-- 1. 补充更多民族节日（类型3）
-- ----------------------------------------

-- 苗族节日
INSERT INTO `festival` (`name`, `name_local`, `type`, `region_id`, `ethnicity_id`, `start_date`, `duration`, `is_lunar`, `lunar_month`, `lunar_day`, `is_holiday`, `description`, `customs`, `food`, `status`) VALUES
('苗年', 'Nongx Yangx', 3, NULL, 5, '11-01', 15, 1, 10, 1, 0, '苗族最隆重的传统节日，相当于汉族的春节', '跳芦笙、斗牛、赛马、对歌', '酸汤鱼、腊肉、糯米酒', 1),
('姊妹节', 'Qix Nix Qix', 3, NULL, 5, '03-15', 3, 1, 3, 15, 0, '苗族情人节，青年男女社交的节日', '游方、对歌、吃姊妹饭、跳芦笙', '五彩姊妹饭', 1),
('芦笙节', NULL, 3, NULL, 5, '01-16', 5, 1, 1, 16, 0, '苗族传统节日，以芦笙演奏为主', '跳芦笙、斗牛、赛马', '酸汤鱼', 1),
('龙船节', NULL, 3, NULL, 5, '05-24', 3, 1, 5, 24, 0, '苗族端午节，赛龙舟', '赛龙舟、对歌、游方', '粽子', 1),
('吃新节', NULL, 3, NULL, 5, '06-06', 3, 1, 6, 6, 0, '苗族庆祝丰收的节日', '祭祀祖先、品尝新米', '新米饭、酸汤鱼', 1),
('赶秋节', NULL, 3, NULL, 5, '08-07', 3, 0, NULL, NULL, 0, '苗族传统节日，庆祝丰收', '荡秋千、对歌、跳舞、斗牛', '糯米酒', 1),

-- 傣族节日
('泼水节', 'Songkran', 3, NULL, 19, '04-13', 3, 0, NULL, NULL, 0, '傣族新年，也是傣族最隆重的传统节日', '浴佛、泼水狂欢、赛龙舟、放孔明灯', '菠萝紫米饭、香竹饭', 1),
('关门节', 'Khao Phansa', 3, NULL, 19, '07-15', 1, 1, 7, 15, 0, '傣族佛教节日，开始安居', '诵经、赕佛', '素食', 1),
('开门节', 'Ok Phansa', 3, NULL, 19, '10-15', 1, 1, 10, 15, 0, '傣族佛教节日，结束安居', '诵经、赕佛、放烟花', '丰盛食物', 1),

-- 彝族节日
('火把节', NULL, 3, NULL, 8, '06-24', 3, 1, 6, 24, 0, '彝族最盛大的传统节日，被称为"东方的狂欢节"', '点燃火把、歌舞狂欢、斗牛、摔跤', '坨坨肉、荞麦粑粑', 1),
('彝族年', NULL, 3, NULL, 8, '11-20', 3, 1, 11, 20, 0, '彝族传统新年', '祭祀祖先、跳锅庄、斗牛', '坨坨肉、泡水酒', 1),
('赛装节', NULL, 3, NULL, 8, '01-15', 3, 1, 1, 15, 0, '彝族传统选美节日', '选美、跳舞、对歌', '彝族美食', 1),

-- 蒙古族节日
('那达慕', 'Naadam', 3, NULL, 9, '07-11', 7, 1, 6, 4, 0, '蒙古族最盛大的传统节日，意为"游戏"或"娱乐"', '赛马、摔跤、射箭、歌舞', '手把肉、奶茶、奶酪', 1),
('白节', 'Tsagaan Sar', 3, NULL, 9, '01-01', 15, 1, 1, 1, 0, '蒙古族春节，白色新年', '拜年、献哈达、吃手把肉', '手把肉、奶制品', 1),
('马奶节', NULL, 3, NULL, 9, '07-01', 3, 1, 7, 1, 0, '蒙古族传统节日，庆祝马奶丰收', '赛马、喝马奶酒', '马奶酒、奶制品', 1),

-- 藏族节日
('雪顿节', 'Shoton', 3, NULL, 10, '07-01', 7, 1, 7, 1, 0, '藏族传统节日，意为"酸奶宴"', '晒大佛、藏戏表演、赛马', '酸奶、青稞酒、酥油茶', 1),
('藏历新年', 'Losar', 3, NULL, 10, '01-01', 15, 1, 1, 1, 0, '藏族传统新年', '跳锅庄、献哈达、吃古突', '古突、青稞酒', 1),
('望果节', NULL, 3, NULL, 10, '08-01', 3, 1, 8, 1, 0, '藏族庆祝丰收的节日', '转田、唱歌、跳舞', '青稞酒、酥油茶', 1),
('萨嘎达瓦节', NULL, 3, NULL, 10, '04-15', 7, 1, 4, 15, 0, '藏族佛教节日，纪念释迦牟尼', '转经、放生、布施', '素食', 1),

-- 壮族节日
('三月三', 'Sam Nyied Sam', 3, NULL, 2, '03-03', 3, 1, 3, 3, 0, '壮族最隆重的传统节日，也是广西法定假日', '对歌、抛绣球、抢花炮、碰彩蛋', '五色糯米饭', 1),
('牛魂节', NULL, 3, NULL, 2, '04-08', 1, 1, 4, 8, 0, '壮族传统节日，感谢耕牛', '给牛洗澡、喂五色糯米饭', '五色糯米饭', 1),
('中元节', NULL, 3, NULL, 2, '07-14', 3, 1, 7, 14, 0, '壮族祭祖节日', '祭祖、烧纸钱', '鸭肉、糯米饭', 1),

-- 维吾尔族节日
('古尔邦节', 'Eid al-Adha', 3, NULL, 6, '12-10', 3, 1, 12, 10, 0, '伊斯兰教重要节日', '宰牲、礼拜、走亲访友', '手抓羊肉、油香、馓子', 1),
('开斋节', 'Eid al-Fitr', 3, NULL, 6, '10-01', 3, 1, 10, 1, 0, '伊斯兰教重要节日，斋月结束后的庆祝', '礼拜、走亲访友、施舍', '油香、馓子、糕点', 1),
('诺鲁孜节', 'Nowruz', 3, NULL, 6, '03-21', 15, 0, NULL, NULL, 0, '维吾尔族传统新年', '跳火、唱歌、跳舞', '诺鲁孜饭', 1),

-- 回族节日
('开斋节', 'Eid al-Fitr', 3, NULL, 4, '10-01', 3, 1, 10, 1, 0, '伊斯兰教重要节日', '礼拜、走亲访友、施舍', '油香、馓子', 1),
('古尔邦节', 'Eid al-Adha', 3, NULL, 4, '12-10', 3, 1, 12, 10, 0, '伊斯兰教重要节日', '宰牲、礼拜、走亲访友', '手抓羊肉', 1),
('圣纪节', NULL, 3, NULL, 4, '03-12', 1, 1, 3, 12, 0, '纪念穆罕默德诞辰', '诵经、赞圣、会餐', '油香、馓子', 1),

-- 满族节日
('颁金节', NULL, 3, NULL, 3, '10-13', 1, 0, NULL, NULL, 0, '满族命名日', '祭祀、跳萨满舞', '满族美食', 1),

-- 瑶族节日
('盘王节', NULL, 3, NULL, 13, '10-16', 3, 1, 10, 16, 0, '瑶族最隆重的传统节日', '祭祀盘王、跳长鼓舞', '糍粑、米酒', 1),
('达努节', NULL, 3, NULL, 13, '05-29', 3, 1, 5, 29, 0, '瑶族传统节日，庆祝丰收', '跳铜鼓舞、对歌', '五色糯米饭', 1),

-- 侗族节日
('侗年', NULL, 3, NULL, 12, '11-01', 3, 1, 11, 1, 0, '侗族传统新年', '跳芦笙、斗牛、唱侗歌', '侗族酸肉、糯米饭', 1),
('花炮节', NULL, 3, NULL, 12, '03-03', 3, 1, 3, 3, 0, '侗族传统节日', '抢花炮、斗牛、唱侗歌', '糯米饭', 1),

-- 白族节日
('三月街', NULL, 3, NULL, 15, '03-15', 7, 1, 3, 15, 0, '白族最盛大的传统节日', '赛马、对歌、跳舞', '白族美食', 1),
('火把节', NULL, 3, NULL, 15, '06-25', 3, 1, 6, 25, 0, '白族传统节日', '点火把、跳舞', '白族美食', 1),
('绕三灵', NULL, 3, NULL, 15, '04-23', 3, 1, 4, 23, 0, '白族传统朝拜节日', '朝拜、唱歌、跳舞', '白族美食', 1),

-- 哈尼族节日
('长街宴', NULL, 3, NULL, 16, '10-01', 3, 1, 10, 1, 0, '哈尼族最隆重的传统节日', '摆长街宴、跳乐作舞', '长街宴美食', 1),
('苦扎扎节', NULL, 3, NULL, 16, '06-24', 3, 1, 6, 24, 0, '哈尼族传统节日', '打磨秋、跳舞', '哈尼族美食', 1),

-- 哈萨克族节日
('纳吾鲁孜节', 'Nauryz', 3, NULL, 17, '03-22', 15, 0, NULL, NULL, 0, '哈萨克族传统新年', '赛马、摔跤、唱歌', '纳吾鲁孜饭', 1),

-- 黎族节日
('三月三', NULL, 3, NULL, 18, '03-03', 3, 1, 3, 3, 0, '黎族最隆重的传统节日', '对歌、跳竹竿舞、打柴舞', '竹筒饭、山兰酒', 1),
('军坡节', NULL, 3, NULL, 18, '02-09', 3, 1, 2, 9, 0, '黎族传统节日', '祭祀、跳打柴舞', '黎族美食', 1),

-- 畲族节日
('三月三', NULL, 3, NULL, 20, '03-03', 3, 1, 3, 3, 0, '畲族传统节日', '对歌、跳竹竿舞', '乌饭', 1),

-- 布依族节日
('三月三', NULL, 3, NULL, 11, '03-03', 3, 1, 3, 3, 0, '布依族传统节日', '对歌、跳舞', '五色糯米饭', 1),
('六月六', NULL, 3, NULL, 11, '06-06', 3, 1, 6, 6, 0, '布依族传统节日', '祭祀、对歌', '布依族美食', 1),

-- 朝鲜族节日
('流头节', NULL, 3, NULL, 14, '06-15', 1, 1, 6, 15, 0, '朝鲜族传统节日', '洗头、跳舞', '冷面、打糕', 1);

-- ----------------------------------------
-- 2. 补充民族节日放假安排（地方假日）
-- ----------------------------------------

-- 广西三月三放假（壮族）
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '三月三', 7, '2026-03-22', '2026-03-24', 3, '广西壮族自治区法定假日', 1, 1
FROM festival WHERE name = '三月三' AND ethnicity_id = 2;

-- 云南泼水节放假（傣族）
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '泼水节', 4, '2026-04-13', '2026-04-15', 3, '云南省西双版纳傣族自治州法定假日', 1, 1
FROM festival WHERE name = '泼水节' AND ethnicity_id = 19;

-- 贵州苗年放假（苗族）
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '苗年', 5, '2026-11-20', '2026-11-22', 3, '贵州省黔东南苗族侗族自治州法定假日', 1, 1
FROM festival WHERE name = '苗年' AND ethnicity_id = 5;

-- 内蒙古那达慕放假（蒙古族）
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '那达慕', 10, '2026-07-11', '2026-07-13', 3, '内蒙古自治区法定假日', 1, 1
FROM festival WHERE name = '那达慕' AND ethnicity_id = 9;

-- 西藏雪顿节放假（藏族）
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '雪顿节', 8, '2026-08-23', '2026-08-25', 3, '西藏自治区法定假日', 1, 1
FROM festival WHERE name = '雪顿节' AND ethnicity_id = 10;

-- 新疆古尔邦节放假（维吾尔族）
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '古尔邦节', 9, '2026-06-17', '2026-06-19', 3, '新疆维吾尔自治区法定假日', 1, 1
FROM festival WHERE name = '古尔邦节' AND ethnicity_id = 6;

-- 新疆开斋节放假（维吾尔族）
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '开斋节', 9, '2026-04-21', '2026-04-23', 3, '新疆维吾尔自治区法定假日', 1, 1
FROM festival WHERE name = '开斋节' AND ethnicity_id = 6;

-- 回族开斋节放假
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '开斋节', 9, '2026-04-21', '2026-04-23', 3, '宁夏回族自治区法定假日', 1, 1
FROM festival WHERE name = '开斋节' AND ethnicity_id = 4;

-- 回族古尔邦节放假
INSERT INTO `holiday_schedule` (`year`, `festival_id`, `festival_name`, `region_id`, `start_date`, `end_date`, `total_days`, `work_days_desc`, `is_official`, `status`)
SELECT 2026, id, '古尔邦节', 9, '2026-06-17', '2026-06-19', 3, '宁夏回族自治区法定假日', 1, 1
FROM festival WHERE name = '古尔邦节' AND ethnicity_id = 4;

-- ----------------------------------------
-- 3. 更新节日日期（2026年）
-- ----------------------------------------

-- 更新农历节日的公历日期（2026年）
UPDATE festival SET start_date = '2026-03-22' WHERE name = '三月三' AND type = 3;
UPDATE festival SET start_date = '2026-04-13' WHERE name = '泼水节' AND type = 3;
UPDATE festival SET start_date = '2026-07-24' WHERE name = '火把节' AND type = 3;
UPDATE festival SET start_date = '2026-07-11' WHERE name = '那达慕' AND type = 3;
UPDATE festival SET start_date = '2026-08-23' WHERE name = '雪顿节' AND type = 3;
UPDATE festival SET start_date = '2026-11-20' WHERE name = '苗年' AND type = 3;
UPDATE festival SET start_date = '2026-04-21' WHERE name = '开斋节' AND type = 3;
UPDATE festival SET start_date = '2026-06-17' WHERE name = '古尔邦节' AND type = 3;
UPDATE festival SET start_date = '2026-03-21' WHERE name = '诺鲁孜节' AND type = 3;
UPDATE festival SET start_date = '2026-03-22' WHERE name = '纳吾鲁孜节' AND type = 3;
