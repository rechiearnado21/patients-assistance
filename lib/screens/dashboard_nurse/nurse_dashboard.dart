import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_assistance/database/notifications_table.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/notifications/notifications_screen.dart';
import 'package:nurse_assistance/variables.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chart/charting.dart';

class NurseDashboard extends StatefulWidget {
  const NurseDashboard({super.key});

  @override
  State<NurseDashboard> createState() => _NurseDashboardState();
}

class _NurseDashboardState extends State<NurseDashboard> {
  bool isLoading = true;
  List<dynamic> data = [];
  String filter = '';
  int noNotification = 0;

  @override
  void initState() {
    getNotificationCount();
    getData();
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();

      CustomDialog(
          message:
              "Notification permission denied. Open app settings to manage notification permission.",
          isSuccess: false,
          isCancel: false,
          title: 'Error',
          onTap: () {
            openAppSettings();
          }).defaultDialog();
    }

    if (status.isPermanentlyDenied) {
      CustomDialog(
          message:
              "Notification permission permanently denied. Open app settings to manage notification permission.",
          isSuccess: false,
          isCancel: false,
          title: 'Error',
          onTap: () {
            openAppSettings();
          }).defaultDialog();
    }
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

  void getNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      noNotification = prefs.getInt("NOOFNOTIFICATION") ?? 0;
    });

    Timer(const Duration(seconds: 5), () async {
      await NotificationDatabase.instance.readAllNotifications().then((value) {
        prefs.setInt("NOOFNOTIFICATION", value.length);

        setState(() {
          noNotification = value.length;
        });
        getNotificationCount();
      });
    });
  }

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
                        Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                            child: Stack(
                              fit: StackFit.loose,
                              clipBehavior: Clip.none,
                              alignment: const Alignment(1, -0.5),
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.notifications,
                                    size: 25,
                                    color: Theme.of(context)
                                        .listTileTheme
                                        .iconColor,
                                  ),
                                ),
                                noNotification > 0
                                    ? Positioned(
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.red),
                                          child: Center(
                                            child: SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: Center(
                                                child: AutoSizeText(
                                                  noNotification > 9
                                                      ? '9+'
                                                      : '$noNotification',
                                                  maxLines: 1,
                                                  maxFontSize: 11,
                                                  minFontSize: 8,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Color(0xFFffffff),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
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
    return GestureDetector(
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
      child: Padding(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.black54,
                        ),
                        Variable.verticalSpace(15),
                        Container(
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).primaryColor),
                          child: const Center(
                            child: Text(
                              'Recommend',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
