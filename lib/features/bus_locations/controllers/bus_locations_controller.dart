import 'package:get/get.dart';
import '../models/bus_location_model.dart';
import '../repositories/bus_locations_repository.dart';

class BusLocationsController extends GetxController {
  final BusLocationsRepository _repository = BusLocationsRepository();

  final isLoading = false.obs;
  final busLocations = <BusLocationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBusLocations();
  }

  Future<void> fetchBusLocations() async {
    try {
      isLoading.value = true;
      busLocations.value = await _repository.getBusLocations();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bus locations');
    } finally {
      isLoading.value = false;
    }
  }
}
