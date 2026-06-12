import 'package:get/get.dart';

import '../controllers/favorite_controller.dart';

class FavoritePlacesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritePlacesController>(() => FavoritePlacesController());
  }
}
