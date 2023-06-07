import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/variables.dart';

import '../../dialogs.dart';
import '../../messages.dart';

class ViewChartOrderScreen extends StatefulWidget {
  const ViewChartOrderScreen({super.key, required this.patientId});

  final int patientId;

  @override
  State<ViewChartOrderScreen> createState() => _ViewChartOrderScreenState();
}

class _ViewChartOrderScreenState extends State<ViewChartOrderScreen> {
  bool isLoading = true;
  List<dynamic> data = [];

  List<dynamic> deptData = [
    {"dept": "Gastroentrology", "value": 1},
    {"dept": "Gynaecology", "value": 2},
    {"dept": "Cardiology", "value": 3},
    {"dept": "Neurology", "value": 4},
    {"dept": "Pediatrics", "value": 5},
  ];
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
          "patient_id": widget.patientId,
        };
        HttpRequest(parameters: {"sqlCode": "T1354", "parameters": parameters})
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

  String myDept(id) {
    var depName = deptData
        .where((element) {
          return element["value"] == id;
        })
        .toList()[0]["dept"]
        .toString();

    return depName;
  }

  Future _refresh() async => setState(() {
        isLoading = true;
        getData();
      });
  @override
  Widget build(BuildContext context) {
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
          "Doctor's Order",
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : !isLoading && data.isEmpty
              ? GestureDetector(
                  onTap: _refresh,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(child: Text('No data found! Tap to refresh')),
                  ))
              : StretchingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                        itemCount: data.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
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
                                        child: Text(
                                          data[index]['order'],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Date: ${DateFormat.yMMMMd('en_US').format(DateTime.parse(data[index]['order_date']))}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Variable.verticalSpace(10),
                                              Text(
                                                'Time: ${DateFormat.jm().format(DateTime.parse(data[index]['order_date']))}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Variable.verticalSpace(10),
                                              Text(
                                                'Rationale: ${data[index]['rationale']}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              ),
                                              Variable.verticalSpace(10),
                                              Text(
                                                'Order by: Dr. ${data[index]['doctor_name']} (${myDept(Variable.userInfo["department_id"])})',
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
