import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.runMyApplication();
    return Scaffold(
        body: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.black,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: ColoredBox(
        color: Colors.white,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [
                    Image(
                      image: AssetImage(
                        'assets/images/splash.jpg',
                      ),
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Patient Assistance',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        'assets/lottie/loader.json',
                      ),
                    ),
                    const Text(
                      'Copyright 2023 Thesis Project',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
