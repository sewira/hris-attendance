import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final GetStorage _box = GetStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  // Token
  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  static String? getToken() {
    return _box.read<String>(_tokenKey);
  }

  static Future<void> removeToken() async {
    await _box.remove(_tokenKey);
  }

  // User ID
  static Future<void> saveUserId(String userId) async {
    await _box.write(_userIdKey, userId);
  }

  static String? getUserId() {
    return _box.read<String>(_userIdKey);
  }

  // Clear all
  static Future<void> clearAll() async {
    await _box.erase();
  }
}
