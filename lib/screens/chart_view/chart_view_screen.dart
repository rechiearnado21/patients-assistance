import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurse_assistance/database/notifications_table.dart';

import '../../dialogs.dart';
import '../../http_request.dart';
import '../../messages.dart';
import '../../variables.dart';
import '../../widgets/widgets.dart';
import '../chart_view_order/chart_view_order_screen.dart';

class ChartViewScreen extends StatefulWidget {
  const ChartViewScreen({super.key, this.patientData, required this.callBack});
  final dynamic patientData;
  final Function() callBack;

  @override
  State<ChartViewScreen> createState() => _ChartViewScreenState();
}

class _ChartViewScreenState extends State<ChartViewScreen> {
  bool _isDisabled = true;
  List<dynamic> statuses = [
    {"text": "Carried", "value": "Carried"},
    {"text": "Administired", "value": "Administired"},
    {"text": "Requested", "value": "Requested"},
    {"text": "Endosed", "value": "Endosed"},
    {"text": "Discontinued", "value": "Discontinued"},
  ];
  String? statusVal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Update Chart',
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          widget.patientData["patient_name"],
                          style: const TextStyle(
                              color: Colors.black,
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
                                patientId: widget.patientData["patient_id"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Text(
                            "Doctor's Order",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).primaryColor),
                          )),
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Text(
                        "Room No: ",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                        maxLines: 2,
                      ),
                      Expanded(
                        child: Text(
                          '${widget.patientData["room_no"]}',
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Ward No: ",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                        maxLines: 2,
                      ),
                      Expanded(
                        child: Text(
                          '${widget.patientData["ward_no"]}',
                          style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
                child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Variable.verticalSpace(10),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order: ${widget.patientData['medic_name']}',
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      Variable.verticalSpace(10),
                                      Text(
                                        'Date: ${DateFormat.yMMMMd('en_US').format(DateTime.parse(widget.patientData['medic_date']))}',
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      Variable.verticalSpace(10),
                                      Text(
                                        'Time: ${DateFormat.jm().format(DateTime.parse(widget.patientData['medic_date']))}',
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      Variable.verticalSpace(10),
                                      Text(
                                        'Nurse: ${Variable.userInfo['full_name']}',
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ]),
                              )
                            ]),
                      ),
                      Variable.verticalSpace(20)
                    ],
                  ),
                  DropdownButtonFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Select Status",
                      border: Variable.myinputborder(),
                      enabledBorder: Variable.myinputborder(),
                      focusedBorder: Variable.myfocusborder(),
                    ),
                    value: statusVal,
                    onChanged: (newValue) {
                      setState(() {
                        statusVal = newValue!.toString();
                        _isDisabled = false;
                      });
                    },
                    items: statuses.map((item) {
                      return DropdownMenuItem(
                          value: item['value'].toString(),
                          child: AutoSizeText(
                            item['text'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w200),
                            overflow: TextOverflow.ellipsis,
                            maxFontSize: 15,
                            maxLines: 2,
                          ));
                    }).toList(),
                  ),
                  Variable.verticalSpace(20),
                  PrimaryButton(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    borderRadius: 15,
                    text: 'Update',
                    textColor: const Color(0xFFffffff),
                    backgroundColor: Theme.of(context).primaryColor,
                    isDisabled: _isDisabled,
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      CustomDialog(
                              title: 'Hang on',
                              message:
                                  'Are you sure you want to update this chart?',
                              onTap: submit)
                          .defaultDialog();
                    },
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> submit() async {
    const CustomDialog(isCancel: false).loadingDialog();

    Variable.checkInternet((hasInternet) async {
      if (hasInternet) {
        Map<String, dynamic> parameters = {
          "chart_id": widget.patientData["chart_id"],
          "nurse_id": Variable.userInfo["personnel_id"],
          "status": statusVal!,
          "is_done": 'Y',
        };

        HttpRequest(parameters: {"sqlCode": "T1351", "parameters": parameters})
            .post()
            .then((res) async {
          if (res == null) {
            Get.back();
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else if (res["rows"].isNotEmpty) {
            Get.back();
            if (res["rows"][0]["success"] == "Y") {
              await NotificationDatabase.instance
                  .deleteAllById(widget.patientData["chart_id"])
                  .then((value) {
                widget.callBack();
              });
              CustomDialog(
                  title: "Success",
                  message: res["rows"][0]["msg"],
                  isSuccess: false,
                  isCancel: false,
                  onTap: () {
                    Navigator.of(context).pop();
                  }).defaultDialog();
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
}
