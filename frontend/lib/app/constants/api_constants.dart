import 'package:flutter/foundation.dart';

class ApiConstants {
	// API主机: Web用localhost, Android模拟器用10.0.2.2, 真机改此处为电脑IP
	static const String _webHost = 'localhost';
	static const String _androidHost = '10.0.2.2';

	static String get host {
		if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
			return _androidHost;
		}
		return _webHost;
	}

	static String get baseUrl => 'http://$host:8080/api';
	static const String version = '/v1';
	static String get apiPrefix => '$baseUrl$version';

	static const int connectTimeout = 30000;
	static const int receiveTimeout = 30000;

	static String get region => '$apiPrefix/region';
	static String get regionChildren => '$apiPrefix/region/children';
	static String get regionSearch => '$apiPrefix/region/search';
	static String get ethnicity => '$apiPrefix/ethnicity';
	static String get festival => '$apiPrefix/festival';
	static String get festivalUpcoming => '$apiPrefix/festival/upcoming';
	static String get festivalHot => '$apiPrefix/festival/hot';
	static String get festivalRecommend => '$apiPrefix/festival/recommended';
	static String get activity => '$apiPrefix/activity';
	static String get activityUpcoming => '$apiPrefix/activity/upcoming';
	static String get holiday => '$apiPrefix/holiday';
	static String get userRegister => '$apiPrefix/user/register';
	static String get userLogin => '$apiPrefix/user/login';
	static String get userProfile => '$apiPrefix/user/profile';
	static String get favorite => '$apiPrefix/favorite';
	static String get favoriteToggle => '$apiPrefix/favorite/toggle';
	static String get schedule => '$apiPrefix/schedule';
	static String get content => '$apiPrefix/content';
	static String get contentDaily => '$apiPrefix/content/daily';
	static String get config => '$apiPrefix/config';
}
