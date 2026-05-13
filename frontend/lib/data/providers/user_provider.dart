import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/local_storage.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

// 当前登录用户
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
	return CurrentUserNotifier(ref);
});

class CurrentUserNotifier extends StateNotifier<User?> {
	final Ref ref;

	CurrentUserNotifier(this.ref) : super(null) {
		_checkLogin();
	}

	Future<void> _checkLogin() async {
		final token = await LocalStorage.getToken();
		if (token != null) {
			final repo = ref.read(userRepositoryProvider);
			state = await repo.getProfile();
		}
	}

	Future<User?> login(String username, String password) async {
		final repo = ref.read(userRepositoryProvider);
		final user = await repo.login(username: username, password: password);
		state = user;
		return user;
	}

	Future<void> logout() async {
		final repo = ref.read(userRepositoryProvider);
		await repo.logout();
		state = null;
	}

	bool get isLoggedIn => state != null;
}
