import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WebResponseExtractor {
  static dynamic filterWebData(response,
      {String dataObject = "",
      bool isSubmit = false,
      String innerDataObject = ""}) {
    final jsonData = jsonDecode(response.body) as Map;
    var returnCode = jsonData['RETURN_CODE'];
    print(jsonData['RETURN_MESSAGE']);
    if (returnCode == 1) {
      if (isSubmit) {
        //showToast('${jsonData['RETURN_MESSAGE']}');
        Map dataField = {
          "code": returnCode,
          "data": null,
          "message": jsonData['RETURN_MESSAGE']
        };
        return dataField;
      } else {
        //WebResponseExtractor.showToast('${jsonData['RETURN_MESSAGE']}');
        var data = jsonData['$dataObject'];
        Map dataField = {
          "code": returnCode,
          "data": data,
          "message": jsonData['RETURN_MESSAGE']
        };
        return dataField;
      }
    } else {
      //WebResponseExtractor.showToast('${jsonData['RETURN_MESSAGE']}');
      Map dataField = {"data": null, "message": jsonData['RETURN_MESSAGE']};
      return dataField;
    }
  }

  static dynamic filterUserData(response,
      {String dataObject = "",
      bool isSubmit = false,
      String innerDataObject = ""}) {
    final jsonData = jsonDecode(response.body) as Map;
    var returnCode = jsonData['RETURN_CODE'];
    if (returnCode == 1) {
      if (isSubmit) {
        Map dataField = {
          "code": returnCode,
          "data": null,
          "message": jsonData['RETURN_MESSAGE']
        };
        return dataField;
      } else {
        var data = jsonData['$dataObject'];
        Map dataField = {
          "code": returnCode,
          "data": data,
          "message": jsonData['RETURN_MESSAGE']
        };
        return dataField;
      }
    } else if (returnCode == -1) {
      var data = jsonData['$dataObject'];
      Map dataField = {
        "data": data,
        "message": jsonData['RETURN_MESSAGE'],
      };
      return dataField;
    }
  }

  static Map<String, dynamic> filterListWebData(response,
      {String dataObject, bool isSubmit = false}) {
    final jsonData = jsonDecode(response.body) as Map;
    var returnCode = jsonData['RETURN_CODE'];
    print(jsonData['RETURN_MESSAGE']);
    if (returnCode == 1) {
      if (isSubmit) {
        // showToast('${jsonData['RETURN_MESSAGE']}');
        Map<dynamic, dynamic> dataField = {
          "code": 1,
          "data": null,
          "message": jsonData['RETURN_MESSAGE']
        };
        return dataField;
      } else {
        //Utils.showToast('${jsonData['RETURN_MESSAGE']}');
        // WebResponseExtractor.showToast('${jsonData['RETURN_MESSAGE']}');
        Map<dynamic, dynamic> data = jsonData['$dataObject'];
        Map<dynamic, dynamic> dataField = {
          "code": 1,
          "data": data,
          "message": jsonData['RETURN_MESSAGE']
        };
        return dataField;
      }
    } else {
      //  Utils.showToast('${jsonData['RETURN_MESSAGE']}');
      return null;
    }
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        textColor: Colors.black,
        backgroundColor: Colors.grey[200],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2);
  }
}
