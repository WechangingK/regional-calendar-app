import 'package:json_annotation/json_annotation.dart';

part 'region.g.dart';

@JsonSerializable()
class Region {
	final int id;
	final int? parentId;
	final String name;
	final String? nameLocal;
	final int level;
	final String code;
	final double? latitude;
	final double? longitude;
	final String? description;
	final String? imageUrl;
	final int status;

	Region({
		required this.id,
		this.parentId,
		required this.name,
		this.nameLocal,
		required this.level,
		required this.code,
		this.latitude,
		this.longitude,
		this.description,
		this.imageUrl,
		this.status = 1,
	});

	factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
	Map<String, dynamic> toJson() => _$RegionToJson(this);
}
