import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:startit/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/WebApis.dart';
import '../services/WebResponseExtractor.dart';

class AddModify2 extends StatefulWidget {
  double width;
  PageController pageController = PageController();
  int sliderIndex;
  AddModify2(this.width, this.pageController, this.sliderIndex);

  @override
  _AddModify2State createState() => _AddModify2State();
}

class _AddModify2State extends State<AddModify2>
    with AutomaticKeepAliveClientMixin<AddModify2> {
  List<TextEditingController> createTextController = [
    for (int i = 0; i < 4; i++) TextEditingController()
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // if (loadedBip == true) {
    getData();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: widget.width * 0.1, right: widget.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isEnglish ? "Idea Title" : 'आइडिया शीर्षक',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                " *",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: createTextController.elementAt(0),
            maxLength: 30,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              focusColor: Colors.white70,
              hintText: isEnglish ? "Enter Title" : 'आइडिया शीर्षक दर्ज करें',
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
          Row(
            children: [
              Text(
                isEnglish ? "Idea Summary" : 'आइडिया सारांश',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                " *",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 4,
            maxLength: 200,
            controller: createTextController.elementAt(1),
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(
              //     vertical: widget.width * 0.13,
              //     horizontal: widget.width * 0.02),
              filled: true,
              fillColor: Colors.grey[50],
              focusColor: Colors.white70,
              hintText: isEnglish
                  ? "Enter The Summary of your Idea"
                  : 'आइडिया सारांश दर्ज करें',
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
          Text(
            "50-200 characters",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                isEnglish
                    ? "How is your Idea unique?"
                    : 'आपका आइडिया कितना अनूठा है?',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                " *",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 4,
            maxLength: 100,
            controller: createTextController.elementAt(2),
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(
              //     vertical: widget.width * 0.13,
              //     horizontal: widget.width * 0.02),
              filled: true,
              fillColor: Colors.grey[50],
              focusColor: Colors.white70,
              hintText: isEnglish
                  ? "Explain your Idea"
                  : 'अपनी विशिष्टता की व्याख्या करें',
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
          Text(
            "20-100 characters",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                isEnglish
                    ? "Use Case or Case Study"
                    : 'केस या केस स्टडी का उपयोग करें',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              // Text(
              //   " *",
              //   style: TextStyle(color: Colors.red),
              // )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: 4,
            maxLength: 250,
            controller: createTextController.elementAt(3),
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(
              //     vertical: widget.width * 0.13,
              //     horizontal: widget.width * 0.02),
              filled: true,
              fillColor: Colors.grey[50],
              focusColor: Colors.white70,
              hintText: isEnglish
                  ? "Explain your Use Case or Case Study"
                  : 'अपने उपयोग के मामले या केस स्टडी की व्याख्या करें',
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
          Text(
            "100-250 characters",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.grey[500]),
          ),
          // SizedBox(height: 10),
          // GestureDetector(
          //   child: Text(
          //     "Example",
          //     textScaleFactor: 1,
          //     style: TextStyle(
          //         color: Colors.blue,
          //         decoration: TextDecoration.underline,
          //         decorationStyle: TextDecorationStyle.double),
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 30,
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
              if (createTextController.elementAt(0).text.trim().isEmpty) {
                WebResponseExtractor.showToast('Please enter Idea Title');
              } else if (createTextController.elementAt(0).text.length > 30) {
                WebResponseExtractor.showToast(
                    'Idea Title is not more than 30 words');
              } else if (createTextController
                  .elementAt(1)
                  .text
                  .trim()
                  .isEmpty) {
                WebResponseExtractor.showToast('Please enter Idea Summary');
              } else if (createTextController.elementAt(1).text.length < 50) {
                WebResponseExtractor.showToast(
                    'Please enter minimum 50 words in Idea Summary');
              } else if (createTextController.elementAt(1).text.length > 200) {
                WebResponseExtractor.showToast(
                    'Please enter less than 200 words in Idea Summary');
              } else if (createTextController
                  .elementAt(2)
                  .text
                  .trim()
                  .isEmpty) {
                WebResponseExtractor.showToast(
                    'Please enter How is your idea unique');
              } else if (createTextController.elementAt(2).text.length < 20) {
                WebResponseExtractor.showToast(
                    'Please enter minimum 20 words in How is your idea unique');
                // } else if (createTextController.elementAt(3).text.isEmpty) {
                //   WebResponseExtractor.showToast(
                //       'Please enter Use case or case study');
                // } else if (createTextController.elementAt(3).text.length < 100) {
                //   WebResponseExtractor.showToast(
                //       'Please enter minimum 100 words in Use case or case study');
              } else {
                addBipTextData();
                widget.pageController.animateToPage(widget.sliderIndex + 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastLinearToSlowEaseIn);
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.35)
        ],
      ),
    );
  }

  void addBipTextData() async {
    Map data = {
      "user_id": userIdMain,
      "bip_idea_id": bipIdeaId,
      "idea_title": createTextController.elementAt(0).text,
      "how_your_idea_is_unique": createTextController.elementAt(2).text,
      "use_case_or_story": createTextController.elementAt(3).text,
      "idea_summary": createTextController.elementAt(1).text,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.ADD_BIP_IDEA_SECOND),
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
        recentIdeaGroupId = jsonData["FIREBASE_GROUP_ID"];
        // print(recentIdeaGroupId);
        recentIdeaTitle = createTextController.elementAt(0).text;
        recentFriendListIds.add(userFirebaseId);
        // sendGroupMessage(
        //     recentIdeaGroupId,
        //     createTextController.elementAt(0).text,
        //     recentIdeaGroupId,
        //     "https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png",
        //     recentFriendListIds);
      }
    }
  }

  static void sendGroupMessage(String groupFirebaseId, String groupName,
      String groupId, String groupImage, List<String> userList) {
    DocumentReference documentReference1;
    DateTime nows = DateTime.now();

    String formattedDate = nows.microsecondsSinceEpoch.toString();
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
        'forwardMessage': "no"
      });
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
          createTextController.elementAt(0).text = userData["idea_title"];
          recentIdeaTitle = userData["idea_title"];
          createTextController.elementAt(1).text = userData["idea_summary"];
          createTextController.elementAt(2).text =
              userData["how_your_idea_is_unique"];
          createTextController.elementAt(3).text =
              userData["use_case_or_story"];
        });
      }
    }
  }
}
