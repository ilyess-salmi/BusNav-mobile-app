import 'package:flutter/material.dart';

import 'home_nav_item.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HomeNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            active: true,
          ),
          HomeNavItem(
            icon: Icons.directions_bus_outlined,
            label: 'Bus Lines',
          ),
          HomeNavItem(
            icon: Icons.favorite_border,
            label: 'Favorites',
          ),
          HomeNavItem(
            icon: Icons.notifications_none,
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
