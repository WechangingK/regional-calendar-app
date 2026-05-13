import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/storage/local_storage.dart';
import '../models/user.dart';

class UserRepository {
	final _dio = DioClient.instance.dio;

	Future<bool> register({
		required String username,
		required String password,
		String? nickname,
		String? phone,
		String? email,
		int? regionId,
		int? gender,
	}) async {
		final response = await _dio.post(
			'/v1/user/register',
			data: {
				'username': username,
				'password': password,
				if (nickname != null && nickname.isNotEmpty) 'nickname': nickname,
				if (phone != null && phone.isNotEmpty) 'phone': phone,
				if (email != null && email.isNotEmpty) 'email': email,
				if (regionId != null) 'regionId': regionId,
				if (gender != null) 'gender': gender,
			},
		);
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => json,
		);
		return apiResponse.isSuccess;
	}

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

	Future<User?> getProfile() async {
		final response = await _dio.get('/v1/user/profile');
		final apiResponse = ApiResponse.fromJson(
			response.data,
			(json) => User.fromJson(json as Map<String, dynamic>),
		);
		return apiResponse.data;
	}

	Future<void> logout() async {
		await LocalStorage.clearAll();
	}
}
