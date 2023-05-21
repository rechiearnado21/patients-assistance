import 'package:get/get.dart';
import 'package:nurse_assistance/routes/routes.dart';

import '../screens/doctor_dashboard.dart/index.dart';
import '../screens/landing/index.dart';
import '../screens/login/index.dart';
import '../screens/order/index.dart';
import '../screens/patient/index.dart';
import '../screens/signup/index.dart';
import '../screens/splash/index.dart';
import '../screens/view_order/index.dart';

class AppPages {
  static const initial = AppRoutes.initial;
  static const home = AppRoutes.home;
  static const login = AppRoutes.login;
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
    GetPage(
      name: AppRoutes.landing,
      page: () => const LandingScreen(),
      binding: LandingBinding(),
    ),
    GetPage(
      name: AppRoutes.doctorDashboard,
      page: () => const DoctorDashboardScreen(),
      binding: DoctorDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.order,
      page: () => const OrderScreen(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: AppRoutes.patient,
      page: () => const PatientScreen(),
      binding: PatientBinding(),
    ),
    GetPage(
      name: AppRoutes.viewOrder,
      page: () => const ViewOrderScreen(),
      binding: ViewOrderBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeScreen(),
    //   binding: HomeBinding(),
    // ),
  ];
}
