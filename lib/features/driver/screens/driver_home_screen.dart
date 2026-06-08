import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/driver_home_controller.dart';
import '../controllers/driver_trip_controller.dart';
import '../controllers/driver_location_controller.dart';
import '../widgets/driver_bottom_nav.dart';
import '../widgets/driver_map.dart';
import '../widgets/trip_status_card.dart';
import '../../bus_lines/repositories/bus_line_repository.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final _tripController = Get.find<DriverTripController>();
  final _locationController = Get.find<DriverLocationController>();
  final _homeController = Get.find<DriverHomeController>();
  final _busLineRepo = BusLinesRepository();

  // Route points fed into DriverMap — empty until an active trip is found
  final _routePoints = <LatLng>[].obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _tripController.fetchTrips();
      _loadActiveRoute();
    });

    // Re-fetch route whenever activeTrip changes
    // (e.g. driver starts trip from the trip list screen and comes back home)
    ever(_tripController.activeTrip, (_) => _loadActiveRoute());
  }

  Future<void> _loadActiveRoute() async {
    final trip = _tripController.activeTrip.value;
    if (trip == null || trip.busLineId == 0) {
      _routePoints.clear();
      return;
    }
    try {
      final points = await _busLineRepo.getLinePoints(trip.busLineId);
      _routePoints.value =
          points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    } catch (_) {
      _routePoints.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const DriverBottomNav(activePage: 'home'),
      body: Stack(
        children: [
          // ── Map — receives route reactively ──────────────────────
          Obx(() => DriverMap(
                routePoints:
                    _routePoints.isEmpty ? null : _routePoints.toList(),
              )),

          // ── Header ───────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.93),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text('🚌 ', style: TextStyle(fontSize: 14)),
                        Text(
                          'Hello, ${_homeController.driverName}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => _locationController.isTracking.value
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('Tracking',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),

          // ── Active trip card ─────────────────────────────────────
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Obx(() {
              final trip = _tripController.activeTrip.value;
              if (trip == null) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'No active trip assigned',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                );
              }
              return TripStatusCard(
                trip: trip,
                onStart: () async {
                  await _tripController.startTrip(trip);
                  _loadActiveRoute(); // load route immediately after start
                },
                onEnd: () async {
                  await _tripController.endTrip(trip);
                  _routePoints.clear(); // clear route from map on end
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
