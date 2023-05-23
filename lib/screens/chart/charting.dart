import 'package:flutter/material.dart';
import 'package:nurse_assistance/screens/chart/add_chart.dart';

class Chart extends StatefulWidget {
  final Object patientData;
  const Chart({super.key, required this.patientData});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Object> patientDataLocal = [];

  @override
  void initState() {
    super.initState();
    patientDataLocal.add(widget.patientData);
  }

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
        title: const Text(
          'Charting',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => AddChart(data: patientDataLocal)),
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
                              children: const [
                                Text(
                                  "John Doe",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                ),
                                Text(
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
                          children: const [
                            Text(
                              "Room No: ",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                              maxLines: 2,
                            ),
                            Expanded(
                              child: Text(
                                "1",
                                style: TextStyle(
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
                          children: const [
                            Text(
                              "Ward No: ",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                              maxLines: 2,
                            ),
                            Expanded(
                              child: Text(
                                "1",
                                style: TextStyle(
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
