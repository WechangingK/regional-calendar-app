import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/storage/local_storage.dart';
import '../models/user.dart';

class UserRepository {
	final _dio = DioClient.instance.dio;

	// 注册
	Future<bool> register({
		required String username,
		required String password,
		String? nickname,
		String? phone,
	}) async {
		final response = await _dio.post(
			'/v1/user/register',
			data: {
				'username': username,
				'password': password,
				if (nickname != null) 'nickname': nickname,
				if (phone != null) 'phone': phone,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => json,
		);
		return apiResponse.isSuccess;
	}

	// 登录
	Future<User?> login({
		required String username,
		required String password,
	}) async {
		final response = await _dio.post(
			'/v1/user/login',
			data: {
				'username': username,
				'password': password,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => json as Map<String, dynamic>,
		);
		if (apiResponse.isSuccess && apiResponse.data != null) {
			final data = apiResponse.data!;
			if (data['token'] != null) {
				await LocalStorage.saveToken(data['token']);
			}
			if (data['user'] != null) {
				final user = User.fromJson(data['user']);
				await LocalStorage.saveUserId(user.id);
				return user;
			}
		}
		return null;
	}

	// 获取用户信息
	Future<User?> getProfile() async {
		final response = await _dio.get('/v1/user/profile');
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => User.fromJson(json as Map<String, dynamic>),
		);
		return apiResponse.data;
	}

	// 退出登录
	Future<void> logout() async {
		await LocalStorage.clearAll();
	}
}
