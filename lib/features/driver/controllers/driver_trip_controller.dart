import 'package:get/get.dart';
import '../models/driver_trip_model.dart';
import '../repositories/driver_trip_repository.dart';
import 'driver_location_controller.dart';

class DriverTripController extends GetxController {
  final DriverTripRepository _repository = DriverTripRepository();
  final DriverLocationController locationController = Get.find();

  final isLoading = false.obs;
  final trips = <DriverTripModel>[].obs;
  final Rxn<DriverTripModel> activeTrip = Rxn<DriverTripModel>();

  // Replace with real driverId from AuthController
  int get driverId => 1;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    try {
      isLoading.value = true;
      trips.value = await _repository.getDriverTrips(driverId);
      // Set the first started/in_progress trip as active
      activeTrip.value = trips.firstWhereOrNull(
        (t) => t.tripStatus == 'started' || t.tripStatus == 'in_progress',
      );
    } catch (e) {
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
