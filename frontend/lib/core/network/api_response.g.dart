part of 'api_response.dart';

ApiResponse<T> _$ApiResponseFromJson<T>(
	Map<String, dynamic> json,
	T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
	code: (json['code'] as num).toInt(),
	message: json['message'] as String,
	data: _$nullableGenericFromJson(json['data'], fromJsonT),
	timestamp: (json['timestamp'] as num?)?.toInt(),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
	ApiResponse<T> instance,
	Object? Function(T value) toJsonT,
) => <String, dynamic>{
	'code': instance.code,
	'message': instance.message,
	'data': _$nullableGenericToJson(instance.data, toJsonT),
	'timestamp': instance.timestamp,
};

T? _$nullableGenericFromJson<T>(
	Object? input,
	T Function(Object? json) fromJsonT,
) => input == null ? null : fromJsonT(input);

Object? _$nullableGenericToJson<T>(
	T? input,
	Object? Function(T value) toJsonT,
) => input == null ? null : toJsonT(input);
