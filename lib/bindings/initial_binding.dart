import 'package:get/get.dart';

import '../features/auth/controllers/auth_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(
      AuthController(),
      permanent: true, //never destroyed, never recreated
    );
  }
}
