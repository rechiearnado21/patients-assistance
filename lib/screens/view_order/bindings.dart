import 'package:get/get.dart';
import 'controller.dart';

class ViewOrderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewOrderController>(() => ViewOrderController());
  }
}
