import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_assistance/dialogs.dart';
import 'package:nurse_assistance/http_request.dart';
import 'package:nurse_assistance/screens/chart_view/patients_records.dart';
import 'package:nurse_assistance/variables.dart';

import '../../messages.dart';

class MyRecords extends StatefulWidget {
  const MyRecords({super.key});

  @override
  State<MyRecords> createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  List<dynamic> listOfNursedata = [];
  List<dynamic> patientData = [];
  bool loadingNurse = true;
  String filter = '';
  TextEditingController controller = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    getListOfPatients();
    super.initState();
  }

  void zettaGroupBy(data, callBack) {
    var groups = [];
    // ignore: no_leading_underscores_for_local_identifiers
    _setItem(name, value) {
      // ignore: prefer_typing_uninitialized_variables
      var r;
      r = null;
      for (var itemData in groups) {
        if (itemData['patient_name'] == name) {
          r = itemData;
        }
      }
      if (r != null) {
        r['items'].add(value);
      } else {
        var item = {
          "patient_name": name,
          "items": [value]
        };

        groups.add(item);
      }
    }

    for (var itemData in data) {
      var self = itemData;
      var group = "";
      group = '${self["patient_name"]}';
      _setItem(group, itemData);
    }

    callBack(groups);
  }

  void getListOfPatients() async {
    setState(() {
      patientData = [];
    });
    Variable.checkInternet((hasInternet) {
      if (!hasInternet) {
        setState(() {
          loadingNurse = false;
        });
        CustomDialog(
                message: Message.noInternet, isSuccess: false, isCancel: false)
            .defaultDialog();
      } else {
        Map<String, dynamic> parameters = {
          "nurse_id": Variable.userInfo["personnel_id"],
        };
        HttpRequest(parameters: {"sqlCode": "T1355", "parameters": parameters})
            .post()
            .then((res) {
          if (res == null) {
            setState(() {
              loadingNurse = false;
            });
            CustomDialog(
                    message: Message.error, isSuccess: false, isCancel: false)
                .defaultDialog();
          } else {
            setState(() {
              // var newMap = groupBy(res["rows"], (Map obj) => obj['patient_id']);

              // for (var dataRow in res["rows"]) {

              //    patientData.add({"patient_name:"});
              // }
              // print(newMap);
              zettaGroupBy(res["rows"], (dataReturn) {
                setState(() {
                  patientData = dataReturn;
                  loadingNurse = false;
                });
              });
            });
          }
        });
      }
    });
  }

  Future _refreshNurse() async => setState(() {
        loadingNurse = true;
        getListOfPatients();
      });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              // Get.back();
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.clear,
              color: Theme.of(context).primaryColor,
              size: 30,
            )),
        title: Text(
          'My Records',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: TextField(
                focusNode: searchFocusNode,
                controller: controller,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: 'Search Patients',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.only(left: 20),
                  hintStyle: const TextStyle(color: Colors.black54),
                  suffixIcon: InkWell(
                    onTap: filter.isEmpty
                        ? () {
                            searchFocusNode.requestFocus();
                          }
                        : () {
                            controller.clear();
                            setState(() {
                              filter = '';
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                    child: filter.isEmpty
                        ? const Icon(Icons.search)
                        : const Icon(Icons.close),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    filter = value;
                  });
                }),
          ),
          const Divider(),
          Expanded(
            child: loadingNurse
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor),
                  )
                : !loadingNurse && patientData.isEmpty
                    ? GestureDetector(
                        onTap: _refreshNurse,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                              child: Text(
                                  'No data found! Tap to refresh ${patientData.length}')),
                        ))
                    : StretchingOverscrollIndicator(
                        axisDirection: AxisDirection.down,
                        child: RefreshIndicator(
                          onRefresh: _refreshNurse,
                          child: ListView.builder(
                              itemCount: patientData.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (filter.isEmpty) {
                                  return listTileBottomSheet(
                                      patientData[index]);
                                } else {
                                  if (patientData[index]['patient_name']
                                      .toLowerCase()
                                      .contains(filter.toLowerCase())) {
                                    return listTileBottomSheet(
                                        patientData[index]);
                                  } else {
                                    return const SizedBox();
                                  }
                                }
                              }),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget listTileBottomSheet(dataNurse) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PatientsRecords(
                  patientData: dataNurse["items"],
                  patientName: dataNurse["patient_name"]),
            ),
          );
        },
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
                  dataNurse["patient_name"],
                  style: const TextStyle(
                    color: Color(0xFF255880),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    AutoSizeText(
                      "Patient Name",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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
