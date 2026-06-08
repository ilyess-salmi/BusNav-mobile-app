import '../../../core/api/api_client.dart';
import '../models/driver_trip_model.dart';

class DriverTripRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<DriverTripModel>> getDriverTrips(int driverId) async {
    final response = await _apiClient.get('/trips?driver_id=$driverId');
    final List data = response.data as List;
    print(response.data);
    return data.map((e) => DriverTripModel.fromJson(e)).toList();
  }

  Future<DriverTripModel> getTripById(int tripId) async {
    final response = await _apiClient.get('/trips/$tripId');
    return DriverTripModel.fromJson(response.data);
  }

  Future<void> updateTripStatus(int tripId, String status) async {
    await _apiClient.patch('/trips/$tripId', {'trip_status': status});
  }

  Future<void> endTrip(int tripId) async {
    await _apiClient.patch('/trips/$tripId', {
      'trip_status': 'finished',
      'end_time': DateTime.now().toIso8601String(),
    });
  }
}
