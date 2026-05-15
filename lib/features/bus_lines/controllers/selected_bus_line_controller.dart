import 'package:get/get.dart';

class SelectedBusLineController extends GetxController {
  final selectedLineId = Rxn<int>();

  void selectLine(int lineId) {
    selectedLineId.value = lineId;
  }

  void clearSelection() {
    selectedLineId.value = null;
  }
}

