import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:nurse_assistance/widgets/custom_btn.dart';
import 'package:nurse_assistance/widgets/custom_loader.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({super.key, required this.onSubmit});
  final ValueChanged<Object> onSubmit;
  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  TextEditingController dateTime = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController rationale = TextEditingController();

  List<dynamic> typeOfUserData = [
    {"type": "Doctor", "value": "doctor"},
    {"type": "Nurse", "value": "nurse"}
  ];
  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ));
  }

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
        DateTime selectdate = date;
        setState(() {
          dateTime.text = date.toString();
        });
        print(selectdate);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
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
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
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
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
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
                            CustomModal(context: context).loader();
                            widget.onSubmit({
                              'date': dateTime.text,
                              "order": order.text,
                              "rationale": rationale.text
                            });
                            Timer(const Duration(seconds: 3), () {
                              Navigator.of(context).pop();
                              if (Navigator.canPop(context)) {
                                Navigator.of(context).pop();
                              }
                            });
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
}
