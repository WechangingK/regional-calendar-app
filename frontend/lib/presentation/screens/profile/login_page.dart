import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/user_provider.dart';
import '../../../data/repositories/user_repository.dart';

class LoginPage extends ConsumerStatefulWidget {
	const LoginPage({super.key});

	@override
	ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
	final _formKey = GlobalKey<FormState>();
	final _usernameController = TextEditingController();
	final _passwordController = TextEditingController();
	final _nicknameController = TextEditingController();
	final _phoneController = TextEditingController();
	bool _isLogin = true;
	bool _isLoading = false;
	bool _obscurePassword = true;

	@override
	void dispose() {
		_usernameController.dispose();
		_passwordController.dispose();
		_nicknameController.dispose();
		_phoneController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(_isLogin ? '登录' : '注册'),
				centerTitle: true,
			),
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(24),
				child: Form(
					key: _formKey,
					child: Column(
						children: [
							const SizedBox(height: 40),
							// Logo
							Container(
								width: 100,
								height: 100,
								decoration: BoxDecoration(
									color: AppColors.primary.withValues(alpha: 0.1),
									shape: BoxShape.circle,
								),
								child: const Icon(
									Icons.celebration,
									size: 60,
									color: AppColors.primary,
								),
							),
							const SizedBox(height: 16),
							const Text(
								'节日历',
								style: TextStyle(
									fontSize: 28,
									fontWeight: FontWeight.bold,
									color: AppColors.primary,
								),
							),
							const SizedBox(height: 8),
							Text(
								_isLogin ? '欢迎回来' : '创建新账号',
								style: const TextStyle(
									fontSize: 16,
									color: AppColors.textSecondary,
								),
							),
							const SizedBox(height: 40),
							// 用户名
							TextFormField(
								controller: _usernameController,
								decoration: InputDecoration(
									labelText: '用户名',
									hintText: '请输入用户名',
									prefixIcon: const Icon(Icons.person_outline),
									border: OutlineInputBorder(
										borderRadius: BorderRadius.circular(12),
									),
									filled: true,
									fillColor: Colors.grey[50],
								),
								validator: (value) {
									if (value == null || value.isEmpty) {
										return '请输入用户名';
									}
									if (value.length < 3) {
										return '用户名至少3个字符';
									}
									return null;
								},
							),
							const SizedBox(height: 16),
							// 密码
							TextFormField(
								controller: _passwordController,
								obscureText: _obscurePassword,
								decoration: InputDecoration(
									labelText: '密码',
									hintText: '请输入密码',
									prefixIcon: const Icon(Icons.lock_outline),
									suffixIcon: IconButton(
										icon: Icon(
											_obscurePassword ? Icons.visibility_off : Icons.visibility,
										),
										onPressed: () {
											setState(() {
												_obscurePassword = !_obscurePassword;
											});
										},
									),
									border: OutlineInputBorder(
										borderRadius: BorderRadius.circular(12),
									),
									filled: true,
									fillColor: Colors.grey[50],
								),
								validator: (value) {
									if (value == null || value.isEmpty) {
										return '请输入密码';
									}
									if (value.length < 6) {
										return '密码至少6位';
									}
									return null;
								},
							),
							// 注册额外字段
							if (!_isLogin) ...[
								const SizedBox(height: 16),
								TextFormField(
									controller: _nicknameController,
									decoration: InputDecoration(
										labelText: '昵称',
										hintText: '请输入昵称（选填）',
										prefixIcon: const Icon(Icons.badge_outlined),
										border: OutlineInputBorder(
											borderRadius: BorderRadius.circular(12),
										),
										filled: true,
										fillColor: Colors.grey[50],
									),
								),
								const SizedBox(height: 16),
								TextFormField(
									controller: _phoneController,
									keyboardType: TextInputType.phone,
									decoration: InputDecoration(
										labelText: '手机号',
										hintText: '请输入手机号（选填）',
										prefixIcon: const Icon(Icons.phone_outlined),
										border: OutlineInputBorder(
											borderRadius: BorderRadius.circular(12),
										),
										filled: true,
										fillColor: Colors.grey[50],
									),
								),
							],
							const SizedBox(height: 24),
							// 登录/注册按钮
							SizedBox(
								width: double.infinity,
								height: 50,
								child: ElevatedButton(
									onPressed: _isLoading ? null : _handleSubmit,
									style: ElevatedButton.styleFrom(
										backgroundColor: AppColors.primary,
										foregroundColor: Colors.white,
										shape: RoundedRectangleBorder(
											borderRadius: BorderRadius.circular(12),
										),
									),
									child: _isLoading
										? const SizedBox(
											width: 24,
											height: 24,
											child: CircularProgressIndicator(
												color: Colors.white,
												strokeWidth: 2,
											),
										)
										: Text(
											_isLogin ? '登录' : '注册',
											style: const TextStyle(fontSize: 16),
										),
								),
							),
							const SizedBox(height: 16),
							// 切换登录/注册
							Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									Text(
										_isLogin ? '还没有账号？' : '已有账号？',
										style: const TextStyle(color: AppColors.textSecondary),
									),
									TextButton(
										onPressed: () {
											setState(() {
												_isLogin = !_isLogin;
											});
										},
										child: Text(
											_isLogin ? '立即注册' : '去登录',
											style: const TextStyle(
												color: AppColors.primary,
												fontWeight: FontWeight.bold,
											),
										),
									),
								],
							),
						],
					),
				),
			),
		);
	}

	Future<void> _handleSubmit() async {
		if (!_formKey.currentState!.validate()) return;

		setState(() => _isLoading = true);

		try {
			if (_isLogin) {
				final user = await ref.read(currentUserProvider.notifier).login(
					_usernameController.text.trim(),
					_passwordController.text,
				);
				if (user != null && mounted) {
					ScaffoldMessenger.of(context).showSnackBar(
						SnackBar(
							content: Text('欢迎回来，${user.displayName}！'),
							backgroundColor: AppColors.success,
						),
					);
					context.pop();
				} else if (mounted) {
					ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(
							content: Text('登录失败，请检查用户名和密码'),
							backgroundColor: AppColors.error,
						),
					);
				}
			} else {
				final repo = ref.read(userRepositoryProvider);
				final success = await repo.register(
					username: _usernameController.text.trim(),
					password: _passwordController.text,
					nickname: _nicknameController.text.trim().isNotEmpty
						? _nicknameController.text.trim()
						: null,
					phone: _phoneController.text.trim().isNotEmpty
						? _phoneController.text.trim()
						: null,
				);
				if (success && mounted) {
					ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(
							content: Text('注册成功，请登录'),
							backgroundColor: AppColors.success,
						),
					);
					setState(() {
						_isLogin = true;
						_nicknameController.clear();
						_phoneController.clear();
					});
				} else if (mounted) {
					ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(
							content: Text('注册失败，用户名可能已存在'),
							backgroundColor: AppColors.error,
						),
					);
				}
			}
		} finally {
			if (mounted) {
				setState(() => _isLoading = false);
			}
		}
	}
}
