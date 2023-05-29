import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/screens/order/view.dart';
import 'package:nurse_assistance/variables.dart';

class PatientDetails extends StatefulWidget {
  final Object dataObject;
  const PatientDetails({super.key, required this.dataObject});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  bool isLoadingPatient = true;
  bool isLoadingOrder = true;
  int tabIndex = 0;
  List<dynamic> dataPatient = [];
  List<dynamic> data = [];
  List<dynamic> dataMonitoringTask = [];
  var doctorsOrderWidget = <Widget>[];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    dataPatientGG();
  }

  void dataPatientGG() {
    setState(() {
      dataPatient.add(widget.dataObject);
      isLoading = false;
    });
    refresh();
    refreshMonitoring();
  }

  Future<void> getMonitoringData() async {
    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        setState(() {
          isLoadingPatient = false;
        });
        CustomDialog(
                message: Message.noInternet, isSuccess: false, isCancel: false)
            .defaultDialog();
      } else {
        Map<String, dynamic> parameters = {
          "patient_id": dataPatient[0]["patient_id"],
        };

        HttpRequest(parameters: {"sqlCode": "T1352", "parameters": parameters})
            .post()
            .then((res) {
          if (res == null) {
            setState(() {
              isLoadingPatient = false;
            });
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else {
            setState(() {
              dataMonitoringTask = res["rows"];
              isLoadingPatient = false;
            });
          }
        });
      }
    });
  }

  Future<void> getData() async {
    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        setState(() {
          isLoadingOrder = false;
        });
        CustomDialog(
                message: Message.noInternet, isSuccess: false, isCancel: false)
            .defaultDialog();
      } else {
        Map<String, dynamic> parameters = {
          "doctor_id": Variable.userInfo["personnel_id"],
          "patient_id": dataPatient[0]["patient_id"],
        };

        HttpRequest(parameters: {"sqlCode": "T1345", "parameters": parameters})
            .post()
            .then((res) {
          if (res == null) {
            setState(() {
              isLoadingOrder = false;
            });
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else {
            setState(() {
              data = res["rows"];

              isLoadingOrder = false;
            });
          }
        });
      }
    });
  }

  Future refresh() async => setState(() {
        isLoadingOrder = true;
        getData();
      });
  Future refreshMonitoring() async => setState(() {
        isLoadingPatient = true;
        getMonitoringData();
      });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        // ignore: unrelated_type_equality_checks
        floatingActionButton: tabIndex == 1
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => OrderScreen(
                            dataObject: dataPatient, onSuccess: refresh)),
                      ),
                    );
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.add),
                ),
              ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).primaryColor,
                size: 30,
              )),
          title: Text(
            'Patient Details',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black, fontSize: 16),
          ),
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white),
          elevation: 0.5,
        ),
        body: SafeArea(
          child: Container(
            color: Colors.grey.shade100,
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          width: size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          "assets/images/profileimage.png"),
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  dataPatient[0]["full_name"],
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Container(
                                                width: 3,
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: 5,
                                          ),
                                          Container(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Patient Name",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 10,
                                ),
                                const Divider(),
                                Text("Address: ${dataPatient[0]["address"]}"),
                                Container(
                                  height: 10,
                                ),
                                Text("Mobile: ${dataPatient[0]["mobile_no"]}"),
                                Container(
                                  height: 10,
                                ),
                                Text(
                                    "BirthDate: ${DateFormat.yMMMMd('en_US').format(DateTime.parse(dataPatient[0]["birth_date"]))}"),
                                Container(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            "Age:  ${dataPatient[0]["age"]}")),
                                    Expanded(
                                        child: Text(
                                            "Gender: ${dataPatient[0]["gender"]}")),
                                  ],
                                ),
                                Container(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            "Room#: ${dataPatient[0]["room_no"]}")),
                                    Expanded(
                                        child: Text(
                                            "Ward#: ${dataPatient[0]["ward_no"]}")),
                                  ],
                                ),
                                Container(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text("Diagnosis: "),
                                    Text(dataPatient[0]["diagnosis"]),
                                  ],
                                ),
                                Container(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                  Container(
                    height: 20,
                  ),
                  TabBar(
                    controller: tabController,
                    onTap: (index) {
                      setState(() {
                        tabIndex = index;
                      });
                    },
                    isScrollable: false,
                    labelColor: Colors.black,
                    indicatorColor: Colors.blue,
                    labelPadding: const EdgeInsets.all(0),
                    unselectedLabelStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400),
                    labelStyle: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                    tabs: const [
                      Tab(
                        // icon: Icon(Icons.add_circle_outline_rounded),
                        text: "Order",
                      ),
                      Tab(
                          // icon: Icon(Icons.add_circle_outline_rounded),
                          text: "Patient Monitoring"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        doctorsOrderTab(size),
                        patientMonitoringTab(size),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget doctorsOrderTab(size) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: isLoadingOrder
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : !isLoadingOrder && data.isEmpty
              ? GestureDetector(
                  onTap: refresh,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(child: Text('No data found! Tap to refresh')),
                  ))
              : Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 10),
                    child: StretchingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      child: RefreshIndicator(
                        onRefresh: refresh,
                        child: ListView.builder(
                            itemCount: data.length,
                            padding: const EdgeInsets.only(top: 15),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  if (index == 0)
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Expanded(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Date",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            )),
                                            Expanded(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Order",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            )),
                                            Expanded(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                "Rationale",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            )),
                                          ],
                                        ),
                                        Container(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data[index]["order_date"],
                                          softWrap: true,
                                        ),
                                      )),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data[index]["order"],
                                          softWrap: true,
                                        ),
                                      )),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data[index]["rationale"],
                                          softWrap: true,
                                        ),
                                      )),
                                    ],
                                  ),
                                  Variable.verticalSpace(10)
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget patientMonitoringTab(size) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: isLoadingPatient
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : !isLoadingPatient && dataMonitoringTask.isEmpty
              ? GestureDetector(
                  onTap: refreshMonitoring,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(child: Text('No data found! Tap to refresh')),
                  ))
              : StretchingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  child: RefreshIndicator(
                    onRefresh: refreshMonitoring,
                    child: ListView.builder(
                        itemCount: dataMonitoringTask.length,
                        padding: const EdgeInsets.only(top: 15),
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey.shade300)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: AutoSizeText(
                                                dataMonitoringTask[index]
                                                    ['medic_name'],
                                                maxFontSize: 14,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Variable.horizontalSpace(10),
                                            dataMonitoringTask[index]
                                                        ['is_done'] ==
                                                    'Y'
                                                ? const Icon(
                                                    Icons
                                                        .check_circle_outline_outlined,
                                                    color: Colors.green,
                                                  )
                                                : Variable.horizontalSpace(1)
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Date: ${DateFormat.yMMMMd('en_US').format(DateTime.parse(dataMonitoringTask[index]['medic_date']))}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Variable.verticalSpace(10),
                                              Text(
                                                'Time: ${DateFormat.jm().format(DateTime.parse(dataMonitoringTask[index]['medic_date']))}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Variable.verticalSpace(10),
                                              Text(
                                                'Medication: ${dataMonitoringTask[index]['meal'] == 'N' ? 'N/A' : dataMonitoringTask[index]['meal']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Variable.verticalSpace(10),
                                              Text(
                                                'Status: ${dataMonitoringTask[index]['status'] == 'N' ? 'N/A' : dataMonitoringTask[index]['status']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Variable.verticalSpace(10),
                                              Text(
                                                'Encoded By: ${dataMonitoringTask[index]['encoded_by_name'].isEmpty ? 'N/A' : dataMonitoringTask[index]['encoded_by_name']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                            ]),
                                      )
                                    ]),
                              ),
                              Variable.verticalSpace(10)
                            ],
                          );
                        }),
                  ),
                ),
    );
  }
}
