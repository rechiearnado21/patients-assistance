import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const AddPatient()),
                ),
              );
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
        ),
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
            "Patients",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
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
    return InkWell(
      onTap: () {
        //  print("data $data");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => PatientDetails(dataObject: data)),
          ),
        );
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
