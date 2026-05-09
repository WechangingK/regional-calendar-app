part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
	id: (json['id'] as num).toInt(),
	username: json['username'] as String,
	nickname: json['nickname'] as String?,
	avatar: json['avatar'] as String?,
	phone: json['phone'] as String?,
	email: json['email'] as String?,
	regionId: (json['regionId'] as num?)?.toInt(),
	ethnicityId: (json['ethnicityId'] as num?)?.toInt(),
	status: (json['status'] as num?)?.toInt() ?? 1,
	lastLoginTime: json['lastLoginTime'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
	'id': instance.id,
	'username': instance.username,
	'nickname': instance.nickname,
	'avatar': instance.avatar,
	'phone': instance.phone,
	'email': instance.email,
	'regionId': instance.regionId,
	'ethnicityId': instance.ethnicityId,
	'status': instance.status,
	'lastLoginTime': instance.lastLoginTime,
};
