import 'package:get/get.dart';
import '../controllers/driver_trip_controller.dart';
import '../controllers/driver_location_controller.dart';

class DriverTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DriverLocationController());
    Get.lazyPut(() => DriverTripController());
  }
}
