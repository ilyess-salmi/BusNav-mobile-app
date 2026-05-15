import 'package:get/get.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/screens/login/login_screen.dart';
import '../features/auth/screens/register/register_screen.dart';
import '../features/bus_lines/bindings/bus_lines_binding.dart';

import '../features/home/screens/home_screen.dart';
import '../features/bus_lines/screens/bus_lines_screen.dart';
import '../features/bus_stops/screens/bus_stops_screen.dart';
import '../features/predictions/screens/predictions_screen.dart';
import '../features/favorites/screens/favorites_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/trips/screens/trips_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.busLines,
      page: () => const BusLinesScreen(),
      binding: BusLinesBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.busStops,
    //   page: () => const BusStopsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.predictions,
    //   page: () => const PredictionsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.favorites,
    //   page: () => const FavoritesScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.notifications,
    //   page: () => const NotificationsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => const ProfileScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.trips,
    //   page: () => const TripsScreen(),
    // ),
  ];
}
