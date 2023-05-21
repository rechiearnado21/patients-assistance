import 'package:get/get.dart';
import 'package:nurse_assistance/routes/routes.dart';

import '../screens/login/index.dart';
import '../screens/signup/index.dart';
import '../screens/splash/index.dart';

class AppPages {
  static const initial = AppRoutes.initial;
  static const home = AppRoutes.home;
  static const login = AppRoutes.login;
  static const ticketing = AppRoutes.ticketing;
  static const vehicleReg = AppRoutes.vehicleReg;
  static const deviceReg = AppRoutes.deviceReg;
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeScreen(),
    //   binding: HomeBinding(),
    // ),
  ];
}
