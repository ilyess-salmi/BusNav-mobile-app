import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repositories/driver_location_repository.dart';

class DriverLocationController extends GetxController {
  final DriverLocationRepository _repository = DriverLocationRepository();

  final isTracking = false.obs;
  final currentLat = 0.0.obs;
  final currentLng = 0.0.obs;
  final currentSpeed = 0.0.obs;
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();

  Timer? _timer;
  int? activeBusId;

  Future<void> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Get.snackbar(
          'Permission denied', 'Location access is required for tracking');
    }
  }

  void startTracking(int busId) async {
    activeBusId = busId;
    isTracking.value = true;

    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Get.snackbar(
          'Permission denied', 'Location access is required for tracking');
      isTracking.value = false;
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _pushLocation();
    });

    // Push immediately on start
    await _pushLocation();
  }

  Future<void> _pushLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      currentSpeed.value = position.speed;
      currentPosition.value =
          LatLng(position.latitude, position.longitude); // ← was missing

      await _repository.postLocation(
        busId: activeBusId!,
        latitude: position.latitude,
        longitude: position.longitude,
        speed: position.speed,
      );
    } catch (e) {
      // Silent fail — will retry on next tick
    }
  }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    isTracking.value = false;
    currentPosition.value = null; // clear marker from map on end
  }

  @override
  void onClose() {
    stopTracking();
    super.onClose();
  }
}
