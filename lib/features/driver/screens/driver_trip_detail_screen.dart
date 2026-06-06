import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/driver_trip_controller.dart';
import '../controllers/driver_location_controller.dart';
import '../models/driver_trip_model.dart';
import '../repositories/driver_trip_repository.dart';
import '../../bus_lines/repositories/bus_line_repository.dart';

class DriverTripDetailScreen extends StatefulWidget {
  final DriverTripModel trip;
  const DriverTripDetailScreen({super.key, required this.trip});

  @override
  State<DriverTripDetailScreen> createState() => _DriverTripDetailScreenState();
}

class _DriverTripDetailScreenState extends State<DriverTripDetailScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final DriverTripController _tripController = Get.find();
  final DriverLocationController _locationController = Get.find();
  final BusLinesRepository _busLineRepo = BusLinesRepository();

  Set<Polyline> _polylines = {};
  bool _loadingRoute = true;

  @override
  void initState() {
    super.initState();
    _loadRoute();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    await _locationController.requestPermission();
  }

  Future<void> _loadRoute() async {
    try {
      final points = await _busLineRepo.getLinePoints(widget.trip.busLineId);
      final latLngs = points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('trip_route'),
            points: latLngs,
            color: const Color(0xFF2563EB),
            width: 5,
          ),
        };
        _loadingRoute = false;
      });
    } catch (e) {
      setState(() => _loadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    const LatLng defaultCenter = LatLng(33.894, -5.555);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Trip #${trip.tripId}',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Map with route
          Expanded(
            child: _loadingRoute
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFB247FF),
                    ),
                  )
                : GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: defaultCenter,
                      zoom: 13,
                    ),
                    onMapCreated: (controller) {
                      if (!_mapController.isCompleted) {
                        _mapController.complete(controller);
                      }
                    },
                    polylines: _polylines,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                  ),
          ),

          // Trip info + action button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trip #${trip.tripId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    _StatusBadge(status: trip.tripStatus),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.directions_bus,
                        size: 16, color: Colors.black45),
                    const SizedBox(width: 6),
                    Text(
                      'Bus #${trip.busId}',
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final isTracking = _locationController.isTracking.value;
                  if (trip.tripStatus == 'finished') {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (trip.tripStatus == 'started') {
                          await _tripController.startTrip(trip);
                          Get.back();
                        } else if (trip.tripStatus == 'in_progress') {
                          await _tripController.endTrip(trip);
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: trip.tripStatus == 'in_progress'
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFB247FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        trip.tripStatus == 'in_progress'
                            ? 'End Trip'
                            : 'Start Trip',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get color {
    switch (status) {
      case 'in_progress': return const Color(0xFF22C55E);
      case 'finished': return Colors.grey;
      default: return const Color(0xFFB247FF);
    }
  }

  String get label {
    switch (status) {
      case 'in_progress': return 'In Progress';
      case 'finished': return 'Finished';
      default: return 'Not Started';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}