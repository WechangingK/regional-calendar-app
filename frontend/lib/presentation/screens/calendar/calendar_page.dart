import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../app/constants/app_colors.dart';

class CalendarPage extends StatefulWidget {
	const CalendarPage({super.key});

	@override
	State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
	DateTime _focusedDay = DateTime.now();
	DateTime? _selectedDay;
	CalendarFormat _calendarFormat = CalendarFormat.month;

	@override
	Widget build(BuildContext context) {
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
				_focusedDay = focusedDay;
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
				markerDecoration: BoxDecoration(
					color: AppColors.festivalEthnic,
					shape: BoxShape.circle,
				),
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
				const Text(
					'农历信息加载中...',
					style: TextStyle(color: AppColors.textSecondary),
				),
				const SizedBox(height: 16),
				_buildSection('节日', [
					_buildInfoTile('暂无节日信息', Icons.celebration),
				]),
				const SizedBox(height: 16),
				_buildSection('活动', [
					_buildInfoTile('暂无活动信息', Icons.event),
				]),
				const SizedBox(height: 16),
				_buildSection('日程', [
					_buildInfoTile('暂无日程安排', Icons.schedule),
				]),
			],
		);
	}

	Widget _buildSection(String title, List<Widget> children) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(
					title,
					style: const TextStyle(
						fontSize: 16,
						fontWeight: FontWeight.w600,
						color: AppColors.primary,
					),
				),
				const SizedBox(height: 8),
				...children,
			],
		);
	}

	Widget _buildInfoTile(String text, IconData icon) {
		return Card(
			child: ListTile(
				leading: Icon(icon, color: AppColors.textHint),
				title: Text(text),
			),
		);
	}
}
