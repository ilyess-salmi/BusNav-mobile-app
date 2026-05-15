import 'package:get/get.dart';
import '../models/bus_line_model.dart';
import '../repositories/bus_line_repository.dart';

class BusLinesController extends GetxController {
  final BusLinesRepository _repository = BusLinesRepository();

  final isLoading = false.obs;
  final busLines = <BusLineModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBusLines();
  }

  Future<void> fetchBusLines() async {
    try {
      isLoading.value = true;
      busLines.value = await _repository.getBusLines();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bus lines');
    } finally {
      isLoading.value = false;
    }
  }
}
