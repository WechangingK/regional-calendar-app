import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
	static const String _tokenKey = 'auth_token';
	static const String _userIdKey = 'user_id';
	static const String _regionIdKey = 'region_id';
	static const String _regionNameKey = 'region_name';

	// Token
	static Future<void> saveToken(String token) async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setString(_tokenKey, token);
	}

	static Future<String?> getToken() async {
		final prefs = await SharedPreferences.getInstance();
		return prefs.getString(_tokenKey);
	}

	static Future<void> removeToken() async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.remove(_tokenKey);
	}

	// 用户ID
	static Future<void> saveUserId(int userId) async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setInt(_userIdKey, userId);
	}

	static Future<int?> getUserId() async {
		final prefs = await SharedPreferences.getInstance();
		return prefs.getInt(_userIdKey);
	}

	// 当前地区
	static Future<void> saveRegion(int regionId, String regionName) async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.setInt(_regionIdKey, regionId);
		await prefs.setString(_regionNameKey, regionName);
	}

	static Future<int?> getRegionId() async {
		final prefs = await SharedPreferences.getInstance();
		return prefs.getInt(_regionIdKey);
	}

	static Future<String?> getRegionName() async {
		final prefs = await SharedPreferences.getInstance();
		return prefs.getString(_regionNameKey);
	}

	// 清除所有数据
	static Future<void> clearAll() async {
		final prefs = await SharedPreferences.getInstance();
		await prefs.clear();
	}
}
