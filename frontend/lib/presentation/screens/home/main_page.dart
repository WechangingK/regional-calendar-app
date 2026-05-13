import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

export '../calendar/calendar_page.dart';
export '../festival/festival_list_page.dart';
export '../activity/activity_list_page.dart';
export '../content/content_list_page.dart';
export '../profile/profile_page.dart';
export 'home_page.dart';

class MainPage extends StatelessWidget {
	final Widget child;

	const MainPage({super.key, required this.child});

	int _getCurrentIndex(BuildContext context) {
		final location = GoRouterState.of(context).uri.path;
		if (location == '/') return 0;
		if (location == '/calendar') return 1;
		if (location == '/festival') return 2;
		if (location == '/profile') return 3;
		return 0;
	}

	void _onTap(BuildContext context, int index) {
		switch (index) {
			case 0: context.go('/');
			case 1: context.go('/calendar');
			case 2: context.go('/festival');
			case 3: context.go('/profile');
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: child,
			bottomNavigationBar: BottomNavigationBar(
				currentIndex: _getCurrentIndex(context),
				onTap: (index) => _onTap(context, index),
				items: const [
					BottomNavigationBarItem(
						icon: Icon(Icons.home_outlined),
						activeIcon: Icon(Icons.home),
						label: '首页',
					),
					BottomNavigationBarItem(
						icon: Icon(Icons.calendar_today_outlined),
						activeIcon: Icon(Icons.calendar_today),
						label: '日历',
					),
					BottomNavigationBarItem(
						icon: Icon(Icons.celebration_outlined),
						activeIcon: Icon(Icons.celebration),
						label: '节日',
					),
					BottomNavigationBarItem(
						icon: Icon(Icons.person_outline),
						activeIcon: Icon(Icons.person),
						label: '我的',
					),
				],
			),
		);
	}
}
