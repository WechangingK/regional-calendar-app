import '../../core/network/dio_client.dart';
import '../models/activity.dart';

class ActivityRepository {
	final _dio = DioClient.instance.dio;

	// 获取活动列表（分页）
	Future<List<Activity>> getActivities({
		int? regionId,
		int? type,
		int page = 1,
		int size = 20,
	}) async {
		final response = await _dio.get(
			'/v1/activity/list',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				if (type != null) 'type': type,
				'page': page,
				'pageSize': size,
			},
		);
		return _parsePageList(response.data);
	}

	// 获取即将到来的活动
	Future<List<Activity>> getUpcomingActivities({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/activity/upcoming',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				'limit': size,
			},
		);
		return _parseDataList(response.data);
	}

	// 获取热门活动
	Future<List<Activity>> getHotActivities({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/activity/hot',
			queryParameters: {
				'limit': size,
				if (regionId != null) 'regionId': regionId,
			},
		);
		return _parseDataList(response.data);
	}

	// 获取推荐活动
	Future<List<Activity>> getRecommendActivities({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/activity/recommended',
			queryParameters: {
				'limit': size,
				if (regionId != null) 'regionId': regionId,
			},
		);
		return _parseDataList(response.data);
	}

	// 按月查询活动（日历视图）
	Future<List<Activity>> getActivitiesByMonth({
		required int year,
		required int month,
		int? regionId,
	}) async {
		final response = await _dio.get(
			'/v1/activity/calendar',
			queryParameters: {
				'year': year,
				'month': month,
				if (regionId != null) 'regionId': regionId,
			},
		);
		return _parseDataList(response.data);
	}

	// 获取活动详情
	Future<Activity?> getActivityDetail(int id) async {
		final response = await _dio.get('/v1/activity/$id');
		final data = response.data;
		if (data['code'] == 200 && data['data'] != null) {
			return Activity.fromJson(data['data']);
		}
		return null;
	}

	// 按节日获取活动
	Future<List<Activity>> getActivitiesByFestival(int festivalId) async {
		final response = await _dio.get('/v1/activity/festival/$festivalId');
		return _parseDataList(response.data);
	}

	// 解析分页列表数据
	List<Activity> _parsePageList(dynamic data) {
		if (data['code'] == 200 && data['data'] != null) {
			final pageData = data['data'];
			if (pageData['records'] != null) {
				return (pageData['records'] as List)
					.map((e) => Activity.fromJson(e))
					.toList();
			}
		}
		return [];
	}

	// 解析直接列表数据
	List<Activity> _parseDataList(dynamic data) {
		if (data['code'] == 200 && data['data'] != null) {
			final list = data['data'];
			if (list is List) {
				return list.map((e) => Activity.fromJson(e)).toList();
			}
		}
		return [];
	}
}
