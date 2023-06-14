import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:nurse_assistance/database/notifications_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dialogs.dart';
import '../../http_request.dart';
import '../../messages.dart';
import '../../routes/routes.dart';
import '../../variables.dart';
import '../../widgets/widgets.dart';

enum AppState {
  free,
  picked,
  cropped,
}

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
  String? shift;
  bool isLoading = true;

  final ImagePicker _picker = ImagePicker();
  String? imageBase64;
  File? imageFile;
  AppState? state;
  String? imageFileBase64;
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

  List<dynamic> shiftDd = [
    {"text": "Morning Shift", "value": "Morning"},
    {"text": "Evening Shift", "value": "Evening"},
    {"text": "Midnight Shift", "value": "Midnight"},
  ];

  @override
  void initState() {
    super.initState();
    fullName.text = Variable.userInfo["full_name"];
    email.text = Variable.userInfo["email"];
    phone.text = Variable.userInfo["mobile_no"];
    address.text = Variable.userInfo["address"];
    shift =
        Variable.userInfo["shift"] == 'N' ? null : Variable.userInfo["shift"];
    isLoading = false;
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
            'Profile Details',
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
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.purple,
                          radius: 50,
                          backgroundImage: imageFile == null &&
                                  Variable.userInfo["image_file"] == ""
                              ? const AssetImage('assets/images/doctora.png')
                              : imageFile != null
                                  ? FileImage(imageFile!)
                                  : MemoryImage(
                                      const Base64Decoder().convert(
                                          Variable.userInfo["image_file"]),
                                    ) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 10,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              showBottomSheetCamera();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.camera,
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                      height: 20,
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
                      height: 20,
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
                      height: 20,
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
                    if (Variable.userInfo["role_id"] != 1)
                      DropdownButtonFormField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Select Shift",
                          border: Variable.myinputborder(),
                          enabledBorder: Variable.myinputborder(),
                          focusedBorder: Variable.myfocusborder(),
                        ),
                        value: shift,
                        onChanged: (newValue) {
                          setState(() {
                            shift = newValue!.toString();
                          });
                        },
                        items: shiftDd.map((item) {
                          return DropdownMenuItem(
                              value: item['value'].toString(),
                              child: AutoSizeText(
                                item['text'],
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxFontSize: 15,
                                maxLines: 2,
                              ));
                        }).toList(),
                      ),
                    Container(
                      height: 20,
                    ),
                    PrimaryButton(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 15,
                      text: 'Update',
                      textColor: const Color(0xFFffffff),
                      backgroundColor: Theme.of(context).primaryColor,
                      isDisabled: false,
                      onTap: () async {
                        FocusManager.instance.primaryFocus!.unfocus();
                        CustomDialog(
                                title: 'Hang on',
                                message:
                                    'Are you sure you want to update this profile?',
                                onTap: register)
                            .defaultDialog();
                      },
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

  void showBottomSheetCamera() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                child: Text('Use Camera'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                child: Text('Upload from files'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(cont).pop;
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          );
        });
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 25,
      maxHeight: 480,
      maxWidth: 640,
    );

    setState(() {
      imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
        imageFile!.readAsBytes().then((data) {
          imageBase64 = base64.encode(data);

          imageFileBase64 = imageBase64.toString();
        });
      });
    } else {
      imageBase64 = null;
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
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
          "shift": shift ?? 'N',
          "image_file": imageFileBase64
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
              Variable.userInfo["full_name"] = fullName.text;
              Variable.userInfo["mobile_no"] = phone.text;
              Variable.userInfo["address"] = address.text;
              Variable.userInfo["gender"] = "M";
              Variable.userInfo["shift"] = shift ?? 'N';
              Variable.userInfo["image_file"] =
                  imageFileBase64 ?? Variable.userInfo["image_file"];

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
