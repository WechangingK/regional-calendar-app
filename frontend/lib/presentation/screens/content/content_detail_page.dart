import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../data/models/content.dart';

class ContentDetailPage extends ConsumerStatefulWidget {
	final int contentId;

	const ContentDetailPage({super.key, required this.contentId});

	@override
	ConsumerState<ContentDetailPage> createState() => _ContentDetailPageState();
}

class _ContentDetailPageState extends ConsumerState<ContentDetailPage> {
	Content? _content;
	bool _isLoading = true;

	@override
	void initState() {
		super.initState();
		_loadContent();
	}

	Future<void> _loadContent() async {
		final repo = ContentRepository();
		final content = await repo.getContentDetail(widget.contentId);
		setState(() {
			_content = content;
			_isLoading = false;
		});
	}

	@override
	Widget build(BuildContext context) {
		if (_isLoading) {
			return Scaffold(
				appBar: AppBar(title: const Text('内容详情')),
				body: const Center(child: CircularProgressIndicator()),
			);
		}

		if (_content == null) {
			return Scaffold(
				appBar: AppBar(title: const Text('内容详情')),
				body: const Center(child: Text('内容不存在')),
			);
		}

		return Scaffold(
			body: CustomScrollView(
				slivers: [
					SliverAppBar(
						expandedHeight: 250,
						pinned: true,
						title: Text(_content!.typeText),
						actions: [
							IconButton(
								icon: const Icon(Icons.share),
								onPressed: () {},
							),
							IconButton(
								icon: const Icon(Icons.bookmark_border),
								onPressed: () {},
							),
						],
						flexibleSpace: FlexibleSpaceBar(
							background: _content!.imageUrl != null
								? Image.network(
									_content!.imageUrl!,
									fit: BoxFit.cover,
									errorBuilder: (_, __, ___) => _buildPlaceholder(),
								)
								: _buildPlaceholder(),
						),
					),
					SliverToBoxAdapter(
						child: Padding(
							padding: const EdgeInsets.all(16),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									// 标题
									Text(
										_content!.title,
										style: const TextStyle(
											fontSize: 22,
											fontWeight: FontWeight.bold,
											color: AppColors.textPrimary,
										),
									),
									const SizedBox(height: 12),
									// 元信息
									_buildMetaInfo(),
									const Divider(height: 32),
									// 摘要
									if (_content!.summary != null) ...[
										Container(
											padding: const EdgeInsets.all(12),
											decoration: BoxDecoration(
												color: AppColors.accent.withValues(alpha: 0.05),
												borderRadius: BorderRadius.circular(8),
												border: Border.all(
													color: AppColors.accent.withValues(alpha: 0.2),
												),
											),
											child: Text(
												_content!.summary!,
												style: const TextStyle(
													fontSize: 15,
													fontStyle: FontStyle.italic,
													color: AppColors.textSecondary,
													height: 1.5,
												),
											),
										),
										const SizedBox(height: 16),
									],
									// 正文内容
									if (_content!.content != null)
										Text(
											_content!.content!,
											style: const TextStyle(
												fontSize: 16,
												height: 1.8,
												color: AppColors.textPrimary,
											),
										),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _buildPlaceholder() {
		return Container(
			color: AppColors.accent.withValues(alpha: 0.3),
			child: const Center(
				child: Icon(Icons.article, size: 80, color: Colors.white54),
			),
		);
	}

	Widget _buildMetaInfo() {
		return Row(
			children: [
				// 类型标签
				Container(
					padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
					decoration: BoxDecoration(
						color: AppColors.accent.withValues(alpha: 0.1),
						borderRadius: BorderRadius.circular(12),
					),
					child: Text(
						_content!.typeText,
						style: const TextStyle(
							color: AppColors.accent,
							fontSize: 12,
						),
					),
				),
				const SizedBox(width: 12),
				// 浏览量
				const Icon(Icons.visibility, size: 16, color: AppColors.textHint),
				const SizedBox(width: 4),
				Text(
					'${_content!.viewCount}次浏览',
					style: const TextStyle(
						color: AppColors.textHint,
						fontSize: 13,
					),
				),
				const Spacer(),
				// 发布时间
				if (_content!.createTime != null)
					Text(
						_content!.createTime!.substring(0, 10),
						style: const TextStyle(
							color: AppColors.textHint,
							fontSize: 13,
						),
					),
			],
		);
	}
}
