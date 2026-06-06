import 'package:get/get.dart';
import '../models/driver_trip_model.dart';
import '../repositories/driver_trip_repository.dart';
import 'driver_location_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class DriverTripController extends GetxController {
  final DriverTripRepository _repository = DriverTripRepository();
  final DriverLocationController locationController = Get.find();

  final isLoading = false.obs;
  final trips = <DriverTripModel>[].obs;
  final AuthController _authController = Get.find();
  final Rxn<DriverTripModel> activeTrip = Rxn<DriverTripModel>();

  int get driverId => _authController.currentUser.value?.driverId ?? 0;
  @override
  void onInit() {}

  Future<void> fetchTrips() async {
    try {
      isLoading.value = true;
      print("=================================================================");
      print('driverId: $driverId');
      print('currentUser: ${_authController.currentUser.value?.toJson()}');
      print('fetching trips for driverId: $driverId');
      print('driverid from model: ${_authController.currentUser.value?.driverId}');
      print("=================================================================");

      trips.value = await _repository.getDriverTrips(driverId);
      activeTrip.value = trips.firstWhereOrNull(
        (t) => t.tripStatus == 'started' || t.tripStatus == 'in_progress',
      );
    } catch (e) {
      print('fetchTrips error: $e');
      Get.snackbar('Error', 'Failed to load trips');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startTrip(DriverTripModel trip) async {
    try {
      await _repository.updateTripStatus(trip.tripId, 'in_progress');
      activeTrip.value = trip;
      locationController.startTracking(trip.busId);
      await fetchTrips();
      Get.snackbar('Trip started', 'Location tracking is now active');
    } catch (e) {
      Get.snackbar('Error', 'Failed to start trip');
    }
  }

  Future<void> endTrip(DriverTripModel trip) async {
    try {
      await _repository.endTrip(trip.tripId);
      locationController.stopTracking();
      activeTrip.value = null;
      await fetchTrips();
      Get.snackbar('Trip ended', 'Trip has been completed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to end trip');
    }
  }
}
