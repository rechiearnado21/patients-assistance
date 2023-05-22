import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/screens/order/view.dart';
import 'package:nurse_assistance/variables.dart';

class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  bool isLoading = true;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    // getData();
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
        HttpRequest(parameters: {"sqlCode": "T1343", "parameters": parameters})
            .post()
            .then((res) {
          print("res $res");
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(bottom: 20),
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: ((context) => const AddPatient()),
        //         ),
        //       );
        //     },
        //     backgroundColor: Colors.green,
        //     child: const Icon(Icons.add),
        //   ),
        // ),
        appBar: AppBar(
          backgroundColor: const Color(0xFF06919d),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF06919d),
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Patient Information",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.grey.shade100,
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
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
                                          const Expanded(
                                            child: AutoSizeText(
                                              "Rechie R. Arnado",
                                              style: TextStyle(
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
                            Text("Address: Libaong San Remigio"),
                            Container(
                              height: 10,
                            ),
                            Text("Mobile: 09215764234"),
                            Container(
                              height: 10,
                            ),
                            Text("BirthDate: 08-16-1998"),
                            Container(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(child: Text("Age: 10")),
                                Expanded(child: Text("Gender: F")),
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Expanded(child: Text("Room#: 1")),
                                Expanded(child: Text("Ward#: 2")),
                              ],
                            ),
                            Container(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text("Diagnosis: "),
                                Text("Wala ko kabalo huhu"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Doctors Order",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const OrderScreen()),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.purple,
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "fasdfsaf",
                                        softWrap: true,
                                      ),
                                    )),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "fasfdasfa",
                                        softWrap: true,
                                      ),
                                    )),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "adfafasf",
                                        softWrap: true,
                                      ),
                                    )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "fasdfsaf",
                                        softWrap: true,
                                      ),
                                    )),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "fasfdasfa",
                                        softWrap: true,
                                      ),
                                    )),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "adfafasf",
                                        softWrap: true,
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Task",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Task 1",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          "John Doe",
                                          style: TextStyle(
                                              color: Color(0xFF255880),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 2,
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Patient Name",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Container(
                                      height: 5,
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.medication,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          " Paracetamol",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 5,
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.alarm,
                                          color: Colors.purple,
                                        ),
                                        Text(
                                          " 3:00 PM 08/18/1998",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Task 2",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          "John Doe",
                                          style: TextStyle(
                                              color: Color(0xFF255880),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 2,
                                        ),
                                        Container(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Patient Name",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Container(
                                      height: 5,
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.medication,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          " Paracetamol",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 5,
                                    ),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.alarm,
                                          color: Colors.purple,
                                        ),
                                        Text(
                                          " 3:00 PM 08/18/1998",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // isLoading
            //     ? Center(
            //         child: CircularProgressIndicator(
            //             color: Theme.of(context).primaryColor),
            //       )
            //     : !isLoading && data.isEmpty
            //         ? GestureDetector(
            //             onTap: _refresh,
            //             child: const Padding(
            //               padding: EdgeInsets.symmetric(horizontal: 20),
            //               child: Center(
            //                   child: Text('No data found! Tap to refresh')),
            //             ))
            //         : StretchingOverscrollIndicator(
            //             axisDirection: AxisDirection.down,
            //             child: RefreshIndicator(
            //               onRefresh: _refresh,
            //               child: ListView.builder(
            //                   itemCount: data.length,
            //                   itemBuilder: (BuildContext context, int index) {
            //                     return patientsChuChu(data[index]);
            //                   }),
            //             ),
            //           ),

            // ListView.builder(
            //     itemCount: 5,
            //     itemBuilder: (BuildContext context, int index) {
            //       return patientsChuChu();
            //     }),
          ),
        ),
      ),
    );
  }

  Widget patientsChuChu(data) {
    return InkWell(
      onTap: () {
        print("data $data");
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: ListTile(
            leading: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            ),
            title: Text(data['full_name']),
            subtitle: const Text("Patient Name"),
            trailing: const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
