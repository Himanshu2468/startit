import 'package:flutter/material.dart';

import '../../main.dart';
import '../services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddModify3 extends StatefulWidget {
  PageController pageController = PageController();
  int sliderIndex;
  double width;
  double height;
  AddModify3(this.pageController, this.sliderIndex, this.width, this.height);

  @override
  _AddModify3State createState() => _AddModify3State();
}

class _AddModify3State extends State<AddModify3>
    with AutomaticKeepAliveClientMixin<AddModify3> {
  TextEditingController createUserController = TextEditingController();
  List<int> friendUserId = [];

  List<String> pickItemFriendList = [];

  bool isNumber = false;

  @override
  void initState() {
    friendUserId.add(0);
    // if (loadedBip == true) {
    getData();
    // }
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: widget.width * 0.1, right: widget.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEnglish
                ? "Add By Mobile No./ Email"
                : 'मोबाइल नंबर या ईमेल द्वारा जोड़ें।',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: createUserController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              focusColor: Colors.white70,
              hintText: isEnglish
                  ? "Enter Mobile No./ Email"
                  : 'मोबाइल नंबर / ईमेल दर्ज करें',
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
          SizedBox(
            height: 30,
          ),
          Container(
            // color: Colors.yellow,
            width: widget.width * 0.43,
            height: widget.height * 0.07,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.orange),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isEnglish ? 'Invite' : 'आमंत्रण',
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
                onPressed: () {
                  if (validateEmail(createUserController.text) == true) {
                    createUser();
                  } else
                    WebResponseExtractor.showToast(isNumber
                        ? "Invalid Mobile Number"
                        : "Invalid Email Id");
                }),
          ),
          SizedBox(
            height: widget.height * 0.05,
          ),
          Container(
            child: Wrap(
              children: [
                ...List.generate(
                  pickItemFriendList.length,
                  (index) => list(
                    index,
                    pickItemFriendList[index],
                    Colors.amber[600],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: widget.height * 0.05,
          ),
          ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
            onPressed: () {
              if (friendUserId.first != 0) {
                addFriends();
              }

              widget.pageController.animateToPage(widget.sliderIndex + 1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn);
            },
          ),
        ],
      ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);

    if (regex.hasMatch(value)) {
      isNumber = false;
      return true;
    } else if (int.tryParse(value) != null) {
      isNumber = true;
      if (value.length != 10) {
        return false;
      } else if (int.parse(value[0]) != 6 &&
          int.parse(value[0]) != 7 &&
          int.parse(value[0]) != 8 &&
          int.parse(value[0]) != 9) {
        return false;
      } else {
        return true;
      }
    } else {
      isNumber = false;
      return false;
    }
  }

  Widget list(int item, String txt, Color clr) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: height * 0.04,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: clr,
          ),
          padding: EdgeInsets.only(left: width * 0.04),
          width: width * 0.71,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.55,
                child: Text(
                  txt,
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pickItemFriendList.remove(pickItemFriendList[item]);
                    friendUserId.remove(friendUserId[item]);
                  });
                  print(friendUserId);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
      ],
    );
  }

  void createUser() async {
    Map mapData = {
      "user_id": userIdMain,
      "user_email": isNumber
          ? int.parse(createUserController.text)
          : createUserController.text,
      "mapped_user_ids": friendUserId.join(","),
    };
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.BIP_INVITE_FRIEND),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );

    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      Map data =
          WebResponseExtractor.filterWebData(response, dataObject: "DETAILS");

      if (data["code"] == 1) {
        getFriendIdFromWeb(data["data"]);
      }
    } else
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
  }

  Future<Null> getFriendIdFromWeb(var jsonData) async {
    if (friendUserId.first == 0) {
      friendUserId.clear();
    }
    if (friendUserId.contains(jsonData["id"])) {
      WebResponseExtractor.showToast('Already exist in friend List');
    } else {
      friendUserId.add(int.parse(jsonData["id"]));
      setState(() {
        pickItemFriendList.add(createUserController.text);
      });
    }
    createUserController.clear();
    print(friendUserId);
  }

  void addFriends() async {
    Map mapData = {
      "user_id": userIdMain,
      "bip_idea_id": bipIdeaId,
      "mapped_user_ids": friendUserId.join(","),
    };
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.BIP_ADD_FRIEND),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );

    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;

    WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
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
            dataObject: "FRIEND_LIST");
        List userData = data["data"] != null ? data["data"] : [];
        print(userData);
        if (userData != []) {
          pickItemFriendList.clear();
          friendUserId.clear();
          userData.forEach((e) {
            pickItemFriendList
                .add(e["email"] != null ? e["email"] : e["mobile"]);
            friendUserId.add(int.parse(e["id"]));
          });
          print(friendUserId);
          setState(() {});
        }
      }
    }
  }
}
