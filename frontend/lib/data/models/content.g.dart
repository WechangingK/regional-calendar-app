part of 'content.dart';

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
	id: (json['id'] as num).toInt(),
	title: json['title'] as String,
	summary: json['summary'] as String?,
	content: json['content'] as String?,
	type: (json['type'] as num?)?.toInt() ?? 1,
	imageUrl: json['imageUrl'] as String?,
	regionId: (json['regionId'] as num?)?.toInt(),
	festivalId: (json['festivalId'] as num?)?.toInt(),
	viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
	status: (json['status'] as num?)?.toInt() ?? 1,
	createTime: json['createTime'] as String?,
);

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
	'id': instance.id,
	'title': instance.title,
	'summary': instance.summary,
	'content': instance.content,
	'type': instance.type,
	'imageUrl': instance.imageUrl,
	'regionId': instance.regionId,
	'festivalId': instance.festivalId,
	'viewCount': instance.viewCount,
	'status': instance.status,
	'createTime': instance.createTime,
};
