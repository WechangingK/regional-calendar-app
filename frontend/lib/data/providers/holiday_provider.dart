import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/holiday_schedule.dart';
import '../repositories/holiday_repository.dart';
import 'region_provider.dart';

final holidayRepositoryProvider = Provider((ref) => HolidayRepository());

// 当年放假安排
final holidayScheduleProvider = FutureProvider<List<HolidaySchedule>>((ref) async {
	final repo = ref.read(holidayRepositoryProvider);
	final region = ref.watch(currentRegionProvider);
	return repo.getHolidays(regionId: region?.id);
});

// 日历月视图放假安排
final calendarHolidaysProvider = FutureProvider.family<List<HolidaySchedule>, ({int year, int month})>((ref, params) async {
	final repo = ref.read(holidayRepositoryProvider);
	final region = ref.watch(currentRegionProvider);
	return repo.getHolidaysByMonth(
		year: params.year,
		month: params.month,
		regionId: region?.id,
	);
});
