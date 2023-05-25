// ignore_for_file: file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/messages.dart';
import 'package:nurse_assistance/screens/doctor_dashboard.dart/add_patient_form.dart';
import 'package:nurse_assistance/screens/doctor_dashboard.dart/patient_details.dart';
import 'package:nurse_assistance/variables.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  bool isLoading = true;
  List<dynamic> data = [];

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
        HttpRequest(parameters: {"sqlCode": "T1343", "parameters": parameters})
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => AddPatient(callBack: getData)),
                ),
              );
            },
            backgroundColor: Colors.green,
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
            'Patients',
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
            color: Colors.white,
            width: size.width,
            height: size.height,
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
                              child: Text('No data found! Tap to refresh')),
                        ))
                    : StretchingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        child: RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return patientsChuChu(data[index]);
                              }),
                        ),
                      ),

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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => PatientDetails(dataObject: data)),
          ),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 10,
              ),
              ListTile(
                leading: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/profileimage.png"),
                ),
                title: AutoSizeText(
                  data["full_name"],
                  style: const TextStyle(
                    color: Color(0xFF255880),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
