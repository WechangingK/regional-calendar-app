part of 'holiday_schedule.dart';

HolidaySchedule _$HolidayScheduleFromJson(Map<String, dynamic> json) =>
	HolidaySchedule(
		id: (json['id'] as num).toInt(),
		year: (json['year'] as num).toInt(),
		festivalId: (json['festivalId'] as num).toInt(),
		regionId: (json['regionId'] as num?)?.toInt(),
		startDate: json['startDate'] as String,
		endDate: json['endDate'] as String,
		totalDays: (json['totalDays'] as num).toInt(),
		workDays: json['workDays'] as String?,
		description: json['description'] as String?,
		status: (json['status'] as num?)?.toInt() ?? 1,
	);

Map<String, dynamic> _$HolidayScheduleToJson(HolidaySchedule instance) =>
	<String, dynamic>{
		'id': instance.id,
		'year': instance.year,
		'festivalId': instance.festivalId,
		'regionId': instance.regionId,
		'startDate': instance.startDate,
		'endDate': instance.endDate,
		'totalDays': instance.totalDays,
		'workDays': instance.workDays,
		'description': instance.description,
		'status': instance.status,
	};
