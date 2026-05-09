import 'package:dio/dio.dart';
import '../../app/constants/api_constants.dart';
import '../storage/local_storage.dart';

class DioClient {
	static DioClient? _instance;
	late Dio _dio;

	DioClient._() {
		_dio = Dio(BaseOptions(
			baseUrl: ApiConstants.baseUrl,
			connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
			receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
			headers: {
				'Content-Type': 'application/json',
				'Accept': 'application/json',
			},
		));

		_dio.interceptors.addAll([
			AuthInterceptor(),
			LogInterceptor(
				requestBody: true,
				responseBody: true,
			),
		]);
	}

	static DioClient get instance {
		_instance ??= DioClient._();
		return _instance!;
	}

	Dio get dio => _dio;
}

class AuthInterceptor extends Interceptor {
	@override
	void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
		final token = await LocalStorage.getToken();
		if (token != null && token.isNotEmpty) {
			options.headers['Authorization'] = 'Bearer $token';
		}
		handler.next(options);
	}

	@override
	void onError(DioException err, ErrorInterceptorHandler handler) {
		if (err.response?.statusCode == 401) {
			// Token过期，清除本地token
			LocalStorage.removeToken();
		}
		handler.next(err);
	}
}
