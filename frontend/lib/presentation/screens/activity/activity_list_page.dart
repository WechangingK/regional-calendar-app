import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/activity_provider.dart';
import '../../../data/models/activity.dart';

class ActivityListPage extends ConsumerStatefulWidget {
	const ActivityListPage({super.key});

	@override
	ConsumerState<ActivityListPage> createState() => _ActivityListPageState();
}

class _ActivityListPageState extends ConsumerState<ActivityListPage>
	with SingleTickerProviderStateMixin {
	late TabController _tabController;

	@override
	void initState() {
		super.initState();
		_tabController = TabController(length: 3, vsync: this);
	}

	@override
	void dispose() {
		_tabController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('特色活动'),
				bottom: TabBar(
					controller: _tabController,
					indicatorColor: Colors.white,
					tabs: const [
						Tab(text: '即将开始'),
						Tab(text: '热门活动'),
						Tab(text: '推荐'),
					],
				),
			),
			body: TabBarView(
				controller: _tabController,
				children: [
					_buildUpcomingTab(),
					_buildHotTab(),
					_buildRecommendTab(),
				],
			),
		);
	}

	Widget _buildUpcomingTab() {
		final activities = ref.watch(upcomingActivitiesProvider);
		return _buildActivityList(activities);
	}

	Widget _buildHotTab() {
		final activities = ref.watch(hotActivitiesProvider);
		return _buildActivityList(activities);
	}

	Widget _buildRecommendTab() {
		final activities = ref.watch(recommendActivitiesProvider);
		return _buildActivityList(activities);
	}

	Widget _buildActivityList(AsyncValue<List<Activity>> activities) {
		return activities.when(
			data: (list) {
				if (list.isEmpty) {
					return const Center(child: Text('暂无活动数据'));
				}
				return ListView.builder(
					padding: const EdgeInsets.all(12),
					itemCount: list.length,
					itemBuilder: (context, index) => _buildActivityCard(list[index]),
				);
			},
			loading: () => const Center(child: CircularProgressIndicator()),
			error: (error, _) => Center(child: Text('加载失败：$error')),
		);
	}

	Widget _buildActivityCard(Activity activity) {
		return Card(
			margin: const EdgeInsets.only(bottom: 12),
			child: InkWell(
				onTap: () => context.push('/activity/${activity.id}'),
				borderRadius: BorderRadius.circular(12),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						// 活动图片
						if (activity.imageUrl != null)
							ClipRRect(
								borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
								child: Image.network(
									activity.imageUrl!,
									height: 160,
									width: double.infinity,
									fit: BoxFit.cover,
									errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
								),
							)
						else
							_buildImagePlaceholder(),
						// 活动信息
						Padding(
							padding: const EdgeInsets.all(12),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									// 类型标签 + 状态
									Row(
										children: [
											Container(
												padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
												decoration: BoxDecoration(
													color: _getTypeColor(activity.type).withValues(alpha: 0.1),
													borderRadius: BorderRadius.circular(4),
												),
												child: Text(
													activity.typeText,
													style: TextStyle(
														color: _getTypeColor(activity.type),
														fontSize: 12,
													),
												),
											),
											const Spacer(),
											_buildStatusChip(activity.status),
										],
									),
									const SizedBox(height: 8),
									// 活动名称
									Text(
										activity.name,
										style: const TextStyle(
											fontSize: 18,
											fontWeight: FontWeight.bold,
										),
									),
									const SizedBox(height: 8),
									// 时间地点
									if (activity.startTime != null)
										_buildInfoRow(Icons.access_time, activity.startTime!),
									if (activity.location != null) ...[
										const SizedBox(height: 4),
										_buildInfoRow(Icons.location_on, activity.location!),
									],
									// 简介
									if (activity.description != null) ...[
										const SizedBox(height: 8),
										Text(
											activity.description!,
											maxLines: 2,
											overflow: TextOverflow.ellipsis,
											style: const TextStyle(
												color: AppColors.textSecondary,
												fontSize: 14,
											),
										),
									],
								],
							),
						),
					],
				),
			),
		);
	}

	Widget _buildImagePlaceholder() {
		return Container(
			height: 160,
			width: double.infinity,
			decoration: BoxDecoration(
				color: AppColors.accent.withValues(alpha: 0.2),
				borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
			),
			child: const Center(
				child: Icon(Icons.event, size: 60, color: AppColors.accent),
			),
		);
	}

	Widget _buildInfoRow(IconData icon, String text) {
		return Row(
			children: [
				Icon(icon, size: 16, color: AppColors.textHint),
				const SizedBox(width: 6),
				Expanded(
					child: Text(
						text,
						style: const TextStyle(
							color: AppColors.textSecondary,
							fontSize: 13,
						),
						maxLines: 1,
						overflow: TextOverflow.ellipsis,
					),
				),
			],
		);
	}

	Widget _buildStatusChip(int status) {
		String text;
		Color color;
		switch (status) {
			case 1:
				text = '即将开始';
				color = AppColors.info;
				break;
			case 2:
				text = '进行中';
				color = AppColors.success;
				break;
			case 3:
				text = '已结束';
				color = AppColors.textHint;
				break;
			default:
				text = '未知';
				color = AppColors.textHint;
		}
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
			decoration: BoxDecoration(
				color: color.withValues(alpha: 0.1),
				borderRadius: BorderRadius.circular(4),
			),
			child: Text(
				text,
				style: TextStyle(color: color, fontSize: 12),
			),
		);
	}

	Color _getTypeColor(int type) {
		switch (type) {
			case 1: return AppColors.primary; // 庆典
			case 2: return AppColors.festivalEthnic; // 祭祀
			case 3: return AppColors.info; // 比赛
			case 4: return AppColors.gold; // 表演
			case 5: return AppColors.accent; // 展览
			default: return AppColors.textSecondary;
		}
	}
}
