import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../landing/landing.dart';

class MainLandingScreen extends StatefulWidget {
  const MainLandingScreen({super.key});

  @override
  State<MainLandingScreen> createState() => _MainLandingScreenState();
}

class _MainLandingScreenState extends State<MainLandingScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      width: size.width,
                      height: size.height * 0.40,
                      image:
                          const AssetImage("assets/images/welcome_nurse.png"),
                    ),
                    Container(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "Welcome Nurse",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        "We care your health",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, right: 10.0),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Colors.green,
                            padding: const EdgeInsets.all(10),
                            onPressed: () async {
                              // showReceipt();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => const LoginScreen()));
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 8.0, right: 10.0),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Colors.green,
                            padding: const EdgeInsets.all(10),
                            onPressed: () async {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => const Signup()));
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  duration: const Duration(milliseconds: 400),
                                  alignment: Alignment.centerLeft,
                                  child: const LandingPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
