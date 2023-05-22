import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/routes/routes.dart';
import 'controller.dart';

class PatientScreen extends GetView<PatientController> {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PatientForm(
        //  backgroundColor: Colors.transparent,
        );
  }
}

class PatientForm extends StatefulWidget {
  const PatientForm({super.key});

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  TextEditingController patientName = TextEditingController();
  TextEditingController diagnosis = TextEditingController();
  TextEditingController roomNumber = TextEditingController();
  TextEditingController wardNumber = TextEditingController();
  TextEditingController dateTime = TextEditingController();
  int activeStepIndex = 0;

  bool isLoading = true;
  bool isShowPassword = false;
  String? roomNo;
  String? wardNo;
  String? gender;
  List<dynamic> roomData = [
    {"room": "Room 1", "value": "room 1"},
    {"room": "Room 2", "value": "room 2"},
    {"room": "Room 3", "value": "room 3"},
    {"room": "Room 4", "value": "room 4"},
    {"room": "Room 5", "value": "room 5"},
    {"room": "Room 6", "value": "room 6"},
    {"room": "Room 7", "value": "room 7"},
    {"room": "Room 8", "value": "room 8"},
    {"room": "Room 9", "value": "room 9"},
    {"room": "Room 10", "value": "room 10"},
  ];
  List<dynamic> wardData = [
    {"ward": "Ward 1", "value": "ward 1"},
    {"ward": "Ward 2", "value": "ward 2"},
    {"ward": "Ward 3", "value": "ward 3"},
    {"ward": "Ward 4", "value": "ward 4"},
    {"ward": "Ward 5", "value": "ward 5"},
  ];
  List<dynamic> genderData = [
    {"gender": "Female", "value": "f"},
    {"gender": "Male", "value": "m"},
  ];
  List<dynamic> doctorsOrder = [];
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
    patientName = TextEditingController();
    diagnosis = TextEditingController();
    roomNumber = TextEditingController();
    wardNumber = TextEditingController();
    dateTime = TextEditingController();
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
        setState(() {
          dateTime.text = date.toString();
        });
      },
    );
  }

  void getSearchValue(data) async {
    if (mounted) {
      setState(() {
        doctorsOrder.add(data);
      });
    }
  }

  List<Step> stepList() => [
        Step(
          state: activeStepIndex <= 0 ? StepState.editing : StepState.complete,
          isActive: activeStepIndex >= 0,
          title: const Text('Patient'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
              ),
              const Text("Name of patient:"),
              Container(
                height: 5,
              ),
              TextField(
                controller: patientName,
                obscureText: false,
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
                onChanged: (value) {},
              ),
              Container(
                height: 10,
              ),
              const Text("Diagnosis:"),
              Container(
                height: 5,
              ),
              TextField(
                controller: diagnosis,
                obscureText: false,
                textInputAction: TextInputAction.done,
                maxLines: 2,
                decoration: InputDecoration(
                  border: myinputborder(),
                  enabledBorder: myinputborder(),
                  focusedBorder: myfocusborder(),
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
              const Text("Room #"),
              Container(
                height: 5,
              ),
              DropdownButtonFormField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: myinputborder(),
                  enabledBorder: myinputborder(),
                  focusedBorder: myfocusborder(),
                ),
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
                            color: Colors.black, fontWeight: FontWeight.w200),
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 15,
                        maxLines: 2,
                      ));
                }).toList(),
              ),
              Container(
                height: 10,
              ),
              const Text("Ward #"),
              Container(
                height: 5,
              ),
              DropdownButtonFormField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: myinputborder(),
                  enabledBorder: myinputborder(),
                  focusedBorder: myfocusborder(),
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
                            color: Colors.black, fontWeight: FontWeight.w200),
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 15,
                        maxLines: 2,
                      ));
                }).toList(),
              ),
              Container(
                height: 10,
              ),
              const Text("Date & Time"),
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
              const Text("Gender #"),
              Container(
                height: 5,
              ),
              DropdownButtonFormField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: myinputborder(),
                  enabledBorder: myinputborder(),
                  focusedBorder: myfocusborder(),
                ),
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
                            color: Colors.black, fontWeight: FontWeight.w200),
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 15,
                        maxLines: 2,
                      ));
                }).toList(),
              ),
              Container(
                height: 10,
              ),
            ],
          ),
        ),
        Step(
            state:
                activeStepIndex <= 1 ? StepState.editing : StepState.complete,
            isActive: activeStepIndex >= 1,
            title: const Text('Doctors Order'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.order);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_rounded),
                          Text(
                            " Add Order",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: ListView.builder(
                    itemCount: doctorsOrder.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.viewOrder,
                              arguments: doctorsOrder[i]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade100,
                                ),
                                child: Center(
                                  child: Text(
                                    "${i + 1}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ),
                              ),
                              title: AutoSizeText(
                                doctorsOrder[i]['order'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: AutoSizeText(
                                doctorsOrder[i]['date'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(
                                  Icons.keyboard_arrow_right_rounded),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 10,
                ),
              ],
            )),
      ];
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: const AutoSizeText(
            "Add Patient Form",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Theme(
              data: ThemeData(
                  primarySwatch: Colors.green,
                  colorScheme: const ColorScheme.light(primary: Colors.green)),
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: activeStepIndex,
                steps: stepList(),
                onStepContinue: () {
                  if (activeStepIndex < (stepList().length - 1)) {
                    setState(() {
                      activeStepIndex += 1;
                    });
                  } else {
                    print('Submited doctor order $doctorsOrder');
                  }
                },
                onStepCancel: () {
                  if (activeStepIndex == 0) {
                    return;
                  }
                  setState(() {
                    activeStepIndex -= 1;
                  });
                },
                onStepTapped: (int index) {
                  setState(() {
                    activeStepIndex = index;
                  });
                },
                controlsBuilder:
                    (BuildContext context, ControlsDetails controls) {
                  final isLastStep = activeStepIndex == stepList().length - 1;
                  return Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controls.onStepContinue,
                          child: (isLastStep)
                              ? const Text('Submit')
                              : const Text('Next'),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (activeStepIndex > 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controls.onStepCancel,
                            child: const Text('Back'),
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
