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
	final int? ethnicityId;
	final int status;
	final String? lastLoginTime;

	User({
		required this.id,
		required this.username,
		this.nickname,
		this.avatar,
		this.phone,
		this.email,
		this.regionId,
		this.ethnicityId,
		this.status = 1,
		this.lastLoginTime,
	});

	factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
	Map<String, dynamic> toJson() => _$UserToJson(this);

	String get displayName => nickname ?? username;
}
