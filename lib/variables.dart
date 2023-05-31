import 'dart:io';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Variable {
  static String userName = '';
  static String password = '';
  static dynamic userInfo;
  static int orNo = 0;
  static String notificationTable = 'notifications';
  static FlutterTts flutterTts = FlutterTts();
  static int colorIndex(int index) {
    return index > 17
        ? int.parse(index.toString()[(index.toString().length - 1)]) < 17
            ? int.parse(index.toString()[(index.toString().length - 1)]) + 1
            : int.parse(index.toString()[(index.toString().length - 1)])
        : index - 1;
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

      // for (String colName in colNames) {
      //   if (_group != "") _group += "_";
      //   _group += _self.tripNo.toString();
      // }

      _setItem(group, itemData);
    }

    callBack(groups);
  }

  static Widget textFieldTitle(BuildContext context, String title) => Text(
        title,
        textAlign: TextAlign.left,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.grey.shade600),
      );

  static String capitalizeFirstLetter(String str) =>
      str[0].toUpperCase() + str.substring(1).toLowerCase();

  static String capitalize(String value) {
    if (value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  static OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ));
  }

  static OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ));
  }

  static Widget verticalSpace(double height) => SizedBox(
        height: height,
      );
  static Widget horizontalSpace(double width) => SizedBox(
        width: width,
      );

  static String roundString(String num) {
    String res = '';

    if (int.parse(double.parse(num).toStringAsFixed(2).split('.')[1]) == 0) {
      res = double.parse(num).round().toString();
    } else {
      res = double.parse(num).toStringAsFixed(2);
    }

    return res;
  }

  static Future checkInternet(Function(bool hasInternet) callBack) async {
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

  static int numSeconds(String date) {
    int res = 0;

    final eventDate = DateTime.parse(date);
    final today = DateTime.now();

    res = eventDate.difference(today).inSeconds;

    return res;
  }
}
