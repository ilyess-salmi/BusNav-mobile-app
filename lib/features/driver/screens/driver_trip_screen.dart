import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/driver_trip_controller.dart';
import '../widgets/driver_bottom_nav.dart';
import '../widgets/trip_status_card.dart';

class DriverTripScreen extends StatelessWidget {
  const DriverTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverTripController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F0FD),
      bottomNavigationBar: const DriverBottomNav(activePage: 'trip'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Trips',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFB247FF)),
          );
        }
        if (controller.trips.isEmpty) {
          return const Center(
            child: Text(
              'No trips assigned yet',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          );
        }
        return RefreshIndicator(
          color: const Color(0xFFB247FF),
          onRefresh: controller.fetchTrips,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.trips.length,
            itemBuilder: (context, index) {
              final trip = controller.trips[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TripStatusCard(
                  trip: trip,
                  onStart: trip.tripStatus == 'started'
                      ? () => controller.startTrip(trip)
                      : null,
                  onEnd: trip.tripStatus == 'in_progress'
                      ? () => controller.endTrip(trip)
                      : null,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}