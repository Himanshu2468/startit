import 'package:shared_preferences/shared_preferences.dart';
import 'package:startit/src/screens/dashboard.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'package:flutter/material.dart';

class FacebookSignInApi {
  static void facebookLoginUser(
    BuildContext context,
    String move,
    String facebookUserFirstName,
    String facebookUserLastName,
    String facebookUserEmail,
    String facebookUserUniqueId,
  ) async {
    Map mapdata = {
      "email": facebookUserEmail,
      "id": facebookUserUniqueId,
    };
    print(mapdata);
    final response = await http.post(
      Uri.parse(WebApis.FACEBOOK_LOGIN),
      body: json.encode(mapdata),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    final jsonData = jsonDecode(response.body) as Map;

    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 2) {
        Navigator.of(context).pushNamed(
          "/signUp",
          arguments: {
            "first_name": facebookUserFirstName,
            "last_name": facebookUserLastName,
            "email": facebookUserEmail,
            "facebook_id": facebookUserUniqueId,
            "google_id": "",
          },
        );
      }
      if (jsonData["RETURN_CODE"] == 1) {
        Map data = WebResponseExtractor.filterWebData(response,
            dataObject: "USER_DATA");
        var userData = data["data"];

        userIdMain = int.parse(userData["id"]);
        emailMain = userData["email"];
        mobile = userData["mobile"].toString();
        name = "${userData['first_name']} ${userData['last_name']}";
        print(userIdMain);
        print(mobile);
        print(name);

        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);

        if (userData["role_id"] == "1") {
          move = "/occupation";
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "BIP_DATA");
          var bipData = data["data"];

          if (bipData.toString() == "[]") {
            Navigator.of(context)
                .pushNamed('/personal_details', arguments: move);
          } else if (bipData["country"] == "0") {
            bipId = int.parse(bipData["id"]);
            // profileImageMain = bipData["profile_image"];
            Navigator.of(context).pushNamed('/location', arguments: move);
          } else {
            bipId = int.parse(bipData["id"]);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard', (Route<dynamic> route) => false,
            //     arguments: move);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Dashboard(move)), (Route<dynamic> route) => false);
            // Navigator.of(context).pushNamed('/dashboard', arguments: move);
          }
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              "userId": userIdMain,
              "displayName": name,
              "email": emailMain,
              "mobile": mobile,
              "id": bipId,
              "move": move,
              "userFirebaseId": userFirebaseId
            },
          );
          prefs.setString("userData", userData);
          print(userData);
        }
        if (userData["role_id"] == "2") {
          move = "/capabilities";
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "INS_DATA");
          var investorData = data["data"];

          if (investorData.toString() == "[]") {
            Navigator.of(context)
                .pushNamed('/personal_details', arguments: move);
          } else if (investorData["country"] == null) {
            insId = int.parse(investorData["id"]);
            Navigator.of(context).pushNamed('/location', arguments: move);
          } else {
            insId = int.parse(investorData["id"]);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard', (Route<dynamic> route) => false,
            //     arguments: move);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Dashboard(move)), (Route<dynamic> route) => false);
            // Navigator.of(context).pushNamed('/dashboard', arguments: move);
          }
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              "userId": userIdMain,
              "displayName": name,
              "email": emailMain,
              "mobile": mobile,
              "id": insId,
              "move": move,
              "userFirebaseId": userFirebaseId
            },
          );
          prefs.setString("userData", userData);
        }
        if (userData["role_id"] == "3") {
          move = "/product_provider";
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "PP_DATA");
          var ppData = data["data"];

          if (ppData.toString() == "[]") {
            Navigator.of(context)
                .pushNamed('/personal_details', arguments: move);
          } else if (ppData["country"] == "0") {
            ppId = int.parse(ppData["id"]);
            Navigator.of(context).pushNamed('/location', arguments: move);
          } else {
            ppId = int.parse(ppData["id"]);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard', (Route<dynamic> route) => false,
            //     arguments: move);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Dashboard(move)), (Route<dynamic> route) => false);
            // Navigator.of(context).pushNamed('/dashboard', arguments: move);
          }
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              "userId": userIdMain,
              "displayName": name,
              "email": emailMain,
              "mobile": mobile,
              "id": ppId,
              "move": move,
              "userFirebaseId": userFirebaseId
            },
          );
          prefs.setString("userData", userData);
        }
        if (userData["role_id"] == "4") {
          move = "/domain";
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "SP_DATA");
          var spData = data["data"];

          if (spData.toString() == "[]") {
            Navigator.of(context)
                .pushNamed('/personal_details', arguments: move);
          } else if (spData["country"] == "0") {
            spId = int.parse(spData["id"]);
            Navigator.of(context).pushNamed('/location', arguments: move);
          } else {
            spId = int.parse(spData["id"]);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard', (Route<dynamic> route) => false,
            //     arguments: move);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    Dashboard(move)), (Route<dynamic> route) => false);
            // Navigator.of(context).pushNamed('/dashboard', arguments: move);
          }
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              "userId": userIdMain,
              "displayName": name,
              "email": emailMain,
              "mobile": mobile,
              "id": spId,
              "move": move,
              "userFirebaseId": userFirebaseId
            },
          );
          prefs.setString("userData", userData);
        }
      } else if (jsonData["RETURN_CODE"] == -1) {
        Map data = WebResponseExtractor.filterUserData(response,
            dataObject: "USER_ID");
        var userData = data["data"];

        userIdMain = int.parse(userData["id"]);
        mobile = userData["mobile"].toString();
        name = userData["first_name"];
        print(userIdMain);
        print(mobile);
        print(name);

        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
        Navigator.of(context).pushNamed('/welcome');
      }
    } else
      WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
  }
}
