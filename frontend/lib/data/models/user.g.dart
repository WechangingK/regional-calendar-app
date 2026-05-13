part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
	id: (json['id'] as num).toInt(),
	username: json['username'] as String,
	nickname: json['nickname'] as String?,
	avatar: json['avatar'] as String?,
	phone: json['phone'] as String?,
	email: json['email'] as String?,
	regionId: (json['regionId'] as num?)?.toInt(),
	regionName: json['regionName'] as String?,
	ethnicityId: (json['ethnicityId'] as num?)?.toInt(),
	gender: (json['gender'] as num?)?.toInt(),
	birthday: json['birthday'] as String?,
	bio: json['bio'] as String?,
	status: (json['status'] as num?)?.toInt() ?? 1,
	vipLevel: (json['vipLevel'] as num?)?.toInt(),
	points: (json['points'] as num?)?.toInt(),
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
	'regionName': instance.regionName,
	'ethnicityId': instance.ethnicityId,
	'gender': instance.gender,
	'birthday': instance.birthday,
	'bio': instance.bio,
	'status': instance.status,
	'vipLevel': instance.vipLevel,
	'points': instance.points,
	'lastLoginTime': instance.lastLoginTime,
};
