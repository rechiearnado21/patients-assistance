import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/variables.dart';
import '../../widgets/widgets.dart';
import 'controller.dart';

class OrderScreen extends GetView<OrderController> {
  final List dataObject;
  final Function onSuccess;
  const OrderScreen(
      {super.key, required this.dataObject, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return OrderForm(
      onSubmit: (value) {},
      patientData: dataObject,
      onSuccess: onSuccess,
    );
  }
}

class OrderForm extends StatefulWidget {
  const OrderForm({
    super.key,
    required this.onSubmit,
    required this.patientData,
    required this.onSuccess,
  });
  final ValueChanged<Object> onSubmit;
  final Function onSuccess;
  final List patientData;
  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  DateTime? dateTimeValue;
  TextEditingController dateTime = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController rationale = TextEditingController();

  List<dynamic> typeOfUserData = [
    {"type": "Doctor", "value": "doctor"},
    {"type": "Nurse", "value": "nurse"}
  ];

  @override
  void initState() {
    super.initState();
    dateTime = TextEditingController();
    order = TextEditingController();
    rationale = TextEditingController(); 
  }

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
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
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
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF06919d),
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 246, 248, 249),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                firstStanza(),
                Container(
                  height: 20,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AutoSizeText(
                        "Date ",
                      ),
                      Container(
                        height: 5,
                      ),
                      TextField(
                        controller: dateTime,
                        obscureText: false,
                        readOnly: true,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: Variable.myinputborder(),
                          enabledBorder: Variable.myinputborder(),
                          focusedBorder: Variable.myfocusborder(),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        onTap: () {
                          dateTimePickerWidget(context);
                        },
                      ),
                      Container(
                        height: 10,
                      ),
                      const AutoSizeText(
                        "Order",
                      ),
                      Container(
                        height: 5,
                      ),
                      TextField(
                        controller: order,
                        obscureText: false,
                        maxLines: 10,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          border: Variable.myinputborder(),
                          enabledBorder: Variable.myinputborder(),
                          focusedBorder: Variable.myfocusborder(),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      const AutoSizeText(
                        "Rationale",
                      ),
                      Container(
                        height: 5,
                      ),
                      TextField(
                        controller: rationale,
                        obscureText: false,
                        maxLines: 10,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          border: Variable.myinputborder(),
                          enabledBorder: Variable.myinputborder(),
                          focusedBorder: Variable.myfocusborder(),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
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
                          text: 'Submit',
                          textColor: const Color(0xFFffffff),
                          backgroundColor: Colors.purple,
                          isDisabled: false,
                          onTap: () async {
                            // const CustomDialog(isCancel: false).loadingDialog();
                            // widget.onSubmit({
                            //   'date': dateTime.text,
                            //   "order": order.text,
                            //   "rationale": rationale.text
                            // });
                            // Timer(const Duration(seconds: 3), () {
                            //   Navigator.of(context).pop();
                            //   if (Navigator.canPop(context)) {
                            //     Navigator.of(context).pop();
                            //   }
                            // });
                            submitOrder();
                          },
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget firstStanza() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AutoSizeText(
          "Doctors Order",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 10,
        ),
      ],
    );
  }

  Future<void> submitOrder() async {
    const CustomDialog(isCancel: false).loadingDialog();

    Variable.checkInternet((hasInternet) async {
      if (hasInternet) {
        Map<String, dynamic> parameters = {
          "doctor_id": Variable.userInfo["personnel_id"],
          "patient_id": widget.patientData[0]["patient_id"],
          "order_date": dateTimeValue.toString().split(".")[0],
          "order": order.text,
          "rationale": rationale.text,
        };

        HttpRequest(parameters: {"sqlCode": "T1346", "parameters": parameters})
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
                    widget.onSuccess();
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
