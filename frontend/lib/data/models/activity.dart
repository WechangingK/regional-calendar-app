import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity {
	final int id;
	final int? festivalId;
	final int regionId;
	final String name;
	final String? nameLocal;
	final int type;
	final String? startTime;
	final String? endTime;
	final String? location;
	final String? address;
	final double? latitude;
	final double? longitude;
	final String? description;
	final String? content;
	final String? organizer;
	final String? contact;
	final String? ticketInfo;
	final String? imageUrl;
	final int status;

	Activity({
		required this.id,
		this.festivalId,
		required this.regionId,
		required this.name,
		this.nameLocal,
		this.type = 1,
		this.startTime,
		this.endTime,
		this.location,
		this.address,
		this.latitude,
		this.longitude,
		this.description,
		this.content,
		this.organizer,
		this.contact,
		this.ticketInfo,
		this.imageUrl,
		this.status = 1,
	});

	factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
	Map<String, dynamic> toJson() => _$ActivityToJson(this);

	String get typeText {
		switch (type) {
			case 1: return '庆典';
			case 2: return '祭祀';
			case 3: return '比赛';
			case 4: return '表演';
			case 5: return '展览';
			default: return '其他';
		}
	}
}
