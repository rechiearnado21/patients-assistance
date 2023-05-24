import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nurse_assistance/database/notifications_table.dart';
import 'package:nurse_assistance/variables.dart';

import '../screens/chart_view/chart_view_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isLoading = true;
  List<dynamic> data = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    data = await NotificationDatabase.instance.readAllNotifications();
    setState(() {
      isLoading = false;
    });
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
          'Notifications',
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    color: Colors.amber,
                  ),
                  Variable.verticalSpace(5),
                  Container(
                    height: 10,
                    width: 10,
                    color: Colors.green,
                  ),
                  Variable.verticalSpace(5),
                  Container(
                    height: 10,
                    width: 10,
                    color: Colors.red,
                  ),
                ],
              ),
              Variable.horizontalSpace(5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Early",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                  Variable.verticalSpace(3),
                  const Text(
                    "On Time",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                  Variable.verticalSpace(3),
                  const Text(
                    "Late",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 10,
          ),
        ],
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
                        itemBuilder: (BuildContext context, int index) {
                          return StreamBuilder(
                              stream:
                                  Stream.periodic(const Duration(seconds: 1)),
                              builder: (context, snapchat) {
                                final dtCreated =
                                    DateTime.parse(data[index]['medic_date']);
                                final dtNow = DateTime.now();

                                final numMinutes =
                                    dtNow.difference(dtCreated).inMinutes;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChartViewScreen(
                                          patientData: data[index],
                                          callBack: _refresh,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Container(
                                          height: 10,
                                          width: 10,
                                          color: numMinutes >= 5
                                              ? Colors.red
                                              : numMinutes <= -1
                                                  ? Colors.amber
                                                  : Colors.green,
                                        ),
                                        title: Text(
                                          '${data[index]['patient_name']} ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: AutoSizeText(
                                            '${data[index]['medic_name']} ',
                                            maxLines: 2,
                                            maxFontSize: 12,
                                            minFontSize: 10,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                letterSpacing: 0),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 0.2,
                                        width: double.infinity,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }),
                  ),
                ),
    );
  }
}
