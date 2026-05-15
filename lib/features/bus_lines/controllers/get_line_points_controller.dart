import 'package:busnav/features/bus_lines/models/bus_line_points_model.dart';
import 'package:get/get.dart';
import 'selected_bus_line_controller.dart';
import '../repositories/bus_line_repository.dart';

class GetLinePointsController extends GetxController {
  final SelectedBusLineController selectedLineController = Get.find();
  final BusLinesRepository _repository = BusLinesRepository();
  final linePoints = <BusLinePointsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(selectedLineController.selectedLineId, (id) {
      if (id != null){
        fetchLinePoints();
      } 
       else {
        linePoints.clear(); // clear map when no line selected
      }
    });
  }

  Future<void> fetchLinePoints() async {
    final lineId = selectedLineController.selectedLineId.value;
    if (lineId != null) {
      try {
        linePoints.value = await _repository.getLinePoints(lineId);
      } catch (e) {
        Get.snackbar('Error', 'Failed to load line points');
      }
    }
  }
}