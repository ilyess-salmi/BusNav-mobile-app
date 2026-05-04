import 'package:busnav/app.dart';
import 'package:busnav/data/repositories/authentication_repo.dart';
import 'package:busnav/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // Todo: Add Widgets Binding
  WidgetsFlutterBinding.ensureInitialized();
  // Todo: Init Local Storage
  // Todo: Await Native Splash
  // Todo: Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: "auth_app_firebase",
  ).then((value) => Get.put(AuthenticationRepository()));
  // Todo: Initialize Authentication
  runApp(const App());
}
