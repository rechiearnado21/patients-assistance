import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/routes/page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LuvFare',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.green,
          primaryColorLight: const Color(0xFF4466a0),
          scaffoldBackgroundColor: Colors.white,
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.white),
          iconTheme: IconThemeData(color: Colors.grey.shade600)),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
