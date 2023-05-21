import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final String email = prefs.getString("email") ?? "";
    final String password = prefs.getString("password") ?? "";

    if (email.isEmpty && password.isEmpty) {
      Timer(const Duration(seconds: 3), () {
        Get.toNamed(AppRoutes.login);
      });

      return;
    }

    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        labas();
        return;
      }

      Map<String, dynamic> parameters = {
        "email": email,
        "password": password,
      };

      HttpRequest(parameters: {"sqlCode": "T1341", "parameters": parameters})
          .post()
          .then((res) async {
        if (res == null) {
          labas();
          return;
        } else if (res["rows"].isNotEmpty) {
          Get.back();
          Variable.userInfo = res["rows"][0];
          if (Variable.userInfo["role_id"] == 1) {
            Get.offAndToNamed(AppRoutes.doctorDashboard);
          } else {
            Get.offAndToNamed(AppRoutes.landing);
          }
        } else {
          Get.offAndToNamed(AppRoutes.login);
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
