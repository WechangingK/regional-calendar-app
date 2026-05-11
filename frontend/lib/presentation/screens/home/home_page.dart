import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/region_provider.dart';
import '../../../data/providers/festival_provider.dart';
import '../../../data/providers/activity_provider.dart';
import '../../../data/providers/content_provider.dart';
import '../../../data/providers/holiday_provider.dart';
import '../../../data/models/festival.dart';
import '../../../data/models/activity.dart';
import '../../../data/models/holiday_schedule.dart';

class HomePage extends ConsumerStatefulWidget {
	const HomePage({super.key});

	@override
	ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
	DateTime _focusedDay = DateTime.now();
	DateTime? _selectedDay;
	Map<DateTime, List<dynamic>> _markers = {};

	void _buildMarkers(
		List<Festival>? festivals,
		List<Activity>? activities,
		List<HolidaySchedule>? holidays,
	) {
		final map = <DateTime, List<dynamic>>{};

		if (festivals != null) {
			for (final f in festivals) {
				if (f.startDate == null) continue;
				final d = DateTime.tryParse(f.startDate!);
				if (d != null) {
					map.putIfAbsent(d, () => []).add(f);
				}
			}
		}

		if (activities != null) {
			for (final a in activities) {
				if (a.startTime == null) continue;
				final d = DateTime.tryParse(a.startTime!);
				if (d != null) {
					map.putIfAbsent(d, () => []).add(a);
				}
			}
		}

		if (holidays != null) {
			for (final h in holidays) {
				final start = DateTime.tryParse(h.startDate);
				final end = DateTime.tryParse(h.endDate);
				if (start != null && end != null) {
					var d = start;
					while (!d.isAfter(end)) {
						map.putIfAbsent(d, () => []).add(h);
						d = d.add(const Duration(days: 1));
					}
				}
			}
		}

		_markers = map;
	}

