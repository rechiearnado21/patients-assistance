import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_assistance/widgets/custom_btn.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  List<dynamic> typeOfUserData = [
    {"type": "Doctor", "value": "doctor"},
    {"type": "Nurse", "value": "nurse"}
  ];
  List<dynamic> dept = [
    {"dept": "Gastroentrology", "value": "gastro"},
    {"dept": "Gynaecology", "value": "gynaecology"},
    {"dept": "Cardiology", "value": "cardio"},
    {"dept": "Neurology", "value": "neuro"},
    {"dept": "Pediatrics", "value": "pediatrics"},
  ];
  bool isShowPassword = false;
  String? userType;
  String? deptId;
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
    fullName = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    phone = TextEditingController();
    address = TextEditingController();
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
          // leading: InkWell(
          //   onTap: () {},
          //   child: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          // ),
          elevation: 0,
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
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Select Type User",
                          border: myinputborder(),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                        ),
                        value: userType,
                        onChanged: (String? newValue) {
                          setState(() {
                            userType = newValue!.toString();
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
                        onChanged: (String? newValue) {
                          setState(() {
                            deptId = newValue;
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
                        onChanged: (value) {},
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
                        onChanged: (value) {},
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
                        onChanged: (value) {},
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
                        onChanged: (value) {},
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
                        onChanged: (value) {},
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
                        onChanged: (value) {},
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
                          backgroundColor: Colors.purple,
                          isDisabled: false,
                          onTap: () async {},
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      )
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
          "Create Account",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 10,
        ),
        const AutoSizeText(
          "Sign up to register!",
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
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
}
