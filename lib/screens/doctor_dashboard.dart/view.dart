import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/screens/doctor_dashboard.dart/patientsList.dart';
import 'package:nurse_assistance/screens/patient/view.dart';
import 'package:nurse_assistance/screens/profile/update_profile.dart';
import 'package:nurse_assistance/variables.dart';
import '../../dialogs.dart';
import '../../messages.dart';
import 'controller.dart';

class DoctorDashboardScreen extends GetView<DoctorDashboardController> {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorDashboard();
  }
}

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  bool isLoading = true;
  List<dynamic> data = [];
  String myDepartment = "";
  String filter = '';

  TextEditingController controller = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        setState(() {
          isLoading = false;
        });
        CustomDialog(
                message: Message.noInternet, isSuccess: false, isCancel: false)
            .defaultDialog();
      } else {
        Map<String, dynamic> parameters = {
          "department_id": Variable.userInfo["department_id"],
        };
        HttpRequest(parameters: {"sqlCode": "T1342", "parameters": parameters})
            .post()
            .then((res) {
          if (res == null) {
            setState(() {
              isLoading = false;
            });
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else {
            setState(() {
              data = res["rows"];
              //data["full_name"]

              isLoading = false;
            });
          }
        });
      }
    });
  }

  Future _refresh() async => setState(() {
        isLoading = true;
        getData();
      });

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
  String myType(id) {
    var depName = typeOfUserData
        .where((element) {
          return element["value"] == id;
        })
        .toList()[0]["type"]
        .toString();

    return depName;
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: WillPopScope(
        onWillPop: () async {
          CustomDialog(
              title: 'Hang on',
              message: 'Are you sure you want to close the app?',
              onTap: () {
                SystemNavigator.pop();
              }).defaultDialog();
          return false;
        },
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
                          Expanded(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            const UpdateProfile()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              "assets/images/doctora.png"),
                                        )),
                                  ),
                                ),
                                Container(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        "${Variable.userInfo["full_name"]}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                        maxFontSize: 20,
                                      ),
                                      Container(
                                        height: 10,
                                      ),
                                      Text(
                                        "${myType(Variable.userInfo["role_id"])}/${myDept(Variable.userInfo["department_id"])}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => const PatientList()),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.people,
                                  color: Theme.of(context).primaryColor,
                                ),
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
                            focusNode: searchFocusNode,
                            controller: controller,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Search',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.only(left: 20),
                              hintStyle: const TextStyle(color: Colors.black54),
                              suffixIcon: InkWell(
                                onTap: filter.isEmpty
                                    ? () {
                                        searchFocusNode.requestFocus();
                                      }
                                    : () {
                                        controller.clear();
                                        setState(() {
                                          filter = '';
                                        });
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                child: filter.isEmpty
                                    ? const Icon(Icons.search)
                                    : const Icon(Icons.close),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                filter = value;
                              });
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
                            Icons.list,
                            color: Color.fromARGB(255, 7, 182, 235),
                          ),
                          Text(
                            " List of Nurses",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : !isLoading && data.isEmpty
                          ? GestureDetector(
                              onTap: _refresh,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                    child:
                                        Text('No data found! Tap to refresh')),
                              ))
                          : StretchingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              child: RefreshIndicator(
                                onRefresh: _refresh,
                                child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (filter.isEmpty) {
                                        return lamingaNurse(data[index]);
                                      } else {
                                        if (data[index]['full_name']
                                            .toLowerCase()
                                            .contains(filter.toLowerCase())) {
                                          return lamingaNurse(data[index]);
                                        } else {
                                          return const SizedBox();
                                        }
                                      }
                                    }),
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget lamingaNurse(dynamic data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
                          AutoSizeText(
                            data["full_name"],
                            style: const TextStyle(
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
                          Text(
                            'Nurse/${myDept(data["department_id"])}',
                            style: const TextStyle(
                              color: Color(0xFF255880),
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                data["shift"] == 'N'
                                    ? Icons.clear
                                    : Icons.check_circle_outline,
                                color: data["shift"] == 'N'
                                    ? Colors.red
                                    : Colors.green,
                                size: 15,
                              ),
                              Variable.horizontalSpace(5),
                              AutoSizeText(
                                data["shift"] == 'N'
                                    ? 'Not Available'
                                    : '${data["shift"]} Shift',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Container(
                            height: 10,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: MaterialButton(
                                height: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: Theme.of(context).primaryColorLight,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                onPressed: () async {
                                  if (data["shift"] == 'N') {
                                    const CustomDialog(
                                      title: 'Oopss',
                                      isCancel: false,
                                      message:
                                          'This nurse is currently not available.',
                                    ).defaultDialog();
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            PatientScreen(nurseData: data)),
                                      ),
                                    );
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    "Assign Patient",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 13,
                                    ),
                                  ),
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
