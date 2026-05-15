import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bus_line_controller.dart';
import '../widgets/bus_line_card.dart';
import '../../home/widgets/home_bottom_nav.dart';
import '../../home/widgets/home_header.dart';


class BusLinesScreen extends StatelessWidget {
  const BusLinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusLinesController>();

    return Scaffold(
      backgroundColor: const Color(0xFFE9DCF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(),
              const Text(
                'Bus Lines',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
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
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Where do you want to go?',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.busLines.isEmpty) {
                    return const Center(
                      child: Text('No bus lines found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.busLines.length,
                    itemBuilder: (context, index) {
                      return BusLineCard(
                        busLine: controller.busLines[index],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
