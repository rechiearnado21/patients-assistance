import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dialogs.dart';
import '../../http_request.dart';
import '../../messages.dart';
import '../../routes/routes.dart';
import '../../variables.dart';
import '../../widgets/widgets.dart';
import 'controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginBodyScreen();
  }
}

class LoginBodyScreen extends StatefulWidget {
  const LoginBodyScreen({super.key});

  @override
  State<LoginBodyScreen> createState() => _LoginBodyScreenState();
}

class _LoginBodyScreenState extends State<LoginBodyScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _passwordObscure = true;
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isDisabled = true;
  final List<dynamic> _data = [
    {"name": "Username", "cname": "username", "value": "", "is_required": true},
    {"name": "Password", "cname": "password", "value": "", "is_required": true}
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/medicine.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          child: Align(
                            alignment: const Alignment(0, 1.5),
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              child: Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/welcome_nurse.png"),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  verticalSpace(30),
                  SlideFadeTransition(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Hello Again!',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  verticalSpace(10),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Welcome back you've been missed!",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600),
                      )),
                  verticalSpace(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomTextFormField(
                      controller: _userName,
                      onChanged: (value) {
                        _validateMe("username", value);
                      },
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 22.0),
                      prefixIcon: const Icon(
                        Icons.email,
                        size: 25,
                        color: Colors.black,
                      ),
                      obscureText: false,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomTextFormField(
                      controller: _password,
                      onChanged: (value) {
                        _validateMe("password", value);
                      },
                      hintText: 'Password',
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.visiblePassword,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 22.0),
                      prefixIcon: const Icon(
                        Icons.key_outlined,
                        size: 25,
                        color: Colors.black,
                      ),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _passwordObscure = !_passwordObscure;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: AutoSizeText(
                                  _passwordObscure ? 'Show' : 'Hide',
                                  maxLines: 1,
                                  maxFontSize: 14,
                                  minFontSize: 11,
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )),
                      obscureText: _passwordObscure,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0)),
                    ),
                  ),
                  verticalSpace(30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: PrimaryButton(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 15,
                      text: 'Login',
                      textColor: const Color(0xFFffffff),
                      backgroundColor: Theme.of(context).primaryColor,
                      isDisabled: _isDisabled,
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        login();
                      },
                    ),
                  ),
                  verticalSpace(20),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.signup);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'No account yet? ',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget verticalSpace(double height) {
    return Container(
      height: height,
    );
  }

  _validateMe(String cname, String value) {
    var data = _data
        .where(
          (element) => element["cname"] == cname,
        )
        .toList()[0];
    setState(() {
      data["value"] = value;
      _isDisabled = wasValidated();
    });
  }

  bool wasValidated() {
    bool res = false;
    int numDataIsRequired = _data
        .where(
          (element) => element["is_required"],
        )
        .toList()
        .length;

    int numDataWasValidated = _data
        .where(
            (element) => element["is_required"] && element["value"].isNotEmpty)
        .toList()
        .length;

    if (numDataIsRequired == numDataWasValidated) {
      res = false;
    } else {
      res = true;
    }

    return res;
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const CustomDialog(isCancel: false).loadingDialog();

    Variable.checkInternet((hasInternet) async {
      if (hasInternet) {
        Map<String, dynamic> parameters = {
          "email": _userName.text,
          "password": _password.text,
        };

        HttpRequest(parameters: {"sqlCode": "T1341", "parameters": parameters})
            .post()
            .then((res) async {
          if (res == null) {
            Get.back();
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else if (res["rows"].isNotEmpty) {
            Get.back();
            prefs.setString("email", _userName.text);
            prefs.setString("password", _password.text);

            Variable.userInfo = res["rows"][0];
            if (Variable.userInfo["role_id"] == 1) {
              Get.offAndToNamed(AppRoutes.doctorDashboard);
            } else {
              Get.offAndToNamed(AppRoutes.landing);
            }
          } else {
            Get.back();

            const CustomDialog(
                    message: "Invalid email or password.",
                    isSuccess: false,
                    isCancel: false)
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
