import 'package:get/get.dart';

import '../features/auth/controllers/auth_controller.dart';
import '../features/auth/screens/login/login_screen.dart';
import '../features/auth/screens/register/register_screen.dart';
import '../features/bus_lines/bindings/bus_lines_binding.dart';
import '../features/driver/bindings/driver_home_binding.dart';
import '../features/driver/bindings/driver_profile_binding.dart';
import '../features/driver/bindings/driver_trip_binding.dart';
import '../features/driver/screens/driver_home_screen.dart';
import '../features/driver/screens/driver_profile_screen.dart';
import '../features/driver/screens/driver_trip_screen.dart';

import '../features/home/screens/home_screen.dart';
import '../features/bus_lines/screens/bus_lines_screen.dart';


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
    // app_pages.dart
    GetPage(
      name: AppRoutes.driverHome,
      page: () => DriverHomeScreen(),
      binding: DriverHomeBinding(),
      ),
    GetPage(
      name: AppRoutes.driverTrip,
      page: () => DriverTripScreen(),
      binding: DriverTripBinding(),
    ),
    GetPage(
      name: AppRoutes.driverProfile,
      page: () => DriverProfileScreen(),
      binding: DriverProfileBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.driverReport,
    //   page: () => DriverReportProblemScreen(),
    // ),
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
