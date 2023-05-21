import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api_keys.dart';
import '../../dialogs.dart';
import '../../http_request.dart';
import '../../messages.dart';
import '../../routes/routes.dart';
import '../../variables.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Future<void> runTest() async {
    Timer(const Duration(seconds: 3), () {
      Get.offAndToNamed(AppRoutes.login);
    });
  }

  Future<void> runMyApplication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userName = prefs.getString("username") ?? "";
    final String password = prefs.getString("password") ?? "";

    if (userName.isEmpty && password.isEmpty) {
      Timer(const Duration(seconds: 3), () {
        Get.toNamed(AppRoutes.home);
      });

      return;
    }

    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        labas();
        return;
      }

      HttpRequest(parameters: {'username': userName, 'password': password})
          .post()
          .then((value) async {
        if (value == null) {
          labas();
          return;
        } else if (value["items"].isNotEmpty) {
          Variable.userInfo = value["items"][0];
          Get.offAndToNamed(AppRoutes.login);
        } else {
          Get.offAndToNamed(AppRoutes.deviceReg);
        }
      });
    });
  }

  void labas() {
    CustomDialog(
            isSuccess: false,
            isCancel: false,
            message: Message.noInternet,
            onTap: () {
              SystemNavigator.pop();
            },
            title: 'Error')
        .defaultDialog();
  }

  SplashController();
}
