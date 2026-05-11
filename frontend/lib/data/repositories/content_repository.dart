import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../models/content.dart';

class ContentRepository {
	final _dio = DioClient.instance.dio;

	// 获取内容列表
	Future<List<Content>> getContents({
		int? regionId,
		int? type,
		int page = 1,
		int size = 20,
	}) async {
		final response = await _dio.get(
			'/v1/content/list',
			queryParameters: {
				if (regionId != null) 'regionId': regionId,
				if (type != null) 'type': type,
				'page': page,
				'pageSize': size,
			},
		);
		final data = response.data['data'];
		if (data != null && data['records'] != null) {
			return (data['records'] as List).map((e) => Content.fromJson(e)).toList();
		}
		return [];
	}

	// 获取每日推荐内容
	Future<Content?> getDailyContent() async {
		final response = await _dio.get('/v1/content/daily');
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => json != null ? Content.fromJson(json as Map<String, dynamic>) : null,
		);
		return apiResponse.data;
	}

	// 获取内容详情
	Future<Content?> getContentDetail(int id) async {
		final response = await _dio.get('/v1/content/$id');
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => Content.fromJson(json as Map<String, dynamic>),
		);
		return apiResponse.data;
	}
}
