import 'package:flutter/services.dart';

class PublicFunction {
  static bool validate(String cname, String value, List<dynamic> data) {
    return wasValidated(data.map((item) {
      if (item["cname"] == cname) {
        item["value"] = value;
      }
      return item;
    }).toList());
  }

  static bool wasValidated(List<dynamic> data) {
    bool res = false;
    int numDataIsRequired = data
        .where(
          (element) => element["is_required"] == true,
        )
        .toList()
        .length;

    int numDataWasValidated = data
        .where((element) =>
            element["is_required"] == true && element["value"].isNotEmpty)
        .toList()
        .length;

    if (numDataIsRequired == numDataWasValidated) {
      res = false;
    } else {
      res = true;
    }

    return res;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
