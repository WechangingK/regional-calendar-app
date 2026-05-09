import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../models/region.dart';

class RegionRepository {
	final _dio = DioClient.instance.dio;

	// 获取省份列表
	Future<List<Region>> getProvinces() async {
		final response = await _dio.get(
			'/v1/region/provinces',
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Region.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取子地区
	Future<List<Region>> getChildren(int parentId) async {
		final response = await _dio.get(
			'/v1/region/children',
			queryParameters: {'parentId': parentId},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Region.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 搜索地区
	Future<List<Region>> searchRegions(String keyword) async {
		final response = await _dio.get(
			'/v1/region/search',
			queryParameters: {'keyword': keyword},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Region.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取热门地区
	Future<List<Region>> getHotRegions({int size = 10}) async {
		final response = await _dio.get(
			'/v1/region/hot',
			queryParameters: {'size': size},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => (json as List).map((e) => Region.fromJson(e)).toList(),
		);
		return apiResponse.data ?? [];
	}

	// 获取地区详情
	Future<Region?> getRegionDetail(int id) async {
		final response = await _dio.get('/v1/region/$id');
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => Region.fromJson(json as Map<String, dynamic>),
		);
		return apiResponse.data;
	}
}
