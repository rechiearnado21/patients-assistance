// import 'package:flutter/services.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// import 'package:flutter/material.dart';

// class ViewDoctorsOrder extends StatefulWidget {
//   final List<dynamic> doctorsData;
//   const ViewDoctorsOrder({super.key, required this.doctorsData});

//   @override
//   State<ViewDoctorsOrder> createState() => _ViewDoctorsOrderState();
// }

// class _ViewDoctorsOrderState extends State<ViewDoctorsOrder> {
//   var myData = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     myData.add(widget.doctorsData);

//     super.initState();
//     getData();
//   }

//   void getData() {
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
//       child: Scaffold(
//           appBar: AppBar(
//             toolbarHeight: 0,
//             backgroundColor: Colors.white,
//             leading: InkWell(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Icon(
//                 Icons.arrow_back,
//                 color: Colors.black,
//               ),
//             ),
//             elevation: 0,
//             systemOverlayStyle: const SystemUiOverlayStyle(
//               statusBarColor: Color(0xFF06919d),
//               statusBarIconBrightness: Brightness.light,
//             ),
//           ),
//           body: SafeArea(
//               child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             child: Column(
//               children: [
//                 const Center(
//                     child: Text(
//                   'Doctors Order',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 )),
//                 Container(
//                   height: 20,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Expanded(
//                         child: Text(
//                       "Date",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                     )),
//                     Expanded(
//                         child: Text(
//                       "Order",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                     )),
//                     Expanded(
//                         child: Text(
//                       "Rationale",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                     )),
//                   ],
//                 ),
//                 Container(
//                   height: 10,
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: doctorsOrderData.length,
//                     itemBuilder: (context, i) {
//                       return Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                   child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   doctorsOrderData[i]['date'],
//                                   softWrap: true,
//                                 ),
//                               )),
//                               Expanded(
//                                   child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   doctorsOrderData[i]['order'],
//                                   softWrap: true,
//                                 ),
//                               )),
//                               Expanded(
//                                   child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   doctorsOrderData[i]['rationale'],
//                                   softWrap: true,
//                                 ),
//                               )),
//                             ],
//                           ),
//                           Divider()
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Card()
//               ],
//             ),
//           ))),
//     );
//   }
// }
