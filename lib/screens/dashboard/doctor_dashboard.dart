import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import 'patient_form.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        backgroundColor: const Color(0xFF06919d),
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: const Color(0xFF06919d),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF06919d),
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 246, 248, 249),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF06919d),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage("assets/images/doctora.png"),
                                  )),
                            ),
                            Container(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Addrian M. Mamar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                const Text(
                                  "Specialist",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80))),
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.bar_chart_rounded,
                              color: Colors.purple,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              color: Colors.black54,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            hintText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.only(left: 5),
                            hintStyle: const TextStyle(color: Colors.black54),
                          ),
                          onChanged: (text) {
                            // text = text.toLowerCase();
                            // setState(() {
                            //   ctr = 0;
                            //   if (text.isEmpty) {
                            //     _data = widget.data;
                            //   }
                            //   _data = _data.where((areaName) {
                            //     var noteTitle = areaName.parkAreaName
                            //         .toString()
                            //         .toLowerCase();
                            //     return noteTitle.contains(text);
                            //   }).toList();
                            // });
                          }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 7, 182, 235),
                        ),
                        Text(
                          " August 16,1998",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return lamingaNurse(size);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget lamingaNurse(size) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/profileimage.png"),
                                )),
                          ),
                          Container(
                            height: 40,
                          )
                        ],
                      ),
                      Container(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                          ),
                          const AutoSizeText(
                            "Rechie R. Arnado",
                            style: TextStyle(
                              color: Color(0xFF255880),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 10,
                          ),
                          const Text(
                            "Registered Nurse ",
                            style: TextStyle(
                              color: Color(0xFF255880),
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 15,
                              ),
                              Text(
                                " Available",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 10.0),
                              child: MaterialButton(
                                height: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: Colors.green,
                                padding: const EdgeInsets.all(10),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.leftToRight,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      alignment: Alignment.centerLeft,
                                      child: const PatientForm(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "   Assign Patient   ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
