import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import 'home_nav_item.dart';

class HomeBottomNav extends StatelessWidget {
  final int activeIndex;

  const HomeBottomNav({
    super.key,
    this.activeIndex = 0, // 0=Home, 1=Bus Lines, 2=Favorites, 3=Notifications
  });

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
          HomeNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            active: activeIndex == 0,
            onTap: () => Get.offAllNamed(AppRoutes.home),
          ),
          HomeNavItem(
            icon: Icons.directions_bus_outlined,
            label: 'Bus Lines',
            active: activeIndex == 1,
            onTap: () => Get.toNamed(AppRoutes.busLines),
          ),
          HomeNavItem(
            icon: Icons.favorite_border,
            label: 'Favorites',
            active: activeIndex == 2,
          ),
          HomeNavItem(
            icon: Icons.notifications_none,
            label: 'Notifications',
            active: activeIndex == 3,
          ),
        ],
      ),
    );
  }
}