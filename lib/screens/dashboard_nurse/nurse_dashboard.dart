import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/notification_service.dart';
import 'package:nurse_assistance/variables.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chart/charting.dart';

@pragma('vm:entry-point')
void initilizeBackgroundService() async {
  NotificationServices notificationServices = NotificationServices();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String personnelId = prefs.getString("PERSONNELID") ?? "0";
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;

  notificationServices.initializeNotifications();

  int notifId = prefs.getInt("notification_id") ?? 0;
  int nNotifId = notifId + 1;

  prefs.setInt("notification_id", nNotifId);
  //notificationServices.sendNotification(nNotifId, 'Admin', item["message"]);

  if (int.parse(personnelId) == 0) return;

  Variable.checkInternet((hasInternet) {
    if (!hasInternet) {
    } else {
      var mapMsg = <String, dynamic>{};

      //mapMsg["lastsync"] = lastSyncMsg;
      mapMsg["nurse_id"] = int.parse(personnelId);

      Map<String, dynamic> parameters = {
        "nurse_id": Variable.userInfo["personnel_id"],
      };

      HttpRequest(parameters: {"sqlCode": "T1353", "parameters": parameters})
          .post()
          .then((res) async {
        if (res == null) {
        } else {
          for (var item in res["rows"]) {
            if (Variable.numSeconds(item["medic_date"]) <= 0) {
              int notifId = prefs.getInt("notification_id") ?? 0;
              int nNotifId = notifId + 1;

              prefs.setInt("notification_id", nNotifId);
              notificationServices.sendNotification(
                  nNotifId, 'Admin', item["message"]);

              await Variable.flutterTts
                  .speak('Patumara ang pasyenti sa room 201 ug paracetamol.');
            }
          }
        }
      });
    }
  });
}

class NurseDashboard extends StatefulWidget {
  const NurseDashboard({super.key});

  @override
  State<NurseDashboard> createState() => _NurseDashboardState();
}

class _NurseDashboardState extends State<NurseDashboard> {
  bool isLoading = true;
  List<dynamic> data = [];
  String filter = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> initiateNotify() async {
    await AndroidAlarmManager.initialize();
    const int helloAlarmID = 0;

    await AndroidAlarmManager.periodic(
        const Duration(seconds: 3), helloAlarmID, initilizeBackgroundService,
        startAt: DateTime.now());
  }

  Future<void> getData() async {
    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        setState(() {
          isLoading = false;
        });
        CustomDialog(
                message: Message.noInternet, isSuccess: false, isCancel: false)
            .defaultDialog();
      } else {
        Map<String, dynamic> parameters = {
          "nurse_id": Variable.userInfo["personnel_id"],
        };
        HttpRequest(parameters: {"sqlCode": "T1350", "parameters": parameters})
            .post()
            .then((res) {
          if (res == null) {
            setState(() {
              isLoading = false;
            });
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else {
            setState(() {
              data = res["rows"];
              isLoading = false;
            });
          }
        });
      }
    });
  }

  Future _refresh() async => setState(() {
        isLoading = true;
        getData();
      });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        backgroundColor: const Color(0xFF06919d),
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: const Color(0xFF06919d),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF06919d),
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 246, 248, 249),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF06919d),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage("assets/images/doctora.png"),
                                  )),
                            ),
                            Container(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Variable.userInfo["full_name"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                const Text(
                                  "Specialist",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80))),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.notifications,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: TextField(
                          autofocus: false,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              color: Colors.black54,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            hintText: 'Search Patient',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.only(left: 5),
                            hintStyle: const TextStyle(color: Colors.black54),
                          ),
                          onChanged: (text) {
                            // text = text.toLowerCase();
                            // setState(() {
                            //   ctr = 0;
                            //   if (text.isEmpty) {
                            //     _data = widget.data;
                            //   }
                            //   _data = _data.where((areaName) {
                            //     var noteTitle = areaName.parkAreaName
                            //         .toString()
                            //         .toLowerCase();
                            //     return noteTitle.contains(text);
                            //   }).toList();
                            // });
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.list,
                          color: Color.fromARGB(255, 7, 182, 235),
                        ),
                        Text(
                          " List of patients",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : !isLoading && data.isEmpty
                        ? GestureDetector(
                            onTap: _refresh,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Center(
                                  child: Text('No data found! Tap to refresh')),
                            ))
                        : StretchingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            child: RefreshIndicator(
                              onRefresh: _refresh,
                              child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (filter.isEmpty) {
                                      return lamingaNurse(
                                          data[index], size, index);
                                    } else {
                                      if (data[index]['full_name']
                                          .toLowerCase()
                                          .contains(filter.toLowerCase())) {
                                        return lamingaNurse(
                                            data[index], size, index);
                                      } else {
                                        return const SizedBox();
                                      }
                                    }
                                  }),
                            ),
                          ),
              ),
              // Expanded(
              //   child: ListView.builder(
              //       itemCount: 5,
              //       itemBuilder: (BuildContext context, int index) {
              //         return lamingaNurse(size);
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lamingaNurse(data, size, index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/profileimage.png"),
                                )),
                          ),
                          Container(
                            height: 40,
                          )
                        ],
                      ),
                      Container(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Task No: ${index + 1}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 1,
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                          AutoSizeText(
                            data["full_name"],
                            style: const TextStyle(
                              color: Color(0xFF255880),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 5,
                          ),
                          Text(
                            "Room No: ${data["room_no"]}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                          Text(
                            "Ward No: ${data["ward_no"]}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            height: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Colors.black54,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          duration: const Duration(milliseconds: 400),
                          alignment: Alignment.centerLeft,
                          child: Chart(patientData: data),
                        ),
                      );
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
