import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:startit/main.dart';
import 'package:startit/src/screens/dashboard.dart';

import 'dart:convert';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;

class ResourceParameters extends StatefulWidget {
  static const routeName = "/resource_parameters";
  @override
  _ResourceParametersState createState() => _ResourceParametersState();
}

class _ResourceParametersState extends State<ResourceParameters> {
  TextEditingController competitorController = TextEditingController();

  int _volumeSlider = 0;
  int _valueSlider = 0;
  String bulbColor = "";

  @override
  void initState() {
    // if (loadedBip == true) {
    getData();
    fetchCommitteeMemberData();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.blue,
      // drawer: Drawer(),
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        elevation: 0,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          isEnglish ? "Parameters" : 'मापदंड',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: Colors.blue,
        child: Container(
          height: double.maxFinite,
          width: width,
          padding: EdgeInsets.fromLTRB(
              width * 0.12, width * 0.1, width * 0.12, width * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: height * 0.01),
                Container(
                  width: width,
                  // height: 70,
                  child: Text(
                    isEnglish
                        ? "Parameters where Investors can judge your idea"
                        : 'पैरामीटर जहां निवेशक आपके आइडिया को आंक सकते हैं',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Text(
                  isEnglish
                      ? "Current Stage of your idea"
                      : 'आपके आइडिया का वर्तमान चरण',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: width * 0.1,
                          child: Radio(
                              activeColor: Colors.orange,
                              value: "Initial",
                              groupValue: bulbColor,
                              onChanged: (val) {
                                bulbColor = val;
                                setState(() {});
                              }),
                        ),
                        Text(
                          isEnglish ? "Initial" : 'प्रारंभिक',
                          textScaleFactor: 1,
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Row(
                      children: [
                        Container(
                          width: width * 0.1,
                          child: Radio(
                              activeColor: Colors.orange,
                              value: "Middle",
                              splashRadius: width * 0.001,
                              groupValue: bulbColor,
                              onChanged: (val) {
                                bulbColor = val;
                                setState(() {});
                              }),
                        ),
                        Text(
                          isEnglish ? "Middle" : 'मध्य',
                          textScaleFactor: 1,
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Row(
                      children: [
                        Container(
                          width: width * 0.1,
                          child: Radio(
                              activeColor: Colors.orange,
                              value: "Final",
                              groupValue: bulbColor,
                              onChanged: (val) {
                                bulbColor = val;
                                setState(() {});
                              }),
                        ),
                        Text(
                          isEnglish ? "Final" : 'अंतिम',
                          textScaleFactor: 1,
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    Text(
                      isEnglish ? "Market Size" : 'बाजार का आकार',
                      textScaleFactor: 1,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: MediaQuery.of(context).size.width * 0.065,
                      icon: Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.orange[50],
                              content: Text(
                                isEnglish
                                    ? "Market size is the number of specific users in a certain market section who are probable buyers"
                                    : 'बाजार का आकार एक निश्चित बाजार खंड में विशिष्ट उपयोगकर्ताओं की संख्या है जो संभावित खरीदार हैं',
                                textScaleFactor: 1,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
                sliderMoney(
                    context,
                    width,
                    isEnglish ? "By Volume" : 'वॉल्यूम द्वारा',
                    isEnglish
                        ? "Expected Market Volume = Number of target customers + Penetration rate"
                        : 'बाजार की मात्रा = लक्षित ग्राहकों की संख्या + प्रवेश दर',
                    isEnglish
                        ? (_volumeSlider == 100 ? "Crore" : "Lakh")
                        : (_volumeSlider == 100 ? "करोड़" : "लाख"),
                    _volumeSlider),
                sliderMoney(
                    context,
                    width,
                    isEnglish ? "By Value" : 'मान के अनुसार',
                    isEnglish
                        ? "Expected Market Value = Expected Market Volume X average value"
                        : "बाजार मूल्य = बाजार की मात्रा X औसत मूल्य",
                    isEnglish ? "Crore" : 'करोड़',
                    _valueSlider),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEnglish ? "Current Competitor" : 'प्रतियोगी बढ़त',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: competitorController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          focusColor: Colors.white70,
                          hintText: isEnglish
                              ? "Type the companies name"
                              : 'प्रतियोगी कंपनियों का नाम टाइप करें',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.05),
                ElevatedButton(
                    onPressed: () {
                      addResourceParameters();
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //     '/dashboard', (Route<dynamic> route) => false,
                      //     arguments: "/occupation");
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => Dashboard("/occupation")),
                          (Route<dynamic> route) => false);
                      // Navigator.of(context)
                      //     .pushNamed('/dashboard', arguments: "/occupation");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                          textScaleFactor: 1,
                        ),
                        Icon(Icons.chevron_right),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column sliderMoney(BuildContext context, double width, String heading,
      String info, String value, int _currentSliderValue) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              heading,
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              iconSize: MediaQuery.of(context).size.width * 0.065,
              icon: Icon(
                Icons.info,
                color: Colors.blue,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.orange[50],
                      content: Text(
                        info,
                        textScaleFactor: 1,
                        style: TextStyle(fontSize: 14),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width * 0.6,
              child: Slider(
                inactiveColor: Colors.grey,
                value: _currentSliderValue.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                // label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(
                    () {
                      switch (heading) {
                        case "By Volume":
                          _volumeSlider = value.toInt();
                          break;
                        case "वॉल्यूम द्वारा":
                          _volumeSlider = value.toInt();
                          break;
                        case "By Value":
                          _valueSlider = value.toInt();
                          break;
                        case 'मान के अनुसार':
                          _valueSlider = value.toInt();
                          break;
                      }
                    },
                  );
                },
              ),
            ),
            Text(
              (heading == "By Volume" || heading == "वॉल्यूम द्वारा")
                  ? (_currentSliderValue == 100
                          ? "1"
                          : (_currentSliderValue).toString()) +
                      " $value"
                  : (_currentSliderValue).toString() + " $value",
              textScaleFactor: 1,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  void addResourceParameters() async {
    Map data = {
      "user_id": userIdMain,
      "bip_idea_id": bipIdeaId,
      "stage_of_idea": bulbColor,
      "market_volume": _volumeSlider.toString(),
      "market_value": _valueSlider.toString(),
      "competitor_edge": competitorController.text,
    };
    print(data);
    print(WebApis.ADD_BIP_IDEA_STAGE);
    final response = await http.post(
      Uri.parse(WebApis.ADD_BIP_IDEA_STAGE),
      body: json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      if (jsonData["RETURN_CODE"] == 1) {
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
    print(recentIdeaGroupId);
    print(recentIdeaTitle);
    print(bipIdeaId);
    print(recentFriendListIds);

    sendGroupMessage(recentIdeaGroupId, recentIdeaTitle, bipIdeaId.toString(),
        groupLink, recentFriendListIds);
  }

  static void sendGroupMessage(String groupFirebaseId, String groupName,
      String groupId, String groupImage, List<String> userList) {
    DocumentReference documentReference1;
    DateTime nows = DateTime.now();

    String formattedDate = nows.millisecondsSinceEpoch.toString();
    for (int i = 0; i < userList.length; i++) {
      documentReference1 = FirebaseFirestore.instance
          .collection('user/${userList[i]}/recentMessage')
          .doc(groupFirebaseId);
      documentReference1.set({
        "documentId": groupFirebaseId,
        'Name': groupName,
        'ProfileImage': groupImage,
        'Id': groupFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "New Group",
        'url': "",
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': 'text',
        'totalMessage': "",
        'seenMessage': '',
        "group_id": groupId,
        'messageTo': "group",
        'forwardMessage': "no",
        "adminId": userFirebaseId
      });
      documentReference1 = FirebaseFirestore.instance
          .collection('messages/$userFirebaseId/$groupFirebaseId')
          .doc();
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': groupName,
        'ProfileImage': groupImage,
        'Id': groupFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "New group is created.",
        'url': "",
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': 'text',
        'totalMessage': "0",
        'seenMessage': '',
        "group_id": groupFirebaseId,
        'messageTo': "group",
        'forwardMessage': "no",
        "removedMemberId": "",
        "adminId": userFirebaseId
      });
      // documentReference1 = FirebaseFirestore.instance
      //     .collection('user/${userList[i]}/recentMessage')
      //     .doc(groupFirebaseId);
      // documentReference1.set({
      //   "documentId": groupFirebaseId,
      //   'Name': groupName,
      //   'ProfileImage': groupImage,
      //   'Id': groupFirebaseId,
      //   'SenderName': name,
      //   'SenderProfileImage': profileImageMain,
      //   'SenderId': userFirebaseId,
      //   'Message': "New Group",
      //   'url': "",
      //   'timestamp': formattedDate,
      //   'DateAndTime': DateTime.now().toString(),
      //   'messageType': 'text',
      //   'totalMessage': "",
      //   'seenMessage': '',
      //   "group_id": groupId,
      //   'messageTo': "group",
      //   'forwardMessage': "no",
      //   "adminId": userFirebaseId
      // });
    }
  }

  void getData() async {
    Map mapData = {"idea_id": bipIdeaId};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.VIEW_IDEA),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        Map data = WebResponseExtractor.filterWebData(response,
            dataObject: "IDEA_DETAILS");
        var userData = data["data"];

        setState(() {
          bulbColor = userData["stage_of_idea"];
          _volumeSlider = int.parse(userData["market_volume"]);
          _valueSlider = int.parse(userData["market_value"]);
          competitorController.text = userData["competitor_edge"];
        });
      }
    }
  }

  fetchCommitteeMemberData() async {
    try {
      Map data = {"group_fire_base_id": recentIdeaGroupId};
      final response = await http.post(
        WebApis.GET_CHAT_GROUP,
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        Map data = WebResponseExtractor.filterWebData(response,
            dataObject: 'GROUP_DETAILS');

        if (data["code"] == 1) {
          recentFriendListIds.clear();
          List<String> userids = [];
          var jsonData = data["data"];
          userids = jsonData["user_ids"] != null
              ? jsonData["user_ids"].toString().split(",")
              : [];
          groupLink = jsonData["image"];
          recentIdeaTitle = jsonData["group_name"];
          print(userids.toString());
          for (int i = 0; i < userids.length; i++) {
            print(i);
            getFireIds(userids[i]);
          }

          // for (int i = 0; i < data['data'].length; i++) {
          //   if (data['data'][i]['firebase_userid'] != null &&
          //       data['data'][i]['firebase_userid'] != "" &&
          //       data['data'][i]['firebase_userid'] != "null") {
          //     userFirebaseIdList.add(data['data'][i]['firebase_userid']);
          //   }
          //   if (CustomWidgets.CheckValidString(
          //       data['data'][i]['device_token'].toString())) {
          //     if (data['data'][i]['device_token'].toString() !=
          //         userDeviceToken) {
          //       userTokenIdList.add(data['data'][i]['device_token'].toString());
          //     }
          //   }
          //   //print("List:"+data['data'][i]['device_token'].toString());
          // }

          // List<Map<String,dynamic>> membersList= data['data'];
          // print("committee data:"+data['data'].toStri

        } else {
          return null;
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print(e + " Getting some issue try again later");
      return null;
    }
  }

  Future<void> getFireIds(String ids) async {
    Map data = {"user_id": ids};
    final response = await http.post(
      WebApis.VIEW_PROFILE,
      body: json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      Map data =
          WebResponseExtractor.filterWebData(response, dataObject: 'USER_DATA');

      if (data["code"] == 1) {
        // userFirebaseIdList.clear();
        // userTokenIdList.clear();
        // List<String> userids = [];
        var jsonData = data["data"];
        print(jsonData);
        // getTokenSenderReceiver(jsonData["firebase_user_id"].toString(), false);
        recentFriendListIds.add(jsonData["firebase_user_id"]);
        // userFirebaseIdList.add("LUurrED6JuNybCH5E8b6sdsdyHD3");
        // print(userFirebaseIdList.toString());
      }
    }
  }
}
