import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/bus_location_model.dart';

class BusLocationsController extends GetxController {
  final busLocations = <int, BusLocationModel>{}.obs;

  StreamSubscription? _subscription;
  http.Client? _client;
  bool _reconnecting = false;

  static const String _baseUrl = 'http://192.168.11.126:3003';

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
    if (!line.startsWith('data:')) return;
    final jsonStr = line.substring(5).trim();
    if (jsonStr.isEmpty) return;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      final location = BusLocationModel.fromJson(map);
      busLocations[location.busId] = location;
      print(
          'Bus ${location.busId} → ${location.latitude}, ${location.longitude}');
    } catch (e) {
      print('SSE parse error: $e');
    }
  }

  void _scheduleReconnect() {
    if (_reconnecting) return;
    _reconnecting = true; // ← lock
    _subscription?.cancel();
    _client?.close();
    Future.delayed(const Duration(seconds: 3), () {
      _reconnecting = false; // ← unlock before reconnecting
      _connectSSE();
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    _client?.close();
    super.onClose();
  }
}
