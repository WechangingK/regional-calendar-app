import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/festival_provider.dart';
import '../../../data/models/festival.dart';

class FestivalListPage extends ConsumerStatefulWidget {
	const FestivalListPage({super.key});

	@override
	ConsumerState<FestivalListPage> createState() => _FestivalListPageState();
}

class _FestivalListPageState extends ConsumerState<FestivalListPage>
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
				title: const Text('节日'),
				bottom: TabBar(
					controller: _tabController,
					indicatorColor: Colors.white,
					tabs: const [
						Tab(text: '即将到来'),
						Tab(text: '热门节日'),
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
		final festivals = ref.watch(upcomingFestivalsProvider);
		return _buildFestivalList(festivals);
	}

	Widget _buildHotTab() {
		final festivals = ref.watch(hotFestivalsProvider);
		return _buildFestivalList(festivals);
	}

	Widget _buildRecommendTab() {
		final festivals = ref.watch(recommendFestivalsProvider);
		return _buildFestivalList(festivals);
	}

	Widget _buildFestivalList(AsyncValue<List<Festival>> festivals) {
		return festivals.when(
			data: (list) {
				if (list.isEmpty) {
					return const Center(child: Text('暂无节日数据'));
				}
				return ListView.builder(
					padding: const EdgeInsets.all(12),
					itemCount: list.length,
					itemBuilder: (context, index) => _buildFestivalItem(list[index]),
				);
			},
			loading: () => const Center(child: CircularProgressIndicator()),
			error: (error, _) => Center(child: Text('加载失败：$error')),
		);
	}

	Widget _buildFestivalItem(Festival festival) {
		return Card(
			margin: const EdgeInsets.only(bottom: 12),
			child: InkWell(
				onTap: () => context.push('/festival/${festival.id}'),
				borderRadius: BorderRadius.circular(12),
				child: Padding(
					padding: const EdgeInsets.all(12),
					child: Row(
						children: [
							// 图标
							Container(
								width: 60,
								height: 60,
								decoration: BoxDecoration(
									color: _getFestivalColor(festival.type).withOpacity(0.1),
									borderRadius: BorderRadius.circular(12),
								),
								child: Icon(
									_getFestivalIcon(festival.type),
									color: _getFestivalColor(festival.type),
									size: 30,
								),
							),
							const SizedBox(width: 12),
							// 信息
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											festival.name,
											style: const TextStyle(
												fontSize: 16,
												fontWeight: FontWeight.w600,
											),
										),
										const SizedBox(height: 4),
										Text(
											festival.typeText,
											style: TextStyle(
												fontSize: 12,
												color: _getFestivalColor(festival.type),
											),
										),
										if (festival.startDate != null) ...[
											const SizedBox(height: 4),
											Text(
												festival.startDate!,
												style: const TextStyle(
													fontSize: 12,
													color: AppColors.textHint,
												),
											),
										],
									],
								),
							),
							// 放假标签
							if (festival.isHoliday == 1)
								Container(
									padding: const EdgeInsets.symmetric(
										horizontal: 8,
										vertical: 4,
									),
									decoration: BoxDecoration(
										color: AppColors.festivalLegal.withOpacity(0.1),
										borderRadius: BorderRadius.circular(4),
									),
									child: Text(
										'放假${festival.holidayDays ?? festival.duration}天',
										style: const TextStyle(
											color: AppColors.festivalLegal,
											fontSize: 12,
										),
									),
								),
						],
					),
				),
			),
		);
	}

	Color _getFestivalColor(int type) {
		switch (type) {
			case 1: return AppColors.festivalLegal;
			case 2: return AppColors.festivalTraditional;
			case 3: return AppColors.festivalEthnic;
			case 4: return AppColors.festivalSolar;
			case 5: return AppColors.festivalMemorial;
			default: return AppColors.textSecondary;
		}
	}

	IconData _getFestivalIcon(int type) {
		switch (type) {
			case 1: return Icons.flag;
			case 2: return Icons.auto_awesome;
			case 3: return Icons.diversity_3;
			case 4: return Icons.wb_sunny;
			case 5: return Icons.star;
			default: return Icons.event;
		}
	}
}
