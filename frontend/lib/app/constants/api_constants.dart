class ApiConstants {
	static const String baseUrl = 'http://10.0.2.2:8080/api';
	static const String version = '/v1';
	static const String apiPrefix = '$baseUrl$version';

	// 超时时间
	static const int connectTimeout = 15000;
	static const int receiveTimeout = 15000;

	// 地区
	static const String region = '$apiPrefix/region';
	static const String regionChildren = '$apiPrefix/region/children';
	static const String regionSearch = '$apiPrefix/region/search';

	// 民族
	static const String ethnicity = '$apiPrefix/ethnicity';

	// 节日
	static const String festival = '$apiPrefix/festival';
	static const String festivalUpcoming = '$apiPrefix/festival/upcoming';
	static const String festivalHot = '$apiPrefix/festival/hot';
	static const String festivalRecommend = '$apiPrefix/festival/recommend';

	// 活动
	static const String activity = '$apiPrefix/activity';
	static const String activityUpcoming = '$apiPrefix/activity/upcoming';

	// 放假安排
	static const String holiday = '$apiPrefix/holiday';

	// 用户
	static const String userRegister = '$apiPrefix/user/register';
	static const String userLogin = '$apiPrefix/user/login';
	static const String userProfile = '$apiPrefix/user/profile';

	// 收藏
	static const String favorite = '$apiPrefix/favorite';
	static const String favoriteToggle = '$apiPrefix/favorite/toggle';

	// 日程
	static const String schedule = '$apiPrefix/schedule';

	// 内容
	static const String content = '$apiPrefix/content';
	static const String contentDaily = '$apiPrefix/content/daily';

	// 配置
	static const String config = '$apiPrefix/config';
}
