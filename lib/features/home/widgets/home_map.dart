import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:latlong2/latlong.dart';
import '../../bus_locations/controllers/bus_locations_controller.dart';
import '../data/meknes_route_points.dart';
import '../../bus_lines/controllers/selected_bus_line_controller.dart';
import '../../bus_lines/controllers/get_line_points_controller.dart';

class HomeMap extends StatelessWidget {
  HomeMap({super.key});

  static const LatLng defaultCenter = LatLng(33.894, -5.555);
  final BusLocationsController controller = Get.find<BusLocationsController>();
  final SelectedBusLineController selectedLineController =
      Get.find<SelectedBusLineController>();
  final GetLinePointsController linePointsController =
      Get.find<GetLinePointsController>();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: defaultCenter,
        initialZoom: 14,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.busnav.app',
        ),
        Obx(() {
          final selectedId = selectedLineController.selectedLineId.value;
          print('Selected Line ID: $selectedId'); // Debug print

          if (selectedId == null) {
            print(
                'No line selected//null, skipping route rendering.'); // Debug print
            return const SizedBox.shrink();
          }

            final selectedRoute = linePointsController.linePoints.value
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            print('Selected Route Points: $selectedRoute'); // Debug print
  
            if (selectedRoute.isEmpty) {
              print('No route points found for line ID: $selectedId'); // Debug print
              return const SizedBox.shrink();
            }
          return PolylineLayer(
            polylines: [
              Polyline(
                points: selectedRoute,
                color: const Color(0xFF2563EB),
                strokeWidth: 5,
              ),
            ],
          );
        }),
        Obx(() {
          return MarkerLayer(
            markers: controller.busLocations.map((location) {
              return Marker(
                point: LatLng(location.latitude, location.longitude),
                width: 45,
                height: 45,
                child: const Icon(
                  Icons.directions_bus,
                  size: 34,
                  color: Colors.deepPurple,
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
