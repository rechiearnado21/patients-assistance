import 'package:get/get.dart';
import 'controller.dart';

class PatientBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientController>(() => PatientController());
  }
}
