import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/driver_location_controller.dart';

class DriverMap extends StatefulWidget {
  /// Route polyline points — if null no polyline is drawn
  final List<LatLng>? routePoints;

  const DriverMap({super.key, this.routePoints});

  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  static const LatLng _defaultCenter = LatLng(33.894, -5.555);
  final Completer<GoogleMapController> _mapController = Completer();
  final DriverLocationController _locationCtrl = Get.find();

  @override
  void didUpdateWidget(DriverMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When route points arrive (parent fetched them), fit the camera
    if (widget.routePoints != null &&
        widget.routePoints!.isNotEmpty &&
        widget.routePoints != oldWidget.routePoints) {
      _fitRoute(widget.routePoints!);
    }
  }

  Future<void> _fitRoute(List<LatLng> points) async {
    if (!_mapController.isCompleted) return;
    final controller = await _mapController.future;

    final minLat =
        points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    final maxLat =
        points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    final minLng =
        points.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    final maxLng =
        points.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        64,
      ),
    );
  }

  Future<void> _moveTo(LatLng pos) async {
    if (!_mapController.isCompleted) return;
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(pos));
  }

  @override
  Widget build(BuildContext context) {
    final points = widget.routePoints ?? [];

    // Build polyline
    final polylines = points.isNotEmpty
        ? {
            Polyline(
              polylineId: const PolylineId('trip_route'),
              points: points,
              color: const Color(0xFF2563EB),
              width: 5,
            ),
          }
        : <Polyline>{};

    // Start / end markers for the route
    final routeMarkers = <Marker>{};
    if (points.isNotEmpty) {
      routeMarkers.add(Marker(
        markerId: const MarkerId('route_start'),
        position: points.first,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Start'),
      ));
      routeMarkers.add(Marker(
        markerId: const MarkerId('route_end'),
        position: points.last,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'End'),
      ));
    }

    return Obx(() {
      final pos = _locationCtrl.currentPosition.value;

      // Follow driver when tracking is active and no route is shown
      if (pos != null && points.isEmpty) {
        _moveTo(pos);
      }

      final driverMarkers = pos != null
          ? {
              Marker(
                markerId: const MarkerId('driver_position'),
                position: pos,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet),
                infoWindow: InfoWindow(
                  title: 'Your position',
                  snippet:
                      'Speed: ${_locationCtrl.currentSpeed.value.toStringAsFixed(1)} km/h',
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
            if (points.isNotEmpty) {
              Future.delayed(
                const Duration(milliseconds: 300),
                () => _fitRoute(points),
              );
            }
          }
        },
        polylines: polylines,
        markers: {...routeMarkers, ...driverMarkers},
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
      );
    });
  }
}
