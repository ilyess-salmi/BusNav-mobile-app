import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class DriverProfileController extends GetxController {
  final AuthController authController = Get.find();

  String get name => authController.currentUser.value?.userName ?? '';
  String get email => authController.currentUser.value?.userEmail ?? '';

  Future<void> logout() async {
    await authController.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
