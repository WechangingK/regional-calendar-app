import 'package:json_annotation/json_annotation.dart';

part 'holiday_schedule.g.dart';

@JsonSerializable()
class HolidaySchedule {
	final int id;
	final int year;
	final int? festivalId;
	final String? festivalName;
	final int? regionId;
	final String? regionName;
	final String startDate;
	final String endDate;
	final int totalDays;
	final String? workDays;
	final String? workDaysDesc;
	final String? description;
	final String? remark;
	final int status;

	HolidaySchedule({
		required this.id,
		required this.year,
		this.festivalId,
		this.festivalName,
		this.regionId,
		this.regionName,
		required this.startDate,
		required this.endDate,
		required this.totalDays,
		this.workDays,
		this.workDaysDesc,
		this.description,
		this.remark,
		this.status = 1,
	});

	factory HolidaySchedule.fromJson(Map<String, dynamic> json) =>
		_$HolidayScheduleFromJson(json);
	Map<String, dynamic> toJson() => _$HolidayScheduleToJson(this);
}
