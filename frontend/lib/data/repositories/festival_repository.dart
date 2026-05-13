import '../../core/network/dio_client.dart';
import '../models/festival.dart';

class FestivalRepository {
	final _dio = DioClient.instance.dio;

	// 获取节日列表（分页）
	Future<List<Festival>> getFestivals({
		int? regionId,
		int? type,
		int page = 1,
		int size = 20,
	}) async {
		final response = await _dio.get(
			'/v1/festival/list',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				if (type != null) 'type': type,
				'page': page,
				'pageSize': size,
			},
		);
		return _parsePageList(response.data);
	}

	// 获取即将到来的节日
	Future<List<Festival>> getUpcomingFestivals({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/festival/upcoming',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				'limit': size,
			},
		);
		return _parseDataList(response.data);
	}

	// 获取热门节日
	Future<List<Festival>> getHotFestivals({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/festival/hot',
			queryParameters: {
				'limit': size,
				if (regionId != null) 'regionId': regionId,
			},
		);
		return _parseDataList(response.data);
	}

	// 获取推荐节日
	Future<List<Festival>> getRecommendFestivals({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/festival/recommended',
			queryParameters: {
				'limit': size,
				if (regionId != null) 'regionId': regionId,
			},
		);
		return _parseDataList(response.data);
	}

	// 按月查询节日（日历视图）
	Future<List<Festival>> getFestivalsByMonth({
		required int year,
		required int month,
		int? regionId,
	}) async {
		final response = await _dio.get(
			'/v1/festival/calendar',
			queryParameters: {
				'year': year,
				'month': month,
				if (regionId != null) 'regionId': regionId,
			},
		);
		return _parseDataList(response.data);
	}

	// 获取节日详情
	Future<Festival?> getFestivalDetail(int id) async {
		final response = await _dio.get('/v1/festival/$id');
		final data = response.data;
		if (data['code'] == 200 && data['data'] != null) {
			return Festival.fromJson(data['data']);
		}
		return null;
	}

	// 搜索节日
	Future<List<Festival>> searchFestivals(String keyword) async {
		final response = await _dio.get(
			'/v1/festival/search',
			queryParameters: {'keyword': keyword},
		);
		return _parseDataList(response.data);
	}

	// 解析分页列表数据（IPage格式）
	List<Festival> _parsePageList(dynamic data) {
		if (data['code'] == 200 && data['data'] != null) {
			final pageData = data['data'];
			if (pageData['records'] != null) {
				return (pageData['records'] as List)
					.map((e) => Festival.fromJson(e))
					.toList();
			}
		}
		return [];
	}

	// 解析直接列表数据
	List<Festival> _parseDataList(dynamic data) {
		if (data['code'] == 200 && data['data'] != null) {
			final list = data['data'];
			if (list is List) {
				return list.map((e) => Festival.fromJson(e)).toList();
			}
		}
		return [];
	}
}
