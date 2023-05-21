import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CustomDialog {
  final String message;
  final bool isCancel;
  final VoidCallback? onTap;
  final String? title;
  final bool isSuccess;

  const CustomDialog(
      {this.message = 'Default Message',
      this.isCancel = true,
      this.onTap,
      this.title,
      this.isSuccess = false});

  Future<void> defaultDialog() async => showAlertDialog();

  Future<void> loadingDialog() async => showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
            onWillPop: () async => isCancel,
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFffffff),
                ),
                child: Lottie.asset(
                  'assets/lottie/loader.json',
                ),
              ),
            ),
          ));
  Future<void> showAlertDialog() async => showCupertinoModalPopup<void>(
        context: Get.context!,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async {
            return isCancel;
          },
          child: CupertinoAlertDialog(
            title: Text(title ?? (isSuccess ? "Success" : "Error")),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(message),
            ),
            actions: <CupertinoDialogAction>[
              if (isCancel)
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Get.back();
                  if (onTap == null) return;
                  onTap!();
                },
                child: Text(
                  !isCancel ? 'Okay' : 'Yes',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
