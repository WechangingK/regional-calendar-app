import '../../core/network/dio_client.dart';
import '../models/content.dart';

class ContentRepository {
	final _dio = DioClient.instance.dio;

	// 获取内容列表（分页）
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
		return _parsePageList(response.data);
	}

	// 获取每日推荐内容
	Future<Content?> getDailyContent() async {
		final response = await _dio.get('/v1/content/daily');
		final data = response.data;
		if (data['code'] == 200 && data['data'] != null) {
			return Content.fromJson(data['data']);
		}
		return null;
	}

	// 获取内容详情
	Future<Content?> getContentDetail(int id) async {
		final response = await _dio.get('/v1/content/$id');
		final data = response.data;
		if (data['code'] == 200 && data['data'] != null) {
			return Content.fromJson(data['data']);
		}
		return null;
	}

	// 解析分页列表数据
	List<Content> _parsePageList(dynamic data) {
		if (data['code'] == 200 && data['data'] != null) {
			final pageData = data['data'];
			if (pageData['records'] != null) {
				return (pageData['records'] as List)
					.map((e) => Content.fromJson(e))
					.toList();
			}
		}
		return [];
	}
}
