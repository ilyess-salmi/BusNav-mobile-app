import 'package:get/get.dart';
import '../controllers/driver_trip_controller.dart';
import '../controllers/driver_location_controller.dart';
import '../../auth/controllers/auth_controller.dart';


class DriverTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DriverLocationController());
    Get.put(DriverTripController());  }
}
