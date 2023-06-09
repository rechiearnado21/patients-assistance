import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/database/notifications_table.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/notification_service.dart';
import 'package:nurse_assistance/notifications/notifications_screen.dart';
import 'package:nurse_assistance/screens/my_record/my_records.dart';
import 'package:nurse_assistance/variables.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../chart/charting.dart';
import '../profile/update_profile.dart';

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

class NurseDashboard extends StatefulWidget {
  const NurseDashboard({super.key});

  @override
  State<NurseDashboard> createState() => _NurseDashboardState();
}

class _NurseDashboardState extends State<NurseDashboard> {
  bool isLoading = true;
  List<dynamic> data = [];
  String filter = '';
  TextEditingController controller = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  int noNotification = 0;

  @override
  void initState() {
    getNotificationCount();
    getData();
    initPlatformState();
    super.initState();
  }

  List<dynamic> dept = [
    {"dept": "Gastroentrology", "value": 1},
    {"dept": "Gynaecology", "value": 2},
    {"dept": "Cardiology", "value": 3},
    {"dept": "Neurology", "value": 4},
    {"dept": "Pediatrics", "value": 5},
  ];
  List<dynamic> typeOfUserData = [
    {"type": "Doctor", "value": 1},
    {"type": "Nurse", "value": 2}
  ];
  String myType(id) {
    var depName = typeOfUserData
        .where((element) {
          return element["value"] == id;
        })
        .toList()[0]["type"]
        .toString();

    return depName;
  }

