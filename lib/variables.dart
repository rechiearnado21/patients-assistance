import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter_tts/flutter_tts.dart';

const String gApiURL = 'crm.zfleet.ph';
const String gApiSubFolder = '/api/getrecords';
const String gApiSubFolderLogin = '/account/validateMobile';
const String gApiSubFolderGetImage = '/mobile/hsm/uploads/images';
bool isDebugMode = true;
const jsonEncoder = JsonEncoder();
String tableNotification = 'notification';
dynamic eventDataRow;
int userId = 0;
final FlutterTts flutterTts = FlutterTts();
String capitalizeFirstLetter(String str) =>
    str[0].toUpperCase() + str.substring(1).toLowerCase();

int colorIndex(int index) {
  return index > 17
      ? int.parse(index.toString()[(index.toString().length - 1)]) < 17
          ? int.parse(index.toString()[(index.toString().length - 1)]) + 1
          : int.parse(index.toString()[(index.toString().length - 1)])
      : index - 1;
}

bool emailValidator(String string) {
  if (string.isEmpty) {
    return false;
  }

  const pattern = r'[A-Za-z0-9]+(.|_)+[A-Za-z0-9]+(.com|.net)';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(string)) {
    return false;
  }
  return true;
}

void zettaGroupBy(data, callBack) {
  var groups = [];
  setItem(name, value) {
    // ignore: prefer_typing_uninitialized_variables
    var r;
    r = null;
    for (var itemData in groups) {
      if (itemData['name'] == name) {
        r = itemData;
      }
    }
    if (r != null) {
      r['items'].add(value);
    } else {
      var item = {
        "name": name,
        "items": [value]
      };

      groups.add(item);
    }
  }

  for (var itemData in data) {
    var self = itemData;
    var group = "";

    group = '${self["event_id"]}';

    setItem(group, itemData);
  }
  callBack(groups);
}

void hasInternetConnection(Function callBack) async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      final ping = Ping('google.com', count: 1);
      ping.stream.listen((event) {
        if (event.summary == null) {
        } else {
          if (event.summary!.received > 0) {
            callBack(true);
          } else {
            callBack(false);
          }
        }
      });
    } else {
      callBack(false);
    }
  } on SocketException catch (_) {
    callBack(false);
  }
}

Widget verticalSpace(double height) => SizedBox(
      height: height,
    );
Widget horizontalSpace(double width) => SizedBox(
      width: width,
    );

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({required this.child, required this.direction})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: getBeginOffset(),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }
}
