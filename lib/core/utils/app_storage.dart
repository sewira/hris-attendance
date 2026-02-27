import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final GetStorage _box = GetStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';

  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  static String? getToken() => _box.read<String>(_tokenKey);

  static Future<void> removeToken() async => _box.remove(_tokenKey);

  static bool isLoggedIn() => getToken() != null;

  static Future<void> saveUserId(String userId) async =>
      await _box.write(_userIdKey, userId);

  static String? getUserId() => _box.read<String>(_userIdKey);

  static Future<void> saveUserName(String name) async =>
      await _box.write(_userNameKey, name);

  static String? getUserName() => _box.read<String>(_userNameKey);

  static String _cardIndexKey(String userId) => 'dashboard_card_index_$userId';
  static String _cardDateKey(String userId) => 'dashboard_card_date_$userId';

  static Future<void> saveCardIndex(int index) async {
    final userId = getUserId();
    if (userId == null) return;

    final todayString = _formatDate(DateTime.now());

    await _box.write(_cardIndexKey(userId), index);
    await _box.write(_cardDateKey(userId), todayString);
  }

  static int getCardIndex() {
    final userId = getUserId();
    if (userId == null) return 0;

    final todayString = _formatDate(DateTime.now());

    final savedDate = _box.read<String>(_cardDateKey(userId));
    final savedIndex = _box.read<int>(_cardIndexKey(userId));

    if (savedDate != todayString) {
      _box.write(_cardIndexKey(userId), 0);
      _box.write(_cardDateKey(userId), todayString);
      return 0;
    }

    return savedIndex ?? 0;
  }

  static Future<void> resetCardIndex() async {
    final userId = getUserId();
    if (userId == null) return;

    await _box.write(_cardIndexKey(userId), 0);
    await _box.write(_cardDateKey(userId), _formatDate(DateTime.now()));
  }

  static String _clockInKey(String userId) => 'clock_in_$userId';
  static String _clockOutKey(String userId) => 'clock_out_$userId';
  static String _clockInDoneKey(String userId) => 'clock_in_done_$userId';
  static String _clockOutDoneKey(String userId) => 'clock_out_done_$userId';

  static Future<void> saveClockIn(String clockIn) async {
    final userId = getUserId();
    if (userId == null) return;
    await _box.write(_clockInKey(userId), clockIn);
    await _box.write(_clockInDoneKey(userId), true);
  }

  static String? getClockIn() {
    final userId = getUserId();
    if (userId == null) return null;
    return _box.read<String>(_clockInKey(userId));
  }

  static bool getIsClockInDone() {
    final userId = getUserId();
    if (userId == null) return false;
    return _box.read<bool>(_clockInDoneKey(userId)) ?? false;
  }

  static Future<void> saveClockOut(String clockOut) async {
    final userId = getUserId();
    if (userId == null) return;
    await _box.write(_clockOutKey(userId), clockOut);
    await _box.write(_clockOutDoneKey(userId), true);
  }

  static String? getClockOut() {
    final userId = getUserId();
    if (userId == null) return null;
    return _box.read<String>(_clockOutKey(userId));
  }

  static bool getIsClockOutDone() {
    final userId = getUserId();
    if (userId == null) return false;
    return _box.read<bool>(_clockOutDoneKey(userId)) ?? false;
  }

  static Future<void> resetClockState() async {
    final userId = getUserId();
    if (userId == null) return;
    await _box.remove(_clockInKey(userId));
    await _box.remove(_clockOutKey(userId));
    await _box.remove(_clockInDoneKey(userId));
    await _box.remove(_clockOutDoneKey(userId));
  }

  static String _formatDate(DateTime date) =>
      "${date.year}-${date.month}-${date.day}";

  static Future<void> logout() async {
    await _box.remove(_tokenKey);
    await _box.remove(_userIdKey);
    await _box.remove(_userNameKey);
  }

  //clear all
  static Future<void> clearAll() async => await _box.erase();
}
