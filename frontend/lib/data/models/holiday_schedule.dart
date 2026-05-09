import 'package:json_annotation/json_annotation.dart';

part 'holiday_schedule.g.dart';

@JsonSerializable()
class HolidaySchedule {
	final int id;
	final int year;
	final int festivalId;
	final int? regionId;
	final String startDate;
	final String endDate;
	final int totalDays;
	final String? workDays;
	final String? description;
	final int status;

	HolidaySchedule({
		required this.id,
		required this.year,
		required this.festivalId,
		this.regionId,
		required this.startDate,
		required this.endDate,
		required this.totalDays,
		this.workDays,
		this.description,
		this.status = 1,
	});

	factory HolidaySchedule.fromJson(Map<String, dynamic> json) =>
		_$HolidayScheduleFromJson(json);
	Map<String, dynamic> toJson() => _$HolidayScheduleToJson(this);
}
