import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class ViewOrder extends StatefulWidget {
  final Object doctorsData;
  const ViewOrder({super.key, required this.doctorsData});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  var myData = [];
  bool isLoading = true;

  @override
  void initState() {
    myData.add(widget.doctorsData);

    super.initState();
    getData();
  }

  void getData() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
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
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color(0xFF06919d),
              statusBarIconBrightness: Brightness.light,
            ),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const Center(
                    child: Text(
                  'View Order',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
                Container(
                  height: 20,
                ),
                Row(
                  children: const [
                    Expanded(
                        child: Text(
                      "Date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                    Expanded(
                        child: Text(
                      "Order",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                    Expanded(
                        child: Text(
                      "Rationale",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      myData[0]["date"],
                      softWrap: true,
                    )),
                    Expanded(
                        child: Text(
                      myData[0]["order"],
                      softWrap: true,
                    )),
                    Expanded(
                        child: Text(
                      myData[0]["rationale"],
                      softWrap: true,
                    )),
                  ],
                ),

                // Expanded(
                //   child: ListView.builder(
                //     itemCount: widget.doctorsData.length,
                //     itemBuilder: (context, i) {
                //       return Column(
                //         children: [
                //           Row(
                //             children: [
                //               Expanded(
                //                   child: Text(
                //                 widget.doctorsData.date,
                //                 softWrap: true,
                //               )),
                //               Expanded(
                //                   child: Text(
                //                 widget.doctorsData[i]['order'],
                //                 softWrap: true,
                //               )),
                //               Expanded(
                //                   child: Text(
                //                 widget.doctorsData[i]['rationale'],
                //                 softWrap: true,
                //               )),
                //             ],
                //           ),
                //           Divider()
                //         ],
                //       );
                //     },
                //   ),
                // ),
                Container(
                  height: 20,
                ),
              ],
            ),
          ))),
    );
  }
}
