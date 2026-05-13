import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/main_page.dart';
import '../../presentation/screens/festival/festival_detail_page.dart';
import '../../presentation/screens/activity/activity_detail_page.dart';
import '../../presentation/screens/content/content_detail_page.dart';
import '../../presentation/screens/region/region_selector_page.dart';
import '../../presentation/screens/profile/login_page.dart';

final appRouter = GoRouter(
	initialLocation: '/',
	routes: [
		ShellRoute(
			builder: (context, state, child) => MainPage(child: child),
			routes: [
				GoRoute(
					path: '/',
					pageBuilder: (context, state) => const NoTransitionPage(
						child: HomePage(),
					),
				),
				GoRoute(
					path: '/calendar',
					pageBuilder: (context, state) => const NoTransitionPage(
						child: CalendarPage(),
					),
				),
				GoRoute(
					path: '/festival',
					pageBuilder: (context, state) => const NoTransitionPage(
						child: FestivalListPage(),
					),
				),
				GoRoute(
					path: '/activity',
					pageBuilder: (context, state) => const NoTransitionPage(
						child: ActivityListPage(),
					),
				),
				GoRoute(
					path: '/content',
					pageBuilder: (context, state) => const NoTransitionPage(
						child: ContentListPage(),
					),
				),
				GoRoute(
					path: '/profile',
					pageBuilder: (context, state) => const NoTransitionPage(
						child: ProfilePage(),
					),
				),
			],
		),
		GoRoute(
			path: '/festival/:id',
			builder: (context, state) => FestivalDetailPage(
				festivalId: int.parse(state.pathParameters['id']!),
			),
		),
		GoRoute(
			path: '/activity/:id',
			builder: (context, state) => ActivityDetailPage(
				activityId: int.parse(state.pathParameters['id']!),
			),
		),
		GoRoute(
			path: '/content/:id',
			builder: (context, state) => ContentDetailPage(
				contentId: int.parse(state.pathParameters['id']!),
			),
		),
		GoRoute(
			path: '/region-selector',
			builder: (context, state) => const RegionSelectorPage(),
		),
		GoRoute(
			path: '/login',
			builder: (context, state) => const LoginPage(),
		),
	],
);
