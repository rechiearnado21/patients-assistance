import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomModal {
  final BuildContext context;
  final bool? isCancel;
  final String? title;
  final String? msg;
  final Function()? onTap;

  const CustomModal(
      {required this.context, this.isCancel, this.title, this.msg, this.onTap});

  loader() => load(SizedBox(
        child: WillPopScope(
          onWillPop: () async => isCancel ?? false,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFffffff),
                ),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 15,
                    ),
                    CircularProgressIndicator(
                      color: Colors.purple,
                      backgroundColor: Colors.green,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    AutoSizeText(
                      "Please wait...",
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ));

  load(Widget child) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                child: widget,
              ));
        },
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return child;
        });
  }
}
