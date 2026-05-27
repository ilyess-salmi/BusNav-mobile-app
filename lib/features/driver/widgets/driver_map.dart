import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/driver_location_controller.dart';

class DriverMap extends StatefulWidget {
  const DriverMap({super.key});

  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  static const LatLng _defaultCenter = LatLng(33.894, -5.555);
  final Completer<GoogleMapController> _mapController = Completer();

  final DriverLocationController _locationCtrl =
      Get.find<DriverLocationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final lat = _locationCtrl.currentLat.value;
      final lng = _locationCtrl.currentLng.value;
      final hasPosition = lat != 0.0 && lng != 0.0;

      final markers = hasPosition
          ? {
              Marker(
                markerId: const MarkerId('driver_position'),
                position: LatLng(lat, lng),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet,
                ),
                infoWindow: InfoWindow(
                  title: 'Your position',
                  snippet: 'Speed: ${_locationCtrl.currentSpeed.value.toStringAsFixed(1)} km/h',
                ),
              ),
            }
          : <Marker>{};

      return GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _defaultCenter,
          zoom: 15,
        ),
        onMapCreated: (controller) {
          if (!_mapController.isCompleted) {
            _mapController.complete(controller);
          }
        },
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
      );
    });
  }
}