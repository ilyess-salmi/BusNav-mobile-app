import 'package:flutter/material.dart';

import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/home_map.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/nearby_bus_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _navVisible = true;
  double _lastScrollOffset = 0;

  late final AnimationController _navAnimController;
  late final Animation<Offset> _navSlideAnim;

  @override
  void initState() {
    super.initState();

    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _navSlideAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(
      CurvedAnimation(
        parent: _navAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _onSheetScroll(double offset) {
    final delta = offset - _lastScrollOffset;

    if (delta > 4 && _navVisible) {
      setState(() => _navVisible = false);
      _navAnimController.forward();
    } else if (delta < -4 && !_navVisible) {
      setState(() => _navVisible = true);
      _navAnimController.reverse();
    }

    _lastScrollOffset = offset;
  }

  @override
  void dispose() {
    _navAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: SlideTransition(
        position: _navSlideAnim,
        child: const HomeBottomNav(),
      ),
      body: Stack(
        children: [
          const HomeMap(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  HomeHeader(),
                  SizedBox(height: 10),
                  HomeSearchBar(),
                ],
              ),
            ),
          ),
          NearbyBusSheet(
            onScroll: _onSheetScroll,
          ),
        ],
      ),
    );
  }
}
