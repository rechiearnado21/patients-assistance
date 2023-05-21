import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dialogs.dart';
import '../../functions.dart';
import '../../http_request.dart';
import '../../messages.dart';
import '../../routes/routes.dart';
import '../../variables.dart';
import '../../widgets/widgets.dart';
import 'controller.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignupBodyScreen();
  }
}

class SignupBodyScreen extends StatefulWidget {
  const SignupBodyScreen({super.key});

  @override
  State<SignupBodyScreen> createState() => _SignupBodyScreenState();
}

class _SignupBodyScreenState extends State<SignupBodyScreen> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();

  List<dynamic> typeOfUserData = [
    {"type": "Doctor", "value": 1},
    {"type": "Nurse", "value": 2}
  ];
  List<dynamic> dept = [
    {"dept": "Gastroentrology", "value": 1},
    {"dept": "Gynaecology", "value": 2},
    {"dept": "Cardiology", "value": 3},
    {"dept": "Neurology", "value": 4},
    {"dept": "Pediatrics", "value": 5},
  ];

  final List<dynamic> _data = [
    {"name": "Type User", "cname": "role_id", "value": "", "is_required": true},
    {
      "name": "Department",
      "cname": "department_id",
      "value": "",
      "is_required": true
    },
    {
      "name": "Fullname",
      "cname": "full_name",
      "value": "",
      "is_required": true
    },
    {"name": "Email", "cname": "email", "value": "", "is_required": true},
    {"name": "Password", "cname": "password", "value": "", "is_required": true},
    {
      "name": "Confirm Password",
      "cname": "confirm_password",
      "value": "",
      "is_required": true
    },
    {
      "name": "Mobile No.",
      "cname": "mobile_no",
      "value": "",
      "is_required": true
    },
    {"name": "Address", "cname": "address", "value": "", "is_required": true}
  ];
  bool isShowPassword = false;
  String? userType;
  String? deptId;
  bool _isDisabled = true;
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
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: Text(
            'Create Account',
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
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              firstStanza(),
              Expanded(
                  child: StretchingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                child: ListView(
                  children: [
                    DropdownButtonFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Select Type User",
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                      value: userType,
                      onChanged: (newValue) {
                        setState(() {
                          userType = newValue!.toString();
                          _isDisabled = PublicFunction.validate(
                              'role_id', newValue.toString(), _data);
                        });
                      },
                      items: typeOfUserData.map((item) {
                        return DropdownMenuItem(
                            value: item['value'].toString(),
                            child: AutoSizeText(
                              item['type'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200),
                              overflow: TextOverflow.ellipsis,
                              maxFontSize: 15,
                              maxLines: 2,
                            ));
                      }).toList(),
                    ),
                    Container(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Select Department",
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                      value: deptId,
                      onChanged: (newValue) {
                        setState(() {
                          deptId = newValue!.toString();
                          _isDisabled = PublicFunction.validate(
                              'department_id', newValue.toString(), _data);
                        });
                      },
                      items: dept.map((item) {
                        return DropdownMenuItem(
                            value: item['value'].toString(),
                            child: AutoSizeText(
                              item['dept'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200),
                              overflow: TextOverflow.ellipsis,
                              maxFontSize: 15,
                              maxLines: 2,
                            ));
                      }).toList(),
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: fullName,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        hintText: "Fullname",
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDisabled = PublicFunction.validate(
                              'full_name', value.toString(), _data);
                        });
                      },
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: email,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        hintText: "Email",
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDisabled = PublicFunction.validate(
                              'email', value.toString(), _data);
                        });
                      },
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: password,
                      obscureText: !isShowPassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        hintText: "Password",
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDisabled = PublicFunction.validate(
                              'password', value.toString(), _data);
                        });
                      },
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: confirmPassword,
                      obscureText: !isShowPassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        hintText: "Confirm password",
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDisabled = PublicFunction.validate(
                              'confirm_password', value.toString(), _data);
                        });
                      },
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: phone,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        hintText: "Cellphone #",
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDisabled = PublicFunction.validate(
                              'mobile_no', value.toString(), _data);
                        });
                      },
                    ),
                    Container(
                      height: 10,
                    ),
                    TextField(
                      controller: address,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        hintText: "Address",
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isDisabled = PublicFunction.validate(
                              'address', value.toString(), _data);
                        });
                      },
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Row(children: [
                          SizedBox(
                            width: 10,
                            child: Checkbox(
                              value: isShowPassword,
                              activeColor: Colors.orange,
                              onChanged: (value) {
                                //value may be true or false
                                setState(() {
                                  isShowPassword = !isShowPassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            'Show Password',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          )
                        ]),
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
                        text: 'Register Account',
                        textColor: const Color(0xFFffffff),
                        backgroundColor: Theme.of(context).primaryColor,
                        isDisabled: _isDisabled,
                        onTap: () async {
                          FocusManager.instance.primaryFocus!.unfocus();
                          CustomDialog(
                                  title: 'Hang on',
                                  message:
                                      'Are you sure you want to register this account?',
                                  onTap: register)
                              .defaultDialog();
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
          "role_id": int.parse(userType!),
          "department_id": int.parse(deptId!),
          "full_name": fullName.text,
          "email": email.text,
          "password": password.text,
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
              CustomDialog(
                      title: "Success",
                      message: res["rows"][0]["msg"],
                      isSuccess: false,
                      isCancel: false,
                      onTap: () => Get.offAndToNamed(AppRoutes.login))
                  .defaultDialog();
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
