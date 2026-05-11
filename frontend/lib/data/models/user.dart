import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
	final int id;
	final String username;
	final String? nickname;
	final String? avatar;
	final String? phone;
	final String? email;
	final int? regionId;
	final String? regionName;
	final int? ethnicityId;
	final int? gender;
	final String? birthday;
	final String? bio;
	final int status;
	final int? vipLevel;
	final int? points;
	final String? lastLoginTime;

	User({
		required this.id,
		required this.username,
		this.nickname,
		this.avatar,
		this.phone,
		this.email,
		this.regionId,
		this.regionName,
		this.ethnicityId,
		this.gender,
		this.birthday,
		this.bio,
		this.status = 1,
		this.vipLevel,
		this.points,
		this.lastLoginTime,
	});

	factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
	Map<String, dynamic> toJson() => _$UserToJson(this);

	String get displayName => nickname ?? username;

	String get genderLabel {
		if (gender == 1) return '男';
		if (gender == 2) return '女';
		return '未设置';
	}
}
