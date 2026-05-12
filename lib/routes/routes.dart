import 'package:busnav/common/widgets/success_screen/success_screen.dart';
import 'package:busnav/features/auth/screens/login/login_screen.dart';
import 'package:busnav/features/auth/screens/login/phone_number/phone_login_screen.dart';
import 'package:busnav/features/auth/screens/onboarding/onboarding_screen.dart';
import 'package:busnav/features/auth/screens/otp/otp_verification_screen.dart';
import 'package:busnav/features/auth/screens/password_config/forget_password_screen.dart';
import 'package:busnav/features/auth/screens/register/register_screen.dart';
import 'package:busnav/features/auth/screens/register/verify_email_screen.dart';
import 'package:busnav/features/auth/screens/splash_screen.dart';
import 'package:busnav/features/auth/screens/welcome_screen.dart';
import 'package:busnav/navigation_menu.dart';
import 'package:busnav/routes/routes_names.dart';
import 'package:busnav/utils/constants/images.dart';
import 'package:get/get.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(name: RoutesNames.splash_screen, page: () => SplashScreen()),
    GetPage(name: RoutesNames.navigation_menu, page: () => NaviagtionMenu()),
    GetPage(name: RoutesNames.forget_password_screen, page: () => const ForgetPasswordScreen()),
    GetPage(
      name: RoutesNames.success_screen,
      page: () => SuccessScreen(onPressed: () => print("success screen !"), imgUrl: MyImages.svgEmail, subTitle: "subTitle", title: "title"),
    ),
    GetPage(name: RoutesNames.verify_email_screen, page: () => const VerifyEmailScreen()),
    GetPage(name: RoutesNames.login_screen, page: () => PhoneLoginScreen()),
    GetPage(name: RoutesNames.signup_screen, page: () => RegisterScreen()),
    GetPage(
      name: RoutesNames.onboarding_screen,
      page: () => const OnboardingScreen(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(name: RoutesNames.welcome_screen, page: () => const WelcomeScreen()),
    
  ];
}
