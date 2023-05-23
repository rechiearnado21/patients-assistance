import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/variables.dart';
import 'package:nurse_assistance/widgets/custom_btn.dart';

class AddChart extends StatefulWidget {
  final dynamic data;
  const AddChart({super.key, required this.data});

  @override
  State<AddChart> createState() => _AddChartState();
}

class _AddChartState extends State<AddChart> {
  TextEditingController patientName = TextEditingController();
  TextEditingController medicName = TextEditingController();
  TextEditingController roomNo = TextEditingController();
  TextEditingController wardNo = TextEditingController();
  DateTime? dateTimeValue;
  TextEditingController dateTime = TextEditingController();

  dateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (date, List<int> index) {
        String formattedTime = DateFormat('dd-MM-yyyy kk:mm:a').format(date);
        setState(() {
          dateTime.text = formattedTime;
          dateTimeValue = date;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    patientName.text = widget.data["full_name"];
    roomNo.text = "Room ${widget.data["room_no"]}";
    wardNo.text = "Ward ${widget.data["ward_no"]}";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          'Add Chart',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light),
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                  ),
                  const Text("Patient Name"),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    controller: patientName,
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
                    height: 10,
                  ),
                  const Text("Room No"),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    controller: roomNo,
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
                    height: 20,
                  ),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Task 1",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Container(
                            height: 20,
                          ),
                          TextField(
                            controller: medicName,
                            obscureText: false,
                            decoration: InputDecoration(
                                border: Variable.myinputborder(),
                                enabledBorder: Variable.myinputborder(),
                                focusedBorder: Variable.myfocusborder(),
                                label: const Text("Medication Name"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                            onChanged: (value) {},
                          ),
                          Container(
                            height: 20,
                          ),
                          TextField(
                            controller: dateTime,
                            obscureText: false,
                            readOnly: true,
                            decoration: InputDecoration(
                                border: Variable.myinputborder(),
                                enabledBorder: Variable.myinputborder(),
                                focusedBorder: Variable.myfocusborder(),
                                label: const Text("Date & Time"),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                            onTap: () {
                              dateTimePickerWidget(context);
                            },
                          ),
                          Container(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: PrimaryButton(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              borderRadius: 15,
                              text: 'Save Chart',
                              textColor: const Color(0xFFffffff),
                              backgroundColor: Colors.green,
                              isDisabled: false,
                              onTap: () async {
                                // register();
                                submitAssignedPatient();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitAssignedPatient() async {
    const CustomDialog(isCancel: false).loadingDialog();

    Variable.checkInternet((hasInternet) async {
      if (hasInternet) {
        Map<String, dynamic> parameters = {
          "patient_id": widget.data["patient_id"],
          "nurse_id": Variable.userInfo["personnel_id"],
          "room_no": widget.data["room_no"],
          "ward_no": widget.data["ward_no"],
          "medic_name": medicName.text,
          "medic_date": dateTimeValue.toString().split(".")[0],
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
