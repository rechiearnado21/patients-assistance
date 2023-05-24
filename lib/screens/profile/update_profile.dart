import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/database/notifications_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dialogs.dart';
import '../../http_request.dart';
import '../../messages.dart';
import '../../routes/routes.dart';
import '../../variables.dart';
import '../../widgets/widgets.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    fullName.text = Variable.userInfo["full_name"];
    email.text = Variable.userInfo["email"];
    phone.text = Variable.userInfo["mobile_no"];
    address.text = Variable.userInfo["address"];
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

  String myType(id) {
    var depName = typeOfUserData
        .where((element) {
          return element["value"] == id;
        })
        .toList()[0]["type"]
        .toString();

    return depName;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: Text(
            'Update Information',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black, fontSize: 14),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
          ),
          action: [
            IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                  CustomDialog(
                      title: 'Hang on',
                      message: 'Are you sure you want to logout?',
                      onTap: () async {
                        const CustomDialog(isCancel: false).loadingDialog();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString("email", "");
                        prefs.setString("password", "");
                        prefs.setString("PERSONNELID", "0");
                        await NotificationDatabase.instance.deleteAll();
                        Timer(const Duration(seconds: 2), () {
                          Get.back();
                          Get.offAndToNamed(AppRoutes.login);
                        });
                      }).defaultDialog();
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                )),
            Container(
              width: 10,
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: size.width,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.purple,
                      radius: 50,
                      backgroundImage: AssetImage("assets/images/doctora.png"),
                    ),
                    Container(
                      height: 10,
                    ),
                    Text(
                      "${myType(Variable.userInfo["role_id"])}/${myDept(Variable.userInfo["department_id"])}",
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            Expanded(
                child: StretchingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              child: Container(
                color: Colors.grey.shade50,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  children: [
                    Container(
                      height: 20,
                    ),
                    TextField(
                      controller: fullName,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: Variable.myinputborder(),
                        enabledBorder: Variable.myinputborder(),
                        focusedBorder: Variable.myfocusborder(),
                        labelText: "Fullname",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: email,
                      readOnly: true,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: Variable.myinputborder(),
                        enabledBorder: Variable.myinputborder(),
                        focusedBorder: Variable.myfocusborder(),
                        labelText: "Email",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: phone,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: Variable.myinputborder(),
                        enabledBorder: Variable.myinputborder(),
                        focusedBorder: Variable.myfocusborder(),
                        labelText: "Contact #",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: address,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: Variable.myinputborder(),
                        enabledBorder: Variable.myinputborder(),
                        focusedBorder: Variable.myfocusborder(),
                        labelText: "Address",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: PrimaryButton(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        borderRadius: 15,
                        text: 'Save',
                        textColor: const Color(0xFFffffff),
                        backgroundColor: Theme.of(context).primaryColor,
                        isDisabled: false,
                        onTap: () async {
                          FocusManager.instance.primaryFocus!.unfocus();
                          CustomDialog(
                                  title: 'Hang on',
                                  message:
                                      'Are you sure you want to update this account?',
                                  onTap: register)
                              .defaultDialog();
                        },
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget firstStanza() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          "Sign up to register!",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        Container(
          height: 10,
        ),
      ],
    );
  }

  Future<void> register() async {
    const CustomDialog(isCancel: false).loadingDialog();

    Variable.checkInternet((hasInternet) async {
      if (hasInternet) {
        Map<String, dynamic> parameters = {
          "personnel_id": Variable.userInfo["personnel_id"],
          "full_name": fullName.text,
          "mobile_no": phone.text,
          "address": address.text,
          "gender": "M",
        };

        HttpRequest(parameters: {"sqlCode": "T1340", "parameters": parameters})
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
              setState(() {
                Variable.userInfo["full_name"] == fullName.text;
                Variable.userInfo["mobile_no"] == phone.text;
                Variable.userInfo["address"] == address.text;
                Variable.userInfo["gender"] == "M";
              });
              CustomDialog(
                  title: "Success",
                  message: res["rows"][0]["msg"],
                  isSuccess: false,
                  isCancel: false,
                  onTap: () {
                    if (Variable.userInfo["role_id"] == 1) {
                      Get.offAndToNamed(AppRoutes.doctorDashboard);
                    } else {
                      Get.offAndToNamed(AppRoutes.landing);
                    }
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
