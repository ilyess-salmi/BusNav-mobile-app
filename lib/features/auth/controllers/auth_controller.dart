import 'package:get/get.dart';

import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final isLoading = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  RxBool isGuest = false.obs;

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

      print('LOGIN DATA: $data');

      final token = data['access_token'];
      final userData = data['user'] ?? data;

      if (token != null) {
        await TokenStorage.saveToken(token);
      }

      if (userData['role'] != null) {
        await TokenStorage.saveUserRole(userData['role'].toString());
      }

      currentUser.value = UserModel.fromJson(userData);

      Get.snackbar('Success', 'Logged in successfully');

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Login failed', e.toString());
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

  Future<void> loginGuest() async {
    try {
      isGuest.value = true;
      await TokenStorage.saveGuestMode(true);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Guest Login failed', e.toString());
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
