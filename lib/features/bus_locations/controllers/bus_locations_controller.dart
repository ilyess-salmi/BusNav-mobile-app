import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/bus_location_model.dart';

class BusLocationsController extends GetxController {
  // Map of busId → latest location so each bus has exactly one marker
  final busLocations = <int, BusLocationModel>{}.obs;

  StreamSubscription? _subscription;
  http.Client? _client;

  // Android emulator  → 10.0.2.2
  // iOS simulator     → localhost
  // Physical device   → your machine's local IP e.g. 192.168.1.x
  static const String _baseUrl = 'http://10.0.2.2:3000';

  @override
  void onInit() {
    super.onInit();
    _connectSSE();
  }

  Future<void> _connectSSE() async {
    _client = http.Client();

    final request = http.Request(
      'GET',
      Uri.parse('$_baseUrl/bus-locations/stream'),
    );

    // If your backend requires auth, add the token here
    // request.headers['Authorization'] = 'Bearer ${TokenStorage.getToken()}';

    try {
      final response = await _client!.send(request);

      if (response.statusCode != 200) {
        print('SSE connection failed: ${response.statusCode}');
        _scheduleReconnect();
        return;
      }

      print('SSE connected');

      _subscription = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            _onSseData,
            onError: (e) {
              print('SSE error: $e');
              _scheduleReconnect();
            },
            onDone: () {
              print('SSE stream closed');
              _scheduleReconnect();
            },
          );
    } catch (e) {
      print('SSE connect exception: $e');
      _scheduleReconnect();
    }
  }

  void _onSseData(String line) {
    // SSE lines look like:  data: {"bus_id":1,...}
    if (!line.startsWith('data:')) return;

    final jsonStr = line.substring(5).trim();
    if (jsonStr.isEmpty) return;

    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final location = BusLocationModel.fromJson(map);
      busLocations[location.busId] = location; // map auto-notifies Obx
      print('Bus ${location.busId} → ${location.latitude}, ${location.longitude}');
    } catch (e) {
      print('SSE parse error: $e');
    }
  }

  void _scheduleReconnect() {
    _subscription?.cancel();
    _client?.close();
    // Wait 3 seconds before reconnecting
    Future.delayed(const Duration(seconds: 3), _connectSSE);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _client?.close();
    super.onClose();
  }
}