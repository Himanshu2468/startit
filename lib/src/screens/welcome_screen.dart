import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:startit/main.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  DateTime currentBackPressTime;
  String move = "";
  Widget optionsScreen;
  bool isSomethingSelected = false;
  bool isResourceProvider = false;
  int grpValue = 0;
  int resourceGrpValue = 0;
  int userRoleID;

  build(context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.fromLTRB(0, height * 0.1, width * 0.1, height * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.47,
                  child: isSomethingSelected
                      ? optionsScreen
                      : choosePassion(width, height),
                ),
                SizedBox(height: height * 0.03),
                options(width, height),
                SizedBox(height: height * 0.05),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.1),
                  child: ElevatedButton(
                      onPressed: isSomethingSelected
                          ? () {
                              setUserRole();
                            }
                          : null,
                      child: Text(
                        isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                        textScaleFactor: 1,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      WebResponseExtractor.showToast("Press back again to exit the app");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget options(double width, double height) {
    return Container(
      padding: EdgeInsets.only(left: width * 0.1),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                activeColor: Colors.amber,
                value: 1,
                groupValue: grpValue,
                onChanged: (val) {
                  isSomethingSelected = true;
                  isResourceProvider = false;
                  grpValue = val;
                  resourceGrpValue = 0;
                  userRoleID = 1;
                  setState(
                    () {
                      move = "/occupation";
                      optionsScreen = passion(
                          width,
                          height,
                          'undraw_business_shop.png',
                          isEnglish
                              ? 'One different idea can change the world'
                              : 'एक अलग आइडिया दुनिया को बदल सकता है');
                    },
                  );
                },
              ),
              Text(
                isEnglish ? 'Idea Person' : 'आइडिया धारक',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                activeColor: Colors.amber,
                value: 2,
                groupValue: grpValue,
                onChanged: (val) {
                  isResourceProvider = false;
                  isSomethingSelected = true;
                  grpValue = val;
                  resourceGrpValue = 0;
                  userRoleID = 2;
                  setState(
                    () {
                      move = "/capabilities";
                      optionsScreen = passion(
                          width,
                          height,
                          'undraw_server_status.png',
                          isEnglish
                              ? 'Your investment can be a money machine'
                              : 'आपका निवेश एक मनी मशीन हो सकता है');
                    },
                  );
                },
              ),
              Text(
                isEnglish ? 'Investor' : 'इन्वेस्टर',
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio(
                activeColor: Colors.amber,
                value: 3,
                groupValue: grpValue,
                onChanged: (val) {
                  isResourceProvider = true;
                  isSomethingSelected = true;
                  grpValue = val;
                  resourceGrpValue = 4;
                  userRoleID = 4;
                  setState(
                    () {
                      move = "/domain";
                      optionsScreen = passion(
                        width,
                        height,
                        'undraw_environment.png',
                        isEnglish
                            ? 'Your services can help to achieve the goals of others'
                            : 'आपकी सेवाएं दूसरों के लक्ष्यों को प्राप्त करने में मदद कर सकती हैं',
                        leftAlign: true,
                      );
                    },
                  );
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    isEnglish ? 'Resource Provider' : 'संसाधन प्रदाता',
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: Colors.amber,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 4,
                        groupValue: resourceGrpValue,
                        onChanged: isResourceProvider
                            ? (val) {
                                grpValue = 3;
                                resourceGrpValue = val;
                                userRoleID = 4;
                                setState(
                                  () {
                                    move = "/domain";
                                    optionsScreen = passion(
                                      width,
                                      height,
                                      'undraw_environment.png',
                                      isEnglish
                                          ? 'Your services can help to achieve the goals of others'
                                          : 'आपकी सेवाएं दूसरों के लक्ष्यों को प्राप्त करने में मदद कर सकती हैं',
                                      leftAlign: true,
                                    );
                                  },
                                );
                              }
                            : null,
                      ),
                      Text(
                        isEnglish ? 'Service Provider' : 'सेवा प्रदाता',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: resourceGrpValue == 4
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: resourceGrpValue == 4
                                ? Colors.black
                                : Colors.black54),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: Colors.amber,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 5,
                        groupValue: resourceGrpValue,
                        onChanged: isResourceProvider
                            ? (val) {
                                grpValue = 3;
                                resourceGrpValue = val;
                                userRoleID = 3;
                                setState(
                                  () {
                                    move = "/product_provider";
                                    optionsScreen = passion(
                                      width,
                                      height,
                                      'undraw_environment.png',
                                      isEnglish
                                          ? 'Your products can be used in the different manner to fulfill others requirements'
                                          : 'आवश्यकताओं को पूरा करने के लिए आपके उत्पादों/सेवाओं का विभिन्न तरीकों से उपयोग किया जा सकता है',
                                      leftAlign: true,
                                    );
                                  },
                                );
                              }
                            : null,
                      ),
                      Text(
                        isEnglish ? 'Product Provider' : 'उत्पाद प्रदाता',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: resourceGrpValue == 5
                                ? FontWeight.w500
                                : FontWeight.normal,
                            color: resourceGrpValue == 5
                                ? Colors.black
                                : Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
        color: Colors.lightBlue, fontSize: 20.0, fontWeight: FontWeight.w500);
  }

  Widget choosePassion(double width, double height) {
    return Padding(
      padding: EdgeInsets.only(left: width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Image(
          //   image: AssetImage("assets/images/startitsplash.png"),
          // ),
          Center(
            child: Container(
              height: height * 0.09,
              width: width * 0.6,
              child: Image.asset("assets/images/startitsplash2.PNG"),
            ),
          ),
          SizedBox(
            height: height * 0.1,
          ),
          Text(
            isEnglish ? 'Great!' : 'स्वागत है!',
            textScaleFactor: 1,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.lightBlue, fontWeight: FontWeight.w700),
          ),
          Text(
            isEnglish
                ? 'Welcome $name start your journey with STARTiT'
                : ' उपयोगकर्ता $name STARTiT के साथ अपनी यात्रा शुरू करें',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.lightBlue, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: height * 0.06,
          ),
          Text(
            isEnglish ? 'Choose Your Passion' : 'अपना जुनून चुनें',
            textScaleFactor: 1,
            style: _textStyle(),
          ),
        ],
      ),
    );
  }

  Widget passion(double width, double height, String imageName, String tagline,
      {bool leftAlign = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          leftAlign ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
              leftAlign ? EdgeInsets.zero : EdgeInsets.only(left: width * 0.1),
          child: Image(
            image: AssetImage('assets/images/$imageName'),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: width * 0.1),
          child: Text(
            tagline,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: _textStyle(),
          ),
        ),
      ],
    );
  }

  void setUserRole() async {
    Map data = {
      "user_id": userIdMain,
      "user_role": userRoleID,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.UPDATE_USER_ROLE),
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
        print(jsonData);
        Navigator.of(context).pushNamed('/personal_details', arguments: move);
        // WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
        WebResponseExtractor.showToast("Saved");
      }
    }
  }
}
