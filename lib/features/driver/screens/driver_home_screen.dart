import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/driver_home_controller.dart';
import '../controllers/driver_trip_controller.dart';
import '../controllers/driver_location_controller.dart';
import '../widgets/driver_bottom_nav.dart';
import '../widgets/driver_map.dart';
import '../widgets/trip_status_card.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<DriverHomeController>();
    final tripController = Get.find<DriverTripController>();
    final locationController = Get.find<DriverLocationController>();

    return Scaffold(
      bottomNavigationBar: const DriverBottomNav(activePage: 'home'),
      body: Stack(
        children: [
          DriverMap(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
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
                          'Hello, ${homeController.driverName}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() => locationController.isTracking.value
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
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Obx(() {
              final trip = tripController.activeTrip.value;
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
                onStart: () => tripController.startTrip(trip),
                onEnd: () => tripController.endTrip(trip),
              );
            }),
          ),
        ],
      ),
    );
  }
}