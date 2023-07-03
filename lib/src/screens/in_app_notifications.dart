import 'package:flutter/material.dart';
import 'package:startit/src/screens/idea_title.dart';
import 'package:startit/src/screens/pdtProvider_details.dart';
import 'package:startit/src/screens/sProvider_domain.dart';
import 'package:startit/src/screens/view_single_service.dart';

import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'ideas.dart';
import 'mng_invt_viewProfile.dart';

class InAppNotification extends StatefulWidget {
  @override
  _InAppNotificationState createState() => _InAppNotificationState();
}

class _InAppNotificationState extends State<InAppNotification> {
  List<NotificationModel> notificationList = [];
  String move = "";

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Alerts & Notifications",
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        width: width * width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Column(
          children: [
            SizedBox(
              width: width * 0.8,
              height: height * 0.88,
              child: ListView.builder(
                padding: EdgeInsets.only(top: width * 0.1),
                itemCount: notificationList.length,
                itemBuilder: (_, i) => notificationTile(
                    context,
                    notificationList[i].notificationId,
                    notificationList[i].title,
                    notificationList[i].navigationHeader,
                    notificationList[i].description,
                    notificationList[i].imageUrl,
                    notificationList[i].seenOrNot,
                    notificationList[i].header,
                    notificationList[i].pathid,
                    notificationList[i].userpathid),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationTile(
      BuildContext context,
      String notificationId,
      String title,
      String navigationHeader,
      String description,
      String imageUrl,
      String seenOrNot,
      String header,
      String pathid,
      String userpathid) {
    return Column(
      children: [
        Container(
          decoration: seenOrNot == "N"
              ? BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15))
              : BoxDecoration(color: Colors.white),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                "http://164.52.192.76:8080/startit/$imageUrl",
              ),
              backgroundColor:
                  imageUrl == "" ? Colors.grey[400] : Colors.transparent,
            ),
            title: Text(
              title,
              textScaleFactor: 1,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              description,
              textScaleFactor: 1,
              style: TextStyle(fontSize: 12),
            ),
            // trailing: Text(
            //   navigationHeader + seenOrNot,
            //   style: TextStyle(color: Colors.black),
            // ),
            onTap: () async {
              setState(() {
                seenOrNot = "Y";
              });
              notificationYN(notificationId);
              if (title == "Register Succesfully" ||
                  title == "Password Changed Succesfully" ||
                  title == "Birthday") {
                WebResponseExtractor.showToast(description);
                Navigator.of(context).pop();
              } else if (title == "Idea Person Added") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx) => IdeaTitle(int.parse(pathid))));
              } else if (title == "Product Provider Added") {
                String s = await getUserName(userpathid);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx) => ViewSingleService(
                        false,
                        int.parse(pathid),
                        int.parse(userpathid),
                        "",
                        "",
                        "",
                        s)));
              } else if (title == "Service Provider Added") {
                String s = await getUserName(userpathid);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx) => ViewSingleService(true, int.parse(pathid),
                        int.parse(userpathid), "", "", "", s)));
              } else if (title == "Investor Added") {
                String s = await getUserName(userpathid);
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx) => MIViewProfile(
                          int.parse(userpathid),
                          "email",
                          "phone",
                          s,
                          pathid,
                        )));
              } else if (title == "Add Idea") {
                isRemember = true;
                isRemember1 = true;
                isRemember2 = true;
                isRemember3 = true;
                isRemember4 = true;
                isRemember5 = true;
                isRemember6 = true;
                isRemember7 = true;
                isRemember8 = true;
                isRememberMe = false;
                isRememberMe1 = false;
                isRememberMe2 = false;
                isRememberMe3 = false;
                isRememberMe4 = false;
                isRememberMe5 = false;
                isRememberMe6 = false;
                isRememberMe7 = false;
                isRememberMe8 = false;
                bipIdeaId = 0;
                loadedBip = false;
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => Ideas()));
              } else if (title == "Add Products") {
                productId = 0;
                loadedProduct = false;
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx) => ProductProviderDetails()));
              } else if (title == "Add Services") {
                serviceId = 0;
                loadService = false;
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (ctx) => ServiceProviderDomain()));
              } else if (title == "New picture Added" ||
                  title == "New Video Added" ||
                  title == "New Document Added") {
                if (header == "idea") {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => IdeaTitle(int.parse(pathid))));
                } else if (header == "investor") {
                  String s = await getUserName(userpathid);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => MIViewProfile(
                            int.parse(userpathid),
                            "email",
                            "phone",
                            s,
                            pathid,
                          )));
                } else if (header == "product") {
                  String s = await getUserName(userpathid);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => ViewSingleService(
                          false,
                          int.parse(pathid),
                          int.parse(userpathid),
                          "",
                          "",
                          "",
                          s)));
                } else if (header == "service") {
                  String s = await getUserName(userpathid);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => ViewSingleService(
                          true,
                          int.parse(pathid),
                          int.parse(userpathid),
                          "",
                          "",
                          "",
                          s)));
                }
              }

              // Navigator.of(context).pop();
            },

            // contentPadding: EdgeInsets.all(20),
          ),
        ),
        SizedBox(height: 15)
      ],
    );
  }

  Future<String> getUserName(String useridsaw) async {
    Map mapData = {"user_id": useridsaw};

    final response = await http.post(
      Uri.parse(WebApis.GET_USERNAME_BY_USERID),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map data =
          WebResponseExtractor.filterWebData(response, dataObject: "FULLNAME");
      if (data["code"] == 1) {
        print(data["data"]);
        return data["data"];
        // getNotificationsFromWeb(data["data"]);
      }
    }
    return "";
  }

  void getNotifications() async {
    // final prefs = await SharedPreferences.getInstance();
    // final extractUserData =
    //     json.decode(prefs.getString("userData")) as Map<String, Object>;
    // move = extractUserData["move"];
    // print("move: $move");

    Map mapData = {"UserID": userIdMain};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_NOTIFICATIONS),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "NotificationData");
      if (data["code"] == 1) {
        print(data["data"]);
        getNotificationsFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getNotificationsFromWeb(var jsonData) async {
    setState(() {
      for (Map notification in jsonData) {
        notificationList.add(
          NotificationModel(
            notificationId:
                notification["id"] != null ? notification["id"] : "",
            title: notification["title"] != null ? notification["title"] : "",
            description: notification["description"] != null
                ? notification["description"]
                : "",
            navigationHeader:
                notification["header"] != null ? notification["header"] : "",
            imageUrl: notification["image_path"] != ""
                ? notification["image_path"]
                : "uploads/bip_idea/idea_1625641649.jpg",
            seenOrNot: notification["SeenOrNot"] != null
                ? notification["SeenOrNot"]
                : "N",
            header:
                notification["header"] != null ? notification["header"] : "",
            pathid: notification["header_id"] != null
                ? notification["header_id"]
                : "",
            userpathid: notification["created_by"] != null
                ? notification["created_by"]
                : "",
          ),
        );
      }
    });
  }

  Future<void> notificationYN(String notificationId) async {
    Map data = {
      "notification_id": notificationId,
      "user_id": userIdMain,
    };

    final response = await http.post(
      Uri.parse(WebApis.NOTIFICATIONS_Y_N),
      body: json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        // WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        // getNotifications();
      }
    }
    // else
    // WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
  }
}

class NotificationModel {
  String notificationId;
  String title;
  String description;
  String navigationHeader;
  String imageUrl;
  String seenOrNot;
  String header;
  String pathid;
  String userpathid;

  NotificationModel({
    this.notificationId,
    this.title,
    this.description,
    this.navigationHeader,
    this.imageUrl,
    this.seenOrNot,
    this.header,
    this.pathid,
    this.userpathid,
  });
}
