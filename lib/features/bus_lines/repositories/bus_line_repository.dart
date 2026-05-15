import 'package:busnav/features/bus_lines/models/bus_line_points_model.dart';

import '../../../core/api/api_client.dart';
import '../models/bus_line_model.dart';

class BusLinesRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<BusLineModel>> getBusLines() async {
    final response = await _apiClient.get('/bus-lines');

    return (response.data as List)
        .map((json) => BusLineModel.fromJson(json))
        .toList();
  }

  Future<List<BusLinePointsModel>> getLinePoints(int lineId) async {
    final response = await _apiClient.get('/bus-line-points/$lineId');

    return (response.data as List)
      .map((json) => BusLinePointsModel.fromJson(json))
      .toList();
  }
}
