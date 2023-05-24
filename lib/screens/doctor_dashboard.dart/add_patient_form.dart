import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:intl/intl.dart';
import 'package:nurse_assistance/variables.dart';
import 'package:nurse_assistance/widgets/custom_btn.dart';

import '../../messages.dart';

class AddPatient extends StatefulWidget {
  final Function callBack;
  const AddPatient({super.key, required this.callBack});

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  TextEditingController patientName = TextEditingController();
  TextEditingController patientAddress = TextEditingController();
  TextEditingController patientBirthDate = TextEditingController();
  TextEditingController patientMobileNo = TextEditingController();
  TextEditingController patientAge = TextEditingController();
  TextEditingController patientGender = TextEditingController();
  TextEditingController patientDiagnosis = TextEditingController();
  TextEditingController roomNumber = TextEditingController();
  TextEditingController wardNumber = TextEditingController();
  late TabController tabController;
  final DateTime _date = DateTime.now();
  late DateTime dateTime;
  String? roomNo;
  String? wardNo;
  String? gender;
  List<dynamic> roomData = [
    {"room": "Room 1", "value": 1},
    {"room": "Room 2", "value": 2},
    {"room": "Room 3", "value": 3},
    {"room": "Room 4", "value": 4},
    {"room": "Room 5", "value": 5},
    {"room": "Room 6", "value": 6},
    {"room": "Room 7", "value": 7},
    {"room": "Room 8", "value": 8},
    {"room": "Room 9", "value": 9},
    {"room": "Room 10", "value": 10},
  ];
  List<dynamic> wardData = [
    {"ward": "Ward 1", "value": 1},
    {"ward": "Ward 2", "value": 2},
    {"ward": "Ward 3", "value": 3},
    {"ward": "Ward 4", "value": 4},
    {"ward": "Ward 5", "value": 5},
  ];
  List<dynamic> genderData = [
    {"gender": "Female", "value": "f"},
    {"gender": "Male", "value": "m"},
  ];
  List<dynamic> doctorsOrder = [];
  String parsedDate(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Future<void> dateTimePickerWidget(BuildContext context) async {
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.day,
    );
    if (datePicker != null && datePicker != _date) {
      setState(() {
        dateTime = datePicker;
        patientBirthDate.text = parsedDate(dateTime.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 20),
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       // Add your onPressed code here!
        //     },
        //     backgroundColor: Colors.green,
        //     child: const Icon(Icons.add),
        //   ),
        // ),
        appBar: AppBar(
          backgroundColor: const Color(0xFF06919d),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF06919d),
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Add Patient",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.add,
          //       color: Colors.white,
          //       size: 30,
          //     ),
          //   ),
          //   Container(
          //     width: 10,
          //   ),
          // ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                    ),
                    const Text(
                      "Patient Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: patientName,
                          obscureText: false,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: Variable.myinputborder(),
                            enabledBorder: Variable.myinputborder(),
                            focusedBorder: Variable.myfocusborder(),
                            label: const Text("Fullname"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          onChanged: (value) {},
                        ),
                        Container(
                          height: 15,
                        ),
                        TextField(
                          controller: patientAddress,
                          obscureText: false,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: Variable.myinputborder(),
                            enabledBorder: Variable.myinputborder(),
                            focusedBorder: Variable.myfocusborder(),
                            label: const Text("Address"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          onChanged: (value) {},
                        ),
                        Container(
                          height: 15,
                        ),
                        TextField(
                          controller: patientBirthDate,
                          obscureText: false,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: Variable.myinputborder(),
                            enabledBorder: Variable.myinputborder(),
                            focusedBorder: Variable.myfocusborder(),
                            label: const Text(
                              "Birth Date",
                              style: TextStyle(color: Colors.black54),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          readOnly: true,
                          onTap: () {
                            dateTimePickerWidget(context);
                          },
                        ),
                        Container(
                          height: 15,
                        ),
                        TextField(
                          controller: patientMobileNo,
                          obscureText: false,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: Variable.myinputborder(),
                            enabledBorder: Variable.myinputborder(),
                            focusedBorder: Variable.myfocusborder(),
                            label: const Text("Mobile"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          onChanged: (value) {},
                        ),
                        Container(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: patientAge,
                                obscureText: false,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: Variable.myinputborder(),
                                  enabledBorder: Variable.myinputborder(),
                                  focusedBorder: Variable.myfocusborder(),
                                  label: const Text("Age"),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Expanded(
                              child: DropdownButtonFormField(
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    border: Variable.myinputborder(),
                                    enabledBorder: Variable.myinputborder(),
                                    focusedBorder: Variable.myfocusborder(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    label: const Text("Gender")),
                                value: gender,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    gender = newValue!.toString();
                                  });
                                },
                                items: genderData.map((item) {
                                  return DropdownMenuItem(
                                      value: item['value'].toString(),
                                      child: AutoSizeText(
                                        item['gender'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxFontSize: 15,
                                        maxLines: 2,
                                      ));
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                        TextField(
                          controller: patientDiagnosis,
                          obscureText: false,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            border: Variable.myinputborder(),
                            enabledBorder: Variable.myinputborder(),
                            focusedBorder: Variable.myfocusborder(),
                            label: const Text("Diagnosis"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          onChanged: (value) {},
                        ),
                        Container(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField(
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    border: Variable.myinputborder(),
                                    enabledBorder: Variable.myinputborder(),
                                    focusedBorder: Variable.myfocusborder(),
                                    label: const Text("Room Number"),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                                value: roomNo,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    roomNo = newValue!.toString();
                                  });
                                },
                                items: roomData.map((item) {
                                  return DropdownMenuItem(
                                      value: item['value'].toString(),
                                      child: AutoSizeText(
                                        item['room'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxFontSize: 15,
                                        maxLines: 2,
                                      ));
                                }).toList(),
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Expanded(
                              child: DropdownButtonFormField(
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  border: Variable.myinputborder(),
                                  enabledBorder: Variable.myinputborder(),
                                  focusedBorder: Variable.myfocusborder(),
                                  label: const Text("Ward Number"),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                value: wardNo,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    wardNo = newValue!.toString();
                                  });
                                },
                                items: wardData.map((item) {
                                  return DropdownMenuItem(
                                      value: item['value'].toString(),
                                      child: AutoSizeText(
                                        item['ward'],
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxFontSize: 15,
                                        maxLines: 2,
                                      ));
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: PrimaryButton(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        borderRadius: 15,
                        text: 'Save',
                        textColor: const Color(0xFFffffff),
                        backgroundColor: Colors.green,
                        isDisabled: false,
                        onTap: () async {
                          register();
                        },
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget patientsChuChu() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: ListTile(
          leading: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.person,
                color: Colors.grey,
              ),
            ),
          ),
          title: const Text("Rechie R. Arnado"),
          subtitle: const Text("Patient Name"),
          trailing: const Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    const CustomDialog(isCancel: false).loadingDialog();

    Variable.checkInternet((hasInternet) async {
      if (hasInternet) {
        Map<String, dynamic> parameters = {
          "doctor_id": Variable.userInfo['personnel_id'],
          "department_id": Variable.userInfo['department_id'],
          "full_name": patientName.text,
          "address": patientAddress.text,
          "birth_date": patientBirthDate.text,
          "mobile_no": patientMobileNo.text,
          "age": int.parse(patientAge.text),
          "gender": gender,
          "diagnosis": patientDiagnosis.text,
          "room_no": roomNo,
          "ward_no": wardNo,
        };

        HttpRequest(parameters: {"sqlCode": "T1344", "parameters": parameters})
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
              CustomDialog(
                  title: "Success",
                  message: res["rows"][0]["msg"],
                  isSuccess: false,
                  isCancel: false,
                  onTap: () {
                    widget.callBack();
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
