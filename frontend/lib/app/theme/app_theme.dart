import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
	static ThemeData get lightTheme {
		return ThemeData(
			useMaterial3: true,
			brightness: Brightness.light,
			primaryColor: AppColors.primary,
			scaffoldBackgroundColor: AppColors.background,
			colorScheme: ColorScheme.fromSeed(
				seedColor: AppColors.primary,
				brightness: Brightness.light,
			),
			appBarTheme: const AppBarTheme(
				backgroundColor: AppColors.primary,
				foregroundColor: AppColors.textWhite,
				elevation: 0,
				centerTitle: true,
			),
			cardTheme: CardThemeData(
				color: AppColors.card,
				elevation: 2,
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(12),
				),
			),
			bottomNavigationBarTheme: const BottomNavigationBarThemeData(
				backgroundColor: AppColors.surface,
				selectedItemColor: AppColors.primary,
				unselectedItemColor: AppColors.textHint,
				type: BottomNavigationBarType.fixed,
			),
			textTheme: const TextTheme(
				headlineLarge: TextStyle(
					fontSize: 24,
					fontWeight: FontWeight.bold,
					color: AppColors.textPrimary,
				),
				headlineMedium: TextStyle(
					fontSize: 20,
					fontWeight: FontWeight.bold,
					color: AppColors.textPrimary,
				),
				titleLarge: TextStyle(
					fontSize: 18,
					fontWeight: FontWeight.w600,
					color: AppColors.textPrimary,
				),
				titleMedium: TextStyle(
					fontSize: 16,
					fontWeight: FontWeight.w500,
					color: AppColors.textPrimary,
				),
				bodyLarge: TextStyle(
					fontSize: 16,
					color: AppColors.textPrimary,
				),
				bodyMedium: TextStyle(
					fontSize: 14,
					color: AppColors.textSecondary,
				),
				bodySmall: TextStyle(
					fontSize: 12,
					color: AppColors.textHint,
				),
			),
			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ElevatedButton.styleFrom(
					backgroundColor: AppColors.primary,
					foregroundColor: AppColors.textWhite,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(8),
					),
					padding: const EdgeInsets.symmetric(
						horizontal: 24,
						vertical: 12,
					),
				),
			),
		);
	}
}
