part of 'region.dart';

Region _$RegionFromJson(Map<String, dynamic> json) => Region(
	id: (json['id'] as num).toInt(),
	parentId: (json['parentId'] as num?)?.toInt(),
	name: json['name'] as String,
	nameLocal: json['nameLocal'] as String?,
	level: (json['level'] as num).toInt(),
	code: json['code'] as String,
	latitude: (json['latitude'] as num?)?.toDouble(),
	longitude: (json['longitude'] as num?)?.toDouble(),
	description: json['description'] as String?,
	imageUrl: json['imageUrl'] as String?,
	status: (json['status'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
	'id': instance.id,
	'parentId': instance.parentId,
	'name': instance.name,
	'nameLocal': instance.nameLocal,
	'level': instance.level,
	'code': instance.code,
	'latitude': instance.latitude,
	'longitude': instance.longitude,
	'description': instance.description,
	'imageUrl': instance.imageUrl,
	'status': instance.status,
};
