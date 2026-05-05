import 'package:get_storage/get_storage.dart';

class TokenStorage {
  static final GetStorage _box = GetStorage();

  static const String _tokenKey = 'access_token';
  static const String _userRoleKey = 'user_role';

  static Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  static String? getToken() {
    return _box.read<String>(_tokenKey);
  }

  static Future<void> saveUserRole(String role) async {
    await _box.write(_userRoleKey, role);
  }

  static String? getUserRole() {
    return _box.read<String>(_userRoleKey);
  }

  static Future<void> clear() async {
    await _box.remove(_tokenKey);
    await _box.remove(_userRoleKey);
  }

  static bool isLoggedIn() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}