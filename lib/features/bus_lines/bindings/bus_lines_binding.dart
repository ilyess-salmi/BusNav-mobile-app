import 'package:get/get.dart';
import '../controllers/bus_line_controller.dart';

class BusLinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusLinesController>(() => BusLinesController());
  }
}
