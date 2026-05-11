import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/festival_provider.dart';
import '../../../data/providers/activity_provider.dart';
import '../../../data/providers/holiday_provider.dart';
import '../../../data/models/festival.dart';
import '../../../data/models/activity.dart';
import '../../../data/models/holiday_schedule.dart';

class CalendarPage extends ConsumerStatefulWidget {
	const CalendarPage({super.key});

	@override
	ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
	DateTime _focusedDay = DateTime.now();
	DateTime? _selectedDay;
	CalendarFormat _calendarFormat = CalendarFormat.month;
	Map<DateTime, List<CalendarEvent>> _events = {};

	@override
	void initState() {
		super.initState();
		_fetchEvents(_focusedDay.year, _focusedDay.month);
	}

	void _fetchEvents(int year, int month) {
		ref.invalidate(calendarFestivalsProvider);
		ref.invalidate(calendarActivitiesProvider);
		ref.invalidate(calendarHolidaysProvider);
	}

	void _buildEventMap(
		List<Festival>? festivals,
		List<Activity>? activities,
		List<HolidaySchedule>? holidays,
	) {
		final map = <DateTime, List<CalendarEvent>>{};

		if (festivals != null) {
			for (final f in festivals) {
				final dates = _parseFestivalDates(f);
				for (final d in dates) {
					map.putIfAbsent(d, () => []).add(CalendarEvent(
						title: f.name,
						type: CalendarEventType.festival,
						festivalType: f.type,
					));
				}
			}
		}

		if (activities != null) {
			for (final a in activities) {
				if (a.startTime == null) continue;
				final d = _parseDate(a.startTime!);
				map.putIfAbsent(d, () => []).add(CalendarEvent(
					title: a.name,
					type: CalendarEventType.activity,
				));
			}
		}

		if (holidays != null) {
			for (final h in holidays) {
				final start = DateTime.tryParse(h.startDate);
				final end = DateTime.tryParse(h.endDate);
				if (start != null && end != null) {
					var d = start;
					while (!d.isAfter(end)) {
						map.putIfAbsent(d, () => []).add(CalendarEvent(
							title: '${h.festivalName ?? '放假'}',
							type: CalendarEventType.holiday,
						));
						d = d.add(const Duration(days: 1));
					}
				}
			}
		}

		_events = map;
	}

	List<DateTime> _parseFestivalDates(Festival f) {
		final dates = <DateTime>[];
		if (f.startDate == null) return dates;

		final start = DateTime.tryParse(f.startDate!);
		if (start != null) {
			dates.add(start);
			if (f.duration > 1) {
				for (int i = 1; i < f.duration; i++) {
					dates.add(start.add(Duration(days: i)));
				}
			}
		}
		return dates;
	}

	DateTime _parseDate(String s) {
		return DateTime.tryParse(s) ?? DateTime.now();
	}

	List<CalendarEvent> _getEventsForDay(DateTime day) {
		return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
	}

	@override
	Widget build(BuildContext context) {
		final festivalAsync = ref.watch(calendarFestivalsProvider(
			(year: _focusedDay.year, month: _focusedDay.month),
		));
		final activityAsync = ref.watch(calendarActivitiesProvider(
			(year: _focusedDay.year, month: _focusedDay.month),
		));
		final holidayAsync = ref.watch(calendarHolidaysProvider(
			(year: _focusedDay.year, month: _focusedDay.month),
		));

		festivalAsync.whenData((festivals) {
			activityAsync.whenData((activities) {
				holidayAsync.whenData((holidays) {
					_buildEventMap(festivals, activities, holidays);
				});
			});
		});

		return Scaffold(
			appBar: AppBar(
				title: const Text('日历'),
				actions: [
					IconButton(
						icon: const Icon(Icons.view_week),
						onPressed: () {
							setState(() {
								_calendarFormat = _calendarFormat == CalendarFormat.month
									? CalendarFormat.twoWeeks
									: CalendarFormat.month;
							});
						},
					),
				],
			),
			body: Column(
				children: [
					_buildCalendar(),
					const Divider(),
					Expanded(
						child: _buildDayDetail(),
					),
				],
			),
		);
	}

