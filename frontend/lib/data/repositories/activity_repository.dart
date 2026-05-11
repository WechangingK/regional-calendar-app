import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../models/activity.dart';

class ActivityRepository {
	final _dio = DioClient.instance.dio;

	// 获取活动列表
	Future<List<Activity>> getActivities({
		int? regionId,
		int? festivalId,
		int page = 1,
		int size = 20,
	}) async {
		final response = await _dio.get(
			'/v1/activity',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				if (festivalId != null) 'festivalId': festivalId,
				'page': page,
				'size': size,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Activity.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取即将到来的活动
	Future<List<Activity>> getUpcomingActivities({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/activity/upcoming',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				'size': size,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Activity.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取热门活动
	Future<List<Activity>> getHotActivities({int size = 10}) async {
		final response = await _dio.get(
			'/v1/activity/hot',
			queryParameters: {'size': size},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Activity.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取推荐活动
	Future<List<Activity>> getRecommendActivities({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/activity/recommend',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				'size': size,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Activity.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取活动详情
	Future<Activity?> getActivityDetail(int id) async {
		final response = await _dio.get('/v1/activity/$id');
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => Activity.fromJson(json as Map<String, dynamic>),
		);
		return apiResponse.data;
	}

	// 按节日获取活动
	Future<List<Activity>> getActivitiesByFestival(int festivalId) async {
		final response = await _dio.get(
			'/v1/activity/by-festival',
			queryParameters: {'festivalId': festivalId},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Activity.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}
}
