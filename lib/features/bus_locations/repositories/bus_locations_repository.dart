import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';
import '../models/bus_location_model.dart';

class BusLocationsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<BusLocationModel>> getBusLocations() async {
    final response = await _apiClient.get(ApiConstants.busLocations);

    final List data = response.data;

    return data.map((json) => BusLocationModel.fromJson(json)).toList();
  }
}
