import 'package:busnav/features/driver/screens/driver_trip_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../models/driver_trip_model.dart';

class TripStatusCard extends StatelessWidget {
  final DriverTripModel trip;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;

  const TripStatusCard({
    super.key,
    required this.trip,
    this.onStart,
    this.onEnd,
  });

  Color get _statusColor {
    switch (trip.tripStatus) {
      case 'in_progress':
        return const Color(0xFF22C55E);
      case 'finished':
        return Colors.grey;
      default:
        return const Color(0xFFB247FF);
    }
  }

  String get _statusLabel {
    switch (trip.tripStatus) {
      case 'in_progress':
        return 'In Progress';
      case 'finished':
        return 'Finished';
      default:
        return 'Not Started';
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => DriverTripDetailScreen(trip: trip),
      ),
      child: Container(
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
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.directions_bus, size: 16, color: Colors.black45),
                const SizedBox(width: 6),
                Text('Bus #${trip.busId}',
                    style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (trip.tripStatus == 'started' && onStart != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onStart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB247FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Start Trip',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                if (trip.tripStatus == 'in_progress' && onEnd != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onEnd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('End Trip',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
              ],
            ),
          ],
        ),   // closes Column
      ),     // closes Container
    );       // closes GestureDetector
  }
}
