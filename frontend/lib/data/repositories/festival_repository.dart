import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../models/festival.dart';

class FestivalRepository {
	final _dio = DioClient.instance.dio;

	// 获取节日列表
	Future<List<Festival>> getFestivals({
		int? regionId,
		int? type,
		int page = 1,
		int size = 20,
	}) async {
		final response = await _dio.get(
			'/v1/festival',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				if (type != null) 'type': type,
				'page': page,
				'size': size,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Festival.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取即将到来的节日
	Future<List<Festival>> getUpcomingFestivals({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/festival/upcoming',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				'size': size,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Festival.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取热门节日
	Future<List<Festival>> getHotFestivals({int size = 10}) async {
		final response = await _dio.get(
			'/v1/festival/hot',
			queryParameters: {'size': size},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Festival.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取推荐节日
	Future<List<Festival>> getRecommendFestivals({int? regionId, int size = 10}) async {
		final response = await _dio.get(
			'/v1/festival/recommend',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				'size': size,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Festival.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取节日详情
	Future<Festival?> getFestivalDetail(int id) async {
		final response = await _dio.get('/v1/festival/$id');
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => Festival.fromJson(json as Map<String, dynamic>),
		);
		return apiResponse.data;
	}

	// 搜索节日
	Future<List<Festival>> searchFestivals(String keyword, {int? regionId}) async {
		final response = await _dio.get(
			'/v1/festival/search',
			queryParameters: {
				'keyword': keyword,
				if (regionId != null) 'regionId': regionId,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Festival.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}
}
