import 'package:json_annotation/json_annotation.dart';

part 'festival.g.dart';

@JsonSerializable()
class Festival {
	final int id;
	final String name;
	final String? nameLocal;
	final String? nameEnglish;
	final int type;
	final int? regionId;
	final int? ethnicityId;
	final String? startDate;
	final String? endDate;
	final int duration;
	final int isLunar;
	final int isHoliday;
	final int? holidayDays;
	final String? description;
	final String? history;
	final String? customs;
	final String? food;
	final String? clothing;
	final String? activities;
	final String? imageUrl;
	final String? videoUrl;
	final int status;

	Festival({
		required this.id,
		required this.name,
		this.nameLocal,
		this.nameEnglish,
		required this.type,
		this.regionId,
		this.ethnicityId,
		this.startDate,
		this.endDate,
		this.duration = 1,
		this.isLunar = 0,
		this.isHoliday = 0,
		this.holidayDays,
		this.description,
		this.history,
		this.customs,
		this.food,
		this.clothing,
		this.activities,
		this.imageUrl,
		this.videoUrl,
		this.status = 1,
	});

	factory Festival.fromJson(Map<String, dynamic> json) => _$FestivalFromJson(json);
	Map<String, dynamic> toJson() => _$FestivalToJson(this);

	String get typeText {
		switch (type) {
			case 1: return '法定假日';
			case 2: return '传统节日';
			case 3: return '民族节日';
			case 4: return '节气';
			case 5: return '纪念日';
			default: return '其他';
		}
	}
}
