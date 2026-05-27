import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class DriverHomeController extends GetxController {
  final AuthController authController = Get.find();

  String get driverName =>
      authController.currentUser.value?.userName ?? 'Driver';
}
