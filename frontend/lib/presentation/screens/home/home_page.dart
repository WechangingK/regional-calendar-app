import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/region_provider.dart';
import '../../../data/providers/festival_provider.dart';
import '../../../data/models/festival.dart';

class HomePage extends ConsumerStatefulWidget {
	const HomePage({super.key});

	@override
	ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
	DateTime _focusedDay = DateTime.now();
	DateTime? _selectedDay;

	@override
	Widget build(BuildContext context) {
		final region = ref.watch(currentRegionProvider);
		final upcomingFestivals = ref.watch(upcomingFestivalsProvider);

		return Scaffold(
			appBar: AppBar(
				title: const Text('节日历'),
				actions: [
					TextButton.icon(
						onPressed: () => context.push('/region-selector'),
						icon: const Icon(Icons.location_on, color: Colors.white),
						label: Text(
							region?.name ?? '选择地区',
							style: const TextStyle(color: Colors.white),
						),
					),
				],
			),
			body: SingleChildScrollView(
				child: Column(
					children: [
						// 日历组件
						_buildCalendar(),

						// 今日信息
						_buildTodayInfo(),

						// 近期节日
						_buildUpcomingFestivals(upcomingFestivals),
					],
				),
			),
		);
	}

	Widget _buildCalendar() {
		return Card(
			margin: const EdgeInsets.all(12),
			child: TableCalendar(
				locale: 'zh_CN',
				firstDay: DateTime(2020),
				lastDay: DateTime(2030),
				focusedDay: _focusedDay,
				selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
				onDaySelected: (selectedDay, focusedDay) {
					setState(() {
						_selectedDay = selectedDay;
						_focusedDay = focusedDay;
					});
				},
				calendarFormat: CalendarFormat.month,
				startingDayOfWeek: StartingDayOfWeek.sunday,
				headerStyle: HeaderStyle(
					formatButtonVisible: false,
					titleCentered: true,
					titleTextStyle: const TextStyle(
						fontSize: 18,
						fontWeight: FontWeight.bold,
					),
					leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.primary),
					rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.primary),
				),
				calendarStyle: const CalendarStyle(
					todayDecoration: BoxDecoration(
						color: AppColors.calendarToday,
						shape: BoxShape.circle,
					),
					selectedDecoration: BoxDecoration(
						color: AppColors.calendarSelected,
						shape: BoxShape.circle,
					),
					outsideDaysVisible: false,
				),
				daysOfWeekStyle: const DaysOfWeekStyle(
					weekendStyle: TextStyle(color: AppColors.calendarWeekend),
				),
			),
		);
	}

	Widget _buildTodayInfo() {
		final now = DateTime.now();
		return Container(
			margin: const EdgeInsets.symmetric(horizontal: 12),
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				gradient: LinearGradient(
					colors: [AppColors.primary, AppColors.primaryLight],
				),
				borderRadius: BorderRadius.circular(12),
			),
			child: Row(
				children: [
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									'${now.year}年${now.month}月${now.day}日',
									style: const TextStyle(
										color: Colors.white,
										fontSize: 16,
									),
								),
								const SizedBox(height: 4),
								const Text(
									'农历信息加载中...',
									style: TextStyle(
										color: Colors.white70,
										fontSize: 14,
									),
								),
							],
						),
					),
					const Icon(
						Icons.wb_sunny,
						color: Colors.yellow,
						size: 40,
					),
				],
			),
		);
	}

	Widget _buildUpcomingFestivals(AsyncValue<List<Festival>> upcomingFestivals) {
		return Container(
			margin: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const Row(
						children: [
							Icon(Icons.celebration, color: AppColors.primary),
							SizedBox(width: 8),
							Text(
								'近期节日',
								style: TextStyle(
									fontSize: 18,
									fontWeight: FontWeight.bold,
								),
							),
						],
					),
					const SizedBox(height: 12),
					upcomingFestivals.when(
						data: (festivals) {
							if (festivals.isEmpty) {
								return const Center(
									child: Padding(
										padding: EdgeInsets.all(20),
										child: Text('暂无近期节日'),
									),
								);
							}
							return Column(
								children: festivals.take(5).map((festival) {
									return _buildFestivalCard(festival);
								}).toList(),
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
					),
				],
			),
		);
	}

	Widget _buildFestivalCard(Festival festival) {
		return Card(
			margin: const EdgeInsets.only(bottom: 8),
			child: ListTile(
				leading: Container(
					width: 48,
					height: 48,
					decoration: BoxDecoration(
						color: _getFestivalColor(festival.type).withOpacity(0.1),
						borderRadius: BorderRadius.circular(8),
					),
					child: Icon(
						_getFestivalIcon(festival.type),
						color: _getFestivalColor(festival.type),
					),
				),
				title: Text(
					festival.name,
					style: const TextStyle(fontWeight: FontWeight.w600),
				),
				subtitle: Text(
					festival.startDate ?? '',
					style: const TextStyle(fontSize: 12),
				),
				trailing: festival.isHoliday == 1
					? Container(
						padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
					)
					: null,
				onTap: () => context.push('/festival/${festival.id}'),
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
