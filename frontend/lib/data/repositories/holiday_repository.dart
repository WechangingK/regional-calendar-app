import '../../core/network/dio_client.dart';
import '../models/holiday_schedule.dart';

class HolidayRepository {
	final _dio = DioClient.instance.dio;

	Future<List<HolidaySchedule>> getHolidays({int? year, int? regionId}) async {
		final response = await _dio.get(
			'/v1/holiday/list',
			queryParameters: {
				if (year != null) 'year': year,
				if (regionId != null) 'regionId': regionId,
			},
		);
		return _parseList(response.data);
	}

	Future<List<HolidaySchedule>> getHolidaysByMonth({
		required int year,
		required int month,
		int? regionId,
	}) async {
		final response = await _dio.get(
			'/v1/holiday/calendar',
			queryParameters: {
				'year': year,
				'month': month,
				if (regionId != null) 'regionId': regionId,
			},
		);
		return _parseList(response.data);
	}

	List<HolidaySchedule> _parseList(dynamic data) {
		if (data['code'] == 200 && data['data'] != null) {
			final list = data['data'];
			if (list is List) {
				return list.map((e) => HolidaySchedule.fromJson(e)).toList();
			}
		}
		return [];
	}
}
