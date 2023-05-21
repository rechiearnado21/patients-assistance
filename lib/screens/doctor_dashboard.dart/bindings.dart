import 'package:get/get.dart';
import 'controller.dart';

class DoctorDashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorDashboardController>(() => DoctorDashboardController());
  }
}
