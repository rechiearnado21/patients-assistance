import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../variables.dart';

class PatientsRecords extends StatefulWidget {
  final List<dynamic> patientData;
  final String patientName;
  const PatientsRecords(
      {super.key, required this.patientData, required this.patientName});

  @override
  State<PatientsRecords> createState() => _PatientsRecordsState();
}

class _PatientsRecordsState extends State<PatientsRecords> {
  bool isLoading = true;
  List<dynamic> data = [];
  @override
  void initState() {
    super.initState();
    getDataPatient();
  }

  void getDataPatient() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
          'Patient Records',
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
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/profileimage.png"),
                                  )),
                            ),
                            Container(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  widget.patientName,
                                  style: const TextStyle(
                                    color: Color(0xFF255880),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Container(
                                  height: 5,
                                ),
                                const AutoSizeText(
                                  "Patient Name",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          ],
                        ),
                        const Divider(),
                        Container(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                "Diagnosis: ${widget.patientData[0]["diagnosis"]}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                                maxLines: 2,
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                "Date & Time: ${DateFormat().format(DateTime.parse(widget.patientData[0]["created_date"]))}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                "Room No: ${widget.patientData[0]["room_no"]}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                                maxLines: 2,
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                "Ward No: ${widget.patientData[0]["ward_no"]}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                "Gender: ${widget.patientData[0]["gender"] == "m" ? "Male" : "Female"}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                                maxLines: 2,
                              ),
                            ),
                            const Expanded(child: SizedBox())
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 10),
                child: AutoSizeText(
                  "List of Charts",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                ),
              ),
              Expanded(
                  child: Container(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : !isLoading && widget.patientData.isEmpty
                        ? GestureDetector(
                            child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                                child: Text('No data found! Tap to refresh')),
                          ))
                        : StretchingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            child: ListView.builder(
                                itemCount: widget.patientData.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: widget.patientData[index]
                                                    ['is_done'] ==
                                                'Y' ||
                                            widget.patientData[index]
                                                    ['nurse_id'] !=
                                                Variable
                                                    .userInfo["personnel_id"]
                                        ? null
                                        : () {},
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey.shade300)),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          widget.patientData[
                                                                  index]
                                                              ['medic_name'],
                                                          maxFontSize: 14,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14),
                                                        ),
                                                      ),
                                                      Variable.horizontalSpace(
                                                          10),
                                                      widget.patientData[index]
                                                                  ['is_done'] ==
                                                              'Y'
                                                          ? const Icon(
                                                              Icons
                                                                  .check_circle_outline_outlined,
                                                              color:
                                                                  Colors.green,
                                                            )
                                                          : Variable
                                                              .horizontalSpace(
                                                                  1)
                                                    ],
                                                  ),
                                                ),
                                                const Divider(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Date: ${DateFormat.yMMMMd('en_US').format(DateTime.parse(widget.patientData[index]['medic_date']))}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 13),
                                                        ),
                                                        Variable.verticalSpace(
                                                            10),
                                                        Text(
                                                          'Time: ${DateFormat.jm().format(DateTime.parse(widget.patientData[index]['medic_date']))}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 13),
                                                        ),
                                                        Variable.verticalSpace(
                                                            10),
                                                        Text(
                                                          'Medication: ${widget.patientData[index]['meal'] == 'N' ? 'N/A' : widget.patientData[index]['meal']}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 13),
                                                        ),
                                                        Variable.verticalSpace(
                                                            10),
                                                        Text(
                                                          'Status: ${widget.patientData[index]['status'] == 'N' ? 'N/A' : widget.patientData[index]['status']}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 13),
                                                        ),
                                                        Variable.verticalSpace(
                                                            10),
                                                        Text(
                                                          'Encoded By: ${widget.patientData[index]['encoded_by_name'].isEmpty ? 'N/A' : widget.patientData[index]['encoded_by_name']}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 13),
                                                        ),
                                                      ]),
                                                )
                                              ]),
                                        ),
                                        Variable.verticalSpace(10)
                                      ],
                                    ),
                                  );
                                }),
                          ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