  String myDept(id) {
    var depName = dept
        .where((element) {
          return element["value"] == id;
        })
        .toList()[0]["dept"]
        .toString();

    return depName;
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

  Future<void> getNotificationCount() async {
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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        const UpdateProfile()),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.purple,
                                radius: 30,
                                backgroundImage: Variable
                                            .userInfo["image_file"] ==
                                        ""
                                    ? const AssetImage(
                                        'assets/images/doctora.png')
                                    : MemoryImage(
                                        const Base64Decoder().convert(
                                            Variable.userInfo["image_file"]),
                                      ) as ImageProvider,
                              ),
                              // Container(
                              //   width: 50,
                              //   height: 50,
                              //   decoration: const BoxDecoration(
                              //       shape: BoxShape.circle,
                              //       image: DecorationImage(
                              //         fit: BoxFit.cover,
                              //         image: AssetImage(
                              //             "assets/images/doctora.png"),
                              //       )),
                              // ),
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
                                Text(
                                  "${myType(Variable.userInfo["role_id"])}/${myDept(Variable.userInfo["department_id"])}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                  softWrap: true,
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
                          focusNode: searchFocusNode,
                          controller: controller,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.only(left: 20),
                            hintStyle: const TextStyle(color: Colors.black54),
                            suffixIcon: InkWell(
                              onTap: filter.isEmpty
                                  ? () {
                                      searchFocusNode.requestFocus();
                                    }
                                  : () {
                                      controller.clear();
                                      setState(() {
                                        filter = '';
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                              child: filter.isEmpty
                                  ? const Icon(Icons.search)
                                  : const Icon(Icons.close),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              filter = value;
                            });
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.list,
                          color: Color.fromARGB(255, 7, 182, 235),
                        ),
                        Text(
                          " List of Patients",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const MyRecords()),
                          ),
                        );
                      },
                      padding: const EdgeInsets.only(right: 0),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.pie_chart_rounded,
                                color: Colors.purple,
                              ),
                              Text(
                                "Records",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                    Expanded(
                      child: Row(
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
                          Expanded(
                            child: Column(
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
                                Text(
                                  "Diagnosis: ${data["diagnosis"]}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.black54,
                        ),
                        Variable.verticalSpace(15),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => RecommendationsScreen(
                                      callBack: _refresh,
                                      data: data,
                                    )),
                              ),
                            );
                          },
                          child: Container(
                            height: 35,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).primaryColor),
                            child: const Center(
                              child: Text(
                                'Recommend',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
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

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen(
      {super.key, required this.callBack, required this.data});

  final Function() callBack;
  final dynamic data;

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List<dynamic> listOfNursedata = [];
  bool loadingNurse = true;
  String filter = '';
  TextEditingController controller = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    getListOfNurse();
    super.initState();
  }

  void getListOfNurse() async {
    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        setState(() {
          loadingNurse = false;
        });
        CustomDialog(
                message: Message.noInternet, isSuccess: false, isCancel: false)
            .defaultDialog();
      } else {
        Map<String, dynamic> parameters = {
          "department_id": Variable.userInfo["department_id"],
        };
        HttpRequest(parameters: {"sqlCode": "T1342", "parameters": parameters})
            .post()
            .then((res) {
          if (res == null) {
            setState(() {
              loadingNurse = false;
            });
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else {
            setState(() {
              listOfNursedata = res["rows"]
                  .where((e) =>
                      e["personnel_id"] != Variable.userInfo["personnel_id"])
                  .toList();

              loadingNurse = false;
            });
          }
        });
      }
    });
  }

  Future _refreshNurse() async => setState(() {
        loadingNurse = true;
        getListOfNurse();
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).primaryColor,
              size: 30,
            )),
        title: Text(
          'Recommend',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white),
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300)),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            widget.data["full_name"],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                          ),
                        ),
                        Variable.horizontalSpace(1),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Room No: ${widget.data["room_no"]}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          maxLines: 2,
                        ),
                        Container(
                          height: 10,
                        ),
                        Text(
                          "Ward No: ${widget.data["ward_no"]}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          maxLines: 2,
                        ),
                        Container(
                          height: 10,
                        ),
                        Text(
                          "Diagnosis: ${widget.data["diagnosis"]}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: TextField(
                focusNode: searchFocusNode,
                controller: controller,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: 'Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(left: 20),
                  hintStyle: const TextStyle(color: Colors.black54),
                  suffixIcon: InkWell(
                    onTap: filter.isEmpty
                        ? () {
                            searchFocusNode.requestFocus();
                          }
                        : () {
                            controller.clear();
                            setState(() {
                              filter = '';
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                    child: filter.isEmpty
                        ? const Icon(Icons.search)
                        : const Icon(Icons.close),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    filter = value;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.list,
                      color: Color.fromARGB(255, 7, 182, 235),
                    ),
                    Text(
                      " List of Nurses",
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
          const Divider(),
          Expanded(
            child: loadingNurse
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  )
                : !loadingNurse && listOfNursedata.isEmpty
                    ? GestureDetector(
                        onTap: _refreshNurse,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                              child: Text('No data found! Tap to refresh')),
                        ))
                    : StretchingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        child: RefreshIndicator(
                          onRefresh: _refreshNurse,
                          child: ListView.builder(
                              itemCount: listOfNursedata.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (filter.isEmpty) {
                                  return listTileBottomSheet(
                                      listOfNursedata[index]);
                                } else {
                                  if (listOfNursedata[index]['full_name']
                                      .toLowerCase()
                                      .contains(filter.toLowerCase())) {
                                    return listTileBottomSheet(
                                        listOfNursedata[index]);
                                  } else {
                                    return const SizedBox();
                                  }
                                }
                              }),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> submitAssignedPatient(nurseData) async {
    const CustomDialog(isCancel: false).loadingDialog();
    // print(nurseData["personnel_id"]);
    Variable.checkInternet((hasInternet) async {
      if (hasInternet) {
        Map<String, dynamic> parameters = {
          "assigned_id": widget.data['assigned_id'],
          "patient_id": widget.data['patient_id'],
          "nurse_id": nurseData["personnel_id"],
        };

        HttpRequest(parameters: {"sqlCode": "T1349", "parameters": parameters})
            .post()
            .then((res) async {
          if (res == null) {
            Get.back();
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else if (res["rows"].isNotEmpty) {
            if (res["rows"][0]["success"] == "Y") {
              await NotificationDatabase.instance
                  .deleteAllByNurseId(Variable.userInfo["personnel_id"])
                  .then((value) {
                Get.back();
                widget.callBack();
                CustomDialog(
                    title: "Success",
                    message: res["rows"][0]["msg"],
                    isSuccess: false,
                    isCancel: false,
                    onTap: () {
                      Get.back();
                    }).defaultDialog();
              });
            } else {
              CustomDialog(
                      message: res["rows"][0]["msg"],
                      isSuccess: false,
                      isCancel: false)
                  .defaultDialog();
            }
          } else {
            Get.back();

            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          }
        });
      } else {
        Get.back();
        CustomDialog(
                message: Message.noInternet, isSuccess: false, isCancel: false)
            .defaultDialog();
      }
    });
  }

  Widget listTileBottomSheet(dataNurse) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          if (dataNurse["shift"] == 'N') {
            const CustomDialog(
              title: 'Oopss',
              isCancel: false,
              message: 'This nurse is currently not available.',
            ).defaultDialog();
          } else {
            CustomDialog(
                title: 'Hang on',
                message: 'Are you sure you want to recommend this patient?',
                onTap: () => submitAssignedPatient(dataNurse)).defaultDialog();
          }
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 10,
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: 30,
                  backgroundImage: dataNurse["image_file"].isEmpty
                      ? const AssetImage('assets/images/doctora.png')
                      : MemoryImage(
                          const Base64Decoder()
                              .convert(dataNurse["image_file"]),
                        ) as ImageProvider,
                ),
                title: AutoSizeText(
                  dataNurse["full_name"],
                  style: const TextStyle(
                    color: Color(0xFF255880),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      dataNurse["shift"] == 'N'
                          ? Icons.clear
                          : Icons.check_circle_outline,
                      color:
                          dataNurse["shift"] == 'N' ? Colors.red : Colors.green,
                      size: 15,
                    ),
                    Variable.horizontalSpace(5),
                    AutoSizeText(
                      dataNurse["shift"] == 'N'
                          ? 'Not Available'
                          : '${dataNurse["shift"]} Shift',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
