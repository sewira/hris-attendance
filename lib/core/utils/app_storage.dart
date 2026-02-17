import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final GetStorage _box = GetStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';

  //token
  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  static String? getToken() {
    return _box.read<String>(_tokenKey);
  }

  static Future<void> removeToken() async {
    await _box.remove(_tokenKey);
  }

  static bool isLoggedIn() {
    return getToken() != null;
  }

  //ID User
  static Future<void> saveUserId(String userId) async {
    await _box.write(_userIdKey, userId);
  }

  static String? getUserId() {
    return _box.read<String>(_userIdKey);
  }

  //User name
  static Future<void> saveUserName(String name) async {
    await _box.write(_userNameKey, name);
  }

  static String? getUserName() {
    return _box.read<String>(_userNameKey);
  }

  static Future<void> clearAll() async {
    await _box.erase();
  }
}
