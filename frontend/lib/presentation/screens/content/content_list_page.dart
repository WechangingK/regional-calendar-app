import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/models/content.dart';

class ContentListPage extends ConsumerWidget {
	const ContentListPage({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final dailyContent = ref.watch(dailyContentProvider);
		final contentList = ref.watch(contentListProvider);

		return Scaffold(
			appBar: AppBar(
				title: const Text('文化内容'),
			),
			body: ListView(
				padding: const EdgeInsets.all(12),
				children: [
					// 每日推荐
					_buildDailyCard(dailyContent),
					const SizedBox(height: 16),
					// 内容分类
					_buildCategorySection(context),
					const SizedBox(height: 16),
					// 内容列表
					_buildContentList(contentList),
				],
			),
		);
	}

	Widget _buildDailyCard(AsyncValue<Content?> dailyContent) {
		return dailyContent.when(
			data: (content) {
				if (content == null) return const SizedBox.shrink();
				return Card(
					child: Container(
						padding: const EdgeInsets.all(16),
						decoration: BoxDecoration(
							gradient: LinearGradient(
								colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0.7)],
							),
							borderRadius: BorderRadius.circular(12),
						),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								const Row(
									children: [
										Icon(Icons.auto_awesome, color: Colors.white, size: 20),
										SizedBox(width: 8),
										Text(
											'每日文化小知识',
											style: TextStyle(
												color: Colors.white,
												fontSize: 16,
												fontWeight: FontWeight.bold,
											),
										),
									],
								),
								const SizedBox(height: 12),
								Text(
									content.title,
									style: const TextStyle(
										color: Colors.white,
										fontSize: 18,
										fontWeight: FontWeight.bold,
									),
								),
								if (content.summary != null) ...[
									const SizedBox(height: 8),
									Text(
										content.summary!,
										style: const TextStyle(
											color: Colors.white70,
											fontSize: 14,
										),
										maxLines: 3,
										overflow: TextOverflow.ellipsis,
									),
								],
							],
						),
					),
				);
			},
			loading: () => const Card(
				child: SizedBox(
					height: 150,
					child: Center(child: CircularProgressIndicator()),
				),
			),
			error: (_, __) => const SizedBox.shrink(),
		);
	}

	Widget _buildCategorySection(BuildContext context) {
		final categories = [
			{'icon': Icons.lightbulb, 'label': '文化小知识', 'type': 1},
			{'icon': Icons.celebration, 'label': '节日介绍', 'type': 2},
			{'icon': Icons.people, 'label': '民俗风情', 'type': 3},
			{'icon': Icons.restaurant, 'label': '美食文化', 'type': 4},
			{'icon': Icons.checkroom, 'label': '服饰文化', 'type': 5},
		];

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					'内容分类',
					style: TextStyle(
						fontSize: 18,
						fontWeight: FontWeight.bold,
					),
				),
				const SizedBox(height: 12),
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: categories.map((cat) {
						return GestureDetector(
							onTap: () {
								// TODO: 跳转到分类内容页
							},
							child: Column(
								children: [
									Container(
										width: 50,
										height: 50,
										decoration: BoxDecoration(
											color: AppColors.primary.withValues(alpha: 0.1),
											borderRadius: BorderRadius.circular(12),
										),
										child: Icon(
											cat['icon'] as IconData,
											color: AppColors.primary,
										),
									),
									const SizedBox(height: 6),
									Text(
										cat['label'] as String,
										style: const TextStyle(fontSize: 12),
									),
								],
							),
						);
					}).toList(),
				),
			],
		);
	}

	Widget _buildContentList(AsyncValue<List<Content>> contentList) {
		return contentList.when(
			data: (list) {
				if (list.isEmpty) {
					return const Center(
						child: Padding(
							padding: EdgeInsets.all(20),
							child: Text('暂无内容'),
						),
					);
				}
				return Column(
					children: list.map((content) => _buildContentItem(content)).toList(),
				);
			},
			loading: () => const Center(
				child: Padding(
					padding: EdgeInsets.all(20),
					child: CircularProgressIndicator(),
				),
			),
			error: (error, _) => Center(
				child: Padding(
					padding: const EdgeInsets.all(20),
					child: Text('加载失败：$error'),
				),
			),
		);
	}

	Widget _buildContentItem(Content content) {
		return Card(
			margin: const EdgeInsets.only(bottom: 12),
			child: InkWell(
				onTap: () => _navigateToDetail(content),
				borderRadius: BorderRadius.circular(12),
				child: Padding(
					padding: const EdgeInsets.all(12),
					child: Row(
						children: [
							// 图片
							ClipRRect(
								borderRadius: BorderRadius.circular(8),
								child: content.imageUrl != null
									? Image.network(
										content.imageUrl!,
										width: 100,
										height: 80,
										fit: BoxFit.cover,
										errorBuilder: (_, __, ___) => _buildItemPlaceholder(),
									)
									: _buildItemPlaceholder(),
							),
							const SizedBox(width: 12),
							// 信息
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											content.title,
											style: const TextStyle(
												fontSize: 16,
												fontWeight: FontWeight.w600,
											),
											maxLines: 2,
											overflow: TextOverflow.ellipsis,
										),
										const SizedBox(height: 4),
										Text(
											content.typeText,
											style: const TextStyle(
												fontSize: 12,
												color: AppColors.accent,
											),
										),
										const SizedBox(height: 4),
										Row(
											children: [
												const Icon(Icons.visibility, size: 14, color: AppColors.textHint),
												const SizedBox(width: 4),
												Text(
													'${content.viewCount}',
													style: const TextStyle(
														fontSize: 12,
														color: AppColors.textHint,
													),
												),
											],
										),
									],
								),
							),
						],
					),
				),
			),
		);
	}

	Widget _buildItemPlaceholder() {
		return Container(
			width: 100,
			height: 80,
			decoration: BoxDecoration(
				color: AppColors.accent.withValues(alpha: 0.1),
				borderRadius: BorderRadius.circular(8),
			),
			child: const Icon(Icons.article, color: AppColors.accent),
		);
	}

	void _navigateToDetail(Content content) {
		// 使用go_router导航
	}
}
