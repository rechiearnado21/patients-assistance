import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/notification_service.dart';
import 'package:nurse_assistance/routes/page.dart';
import 'package:nurse_assistance/variables.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/notifications_table.dart';
import 'http_request.dart';

@pragma('vm:entry-point')
void oneShotAlarm() async {
  NotificationServices notificationServices = NotificationServices();
  await NotificationDatabase.instance
      .readAllNotifications()
      .then((value) async {
    for (dynamic item in value) {
      if (Variable.numSeconds(item["medic_date"]) <= 0 &&
          Variable.numSeconds(item["medic_date"]) >= -30) {
        notificationServices.sendNotification(
            item["chart_id"], item["patient_name"], item["medic_name"]);

        await Variable.flutterTts.speak(item["medic_name"]);
        Timer(const Duration(seconds: 4), () async {
          await Variable.flutterTts.speak(item["medic_name"]);
        });
      }
    }
  });
}

@pragma('vm:entry-point')
void initilizeBackgroundService() async {
  NotificationServices notificationServices = NotificationServices();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String personnelId = prefs.getString("PERSONNELID") ?? "0";
  final String lastSyncDatetime = prefs.getString("LASTSYNCDATETIME") ??
      DateTime.now().toString().split('.')[0];

  notificationServices.initializeNotifications();

  if (int.parse(personnelId) == 0 || int.parse(personnelId) == 1) return;

  Variable.checkInternet((hasInternet) {
    if (!hasInternet) {
    } else {
      var parameters = <String, dynamic>{};

      parameters["in_dt"] = lastSyncDatetime;
      parameters["nurse_id"] = int.parse(personnelId);

      HttpRequest(parameters: {"sqlCode": "T1353", "parameters": parameters})
          .post()
          .then((res) async {
        if (res == null) {
        } else if (res["isSuccess"].toString() == "false") {
        } else {
          prefs.setString(
              "LASTSYNCDATETIME", DateTime.now().toString().split('.')[0]);
          for (var item in res["rows"]) {
            await NotificationDatabase.instance
                .readNotificationById(item['chart_id'])
                .then((value) async {
              if (value != null) {
              } else {
                await NotificationDatabase.instance.insertUpdate(item);

                await AndroidAlarmManager.oneShotAt(
                    DateTime.parse(item['medic_date']),
                    item['chart_id'],
                    oneShotAlarm);
              }
            });
          }
        }
      });
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var status = await Permission.notification.status;
  if (status.isDenied) {
    await Permission.notification.request();
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initiateNotify();
    super.initState();
    //getEMpty();
  }

  getEMpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", "");
    prefs.setString("password", "");
  }

  Future<void> initiateNotify() async {
    await AndroidAlarmManager.initialize();
    const int helloAlarmID = 0;

    await AndroidAlarmManager.periodic(
        const Duration(seconds: 3), helloAlarmID, initilizeBackgroundService,
        startAt: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Assistance App for Nurses',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF06919d),
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
