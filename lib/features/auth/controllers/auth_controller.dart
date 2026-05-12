import 'package:get/get.dart';

import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final isLoading = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final data = await _authRepository.login(
        email: email,
        password: password,
      );

      final token = data['access_token'];
      final userData = data['user'];

      await TokenStorage.saveToken(token);
      await TokenStorage.saveUserRole(userData['role']);

      currentUser.value = UserModel.fromJson(userData);

      Get.snackbar('Success', 'Logged in successfully fi');

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Login failed fi', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required int roleId,
  }) async {
    try {
      isLoading.value = true;

      await _authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        roleId: roleId,
      );

      Get.snackbar('Success', 'Account created successfully fi');

      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Register failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProfile() async {
    try {
      final data = await _authRepository.getProfile();
      currentUser.value = UserModel.fromJson(data);
    } catch (e) {
      await logout();
    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    currentUser.value = null;
    Get.offAllNamed('/login');
  }
}
