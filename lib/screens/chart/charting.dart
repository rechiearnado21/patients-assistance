import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nurse_assistance/screens/chart/add_chart.dart';

import '../../dialogs.dart';
import '../../http_request.dart';
import '../../messages.dart';
import '../../variables.dart';

class Chart extends StatefulWidget {
  final dynamic patientData;
  const Chart({super.key, required this.patientData});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  bool isLoading = true;
  List<dynamic> data = [];
  @override
  void initState() {
    getData();
    super.initState();
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
          "patient_id": widget.patientData["patient_id"],
        };
        HttpRequest(parameters: {"sqlCode": "T1352", "parameters": parameters})
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Charts',
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
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => AddChart(data: widget.patientData)),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 35,
              ),
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: const [
          //     Text(
          //       "Early",
          //       style: TextStyle(
          //         color: Colors.black54,
          //         fontSize: 10,
          //       ),
          //     ),
          //     Text(
          //       "On Time",
          //       style: TextStyle(
          //         color: Colors.black54,
          //         fontSize: 10,
          //       ),
          //     ),
          //     Text(
          //       "Late",
          //       style: TextStyle(
          //         color: Colors.black54,
          //         fontSize: 10,
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            width: 10,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.patientData["full_name"],
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                ),
                                const Text(
                                  "08/16/ 1998 8:00 PM",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 2,
                                ),
                              ],
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text(
                              "Room No: ",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                              maxLines: 2,
                            ),
                            Expanded(
                              child: Text(
                                '${widget.patientData["room_no"]}',
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Ward No: ",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                              maxLines: 2,
                            ),
                            Expanded(
                              child: Text(
                                '${widget.patientData["ward_no"]}',
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                    child: Container(
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
                                    padding: const EdgeInsets.only(top: 15),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Material(
                                            elevation: 1,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Container(
                                              height: 200,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.primaries[
                                                    Variable.colorIndex(
                                                        data[index]
                                                            ['chart_id'])],
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: Text(
                                                        "Task No: ${index + 1}",
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15)),
                                                          color: Colors.white,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                data[index][
                                                                    'medic_name'],
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Variable
                                                                  .verticalSpace(
                                                                      10),
                                                              Text(
                                                                'Date: ${data[index]['medic_date'].toString().split(' ')[0]}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              Variable
                                                                  .verticalSpace(
                                                                      10),
                                                              Text(
                                                                'Time: ${data[index]['medic_date'].toString().split(' ')[1]}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              Variable
                                                                  .verticalSpace(
                                                                      10),
                                                              Text(
                                                                'Nurse: ${data[index]['full_name']}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ]),
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
                                          Variable.verticalSpace(10)
                                        ],
                                      );
                                    }),
                              ),
                            ),
                )),

                // const Center(
                //     child: Text(
                //   'Doctors Order',
                //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                // )),
                // Container(
                //   height: 20,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     Expanded(
                //         child: Text(
                //       "Date",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                //     )),
                //     Expanded(
                //         child: Text(
                //       "Order",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                //     )),
                //     Expanded(
                //         child: Text(
                //       "Rationale",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                //     )),
                //   ],
                // ),
                // Container(
                //   height: 10,
                // ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: doctorsOrderData.length,
                //     itemBuilder: (context, i) {
                //       return Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Expanded(
                //                   child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text(
                //                   doctorsOrderData[i]['date'],
                //                   softWrap: true,
                //                 ),
                //               )),
                //               Expanded(
                //                   child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text(
                //                   doctorsOrderData[i]['order'],
                //                   softWrap: true,
                //                 ),
                //               )),
                //               Expanded(
                //                   child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text(
                //                   doctorsOrderData[i]['rationale'],
                //                   softWrap: true,
                //                 ),
                //               )),
                //             ],
                //           ),
                //           Divider()
                //         ],
                //       );
                //     },
                //   ),
                // ),
                // Card()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
