import 'package:flutter/material.dart';
import '../models/bus_line_model.dart';
import '../controllers/selected_bus_line_controller.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class BusLineCard extends StatelessWidget {
  final BusLineModel busLine;

  const BusLineCard({
    super.key,
    required this.busLine,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final selectedController = Get.find<SelectedBusLineController>();
        selectedController.selectLine(busLine.busLineId);
        Get.offNamed(AppRoutes.home);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFCB82FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  busLine.lineName.replaceAll('Line ', ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    busLine.lineName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${busLine.startPoint} → ${busLine.endPoint}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFFB247FF),
            ),
          ],
        ),
      ),
    );
  }
}
