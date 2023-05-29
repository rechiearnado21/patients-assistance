import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/variables.dart';
import 'package:nurse_assistance/widgets/custom_btn.dart';
import 'controller.dart';

class PatientScreen extends GetView<PatientController> {
  final Object nurseData;
  const PatientScreen({super.key, this.nurseData = ""});

  @override
  Widget build(BuildContext context) {
    return PatientForm(
      //  backgroundColor: Colors.transparent,
      nurseData: nurseData,
    );
  }
}

class PatientForm extends StatefulWidget {
  final Object nurseData;
  const PatientForm({super.key, required this.nurseData});

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  TextEditingController nurseName = TextEditingController();
  bool isLoading = true;
  bool isLoadingOrder = false;
  String? patientId;
  List<dynamic> nurseLocalData = [];
  List<dynamic> dropdownData = [];
  int rowsData = 0;
  var doctorsOrderWidget = <Widget>[];

  @override
  void initState() {
    super.initState();
    doctorsOrderWidget = <Widget>[];
    nurseName.text = "";
    getData();
  }

  Future<void> getData() async {
    setState(() {
      nurseLocalData = [];
    });
    setState(() {
      nurseLocalData.add(widget.nurseData);
      nurseName.text = nurseLocalData[0]["full_name"];
    });
    doctorsOrderWidget.add(const Center(
      child: Text("No Orders"),
    ));
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
          "department_id": Variable.userInfo["department_id"],
          "nurse_id": nurseLocalData[0]["personnel_id"],
        };
        HttpRequest(parameters: {"sqlCode": "T1347", "parameters": parameters})
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
              dropdownData = res["rows"];

              isLoading = false;
            });
          }
        });
      }
    });
  }

  Future<void> getPatientOrders(patientId) async {
    doctorsOrderWidget = <Widget>[];
    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        setState(() {
          isLoadingOrder = false;
        });
        CustomDialog(
                message: Message.noInternet, isSuccess: false, isCancel: false)
            .defaultDialog();
      } else {
        Map<String, dynamic> parameters = {
          "patient_id": patientId,
        };

        HttpRequest(parameters: {"sqlCode": "T1348", "parameters": parameters})
            .post()
            .then((res) {
          if (res == null) {
            setState(() {
              isLoadingOrder = false;
            });
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else {
            setState(() {
              rowsData = res["rows"].length;
              if (res["rows"].length > 0) {
                doctorsOrderWidget.add(Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Order",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        )),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Rationale",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        )),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                  ],
                ));
                for (int i = 0; i < res["rows"].length; i++) {
                  doctorsOrderWidget.add(Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          res["rows"][i]["order_date"],
                          softWrap: true,
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          res["rows"][i]["order"],
                          softWrap: true,
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          res["rows"][i]["rationale"],
                          softWrap: true,
                        ),
                      )),
                    ],
                  ));
                }
              } else {
                doctorsOrderWidget.add(const Center(
                  child: Text("No Orders"),
                ));
              }

              isLoading = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        backgroundColor: Colors.white,
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
            'Assign Patient',
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 246, 248, 249),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Nurse Name"),
                            Container(
                              height: 10,
                            ),
                            TextField(
                              controller: nurseName,
                              obscureText: false,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: Variable.myinputborder(),
                                enabledBorder: Variable.myinputborder(),
                                focusedBorder: Variable.myfocusborder(),
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
                            const Text("Patient"),
                            Container(
                              height: 10,
                            ),
                            DropdownButtonFormField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                border: Variable.myinputborder(),
                                enabledBorder: Variable.myinputborder(),
                                focusedBorder: Variable.myfocusborder(),
                                hintText: "Select Patient",
                                fillColor: Colors.black,
                              ),
                              value: patientId,
                              onChanged: (String? newValue) {
                                setState(() {
                                  patientId = newValue!.toString();
                                });

                                getPatientOrders(
                                    int.parse(newValue.toString()));
                              },
                              items: dropdownData.map((item) {
                                return DropdownMenuItem(
                                    value: item['patient_id'].toString(),
                                    child: AutoSizeText(
                                      item['full_name'],
                                    ));
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    const Text(
                      "Doctor's Order",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(children: doctorsOrderWidget),
                      ),
                    ),
                    Container(
                      height: 30,
                    ),
                    PrimaryButton(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 15,
                      text: 'Submit',
                      textColor: const Color(0xFFffffff),
                      backgroundColor: Theme.of(context).primaryColor,
                      isDisabled: patientId == null ? true : false,
                      onTap: patientId == null
                          ? () {}
                          : () async {
                              FocusManager.instance.primaryFocus!.unfocus();
                              CustomDialog(
                                      title: 'Hang on',
                                      message:
                                          'Are you sure you want to assign this patient?',
                                      onTap: submitAssignedPatient)
                                  .defaultDialog();
                            },
                    ),
                    Container(
                      height: 20,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<void> submitAssignedPatient() async {
    const CustomDialog(isCancel: false).loadingDialog();

    Variable.checkInternet((hasInternet) async {
      if (hasInternet) {
        Map<String, dynamic> parameters = {
          "doctor_id": Variable.userInfo["personnel_id"],
          "patient_id": int.parse(patientId.toString()),
          "nurse_id": nurseLocalData[0]["personnel_id"],
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
            Get.back();
            if (res["rows"][0]["success"] == "Y") {
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
