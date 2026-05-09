import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/providers/region_provider.dart';

class ProfilePage extends ConsumerWidget {
	const ProfilePage({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final user = ref.watch(currentUserProvider);
		final region = ref.watch(currentRegionProvider);

		return Scaffold(
			appBar: AppBar(
				title: const Text('我的'),
			),
			body: ListView(
				children: [
					// 用户信息卡片
					_buildUserCard(context, ref, user),
					const SizedBox(height: 12),
					// 当前地区
					_buildRegionCard(context, region),
					const SizedBox(height: 12),
					// 功能列表
					_buildMenuSection(context, ref, user),
				],
			),
		);
	}

	Widget _buildUserCard(BuildContext context, WidgetRef ref, dynamic user) {
		return Container(
			margin: const EdgeInsets.all(12),
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				gradient: LinearGradient(
					colors: [AppColors.primary, AppColors.primaryLight],
				),
				borderRadius: BorderRadius.circular(16),
			),
			child: user != null
				? Row(
					children: [
						CircleAvatar(
							radius: 35,
							backgroundColor: Colors.white,
							child: Text(
								user.displayName[0],
								style: const TextStyle(
									fontSize: 28,
									color: AppColors.primary,
									fontWeight: FontWeight.bold,
								),
							),
						),
						const SizedBox(width: 16),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										user.displayName,
										style: const TextStyle(
											fontSize: 20,
											fontWeight: FontWeight.bold,
											color: Colors.white,
										),
									),
									if (user.phone != null)
										Text(
											user.phone!,
											style: const TextStyle(
												color: Colors.white70,
											),
										),
								],
							),
						),
					],
				)
				: Column(
					children: [
						const CircleAvatar(
							radius: 35,
							backgroundColor: Colors.white24,
							child: Icon(Icons.person, size: 40, color: Colors.white),
						),
						const SizedBox(height: 12),
						ElevatedButton(
							onPressed: () => context.push('/login'),
							style: ElevatedButton.styleFrom(
								backgroundColor: Colors.white,
								foregroundColor: AppColors.primary,
							),
							child: const Text('登录/注册'),
						),
					],
				),
		);
	}

	Widget _buildRegionCard(BuildContext context, dynamic region) {
		return Card(
			margin: const EdgeInsets.symmetric(horizontal: 12),
			child: ListTile(
				leading: const Icon(Icons.location_on, color: AppColors.primary),
				title: Text(region?.name ?? '未选择地区'),
				subtitle: const Text('当前所在地区'),
				trailing: const Icon(Icons.chevron_right),
				onTap: () => context.push('/region-selector'),
			),
		);
	}

	Widget _buildMenuSection(BuildContext context, WidgetRef ref, dynamic user) {
		return Column(
			children: [
				_buildMenuItem(Icons.favorite, '我的收藏', () {}),
				_buildMenuItem(Icons.calendar_month, '我的日程', () {}),
				_buildMenuItem(Icons.history, '浏览历史', () {}),
				_buildMenuItem(Icons.settings, '设置', () {}),
				_buildMenuItem(Icons.info_outline, '关于我们', () {}),
				if (user != null)
					_buildMenuItem(
						Icons.logout,
						'退出登录',
						() => _showLogoutDialog(context, ref),
						color: AppColors.error,
					),
			],
		);
	}

	Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
		return Card(
			margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
			child: ListTile(
				leading: Icon(icon, color: color ?? AppColors.textSecondary),
				title: Text(
					title,
					style: TextStyle(color: color),
				),
				trailing: const Icon(Icons.chevron_right, size: 20),
				onTap: onTap,
			),
		);
	}

	void _showLogoutDialog(BuildContext context, WidgetRef ref) {
		showDialog(
			context: context,
			builder: (context) => AlertDialog(
				title: const Text('退出登录'),
				content: const Text('确定要退出登录吗？'),
				actions: [
					TextButton(
						onPressed: () => Navigator.pop(context),
						child: const Text('取消'),
					),
					TextButton(
						onPressed: () {
							ref.read(currentUserProvider.notifier).logout();
							Navigator.pop(context);
						},
						child: const Text('确定'),
					),
				],
			),
		);
	}
}