	@override
	Widget build(BuildContext context) {
		final region = ref.watch(currentRegionProvider);
		final upcomingFestivals = ref.watch(upcomingFestivalsProvider);
		final upcomingActivities = ref.watch(upcomingActivitiesProvider);
		final dailyContent = ref.watch(dailyContentProvider);
		final holidaySchedule = ref.watch(holidayScheduleProvider);
		final monthFestivals = ref.watch(calendarFestivalsProvider(
			(year: _focusedDay.year, month: _focusedDay.month),
		));
		final monthActivities = ref.watch(calendarActivitiesProvider(
			(year: _focusedDay.year, month: _focusedDay.month),
		));
		final monthHolidays = ref.watch(calendarHolidaysProvider(
			(year: _focusedDay.year, month: _focusedDay.month),
		));

		monthFestivals.whenData((festivals) {
			monthActivities.whenData((activities) {
				monthHolidays.whenData((holidays) {
					_buildMarkers(festivals, activities, holidays);
				});
			});
		});

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
						_buildCalendar(),
						_buildTodayInfo(),
						_buildQuickActions(),
						_buildUpcomingFestivals(upcomingFestivals),
						_buildUpcomingActivities(upcomingActivities),
						_buildHolidaySchedule(holidaySchedule),
						_buildDailyContent(dailyContent),
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
				onPageChanged: (focusedDay) {
					setState(() {
						_focusedDay = focusedDay;
					});
				},
				calendarFormat: CalendarFormat.month,
				eventLoader: (day) => _markers[DateTime.utc(day.year, day.month, day.day)] ?? [],
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
				calendarStyle: CalendarStyle(
					todayDecoration: const BoxDecoration(
						color: AppColors.calendarToday,
						shape: BoxShape.circle,
					),
					selectedDecoration: const BoxDecoration(
						color: AppColors.calendarSelected,
						shape: BoxShape.circle,
					),
					outsideDaysVisible: false,
					markerDecoration: const BoxDecoration(
						color: AppColors.festivalEthnic,
						shape: BoxShape.circle,
					),
					markersMaxCount: 3,
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
									'点击日历查看节日详情',
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

	Widget _buildQuickActions() {
		return Container(
			margin: const EdgeInsets.all(12),
			child: Row(
				children: [
					_expandedAction(
						icon: Icons.celebration,
						label: '节日',
						color: AppColors.primary,
						onTap: () => context.go('/festival'),
					),
					const SizedBox(width: 12),
					_expandedAction(
						icon: Icons.event,
						label: '活动',
						color: AppColors.accent,
						onTap: () => context.push('/activity'),
					),
					const SizedBox(width: 12),
					_expandedAction(
						icon: Icons.article,
						label: '文化',
						color: AppColors.gold,
						onTap: () => context.push('/content'),
					),
				],
			),
		);
	}

	Widget _expandedAction({
		required IconData icon,
		required String label,
		required Color color,
		required VoidCallback onTap,
	}) {
		return Expanded(
			child: Card(
				child: InkWell(
					onTap: onTap,
					borderRadius: BorderRadius.circular(12),
					child: Padding(
						padding: const EdgeInsets.symmetric(vertical: 16),
						child: Column(
							children: [
								Container(
									width: 48,
									height: 48,
									decoration: BoxDecoration(
										color: color.withValues(alpha: 0.1),
										borderRadius: BorderRadius.circular(12),
									),
									child: Icon(icon, color: color, size: 28),
								),
								const SizedBox(height: 8),
								Text(
									label,
									style: TextStyle(
										fontWeight: FontWeight.w600,
										color: color,
									),
								),
							],
						),
					),
				),
			),
		);
	}

	Widget _buildUpcomingFestivals(AsyncValue<List<Festival>> upcomingFestivals) {
		return Container(
			margin: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					_buildSectionHeader(
						icon: Icons.celebration,
						title: '近期节日',
						onMore: () => context.go('/festival'),
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
								children: festivals.take(3).map((festival) {
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

	Widget _buildUpcomingActivities(AsyncValue<List<Activity>> upcomingActivities) {
		return Container(
			margin: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					_buildSectionHeader(
						icon: Icons.event,
						title: '近期活动',
						onMore: () => context.push('/activity'),
					),
					const SizedBox(height: 12),
					upcomingActivities.when(
						data: (activities) {
							if (activities.isEmpty) {
								return const Center(
									child: Padding(
										padding: EdgeInsets.all(20),
										child: Text('暂无近期活动'),
									),
								);
							}
							return SizedBox(
								height: 180,
								child: ListView.builder(
									scrollDirection: Axis.horizontal,
									itemCount: activities.length,
									itemBuilder: (context, index) {
										return _buildActivityCard(activities[index]);
									},
								),
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

	Widget _buildHolidaySchedule(AsyncValue<List<HolidaySchedule>> holidaySchedule) {
		return Container(
			margin: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					_buildSectionHeader(
						icon: Icons.beach_access,
						title: '放假安排',
						onMore: () => context.go('/calendar'),
					),
					const SizedBox(height: 12),
					holidaySchedule.when(
						data: (holidays) {
							if (holidays.isEmpty) {
								return const Center(
									child: Padding(
										padding: EdgeInsets.all(20),
										child: Text('暂无放假安排'),
									),
								);
							}
							return Column(
								children: holidays.take(3).map((h) {
									return _buildHolidayCard(h);
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

	Widget _buildDailyContent(AsyncValue<dynamic> dailyContent) {
		return Container(
			margin: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					_buildSectionHeader(
						icon: Icons.auto_awesome,
						title: '每日文化小知识',
						onMore: () => context.push('/content'),
					),
					const SizedBox(height: 12),
					dailyContent.when(
						data: (content) {
							if (content == null) {
								return const SizedBox.shrink();
							}
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
											Text(
												content.title,
												style: const TextStyle(
													color: Colors.white,
													fontSize: 16,
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
						loading: () => const SizedBox.shrink(),
						error: (_, __) => const SizedBox.shrink(),
					),
				],
			),
		);
	}

	Widget _buildSectionHeader({
		required IconData icon,
		required String title,
		required VoidCallback onMore,
	}) {
		return Row(
			children: [
				Icon(icon, color: AppColors.primary),
				const SizedBox(width: 8),
				Text(
					title,
					style: const TextStyle(
						fontSize: 18,
						fontWeight: FontWeight.bold,
					),
				),
				const Spacer(),
				TextButton(
					onPressed: onMore,
					child: const Text('查看更多'),
				),
			],
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
						color: _getFestivalColor(festival.type).withValues(alpha: 0.1),
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
							color: AppColors.festivalLegal.withValues(alpha: 0.1),
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

	Widget _buildActivityCard(Activity activity) {
		return Card(
			margin: const EdgeInsets.only(right: 12),
			child: InkWell(
				onTap: () => context.push('/activity/${activity.id}'),
				borderRadius: BorderRadius.circular(12),
				child: SizedBox(
					width: 200,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							ClipRRect(
								borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
								child: activity.imageUrl != null
									? Image.network(
										activity.imageUrl!,
										height: 100,
										width: 200,
										fit: BoxFit.cover,
										errorBuilder: (_, __, ___) => _buildActivityPlaceholder(),
									)
									: _buildActivityPlaceholder(),
							),
							Padding(
								padding: const EdgeInsets.all(8),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											activity.name,
											style: const TextStyle(
												fontWeight: FontWeight.w600,
												fontSize: 14,
											),
											maxLines: 1,
											overflow: TextOverflow.ellipsis,
										),
										const SizedBox(height: 4),
										if (activity.startTime != null)
											Text(
												activity.startTime!,
												style: const TextStyle(
													fontSize: 12,
													color: AppColors.textHint,
												),
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

	Widget _buildHolidayCard(HolidaySchedule holiday) {
		return Card(
			margin: const EdgeInsets.only(bottom: 8),
			child: ListTile(
				leading: Container(
					width: 48,
					height: 48,
					decoration: BoxDecoration(
						color: AppColors.gold.withValues(alpha: 0.1),
						borderRadius: BorderRadius.circular(8),
					),
					child: const Icon(
						Icons.beach_access,
						color: AppColors.gold,
					),
				),
				title: Text(
					holiday.festivalName ?? '节假日',
					style: const TextStyle(fontWeight: FontWeight.w600),
				),
				subtitle: Text(
					'${holiday.startDate} ~ ${holiday.endDate}',
					style: const TextStyle(fontSize: 12),
				),
				trailing: Container(
					padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
					decoration: BoxDecoration(
						color: AppColors.gold.withValues(alpha: 0.1),
						borderRadius: BorderRadius.circular(4),
					),
					child: Text(
						'${holiday.totalDays}天',
						style: const TextStyle(
							color: AppColors.gold,
							fontSize: 12,
							fontWeight: FontWeight.bold,
						),
					),
				),
			),
		);
	}

	Widget _buildActivityPlaceholder() {
		return Container(
			height: 100,
			width: 200,
			decoration: BoxDecoration(
				color: AppColors.accent.withValues(alpha: 0.2),
				borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
			),
			child: const Center(
				child: Icon(Icons.event, size: 40, color: AppColors.accent),
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
