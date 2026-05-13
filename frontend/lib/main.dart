import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_router.dart';
import 'app/theme/app_theme.dart';

void main() {
	runApp(
		const ProviderScope(
			child: RegionalCalendarApp(),
		),
	);
}

class RegionalCalendarApp extends StatelessWidget {
	const RegionalCalendarApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp.router(
			title: '节日历',
			theme: AppTheme.lightTheme,
			routerConfig: appRouter,
			debugShowCheckedModeBanner: false,
			localizationsDelegates: const [
				GlobalMaterialLocalizations.delegate,
				GlobalWidgetsLocalizations.delegate,
				GlobalCupertinoLocalizations.delegate,
			],
			supportedLocales: const [
				Locale('zh', 'CN'),
				Locale('en', 'US'),
			],
			locale: const Locale('zh', 'CN'),
		);
	}
}
