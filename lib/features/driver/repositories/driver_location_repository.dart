import '../../../core/api/api_client.dart';

class DriverLocationRepository {
  final ApiClient _apiClient = ApiClient();

  Future<void> postLocation({
    required int busId,
    required double latitude,
    required double longitude,
    required double speed,
  }) async {
    await _apiClient.post('/bus-locations', {
      'bus_id': busId,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
    });
  }
}
