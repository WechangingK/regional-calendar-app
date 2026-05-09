import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/repositories/festival_repository.dart';
import '../../../data/models/festival.dart';

class FestivalDetailPage extends ConsumerStatefulWidget {
	final int festivalId;

	const FestivalDetailPage({super.key, required this.festivalId});

	@override
	ConsumerState<FestivalDetailPage> createState() => _FestivalDetailPageState();
}

class _FestivalDetailPageState extends ConsumerState<FestivalDetailPage> {
	Festival? _festival;
	bool _isLoading = true;

	@override
	void initState() {
		super.initState();
		_loadFestival();
	}

	Future<void> _loadFestival() async {
		final repo = FestivalRepository();
		final festival = await repo.getFestivalDetail(widget.festivalId);
		setState(() {
			_festival = festival;
			_isLoading = false;
		});
	}

	@override
	Widget build(BuildContext context) {
		if (_isLoading) {
			return Scaffold(
				appBar: AppBar(title: const Text('节日详情')),
				body: const Center(child: CircularProgressIndicator()),
			);
		}

		if (_festival == null) {
			return Scaffold(
				appBar: AppBar(title: const Text('节日详情')),
				body: const Center(child: Text('节日信息不存在')),
			);
		}

		return Scaffold(
			body: CustomScrollView(
				slivers: [
					SliverAppBar(
						expandedHeight: 250,
						pinned: true,
						title: Text(_festival!.name),
						actions: [
							IconButton(
								icon: const Icon(Icons.share),
								onPressed: () {},
							),
						],
						flexibleSpace: FlexibleSpaceBar(
							background: _festival!.imageUrl != null
								? Image.network(
									_festival!.imageUrl!,
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
									_buildInfoSection(),
									const Divider(height: 32),
									if (_festival!.description != null)
										_buildContentSection('节日介绍', _festival!.description!),
									if (_festival!.history != null)
										_buildContentSection('历史由来', _festival!.history!),
									if (_festival!.customs != null)
										_buildContentSection('传统习俗', _festival!.customs!),
									if (_festival!.food != null)
										_buildContentSection('特色美食', _festival!.food!),
									if (_festival!.clothing != null)
										_buildContentSection('特色服饰', _festival!.clothing!),
									if (_festival!.activities != null)
										_buildContentSection('相关活动', _festival!.activities!),
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
			color: AppColors.primary.withValues(alpha: 0.3),
			child: const Center(
				child: Icon(Icons.celebration, size: 80, color: Colors.white54),
			),
		);
	}

	Widget _buildInfoSection() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Container(
					padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
					decoration: BoxDecoration(
						color: _getTypeColor().withValues(alpha: 0.1),
						borderRadius: BorderRadius.circular(16),
					),
					child: Text(
						_festival!.typeText,
						style: TextStyle(
							color: _getTypeColor(),
							fontWeight: FontWeight.w500,
						),
					),
				),
				const SizedBox(height: 12),
				if (_festival!.nameLocal != null) ...[
					Text(
						'当地语言：${_festival!.nameLocal}',
						style: const TextStyle(
							fontSize: 16,
							color: AppColors.textSecondary,
						),
					),
					const SizedBox(height: 8),
				],
				_buildInfoRow(Icons.access_time, '时间', _festival!.startDate ?? '待定'),
				if (_festival!.isHoliday == 1)
					_buildInfoRow(
						Icons.calendar_month,
						'放假',
						'${_festival!.holidayDays ?? _festival!.duration}天',
					),
			],
		);
	}

	Widget _buildInfoRow(IconData icon, String label, String value) {
		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 4),
			child: Row(
				children: [
					Icon(icon, size: 20, color: AppColors.textSecondary),
					const SizedBox(width: 8),
					Text(
						'$label：',
						style: const TextStyle(color: AppColors.textSecondary),
					),
					Text(
						value,
						style: const TextStyle(fontWeight: FontWeight.w500),
					),
				],
			),
		);
	}

	Widget _buildContentSection(String title, String content) {
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

	Color _getTypeColor() {
		switch (_festival!.type) {
			case 1: return AppColors.festivalLegal;
			case 2: return AppColors.festivalTraditional;
			case 3: return AppColors.festivalEthnic;
			case 4: return AppColors.festivalSolar;
			case 5: return AppColors.festivalMemorial;
			default: return AppColors.textSecondary;
		}
	}
}
