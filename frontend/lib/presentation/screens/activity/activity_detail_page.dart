import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../data/models/activity.dart';

class ActivityDetailPage extends ConsumerStatefulWidget {
	final int activityId;

	const ActivityDetailPage({super.key, required this.activityId});

	@override
	ConsumerState<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends ConsumerState<ActivityDetailPage> {
	Activity? _activity;
	bool _isLoading = true;

	@override
	void initState() {
		super.initState();
		_loadActivity();
	}

	Future<void> _loadActivity() async {
		final repo = ActivityRepository();
		final activity = await repo.getActivityDetail(widget.activityId);
		setState(() {
			_activity = activity;
			_isLoading = false;
		});
	}

	@override
	Widget build(BuildContext context) {
		if (_isLoading) {
			return Scaffold(
				appBar: AppBar(title: const Text('活动详情')),
				body: const Center(child: CircularProgressIndicator()),
			);
		}

		if (_activity == null) {
			return Scaffold(
				appBar: AppBar(title: const Text('活动详情')),
				body: const Center(child: Text('活动信息不存在')),
			);
		}

		return Scaffold(
			body: CustomScrollView(
				slivers: [
					SliverAppBar(
						expandedHeight: 250,
						pinned: true,
						title: Text(_activity!.name),
						actions: [
							IconButton(
								icon: const Icon(Icons.share),
								onPressed: () {},
							),
						],
						flexibleSpace: FlexibleSpaceBar(
							background: _activity!.imageUrl != null
								? Image.network(
									_activity!.imageUrl!,
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
									// 基本信息卡片
									_buildInfoCard(),
									const SizedBox(height: 16),
									// 活动介绍
									if (_activity!.description != null)
										_buildSection('活动介绍', _activity!.description!),
									// 活动详情
									if (_activity!.content != null)
										_buildSection('活动详情', _activity!.content!),
									// 联系信息
									if (_activity!.contact != null || _activity!.organizer != null)
										_buildContactSection(),
									// 门票信息
									if (_activity!.ticketInfo != null)
										_buildSection('门票信息', _activity!.ticketInfo!),
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
				child: Icon(Icons.event, size: 80, color: Colors.white54),
			),
		);
	}

	Widget _buildInfoCard() {
		return Card(
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					children: [
						// 类型和状态
						Row(
							children: [
								Container(
									padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
									decoration: BoxDecoration(
										color: _getTypeColor().withValues(alpha: 0.1),
										borderRadius: BorderRadius.circular(16),
									),
									child: Text(
										_activity!.typeText,
										style: TextStyle(
											color: _getTypeColor(),
											fontWeight: FontWeight.w500,
										),
									),
								),
								const Spacer(),
								_buildStatusChip(),
							],
						),
						const Divider(height: 24),
						// 时间
						if (_activity!.startTime != null)
							_buildInfoRow(Icons.access_time, '开始时间', _activity!.startTime!),
						if (_activity!.endTime != null)
							_buildInfoRow(Icons.access_time_filled, '结束时间', _activity!.endTime!),
						// 地点
						if (_activity!.location != null)
							_buildInfoRow(Icons.location_on, '活动地点', _activity!.location!),
						if (_activity!.address != null)
							_buildInfoRow(Icons.map, '详细地址', _activity!.address!),
					],
				),
			),
		);
	}

	Widget _buildInfoRow(IconData icon, String label, String value) {
		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 6),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Icon(icon, size: 20, color: AppColors.primary),
					const SizedBox(width: 12),
					SizedBox(
						width: 70,
						child: Text(
							label,
							style: const TextStyle(color: AppColors.textSecondary),
						),
					),
					Expanded(
						child: Text(
							value,
							style: const TextStyle(fontWeight: FontWeight.w500),
						),
					),
				],
			),
		);
	}

	Widget _buildStatusChip() {
		String text;
		Color color;
		switch (_activity!.status) {
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
			padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
			decoration: BoxDecoration(
				color: color.withValues(alpha: 0.1),
				borderRadius: BorderRadius.circular(16),
			),
			child: Text(text, style: TextStyle(color: color)),
		);
	}

	Widget _buildSection(String title, String content) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(
					title,
					style: const TextStyle(
						fontSize: 18,
						fontWeight: FontWeight.bold,
						color: AppColors.primary,
					),
				),
				const SizedBox(height: 8),
				Text(
					content,
					style: const TextStyle(
						fontSize: 15,
						height: 1.6,
						color: AppColors.textPrimary,
					),
				),
				const SizedBox(height: 16),
			],
		);
	}

	Widget _buildContactSection() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				const Text(
					'联系方式',
					style: TextStyle(
						fontSize: 18,
						fontWeight: FontWeight.bold,
						color: AppColors.primary,
					),
				),
				const SizedBox(height: 8),
				Card(
					child: Padding(
						padding: const EdgeInsets.all(12),
						child: Column(
							children: [
								if (_activity!.organizer != null)
									_buildInfoRow(Icons.business, '主办方', _activity!.organizer!),
								if (_activity!.contact != null)
									_buildInfoRow(Icons.phone, '联系电话', _activity!.contact!),
							],
						),
					),
				),
				const SizedBox(height: 16),
			],
		);
	}

	Color _getTypeColor() {
		switch (_activity!.type) {
			case 1: return AppColors.primary;
			case 2: return AppColors.festivalEthnic;
			case 3: return AppColors.info;
			case 4: return AppColors.gold;
			case 5: return AppColors.accent;
			default: return AppColors.textSecondary;
		}
	}
}
