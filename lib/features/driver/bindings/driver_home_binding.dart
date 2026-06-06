import 'package:get/get.dart';
import '../controllers/driver_home_controller.dart';
import '../controllers/driver_location_controller.dart';
import '../controllers/driver_trip_controller.dart';

class DriverHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DriverLocationController());
    Get.put(DriverTripController());
    Get.put(DriverHomeController());
  }
}
