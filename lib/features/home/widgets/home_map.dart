import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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

  final BusLocationsController _busLocCtrl = Get.find<BusLocationsController>();
  final SelectedBusLineController _selectedLineCtrl =
      Get.find<SelectedBusLineController>();
  final GetLinePointsController _linePointsCtrl =
      Get.find<GetLinePointsController>();

  @override
  void initState() {
    super.initState();

    // Whenever points load/change, zoom to polyline if a line is selected,
    // otherwise zoom to user location
    ever(_linePointsCtrl.linePoints, (_) async {
      final selectedId = _selectedLineCtrl.selectedLineId.value;
      if (selectedId != null && _linePointsCtrl.linePoints.isNotEmpty) {
        await _zoomToPolyline();
      }
    });

    // On map open: if a line is already selected show its polyline,
    // otherwise fall back to user location
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _mapController.future; // ensure map is ready
      final selectedId = _selectedLineCtrl.selectedLineId.value;
      if (selectedId != null && _linePointsCtrl.linePoints.isNotEmpty) {
        await _zoomToPolyline();
      } else if (selectedId == null) {
        await _zoomToUserLocation();
      }
    });
  }

  Future<void> _zoomToPolyline() async {
    try {
      final points = _linePointsCtrl.linePoints;
      if (points.isEmpty) return;

      double minLat = points.first.latitude;
      double maxLat = points.first.latitude;
      double minLng = points.first.longitude;
      double maxLng = points.first.longitude;

      for (final p in points) {
        if (p.latitude < minLat) minLat = p.latitude;
        if (p.latitude > maxLat) maxLat = p.latitude;
        if (p.longitude < minLng) minLng = p.longitude;
        if (p.longitude > maxLng) maxLng = p.longitude;
      }

      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 60), // 60px padding
      );
    } catch (_) {}
  }

  Future<void> _zoomToUserLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      // Check / request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      // Get position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Wait for map to be ready then animate camera
      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          ),
        ),
      );
    } catch (_) {
      // If anything fails, the map stays on the default center
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // bus markers
      final markers = _busLocCtrl.busLocations.values.map((location) {
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
