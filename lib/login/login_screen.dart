import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_assistance/dashboard/doctor_dashboard.dart';
import 'package:nurse_assistance/widgets/custom_btn.dart';
import 'package:nurse_assistance/widgets/custom_textformfield.dart';
import 'package:nurse_assistance/widgets/slide_fade_transition.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: MediaQuery(
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
                        child: Text(
                          'Hello Again!',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: isDarkMode ? Colors.white : Colors.black),
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
                              color: isDarkMode
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600),
                        )),
                    verticalSpace(30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CustomTextFormField(
                        controller: _userName,
                        onChanged: (value) {
                          _validateMe("username", value);
                        },
                        hintText: 'Username',
                        textCapitalization: TextCapitalization.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 22.0),
                        prefixIcon: Icon(
                          Icons.person_outlined,
                          size: 25,
                          color: isDarkMode ? Colors.white : Colors.black,
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
                        prefixIcon: Icon(
                          Icons.key_outlined,
                          size: 25,
                          color: isDarkMode ? Colors.white : Colors.black,
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
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white60
                                            : Colors.black54,
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
                        backgroundColor: Colors.purple,
                        isDisabled: false,
                        onTap: () async {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: const Duration(milliseconds: 400),
                              alignment: Alignment.centerLeft,
                              child: const DoctorDashboard(),
                            ),
                          );
                        },
                      ),
                    ),
                    verticalSpace(20),
                  ],
                ),
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
}
