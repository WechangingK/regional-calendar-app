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
	bool _isLogin = true;
	bool _isLoading = false;

	@override
	void dispose() {
		_usernameController.dispose();
		_passwordController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(_isLogin ? '登录' : '注册'),
			),
			body: SingleChildScrollView(
				padding: const EdgeInsets.all(24),
				child: Form(
					key: _formKey,
					child: Column(
						children: [
							const SizedBox(height: 40),
							// Logo
							const Icon(
								Icons.celebration,
								size: 80,
								color: AppColors.primary,
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
							const SizedBox(height: 40),
							// 用户名
							TextFormField(
								controller: _usernameController,
								decoration: const InputDecoration(
									labelText: '用户名',
									prefixIcon: Icon(Icons.person),
									border: OutlineInputBorder(),
								),
								validator: (value) {
									if (value == null || value.isEmpty) {
										return '请输入用户名';
									}
									return null;
								},
							),
							const SizedBox(height: 16),
							// 密码
							TextFormField(
								controller: _passwordController,
								obscureText: true,
								decoration: const InputDecoration(
									labelText: '密码',
									prefixIcon: Icon(Icons.lock),
									border: OutlineInputBorder(),
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
							const SizedBox(height: 24),
							// 登录按钮
							SizedBox(
								width: double.infinity,
								height: 48,
								child: ElevatedButton(
									onPressed: _isLoading ? null : _handleSubmit,
									child: _isLoading
										? const SizedBox(
											width: 24,
											height: 24,
											child: CircularProgressIndicator(
												color: Colors.white,
												strokeWidth: 2,
											),
										)
										: Text(_isLogin ? '登录' : '注册'),
								),
							),
							const SizedBox(height: 16),
							// 切换登录/注册
							TextButton(
								onPressed: () {
									setState(() {
										_isLogin = !_isLogin;
									});
								},
								child: Text(
									_isLogin ? '没有账号？去注册' : '已有账号？去登录',
									style: const TextStyle(color: AppColors.primary),
								),
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
					_usernameController.text,
					_passwordController.text,
				);
				if (user != null && mounted) {
					context.pop();
				} else if (mounted) {
					ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(content: Text('登录失败，请检查用户名和密码')),
					);
				}
			} else {
				final repo = ref.read(userRepositoryProvider);
				final success = await repo.register(
					username: _usernameController.text,
					password: _passwordController.text,
				);
				if (success && mounted) {
					ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(content: Text('注册成功，请登录')),
					);
					setState(() => _isLogin = true);
				} else if (mounted) {
					ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(content: Text('注册失败')),
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
