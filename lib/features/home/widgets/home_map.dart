import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../bus_locations/controllers/bus_locations_controller.dart';
import '../../bus_lines/controllers/selected_bus_line_controller.dart';
import '../../bus_lines/controllers/get_line_points_controller.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  static const LatLng _defaultCenter = LatLng(33.894, -5.555);
  final Completer<GoogleMapController> _mapController = Completer();

  final BusLocationsController _busLocCtrl =
      Get.find<BusLocationsController>();
  final SelectedBusLineController _selectedLineCtrl =
      Get.find<SelectedBusLineController>();
  final GetLinePointsController _linePointsCtrl =
      Get.find<GetLinePointsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bus markers
      final markers = _busLocCtrl.busLocations.map((location) {
        return Marker(
          markerId: MarkerId('bus_${location.locationId}'),
          position: LatLng(location.latitude, location.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
          infoWindow: InfoWindow(
            title: 'Bus ${location.locationId}',
            snippet: 'Speed: ${location.speed} km/h',
          ),
        );
      }).toSet();

      // route polyline
      final selectedId = _selectedLineCtrl.selectedLineId.value;
      Set<Polyline> polylines = {};

      if (selectedId != null && _linePointsCtrl.linePoints.isNotEmpty) {
        final routePoints = _linePointsCtrl.linePoints
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();

        polylines = {
          Polyline(
            polylineId: const PolylineId('selected_route'),
            points: routePoints,
            color: const Color(0xFF2563EB),
            width: 5,
          ),
        };
      }

      return GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _defaultCenter,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          if (!_mapController.isCompleted) {
            _mapController.complete(controller);
          }
        },
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
      );
    });
  }
}