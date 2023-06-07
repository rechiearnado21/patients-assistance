import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurse_assistance/notification_service.dart';
import 'package:nurse_assistance/screens/chart/add_chart.dart';
import 'package:nurse_assistance/screens/chart_view_order/chart_view_order_screen.dart';

import '../../database/notifications_table.dart';
import '../../dialogs.dart';
import '../../http_request.dart';
import '../../messages.dart';
import '../../variables.dart';
import '../chart_view/chart_view_screen.dart';

@pragma('vm:entry-point')
void oneShotAlarm() async {
  NotificationServices notificationServices = NotificationServices();

  await NotificationDatabase.instance
      .readAllNotifications()
      .then((value) async {
    for (dynamic item in value) {
      if (Variable.numSeconds(item["medic_date"]) <= 10 &&
          Variable.numSeconds(item["medic_date"]) >= -30) {
        notificationServices.sendNotification(
            item["chart_id"], item["patient_name"], item["medic_name"]);

        await Variable.flutterTts.speak(item["medic_name"]);

        Timer(const Duration(seconds: 4), () async {
          await Variable.flutterTts.speak(item["medic_name"]);
          // Timer(const Duration(seconds: 4), () async {
          //   await Variable.flutterTts.speak(item["medic_name"]);
          // });
        });
      }
    }
  });
}

class Chart extends StatefulWidget {
  final dynamic patientData;
  const Chart({super.key, required this.patientData});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  bool isLoading = true;
  List<dynamic> data = [];
  @override
  void initState() {
    getData();
    super.initState();
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
          "patient_id": widget.patientData["patient_id"],
        };
        HttpRequest(parameters: {"sqlCode": "T1352", "parameters": parameters})
            .post()
            .then((res) async {
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

            for (var item in res["rows"]) {
              if (item['is_done'] != 'Y') {
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
          'Charts',
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
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) =>
                      AddChart(data: widget.patientData, callBack: _refresh)),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 35,
              ),
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: const [
          //     Text(
          //       "Early",
          //       style: TextStyle(
          //         color: Colors.black54,
          //         fontSize: 10,
          //       ),
          //     ),
          //     Text(
          //       "On Time",
          //       style: TextStyle(
          //         color: Colors.black54,
          //         fontSize: 10,
          //       ),
          //     ),
          //     Text(
          //       "Late",
          //       style: TextStyle(
          //         color: Colors.black54,
          //         fontSize: 10,
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            width: 10,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
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
                                widget.patientData["full_name"],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                              ),
                            ),
                            Variable.horizontalSpace(10),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewChartOrderScreen(
                                      patientId:
                                          widget.patientData["patient_id"],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(15)),
                                child: const Center(
                                    child: Text(
                                  "Doctor's Order",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.white),
                                )),
                              ),
                            )
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
                              "Room No: ${widget.patientData["room_no"]}",
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
                              "Ward No: ${widget.patientData["ward_no"]}",
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
                              "Diagnosis: ${widget.patientData["diagnosis"]}",
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

              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 10),
                child: AutoSizeText(
                  "List of Charts",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                ),
              ),
              Expanded(
                  child: Container(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: data[index]['is_done'] == 'Y' ||
                                              data[index]['nurse_id'] !=
                                                  Variable
                                                      .userInfo["personnel_id"]
                                          ? null
                                          : () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChartViewScreen(
                                                    patientData: data[index],
                                                    callBack: _refresh,
                                                  ),
                                                ),
                                              );
                                            },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300)),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            data[index]
                                                                ['medic_name'],
                                                            maxFontSize: 14,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                        Variable
                                                            .horizontalSpace(
                                                                10),
                                                        data[index]['is_done'] ==
                                                                'Y'
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline_outlined,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : Variable
                                                                .horizontalSpace(
                                                                    1)
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Date: ${DateFormat.yMMMMd('en_US').format(DateTime.parse(data[index]['medic_date']))}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13),
                                                          ),
                                                          Variable
                                                              .verticalSpace(
                                                                  10),
                                                          Text(
                                                            'Time: ${DateFormat.jm().format(DateTime.parse(data[index]['medic_date']))}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13),
                                                          ),
                                                          Variable
                                                              .verticalSpace(
                                                                  10),
                                                          Text(
                                                            'Medication: ${data[index]['meal'] == 'N' ? 'N/A' : data[index]['meal']}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13),
                                                          ),
                                                          Variable
                                                              .verticalSpace(
                                                                  10),
                                                          Text(
                                                            'Status: ${data[index]['status'] == 'N' ? 'N/A' : data[index]['status']}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13),
                                                          ),
                                                          Variable
                                                              .verticalSpace(
                                                                  10),
                                                          Text(
                                                            'Encoded By: ${data[index]['encoded_by_name'].isEmpty ? 'N/A' : data[index]['encoded_by_name']}',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 13),
                                                          ),
                                                        ]),
                                                  )
                                                ]),
                                          ),
                                          Variable.verticalSpace(10)
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
              )),

              // const Center(
              //     child: Text(
              //   'Doctors Order',
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              // )),
              // Container(
              //   height: 20,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     Expanded(
              //         child: Text(
              //       "Date",
              //       style:
              //           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              //     )),
              //     Expanded(
              //         child: Text(
              //       "Order",
              //       style:
              //           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              //     )),
              //     Expanded(
              //         child: Text(
              //       "Rationale",
              //       style:
              //           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              //     )),
              //   ],
              // ),
              // Container(
              //   height: 10,
              // ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: doctorsOrderData.length,
              //     itemBuilder: (context, i) {
              //       return Column(
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Expanded(
              //                   child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Text(
              //                   doctorsOrderData[i]['date'],
              //                   softWrap: true,
              //                 ),
              //               )),
              //               Expanded(
              //                   child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Text(
              //                   doctorsOrderData[i]['order'],
              //                   softWrap: true,
              //                 ),
              //               )),
              //               Expanded(
              //                   child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Text(
              //                   doctorsOrderData[i]['rationale'],
              //                   softWrap: true,
              //                 ),
              //               )),
              //             ],
              //           ),
              //           Divider()
              //         ],
              //       );
              //     },
              //   ),
              // ),
              // Card()
            ],
          ),
        ),
      ),
    );
  }
}
