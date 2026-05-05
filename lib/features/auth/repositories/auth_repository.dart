import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      {
        'user_email': email,
        'user_password': password,
      },
    );

    return response.data;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int roleId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      {
        'user_name': name,
        'user_email': email,
        'user_password': password,
        'user_phone': phone,
        'role_id': roleId,
      },
    );

    return response.data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiClient.get(ApiConstants.profile);
    return response.data;
  }
}