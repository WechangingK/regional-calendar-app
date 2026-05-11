import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/constants/app_colors.dart';
import '../../../data/providers/user_provider.dart';

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
	final _emailController = TextEditingController();
	bool _isLogin = true;
	bool _isLoading = false;
	bool _obscurePassword = true;
	int _selectedGender = 0; // 0=未知, 1=男, 2=女

	@override
	void dispose() {
		_usernameController.dispose();
		_passwordController.dispose();
		_nicknameController.dispose();
		_phoneController.dispose();
		_emailController.dispose();
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
							_buildTextField(
								controller: _usernameController,
								label: '用户名',
								hint: '请输入用户名',
								icon: Icons.person_outline,
								validator: (v) {
									if (v == null || v.isEmpty) return '请输入用户名';
									if (v.length < 3) return '用户名至少3个字符';
									return null;
								},
							),
							const SizedBox(height: 16),
							// 密码
							_buildTextField(
								controller: _passwordController,
								label: '密码',
								hint: '请输入密码',
								icon: Icons.lock_outline,
								obscure: _obscurePassword,
								suffix: IconButton(
									icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
									onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
								),
								validator: (v) {
									if (v == null || v.isEmpty) return '请输入密码';
									if (v.length < 6) return '密码至少6位';
									return null;
								},
							),
							// 注册额外字段
							if (!_isLogin) ...[
								const SizedBox(height: 16),
								_buildTextField(
									controller: _nicknameController,
									label: '昵称',
									hint: '请输入昵称（选填）',
									icon: Icons.badge_outlined,
								),
								const SizedBox(height: 16),
								_buildTextField(
									controller: _phoneController,
									label: '手机号',
									hint: '请输入手机号（选填）',
									icon: Icons.phone_outlined,
									keyboardType: TextInputType.phone,
								),
								const SizedBox(height: 16),
								_buildTextField(
									controller: _emailController,
									label: '邮箱',
									hint: '请输入邮箱（选填）',
									icon: Icons.email_outlined,
									keyboardType: TextInputType.emailAddress,
								),
								const SizedBox(height: 16),
								// 性别选择
								_buildGenderSelector(),
							],
							const SizedBox(height: 24),
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

	Widget _buildTextField({
		required TextEditingController controller,
		required String label,
		required String hint,
		required IconData icon,
		bool obscure = false,
		Widget? suffix,
		TextInputType? keyboardType,
		String? Function(String?)? validator,
	}) {
		return TextFormField(
			controller: controller,
			obscureText: obscure,
			keyboardType: keyboardType,
			decoration: InputDecoration(
				labelText: label,
				hintText: hint,
				prefixIcon: Icon(icon),
				suffixIcon: suffix,
				border: OutlineInputBorder(
					borderRadius: BorderRadius.circular(12),
				),
				filled: true,
				fillColor: Colors.grey[50],
			),
			validator: validator,
		);
	}

	Widget _buildGenderSelector() {
		return InputDecorator(
			decoration: InputDecoration(
				labelText: '性别',
				border: OutlineInputBorder(
					borderRadius: BorderRadius.circular(12),
				),
				filled: true,
				fillColor: Colors.grey[50],
			),
			child: Row(
				children: [
					_buildGenderOption(0, '保密'),
					const SizedBox(width: 24),
					_buildGenderOption(1, '男'),
					const SizedBox(width: 24),
					_buildGenderOption(2, '女'),
				],
			),
		);
	}

	Widget _buildGenderOption(int value, String label) {
		return Row(
			mainAxisSize: MainAxisSize.min,
			children: [
				Radio<int>(
					value: value,
					groupValue: _selectedGender,
					activeColor: AppColors.primary,
					onChanged: (v) => setState(() => _selectedGender = v!),
				),
				Text(label),
			],
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
					email: _emailController.text.trim().isNotEmpty
						? _emailController.text.trim()
						: null,
					gender: _selectedGender > 0 ? _selectedGender : null,
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
						_emailController.clear();
						_selectedGender = 0;
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
