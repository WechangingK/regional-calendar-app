import 'package:json_annotation/json_annotation.dart';

part 'content.g.dart';

@JsonSerializable()
class Content {
	final int id;
	final String title;
	final String? summary;
	final String? content;
	final int type;
	final String? imageUrl;
	final int? regionId;
	final int? festivalId;
	final int viewCount;
	final int status;
	final String? createTime;

	Content({
		required this.id,
		required this.title,
		this.summary,
		this.content,
		this.type = 1,
		this.imageUrl,
		this.regionId,
		this.festivalId,
		this.viewCount = 0,
		this.status = 1,
		this.createTime,
	});

	factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
	Map<String, dynamic> toJson() => _$ContentToJson(this);

	String get typeText {
		switch (type) {
			case 1: return '文化小知识';
			case 2: return '节日介绍';
			case 3: return '民俗风情';
			case 4: return '美食文化';
			case 5: return '服饰文化';
			default: return '其他';
		}
	}
}
