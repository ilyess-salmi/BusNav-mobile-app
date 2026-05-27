import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'driver_nav_item.dart';

class DriverBottomNav extends StatelessWidget {
  final String activePage; // 'home' | 'trip' | 'profile'

  const DriverBottomNav({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DriverNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            active: activePage == 'home',
            onTap: () => Get.offAllNamed(AppRoutes.driverHome),
          ),
          DriverNavItem(
            icon: Icons.directions_bus_outlined,
            label: 'My Trip',
            active: activePage == 'trip',
            onTap: () => Get.toNamed(AppRoutes.driverTrip),
          ),
          DriverNavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            active: activePage == 'profile',
            onTap: () => Get.toNamed(AppRoutes.driverProfile),
          ),
        ],
      ),
    );
  }
}