	Widget _buildCalendar() {
		return TableCalendar(
			locale: 'zh_CN',
			firstDay: DateTime(2020),
			lastDay: DateTime(2030),
			focusedDay: _focusedDay,
			selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
			calendarFormat: _calendarFormat,
			eventLoader: _getEventsForDay,
			onDaySelected: (selectedDay, focusedDay) {
				setState(() {
					_selectedDay = selectedDay;
					_focusedDay = focusedDay;
				});
			},
			onFormatChanged: (format) {
				setState(() {
					_calendarFormat = format;
				});
			},
			onPageChanged: (focusedDay) {
				setState(() {
					_focusedDay = focusedDay;
				});
				_fetchEvents(focusedDay.year, focusedDay.month);
			},
			startingDayOfWeek: StartingDayOfWeek.sunday,
			headerStyle: HeaderStyle(
				titleCentered: true,
				formatButtonVisible: false,
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
		);
	}

	Widget _buildDayDetail() {
		if (_selectedDay == null) {
			return const Center(
				child: Text('选择日期查看详情'),
			);
		}

		final dayEvents = _getEventsForDay(
			DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day),
		);

		return ListView(
			padding: const EdgeInsets.all(16),
			children: [
				Text(
					'${_selectedDay!.year}年${_selectedDay!.month}月${_selectedDay!.day}日',
					style: const TextStyle(
						fontSize: 20,
						fontWeight: FontWeight.bold,
					),
				),
				const SizedBox(height: 8),
				Text(
					'${_weekdayLabel(_selectedDay!.weekday)}',
					style: const TextStyle(color: AppColors.textSecondary),
				),
				const SizedBox(height: 16),
				if (dayEvents.isEmpty)
					_buildEmptyState()
				else
					...dayEvents.map((e) => _buildEventCard(e)),
			],
		);
	}

	Widget _buildEmptyState() {
		return Container(
			padding: const EdgeInsets.all(40),
			child: const Column(
				children: [
					Icon(Icons.event_busy, size: 48, color: AppColors.textHint),
					SizedBox(height: 12),
					Text('当天暂无节日或活动', style: TextStyle(color: AppColors.textHint)),
				],
			),
		);
	}

	Widget _buildEventCard(CalendarEvent event) {
		return Card(
			margin: const EdgeInsets.only(bottom: 8),
			child: ListTile(
				leading: Icon(
					event.icon,
					color: event.color,
				),
				title: Text(
					event.title,
					style: const TextStyle(fontWeight: FontWeight.w600),
				),
				subtitle: Text(event.typeLabel),
			),
		);
	}

	String _weekdayLabel(int weekday) {
		const labels = ['', '周一', '周二', '周三', '周四', '周五', '周六', '周日'];
		return labels[weekday];
	}
}

enum CalendarEventType { festival, activity, holiday }

class CalendarEvent {
	final String title;
	final CalendarEventType type;
	final int? festivalType;

	CalendarEvent({
		required this.title,
		required this.type,
		this.festivalType,
	});

	String get typeLabel {
		switch (type) {
			case CalendarEventType.festival: return '节日';
			case CalendarEventType.activity: return '活动';
			case CalendarEventType.holiday: return '放假';
		}
	}

	IconData get icon {
		switch (type) {
			case CalendarEventType.festival: return Icons.celebration;
			case CalendarEventType.activity: return Icons.event;
			case CalendarEventType.holiday: return Icons.beach_access;
		}
	}

	Color get color {
		switch (type) {
			case CalendarEventType.festival:
				switch (festivalType) {
					case 1: return AppColors.festivalLegal;
					case 2: return AppColors.festivalTraditional;
					case 3: return AppColors.festivalEthnic;
					default: return AppColors.primary;
				}
			case CalendarEventType.activity: return AppColors.accent;
			case CalendarEventType.holiday: return AppColors.gold;
		}
	}
}
