import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../bus_lines/controllers/selected_bus_line_controller.dart';

import '../widgets/home_bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/home_map.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/nearby_bus_sheet.dart';
import '../../bus_locations/controllers/bus_locations_controller.dart';
import '../../bus_lines/controllers/get_line_points_controller.dart';

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
  final SelectedBusLineController selectedBusLineController =
      Get.put(SelectedBusLineController());
  final BusLocationsController busLocationsController =
      Get.put(BusLocationsController());
  final GetLinePointsController linePointsController =
      Get.put(GetLinePointsController());

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

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Exit App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB247FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Leave',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await _onWillPop();
        if (shouldExit && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
