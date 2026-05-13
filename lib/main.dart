import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/initial_binding.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/storage/token_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  runApp(const BusNavApp());
}

class BusNavApp extends StatelessWidget {
  const BusNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      title: 'BusNav',
      initialRoute:
          TokenStorage.isLoggedIn() ? AppRoutes.home : AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
