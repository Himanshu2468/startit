import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'chats.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';

import 'package:intl/intl.dart';

import 'mng_invt_viewProfile.dart';

class AddInsGroup extends StatefulWidget {
  String ideaId;
  String group_id;
  bool isAdmin;
  var data;
  List<String> userFirebaseIdList;

  AddInsGroup(this.ideaId, this.group_id, this.isAdmin, this.data,
      this.userFirebaseIdList);
  @override
  _AddInsGroupState createState() => _AddInsGroupState();
}

class _AddInsGroupState extends State<AddInsGroup> {
  // bool first = true;
  // bool second = false;
  // bool three = false;
  InvestorData search_id = InvestorData();
  ScrollController listController = ScrollController();
  Icon search = Icon(Icons.search);
  Widget searchbar = Text(
    "Add Members",
    textScaleFactor: 1,
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center,
  );

  // TextEditingController remarksController = TextEditingController();
  // TextEditingController storyController = TextEditingController();

  // TextEditingController dateController = TextEditingController();
  // String dob = "";

  // static final now = DateTime.now();

  // TextEditingController timeController = TextEditingController();
  // String time = "";

  List<InvestorData> investordata = [];

  // bool showIdeaSummaryGlobal = false;
  // bool showIdeaUniquenessGlobal = false;
  // bool showIdeaCaseStudyGlobal = false;
  // bool showMediaPicturesGlobal = false;
  // bool showMediaVideosGlobal = false;
  // bool showMediaDocsGlobal = false;

  // String bulbColor = "Y";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    fetchCommitteeMemberData("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    String move = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      // drawer: AppDrawer(move),
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  setState(() {
                    if (search.icon == Icons.search) {
                      search = Icon(Icons.cancel);
                      searchbar = TextField(
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                            hintText: "Search Member",
                            border: InputBorder.none),
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      search = Icon(Icons.search);
                      searchbar = Text(
                        "Add Members",
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      );
                    }
                  });
                },
                icon: search),
          ],
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: searchbar),
      body: Container(
        height: height,
        width: width,
        color: Colors.blue,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )),
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.06, vertical: height * 0.02),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.02),
                if (widget.isAdmin == true)
                  Row(
                    children: [
                      SizedBox(
                        width: width * 0.66,
                        child: TextFormField(
                          controller: searchController,
                          // onChanged: (text) {
                          //   getSuggestions(text);
                          // },
                          onFieldSubmitted: (text) {
                            // text = text.toLowerCase();
                            // setState(() {
                            //   suggestedIdeaData = backupSuggestedIdeaData.where((idea) {
                            //     String ideaTitle = idea.title.toLowerCase();
                            //     String ideaDescription = idea.name.toLowerCase();
                            //     String ideaAddress = idea.address.toLowerCase();
                            //     String ideaContent =
                            //         "$ideaTitle $ideaDescription $ideaAddress";
                            //     return ideaContent.contains(text);
                            //   }).toList();
                            // });
                            getSuggestions(text);
                          },
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Add Members',
                            hintStyle: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 0.4,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Container(
                        height: height * 0.06,
                        decoration: BoxDecoration(
                          // color: Colors.black38,
                          border: Border.all(
                            width: 0.4,
                            color: Colors.blue,
                          ),
                        ),
                        child: TextButton(
                          child: Text(
                            "Add",
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.blue),
                          ),
                          onPressed: () {
                            getSuggestions(searchController.text);
                          },
                          // decoration: BoxDecoration(
                          //     border: Border.all(width: 0.5, color: Colors.green)),
                        ),
                      ),
                    ],
                  ),
                if (widget.isAdmin == true) SizedBox(height: height * 0.03),
                Text(
                  "Group Members",
                  textScaleFactor: 1,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.03),

                // SizedBox(
                //   height: height * 0.01,
                // ),
                Container(
                  height:
                      height - AppBar().preferredSize.height - height * 0.22,
                  child: ListView.builder(
                      controller: listController,
                      padding: EdgeInsets.all(8),
                      itemCount: investordata.length,
                      itemBuilder: (_, i) => InvestorItem(
                            investordata[i].ins_user_id,
                            investordata[i].first_name,
                            investordata[i].last_name,
                            investordata[i].email,
                            investordata[i].firebase_user_id,
                            investordata[i].device_token,
                            investordata[i].profile_image,
                            height,
                            width,
                            investordata[i].phoneNumber,
                            investordata[i].role,
                          )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget InvestorItem(
    String ins_user_id,
    String first_name,
    String last_name,
    String email,
    String firebase_user_id,
    String device_token,
    String profile_image,
    double height,
    double width,
    String phoneNumber,
    String role,
  ) {
    // Color statusColor = Colors.red;
    // String status = "";
    // bool noIdeaSelected = false;
    String roleDes;

    if (role == "1") {
      roleDes = "Business Idea Person";
    } else if (role == "2") {
      roleDes = "Investor";
    } else if (role == "3") {
      roleDes = "Product Provider";
    } else {
      roleDes = "Service Provider";
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.025, vertical: height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                "http://164.52.192.76:8080/startit/$profile_image",
              ),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(
              width: width * 0.05,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width * 0.62,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * 0.40,
                            child: Text(
                              first_name + " " + last_name,
                              textScaleFactor: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            email,
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     // InkWell(
                      //     //   onTap: () {
                      //     //     print("Tap");
                      //     //     Navigator.of(context).push(
                      //     //       MaterialPageRoute(
                      //     //         builder: (context) => MIViewProfile(
                      //     //           int.parse(insUserId),
                      //     //           email,
                      //     //           phone,
                      //     //           createduser,
                      //     //         ),
                      //     //       ),
                      //     //     );
                      //     //   },
                      //     //   child: Container(
                      //     //     width: width * 0.22,
                      //     //     height: height * 0.022,
                      //     //     decoration: BoxDecoration(
                      //     //         border: Border.all(color: Colors.green[300]),
                      //     //         borderRadius: BorderRadius.circular(3)),
                      //     //     child: Center(
                      //     //       child: Text(
                      //     //         "View Profile",
                      //     //         textAlign: TextAlign.center,
                      //     //         style: TextStyle(
                      //     //             color: Colors.green[300],
                      //     //             fontWeight: FontWeight.bold,
                      //     //             fontSize: 10),
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //     // SizedBox(height: 10),
                      //     // // if (receiverFirebaseId != null &&
                      //     // //     receiverFirebaseId != "")
                      //     // if (receiverFirebaseId != null &&
                      //     //     receiverFirebaseId != "")
                      //     //   InkWell(
                      //     //     onTap: () {
                      //     //       var data = {
                      //     //         "name": createduser,
                      //     //         "id": receiverFirebaseId,
                      //     //         "userProfileImage": imageUrl,
                      //     //         "receiverId": receiverFirebaseId,
                      //     //         "chat": "user",
                      //     //         'deviceToken': deviceToken
                      //     //       };
                      //     //       print(data);
                      //     //       Navigator.push(
                      //     //         context,
                      //     //         MaterialPageRoute(
                      //     //             builder: (context) => ChatScreen(data)),
                      //     //       );
                      //     //     },
                      //     //     child: Container(
                      //     //       width: width * 0.22,
                      //     //       height: height * 0.022,
                      //     //       decoration: BoxDecoration(
                      //     //           border: Border.all(color: Colors.blue),
                      //     //           borderRadius: BorderRadius.circular(3)),
                      //     //       child: Center(
                      //     //         child: Text(
                      //     //           "Chat",
                      //     //           textAlign: TextAlign.center,
                      //     //           style: TextStyle(
                      //     //               color: Colors.blue,
                      //     //               fontWeight: FontWeight.bold,
                      //     //               fontSize: 10),
                      //     //         ),
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //   ],
                      // ),
                      if (widget.isAdmin == true &&
                          firebase_user_id != userFirebaseId)
                        IconButton(
                          onPressed: () {
                            // return showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return new AlertDialog(
                            //         title: new Text("Details"),
                            //         content: Column(
                            //           children: [
                            //             CircleAvatar(
                            //               backgroundImage: NetworkImage(
                            //                 "http://164.52.192.76:8080/startit/$profile_image",
                            //               ),
                            //               backgroundColor: Colors.transparent,
                            //               radius: width * 0.3,
                            //             ),

                            //           ],
                            //         ),
                            //         actions: [
                            //           TextButton(
                            //               onPressed: () {
                            //                 Navigator.of(context).pop();
                            //               },
                            //               child: Text("Cancel")),
                            //           TextButton(
                            //               onPressed: () {
                            //                 // if (controller.text.isEmpty)
                            //                 //   WebResponseExtractor.showToast(
                            //                 //       "Please Enter Your Name");
                            //                 // else {
                            //                 // userMain = controller.text.toString();
                            //                 // Navigator.of(context).push(
                            //                 //   MaterialPageRoute(
                            //                 //       builder: (context) => Home(true)),
                            //                 // );
                            //                 // }
                            //               },
                            //               child: Text("Enter"))
                            //         ],
                            //       );
                            //
                            //     });
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(5),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.54,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                "http://164.52.192.76:8080/startit/$profile_image",
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: width * 0.22,
                                            ),
                                          ),
                                          //  /   height: MediaQuery.of(context).size.width * 0.5,
                                          //   child: Divider(
                                          //     thickness: 5,
                                          //     color: Colors.black,
                                          //   ),
                                          // )
                                          SizedBox(
                                            height: height * 0.04,
                                          ),
                                          Text(
                                            first_name + " " + last_name,
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(
                                            email,
                                            textScaleFactor: 1,
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),

                                          Text(
                                            phoneNumber,
                                            textScaleFactor: 1,
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Text(
                                            roleDes,
                                            textScaleFactor: 1,
                                          ),
                                          SizedBox(
                                            height: height * 0.02,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    textScaleFactor: 1,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteMemberIns(
                                                        ins_user_id);
                                                    DocumentReference
                                                        documentReference1;
                                                    //  documentReference1 = FirebaseFirestore
                                                    //   .instance
                                                    //   .collection(
                                                    //       'messages/${widget.userFirebaseIdList[i]}/${widget.data['receiverId']}')
                                                    //   .doc();
                                                    String formattedDate;
                                                    setState(() {
                                                      DateTime now =
                                                          DateTime.now();
                                                      formattedDate = now
                                                          .millisecondsSinceEpoch
                                                          .toString();
                                                    });
                                                    for (int i = 0;
                                                        i <
                                                            widget
                                                                .userFirebaseIdList
                                                                .length;
                                                        i++) {
                                                      // documentReference1 =
                                                      //     FirebaseFirestore
                                                      //         .instance
                                                      //         .collection(
                                                      //             'user/${widget.userFirebaseIdList[i]}/recentMessage')
                                                      //         .doc(widget.data[
                                                      //             'receiverId']);
                                                      // documentReference1.set({
                                                      //   "documentId":
                                                      //       documentReference1.id,
                                                      //   'Name': widget.data['name'],
                                                      //   'ProfileImage': widget.data[
                                                      //       'userProfileImage'],
                                                      //   'Id': widget
                                                      //       .data['receiverId'],
                                                      //   'SenderName': name,
                                                      //   'SenderProfileImage':
                                                      //       profileImageMain,
                                                      //   'SenderId': userFirebaseId,
                                                      //   'Message': sendMsg.text,
                                                      //   'url': "",
                                                      //   'timestamp': formattedDate,
                                                      //   'DateAndTime':
                                                      //       DateTime.now()
                                                      //           .toString(),
                                                      //   'messageType': 'text',
                                                      //   'totalMessage':
                                                      //       userFirebaseIdList[i] !=
                                                      //               userFirebaseId
                                                      //           ? '$countMessage'
                                                      //           : "",
                                                      //   'seenMessage': '',
                                                      //   "group_id":
                                                      //       widget.data['idea_id'],
                                                      //   'messageTo': "group",
                                                      //   'forwardMessage': "no",
                                                      //   "adminId":
                                                      //       widget.data["adminId"]
                                                      // });

                                                      documentReference1 =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'messages/${widget.userFirebaseIdList[i]}/${widget.data['receiverId']}')
                                                              .doc();
                                                      documentReference1.set({
                                                        "documentId":
                                                            documentReference1
                                                                .id,
                                                        'Name':
                                                            widget.data['name'],
                                                        'ProfileImage': widget
                                                                .data[
                                                            'userProfileImage'],
                                                        'Id': widget
                                                            .data['receiverId'],
                                                        'SenderName': name,
                                                        'SenderProfileImage':
                                                            profileImageMain,
                                                        'SenderId':
                                                            userFirebaseId,
                                                        'Message': first_name +
                                                            " " +
                                                            last_name +
                                                            " is removed",
                                                        'url': "",
                                                        'timestamp':
                                                            formattedDate,
                                                        'DateAndTime':
                                                            DateTime.now()
                                                                .toString(),
                                                        'messageType': 'text',
                                                        'totalMessage':
                                                            widget.userFirebaseIdList[
                                                                        i] !=
                                                                    userFirebaseId
                                                                ? '$countMessage'
                                                                : "",
                                                        'seenMessage': '',
                                                        "group_id": widget
                                                            .data['idea_id'],
                                                        'messageTo': "group",
                                                        'forwardMessage': "no",
                                                        "removedMemberId": widget
                                                                    .data[
                                                                'receiverId'] +
                                                            ins_user_id
                                                      });
                                                      /*FirebaseFirestore.instance
                                                    .collection("message")
                                                    .doc('${userFirebaseIdList[i]}')
                                                    .collection(widget.data['receiverId'])
                                                    .add({
                                                  'Name': widget.data['name'],
                                                  'ProfileImage': widget.data['userProfileImage'],
                                                  'Id': widget.data['receiverId'],
                                                  'SenderName': name,
                                                  'SenderProfileImage': profileImageMain,
                                                  'SenderId': userFirebaseId,
                                                  'Message': sendMsg.text,
                                                  'url': "",
                                                  'time': formattedDate,
                                                  'messageType': 'text',
                                                  'totalMessage': '$i',
                                                  'seenMessage': '',
                                                  "group_id":widget.data['id'],
                                                  'messageTo':"group"
                                                });*/

                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Remove",
                                                    textScaleFactor: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                      if (widget.data["adminId"] == firebase_user_id)
                        Container(
                          width: width * 0.22,
                          height: height * 0.022,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green[300]),
                              borderRadius: BorderRadius.circular(3)),
                          child: Center(
                            child: Text(
                              "Group Admin",
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.green[300],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // SizedBox(height: height * 0.015),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         SizedBox(
                //           height: height * 0.01,
                //         ),
                //         Text(
                //           "PHONE",
                //           style: TextStyle(
                //             fontSize: 10,
                //             letterSpacing: 1.0,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         SizedBox(height: 5),
                //         Text(
                //           phone,
                //           style: TextStyle(color: Colors.grey, fontSize: 10),
                //         ),
                //       ],
                //     ),
                //     SizedBox(width: width * 0.05),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         SizedBox(
                //           height: height * 0.01,
                //         ),
                //         Text("EMAIL",
                //             style: TextStyle(
                //               fontSize: 10,
                //               letterSpacing: 1.0,
                //               fontWeight: FontWeight.w500,
                //             )),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Text(
                //           email,
                //           style: TextStyle(color: Colors.grey, fontSize: 10),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(height: height * 0.01),
                // SizedBox(
                //   width: width * 0.6,
                //   child: Divider(
                //     color: Colors.grey[300],
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           "Created",
                //           style: TextStyle(
                //               fontSize: 10, fontWeight: FontWeight.bold),
                //         ),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Container(
                //           width: 80,
                //           height: 25,
                //           decoration: BoxDecoration(
                //               color: Colors.blue[200],
                //               border: Border.all(color: Colors.blue),
                //               borderRadius: BorderRadius.circular(5)),
                //           child: Center(
                //             child: Text(
                //               createdDate,
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 10),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(
                //       width: width * 0.06,
                //     ),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           "Status",
                //           style: TextStyle(
                //               fontSize: 10, fontWeight: FontWeight.bold),
                //         ),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Container(
                //           width: 120,
                //           height: 25,
                //           decoration: BoxDecoration(
                //               border: Border.all(color: statusColor),
                //               borderRadius: BorderRadius.circular(5)),
                //           child: Center(
                //             child: Text(
                //               status,
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                   color: statusColor,
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 10),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // if (titlestatus == "0")
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           SizedBox(height: height * 0.01),
                //           InkWell(
                //             onTap: () {
                //               _declineDialog(
                //                 context,
                //               ).then(
                //                 (val) {
                //                   if (val == true) {
                //                     declineInvestor(titlestatus, relId);
                //                   }
                //                 },
                //               );
                //             },
                //             child: Container(
                //               width: 80,
                //               height: 25,
                //               decoration: BoxDecoration(
                //                   color: Colors.red,
                //                   border: Border.all(color: Colors.red),
                //                   borderRadius: BorderRadius.circular(5)),
                //               child: Center(
                //                 child: Text(
                //                   "Decline",
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                       color: Colors.white,
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 10),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         width: width * 0.06,
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           SizedBox(height: height * 0.01),
                //           InkWell(
                //             onTap: () {
                //               acceptInvestor(1, relId);
                //             },
                //             child: Container(
                //               width: 120,
                //               height: 25,
                //               decoration: BoxDecoration(
                //                   color: Colors.green,
                //                   border: Border.all(color: Colors.green),
                //                   borderRadius: BorderRadius.circular(5)),
                //               child: Center(
                //                 child: Text(
                //                   "Accept",
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 10,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // if (titlestatus == "1")
                //   Column(
                //     children: [
                //       SizedBox(
                //         height: height * 0.02,
                //       ),
                //       SizedBox(
                //         width: width * 0.55,
                //         height: 30,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Flexible(
                //               flex: 1,
                //               child: InkWell(
                //                 onTap: () {
                //                   _declineDialog(
                //                     context,
                //                   ).then(
                //                     (val) {
                //                       if (val == true) {
                //                         declineInvestor(titlestatus, relId);
                //                       }
                //                     },
                //                   );
                //                 },
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       color: Colors.red,
                //                       border: Border.all(color: Colors.red),
                //                       borderRadius: BorderRadius.circular(5)),
                //                   child: Center(
                //                     child: Text(
                //                       "Decline",
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 10),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             SizedBox(width: 4),
                //             Flexible(
                //               flex: 1,
                //               child: InkWell(
                //                 onTap: () {
                //                   {
                //                     showIdeaSummaryGlobal = showIdeaSummary;
                //                     showIdeaUniquenessGlobal =
                //                         showIdeaUniqueness;
                //                     showIdeaCaseStudyGlobal = showIdeaCaseStudy;
                //                   }
                //                   showPrivacyDialog(
                //                     context,
                //                     "Idea Privacy",
                //                     "Idea Summary",
                //                     "Idea Uniqueness",
                //                     "Your Case Study",
                //                   ).then((val) {
                //                     if (val == true) {
                //                       addIdeaPrivacy(relId);
                //                     }
                //                   });
                //                 },
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       color: Colors.amber[700],
                //                       border:
                //                           Border.all(color: Colors.amber[700]),
                //                       borderRadius: BorderRadius.circular(5)),
                //                   child: Center(
                //                     child: Text(
                //                       "Show Idea",
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 10),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             SizedBox(width: 4),
                //             Flexible(
                //               flex: 1,
                //               child: InkWell(
                //                 onTap: noIdeaSelected
                //                     ? () {
                //                         WebResponseExtractor.showToast(
                //                             "Atleast one Idea Privacy is required");
                //                       }
                //                     : () {
                //                         {
                //                           showMediaPicturesGlobal =
                //                               showMediaPictures;
                //                           showMediaVideosGlobal =
                //                               showMediaVideos;
                //                           showMediaDocsGlobal = showMediaDocs;
                //                         }
                //                         showPrivacyDialog(
                //                           context,
                //                           "Media Privacy",
                //                           "Pictures",
                //                           "Videos",
                //                           "Documents",
                //                         ).then((val) {
                //                           if (val == true) {
                //                             addMediaPrivacy(
                //                               relId,
                //                             );
                //                           }
                //                         });
                //                       },
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       color: noIdeaSelected
                //                           ? Colors.grey
                //                           : Colors.amber[700],
                //                       border: Border.all(
                //                           color: noIdeaSelected
                //                               ? Colors.grey
                //                               : Colors.amber[700]),
                //                       borderRadius: BorderRadius.circular(5)),
                //                   child: Center(
                //                     child: Text(
                //                       "Show Media",
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 10),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       SizedBox(
                //         height: height * 0.01,
                //       ),
                //     ],
                //   ),
                // if (titlestatus == "2")
                //   Column(
                //     children: [
                //       SizedBox(
                //         height: height * 0.02,
                //       ),
                //       Container(
                //         width: width * 0.55,
                //         child: Text(
                //           remarks,
                //           textAlign: TextAlign.center,
                //         ),
                //       ),
                //       SizedBox(
                //         height: height * 0.01,
                //       ),
                //     ],
                //   ),
                // if (titlestatus == "3" && successStory == "")
                //   Column(
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               SizedBox(height: height * 0.01),
                //               InkWell(
                //                 onTap: () {
                //                   _declineDialog(
                //                     context,
                //                   ).then(
                //                     (val) {
                //                       if (val == true) {
                //                         declineInvestor(titlestatus, relId);
                //                       }
                //                     },
                //                   );
                //                 },
                //                 child: Container(
                //                   width: 80,
                //                   height: 25,
                //                   decoration: BoxDecoration(
                //                       color: Colors.red,
                //                       border: Border.all(color: Colors.red),
                //                       borderRadius: BorderRadius.circular(5)),
                //                   child: Center(
                //                     child: Text(
                //                       "Decline",
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 10),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //           SizedBox(
                //             width: width * 0.06,
                //           ),
                //           Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               SizedBox(height: height * 0.01),
                //               InkWell(
                //                 onTap: () {
                //                   _successStoryDialog(context).then(
                //                     (val) {
                //                       if (val == true) {
                //                         addSuccessStory(ideaId);
                //                       }
                //                     },
                //                   );
                //                 },
                //                 child: Container(
                //                   width: 120,
                //                   height: 25,
                //                   decoration: BoxDecoration(
                //                       color: Colors.green,
                //                       border: Border.all(color: Colors.green),
                //                       borderRadius: BorderRadius.circular(5)),
                //                   child: Center(
                //                     child: Text(
                //                       "Success Story",
                //                       textAlign: TextAlign.center,
                //                       style: TextStyle(
                //                         color: Colors.white,
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 10,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         height: height * 0.02,
                //       ),
                //       Container(
                //         width: width * 0.55,
                //         child: Text(
                //           "at $meetingDate $meetingTime",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         height: height * 0.01,
                //       ),
                //     ],
                //   ),
                // if (titlestatus == "3" && successStory != "")
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           SizedBox(height: height * 0.01),
                //           InkWell(
                //             onTap: () {
                //               _declineDialog(
                //                 context,
                //               ).then(
                //                 (val) {
                //                   if (val == true) {
                //                     declineInvestor(titlestatus, relId);
                //                   }
                //                 },
                //               );
                //             },
                //             child: Container(
                //               width: 80,
                //               height: 25,
                //               decoration: BoxDecoration(
                //                   color: Colors.red,
                //                   border: Border.all(color: Colors.red),
                //                   borderRadius: BorderRadius.circular(5)),
                //               child: Center(
                //                 child: Text(
                //                   "Decline",
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                       color: Colors.white,
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 10),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         width: width * 0.06,
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           SizedBox(height: height * 0.01),
                //           Container(
                //             width: 120,
                //             height: 25,
                //             child: Center(
                //               child: Text(
                //                 "at $meetingDate $meetingTime",
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(
                //                   color: Colors.black,
                //                   fontWeight: FontWeight.w600,
                //                   fontSize: 10,
                //                 ),
                //               ),
                //             ),
                //           ),
                //           ],
                //         ),
                //       ],
                //     ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Future<bool> showPrivacyDialog(
  //   BuildContext context,
  //   String title,
  //   String heading1,
  //   String heading2,
  //   String heading3,
  // ) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(
  //           title,
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         content: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return SizedBox(
  //               height: 150,
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(heading1),
  //                       SizedBox(width: 16),
  //                       Checkbox(
  //                         value: title == "Idea Privacy"
  //                             ? showIdeaSummaryGlobal
  //                             : showMediaPicturesGlobal,
  //                         onChanged: (val) {
  //                           if (title == "Idea Privacy") {
  //                             setState(() {
  //                               showIdeaSummaryGlobal = val;
  //                             });
  //                           } else
  //                             setState(() {
  //                               showMediaPicturesGlobal = val;
  //                             });
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(heading2),
  //                       SizedBox(width: 16),
  //                       Checkbox(
  //                         value: title == "Idea Privacy"
  //                             ? showIdeaUniquenessGlobal
  //                             : showMediaVideosGlobal,
  //                         onChanged: (val) {
  //                           if (title == "Idea Privacy") {
  //                             setState(() {
  //                               showIdeaUniquenessGlobal = val;
  //                             });
  //                           } else
  //                             setState(() {
  //                               showMediaVideosGlobal = val;
  //                             });
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(heading3),
  //                       SizedBox(width: 16),
  //                       Checkbox(
  //                         value: title == "Idea Privacy"
  //                             ? showIdeaCaseStudyGlobal
  //                             : showMediaDocsGlobal,
  //                         onChanged: (val) {
  //                           if (title == "Idea Privacy") {
  //                             setState(() {
  //                               showIdeaCaseStudyGlobal = val;
  //                             });
  //                           } else
  //                             setState(() {
  //                               showMediaDocsGlobal = val;
  //                             });
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //         backgroundColor: Colors.amber[100],
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(
  //               'CANCEL',
  //               style: TextStyle(color: Colors.black),
  //             ),
  //             onPressed: () {
  //               Navigator.pop(context, false);
  //             },
  //           ),
  //           TextButton(
  //             child: Text(
  //               'OK',
  //               style: TextStyle(color: Colors.black),
  //             ),
  //             onPressed: () {
  //               Navigator.pop(context, true);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<bool> _successStoryDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(
  //           "Success Story",
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         content: TextField(
  //           maxLines: 4,
  //           controller: storyController,
  //           autofocus: true,
  //           decoration: InputDecoration(
  //             hintText: "Write your Success Story",
  //             enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10),
  //               borderSide: BorderSide(
  //                 color: Colors.grey,
  //                 width: 1.5,
  //               ),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10),
  //               borderSide: BorderSide(
  //                 color: Colors.blue,
  //                 width: 1.5,
  //               ),
  //             ),
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('CANCEL'),
  //             onPressed: () {
  //               Navigator.pop(context, false);
  //             },
  //           ),
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.pop(context, true);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<bool> _declineDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(builder: (context, setState1) {
  //         return AlertDialog(
  //           // title: Text(
  //           //   title,
  //           //   style: TextStyle(color: Colors.black),
  //           // ),
  //           title: Row(
  //             children: [
  //               Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Radio(
  //                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                     activeColor: Colors.green,
  //                     value: "Y",
  //                     groupValue: bulbColor,
  //                     onChanged: (val) {
  //                       setState1(() {
  //                         bulbColor = val;
  //                       });
  //                     },
  //                   ),
  //                   Text(
  //                     isEnglish ? "Reshedule" : 'Reshedule',
  //                     style: TextStyle(
  //                       color: Colors.green,
  //                       fontSize: 14,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               SizedBox(width: 30),
  //               Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Radio(
  //                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                     activeColor: Colors.red,
  //                     value: "N",
  //                     groupValue: bulbColor,
  //                     onChanged: (val) {
  //                       setState1(() {
  //                         bulbColor = val;
  //                       });
  //                     },
  //                   ),
  //                   Text(
  //                     isEnglish ? "Decline" : 'Decline',
  //                     style: TextStyle(
  //                       color: Colors.red,
  //                       fontSize: 14,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ],
  //           ),
  //           content: StatefulBuilder(builder: (context, setState2) {
  //             return bulbColor == "Y" ? dateTimeUi() : remarksUI();
  //           }),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text('CANCEL'),
  //               onPressed: () {
  //                 Navigator.pop(context, false);
  //               },
  //             ),
  //             TextButton(
  //               child: Text('OK'),
  //               onPressed: () {
  //                 Navigator.pop(context, true);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }

  // Widget dateTimeUi() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       TextFormField(
  //         readOnly: true,
  //         controller: dateController,
  //         onTap: _presentDatePicker,
  //         decoration: InputDecoration(
  //           hintText: "Choose Date",
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(
  //               color: Colors.grey,
  //               width: 1.5,
  //             ),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(
  //               color: Colors.blue,
  //               width: 1.5,
  //             ),
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 10),
  //       TextFormField(
  //         readOnly: true,
  //         controller: timeController,
  //         onTap: _presentTimePicker,
  //         decoration: InputDecoration(
  //           hintText: "Choose Time",
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(
  //               color: Colors.grey,
  //               width: 1.5,
  //             ),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(10),
  //             borderSide: BorderSide(
  //               color: Colors.blue,
  //               width: 1.5,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget remarksUI() {
  //   return TextField(
  //     maxLines: 4,
  //     controller: remarksController,
  //     decoration: InputDecoration(
  //       hintText: "Write the message for the investor",
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10),
  //         borderSide: BorderSide(
  //           color: Colors.grey,
  //           width: 1.5,
  //         ),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(10),
  //         borderSide: BorderSide(
  //           color: Colors.blue,
  //           width: 1.5,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _presentDatePicker() {
  //   showDatePicker(
  //     context: context,
  //     initialDate: now,
  //     firstDate: now,
  //     lastDate: DateTime(now.year + 10, now.month, now.day),
  //   ).then((pickedDate) {
  //     if (pickedDate == null) {
  //       return;
  //     } else {
  //       dateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
  //       setState(() {
  //         // dob = DateFormat('yyyy-MM-dd').format(pickedDate);
  //         dob = dateController.text;
  //       });
  //     }
  //     print(dob);
  //   });
  // }

  // void _presentTimePicker() {
  //   showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((pickedTime) {
  //     if (pickedTime == null) {
  //       return;
  //     } else
  //       timeController.text = DateFormat.jm().format(DateFormat("hh:mm")
  //           .parse("${pickedTime.hour}:${pickedTime.minute}"));
  //     setState(() {
  //       time = timeController.text;
  //     });
  //     print(time);
  //   });
  // }
  void addMemberIns(String ids, String first_name, String last_name) async {
    Map mapData = {"group_fire_base_id": widget.group_id, "user_id": ids};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.ADD_MEMBER_GROUP),
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
          dataObject: "RETURN_MESSAGE");
      if (data["code"] == 1) {
        await getFireIds(ids, true);
        print(data["data"]);
        WebResponseExtractor.showToast(data["data"].toString());
        fetchCommitteeMemberData('');

        // DocumentReference documentReference1;
        // //  documentReference1 = FirebaseFirestore
        // //   .instance
        // //   .collection(
        // //       'messages/${widget.userFirebaseIdList[i]}/${widget.data['receiverId']}')
        // //   .doc();
        // String formattedDate;
        // // print("YYHSHOMEY" + widget.userFirebaseIdList.toString());
        // setState(() {
        //   DateTime now = DateTime.now();
        //   formattedDate = now.millisecondsSinceEpoch.toString();
        // });
        DocumentReference documentReference1;
        String formattedDate;

        setState(() {
          countMessage = countMessage + 1;
          DateTime nows = DateTime.now();

          formattedDate = nows.millisecondsSinceEpoch.toString();
        });
        // for (int i = 0; i < widget.userFirebaseIdList.length; i++) {
        //   // documentReference1 =
        //   //     FirebaseFirestore
        //   //         .instance
        //   //         .collection(
        //   //             'user/${widget.userFirebaseIdList[i]}/recentMessage')
        //   //         .doc(widget.data[
        //   //             'receiverId']);
        //   // documentReference1.set({
        //   //   "documentId":
        //   //       documentReference1.id,
        //   //   'Name': widget.data['name'],
        //   //   'ProfileImage': widget.data[
        //   //       'userProfileImage'],
        //   //   'Id': widget
        //   //       .data['receiverId'],
        //   //   'SenderName': name,
        //   //   'SenderProfileImage':
        //   //       profileImageMain,
        //   //   'SenderId': userFirebaseId,
        //   //   'Message': sendMsg.text,
        //   //   'url': "",
        //   //   'timestamp': formattedDate,
        //   //   'DateAndTime':
        //   //       DateTime.now()
        //   //           .toString(),
        //   //   'messageType': 'text',
        //   //   'totalMessage':
        //   //       userFirebaseIdList[i] !=
        //   //               userFirebaseId
        //   //           ? '$countMessage'
        //   //           : "",
        //   //   'seenMessage': '',
        //   //   "group_id":
        //   //       widget.data['idea_id'],
        //   //   'messageTo': "group",
        //   //   'forwardMessage': "no",
        //   //   "adminId":
        //   //       widget.data["adminId"]
        //   // });

        //   documentReference1 = FirebaseFirestore.instance
        //       .collection(
        //           'messages/${widget.userFirebaseIdList[i]}/${widget.data['receiverId']}')
        //       .doc();
        //   documentReference1.set({
        //     "documentId": documentReference1.id,
        //     'Name': widget.data['name'],
        //     'ProfileImage': widget.data['userProfileImage'],
        //     'Id': widget.data['receiverId'],
        //     'SenderName': name,
        //     'SenderProfileImage': profileImageMain,
        //     'SenderId': userFirebaseId,
        //     'Message': first_name + " " + last_name + " is removed",
        //     'url': "",
        //     'timestamp': formattedDate,
        //     'DateAndTime': DateTime.now().toString(),
        //     'messageType': 'text',
        //     'totalMessage': widget.userFirebaseIdList[i] != userFirebaseId
        //         ? '$countMessage'
        //         : "",
        //     'seenMessage': '',
        //     "group_id": widget.data['idea_id'],
        //     'messageTo': "group",
        //     'forwardMessage': "no",
        //     "removedMemberId": "",
        //     "adminId": widget.data["adminId"]
        //   });
        //   /*FirebaseFirestore.instance
        //                                             .collection("message")
        //                                             .doc('${userFirebaseIdList[i]}')
        //                                             .collection(widget.data['receiverId'])
        //                                             .add({
        //                                           'Name': widget.data['name'],
        //                                           'ProfileImage': widget.data['userProfileImage'],
        //                                           'Id': widget.data['receiverId'],
        //                                           'SenderName': name,
        //                                           'SenderProfileImage': profileImageMain,
        //                                           'SenderId': userFirebaseId,
        //                                           'Message': sendMsg.text,
        //                                           'url': "",
        //                                           'time': formattedDate,
        //                                           'messageType': 'text',
        //                                           'totalMessage': '$i',
        //                                           'seenMessage': '',
        //                                           "group_id":widget.data['id'],
        //                                           'messageTo':"group"
        //                                         });*/

        // }
        //   for (int i = 0; i < widget.userFirebaseIdList.length; i++) {
        //   DocumentReference documentReferences = FirebaseFirestore.instance
        //       .collection(
        //           'messages/${widget.userFirebaseIdList[i]}/${widget.data['receiverId']}')
        //       .doc();
        //   documentReferences.set({
        //     'documentId': documentReferences.id,
        //     'Name': widget.data['name'],
        //     'ProfileImage': widget.data['userProfileImage'],
        //     'Id': widget.data['receiverId'],
        //     'SenderName': name,
        //     'SenderProfileImage': profileImageMain,
        //     'SenderId': userFirebaseId,
        //     'Message': "ADDED",
        //     'url': "",
        //     'timestamp': formattedDate,
        //     'DateAndTime': DateTime.now().toString(),
        //     'messageType': "text",
        //     'fileName': "",
        //     'totalMessage':
        //         widget.userFirebaseIdList[i] != userFirebaseId ? '$countMessage' : "",
        //     'seenMessage': '',
        //     "group_id": widget.data['idea_id'],
        //     'messageTo': "group",
        //     'forwardMessage': "no",
        //     "removedMemberId": "",
        //     "adminId": widget.data["adminId"]
        //   });
        //   // imageId.add(documentReferences.id.toString());
        // }
        for (int i = 0; i < widget.userFirebaseIdList.length; i++) {
          documentReference1 = FirebaseFirestore.instance
              .collection('user/${widget.userFirebaseIdList[i]}/recentMessage')
              .doc(widget.data['receiverId']);
          documentReference1.set({
            "documentId": documentReference1.id,
            'Name': widget.data['name'],
            'ProfileImage': widget.data['userProfileImage'],
            'Id': widget.data['receiverId'],
            'SenderName': name,
            'SenderProfileImage': profileImageMain,
            'SenderId': userFirebaseId,
            'Message':
                first_name + " " + last_name + " is " "ADDED" + " by " + name,
            'url': "",
            'timestamp': formattedDate,
            'DateAndTime': DateTime.now().toString(),
            'messageType': 'text',
            'totalMessage': widget.userFirebaseIdList[i] != userFirebaseId
                ? '$countMessage'
                : "",
            'seenMessage': '',
            "group_id": widget.data['idea_id'],
            'messageTo': "group",
            'forwardMessage': "no",
            "adminId": widget.data["adminId"]
          });
          documentReference1 = FirebaseFirestore.instance
              .collection(
                  'messages/${widget.userFirebaseIdList[i]}/${widget.data['receiverId']}')
              .doc();
          documentReference1.set({
            "documentId": documentReference1.id,
            'Name': widget.data['name'],
            'ProfileImage': widget.data['userProfileImage'],
            'Id': widget.data['receiverId'],
            'SenderName': name,
            'SenderProfileImage': profileImageMain,
            'SenderId': userFirebaseId,
            'Message':
                first_name + " " + last_name + " is " "ADDED" + " by " + name,
            'url': "",
            'timestamp': formattedDate,
            'DateAndTime': DateTime.now().toString(),
            'messageType': 'text',
            'totalMessage': widget.userFirebaseIdList[i] != userFirebaseId
                ? '$countMessage'
                : "",
            'seenMessage': '',
            "group_id": widget.data['idea_id'],
            'messageTo': "group",
            'forwardMessage': "no",
            "removedMemberId": "",
            "adminId": widget.data["adminId"]
          });
          /*FirebaseFirestore.instance
                                                  .collection("message")
                                                  .doc('${userFirebaseIdList[i]}')
                                                  .collection(widget.data['receiverId'])
                                                  .add({
                                                'Name': widget.data['name'],
                                                'ProfileImage': widget.data['userProfileImage'],
                                                'Id': widget.data['receiverId'],
                                                'SenderName': name,
                                                'SenderProfileImage': profileImageMain,
                                                'SenderId': userFirebaseId,
                                                'Message': sendMsg.text,
                                                'url': "",
                                                'time': formattedDate,
                                                'messageType': 'text',
                                                'totalMessage': '$i',
                                                'seenMessage': '',
                                                "group_id":widget.data['id'],
                                                'messageTo':"group"
                                              });*/

        }
        // getInvestorsFromWeb(data["data"]);
      }
    }
  }

  void deleteMemberIns(String ids) async {
    Map mapData = {"group_fire_base_id": widget.group_id, "user_id": ids};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.DELETE_MEMBER_GROUP),
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
          dataObject: "RETURN_MESSAGE");
      if (data["code"] == 1) {
        print(data["data"]);
        WebResponseExtractor.showToast(data["data"].toString());
        // print(getProfileData(ids));
        // print("hgas");
        String reciever = await getProfileData(ids);
        print(reciever);
        DocumentReference documentReference1;
        documentReference1 = FirebaseFirestore.instance
            .collection('user/$reciever/recentMessage')
            .doc(widget.group_id);
        documentReference1.delete();
        getFireIds(ids, false);
        fetchCommitteeMemberData('');
        // getInvestorsFromWeb(data["data"]);
      }
    }
  }

  fetchCommitteeMemberData(String committeeId) async {
    try {
      investordata.clear();
      Map data = {"group_fire_base_id": widget.group_id};
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
          // userTokenIdList.clear();
          List<String> userids = [];
          // if (ischeck == false) widget.userFirebaseIdList.clear();
          var jsonData = data["data"];
          userids = jsonData["user_ids"] != null
              ? jsonData["user_ids"].toString().split(",")
              : [];
          print(userids.toString());
          for (int i = 0; i < userids.length; i++) {
            print(i);
            // if (ischeck == false) getFireIds(userids[i]);
            getProfileData(userids[i]);
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

  Future<void> getFireIds(String ids, bool istrue) async {
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
        if (jsonData["firebase_user_id"] != null &&
            jsonData["firebase_user_id"] != "")
          istrue == true
              ? widget.userFirebaseIdList.add(jsonData["firebase_user_id"])
              : widget.userFirebaseIdList.remove(jsonData["firebase_user_id"]);
        // userFirebaseIdList.add("LUurrED6JuNybCH5E8b6sdsdyHD3");
        // print(userFirebaseIdList.toString());
      }
    }
  }

  Future<String> getProfileData(String userid) async {
    Map mapData = {"user_id": userid};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.VIEW_PROFILE),
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
        Map data =
            WebResponseExtractor.filterWebData(response, dataObject: "DETAILS");
        Map data1 = WebResponseExtractor.filterWebData(response,
            dataObject: "USER_DATA");

        var userData = data1["data"];
        var userData1 = data["data"];

        // countryID = userData["country"];
        //countryName = userData["country_name"];
        // print(countryID);
        // countryDropDown =
        //     countriesList.firstWhere((element) => element.ID == countryID);
        // countryName = countryDropDown.NAME;

        // await getState();

        // stateID = userData["state"];
        // //stateName = userData["state_name"];
        // print(stateID);
        // stateDropDown =
        //     stateList.firstWhere((element) => element.ID == stateID);
        // stateName = stateDropDown.NAME;

        // await getCity();

        // cityID = userData["city"];
        // //cityName = userData["city_name"];
        // print(cityID);
        // cityDropDown = cityList.firstWhere((element) => element.ID == cityID);
        // cityName = cityDropDown.NAME;

        setState(() {
          investordata.add(InvestorData(
              profile_image: userData1["profile_image"] != null
                  ? userData1["profile_image"]
                  : "",
              first_name:
                  userData["first_name"] != null ? userData["first_name"] : "",
              last_name:
                  userData["last_name"] != null ? userData["last_name"] : "",
              email: userData["email"] != null ? userData["email"] : "",
              firebase_user_id: userData['firebase_user_id'] != null
                  ? userData["firebase_user_id"]
                  : "",
              ins_user_id: userData["id"],
              phoneNumber: userData["mobile"] != null ? userData["mobile"] : '',
              role: userData["role_id"]));
          // image =
          // profileImageMain = userData["profile_image"] != null
          //     ? userData["profile_image"]
          //     : "";
          // location = "${userData["city_name"]}, ${userData["state_name"]}";
          // dob = userData["dob"];
          // gender = userData["gender"] != null ? userData["gender"] : "";
          // bulbColor = gender;

          // _selectedDate = (DateTime.parse(userData["dob"]));

          // pincodeController.text = userData["pincode"];

          // occupation = userData["what_do_you_do"] != null
          //     ? userData["what_do_you_do"]
          //     : "";

          // if (occupation == "Job") {
          //   screenNo = 1;
          //   jobRadio = 'Job';
          //   employmentTypeID = userData["mst_employement_type_id"];
          //   employmentTypeDropDown = employmentTypeList
          //       .firstWhere((element) => element.ID == employmentTypeID);
          //   employment = employmentTypeDropDown.NAME;
          //   createUserController1.text = userData["job_title"];
          // }

          // if (occupation == "Student") {
          //   screenNo = 2;
          //   tradeRadio = 'Student';
          //   tradeTypeID = userData["mst_trade_id"];
          //   tradeDropDown =
          //       tradeList.firstWhere((element) => element.ID == tradeTypeID);
          //   trade = tradeDropDown.NAME;
          //   createUserController2.text = userData["university_or_school_name"];
          // }

          // if (occupation == "Self Employed") {
          //   screenNo = 3;
          //   natureRadio = 'Self Employed';
          //   nOfWorkID = userData["mst_nature_of_work_id"];
          //   natureOfWork = natureOfWorkList
          //       .firstWhere((element) => element.ID == nOfWorkID);
          //   nOfWork = natureOfWork.NAME;
          //   createUserController3.text = userData["work_title"];
          // }

          // if (occupation == "Business") {
          //   screenNo = 4;
          //   businessRadio = 'Business';
          //   businessTypeID = userData["mst_occupation_business_id"];
          //   businessDropDown = businessList
          //       .firstWhere((element) => element.ID == businessTypeID);
          //   business1 = businessDropDown.NAME;
          // }
        });
        return userData["firebase_user_id"];
      }
    }
  }

  void getInvestors() async {
    Map mapData = {"group_fire_base_id": widget.group_id};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_CHAT_GROUP),
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
          dataObject: "GROUP_DETAILS");
      if (data["code"] == 1) {
        print(data["data"]);
        getInvestorsFromWeb(data["data"]);
      }
    }
  }

  Future<void> getSuggestions(String text) async {
    // suggestionsList.clear();
    // if (dataLoadedFirstTime == true) {
    //   LoadingIndicator.loadingIndicator(context);
    // }
    Map mapData = {
      "query_search": text,
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.EMAIL_SEARCH_USER),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    // if (dataLoadedFirstTime == true) Navigator.of(context).pop();
    if (response.statusCode == 200) {
      Map data =
          WebResponseExtractor.filterWebData(response, dataObject: "USER_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        setState(() {
          search_id.first_name = data["data"]["first_name"] != null
              ? data["data"]["first_name"]
              : "";
          search_id.last_name = data["data"]["last_name"] != null
              ? data["data"]["last_name"]
              : "";
          search_id.email =
              data["data"]["email"] != null ? data["data"]["email"] : "";
          search_id.ins_user_id =
              data["data"]["id"] != null ? data["data"]["id"] : "";
          search_id.profile_image = (data["data"]["profile_image"] != null)
              ? data["data"]["profile_image"]
              : "";
          search_id.phoneNumber =
              data["data"]["mobile"] != null ? data["data"]["mobile"] : "";
          search_id.role =
              data["data"]["role_id"] != null ? data["data"]["role_id"] : "";
        });
        String roleDes;
        if (search_id.role == "1") {
          roleDes = "Business Idea Person";
        } else if (search_id.role == "2") {
          roleDes = "Investor";
        } else if (search_id.role == "3") {
          roleDes = "Product Provider";
        } else {
          roleDes = "Service Provider";
        }

        return showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * 0.54,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            search_id.profile_image != ""
                                ? "http://164.52.192.76:8080/startit/${search_id.profile_image}"
                                : "https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png",
                          ),
                          backgroundColor: Colors.transparent,
                          radius: MediaQuery.of(context).size.width * 0.22,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Text(
                        search_id.first_name + " " + search_id.last_name,
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        search_id.email,
                        textScaleFactor: 1,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        search_id.phoneNumber,
                        textScaleFactor: 1,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        roleDes,
                        textScaleFactor: 1,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextButton.icon(
                          onPressed: () {
                            addMemberIns(search_id.ins_user_id,
                                search_id.first_name, search_id.last_name);
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.person_add,
                            color: Colors.green,
                          ),
                          label: Text(
                            "Add",
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.green),
                          )),
                    ],
                  ),
                ),
              ),
            );
          },
        );
        // dataLoadedFirstTime = true;
      } else {
        WebResponseExtractor.showToast("$text does not exist.");
      }
    }
  }

  Future<Null> getSuggestedIdeasFromWeb(var jsonData) async {
    // search_id = null;
    // suggestedIdeaData.clear();

    // setState(() {});
    // backupSuggestedIdeaData = suggestedIdeaData;
  }

  Future<Null> getInvestorsFromWeb(var jsonData) async {
    investordata.clear();
    setState(() {
      for (Map investor in jsonData) {
        investordata.add(
          InvestorData(
            first_name:
                investor["first_name"] != null ? investor["first_name"] : "",
            last_name:
                investor["last_name"] != null ? investor["last_name"] : "",
            device_token: investor["device_token"] != null
                ? investor["device_token"]
                : "",
            email: investor["email"] != null ? investor["email"] : "",
            firebase_user_id: investor["firebase_user_id"] != null
                ? investor["firebase_user_id"]
                : "",
            ins_user_id:
                investor["ins_user_id"] != null ? investor["ins_user_id"] : "",
            profile_image: investor["profile_image"] != null
                ? investor["profile_image"]
                : "",
          ),
        );
      }
      investordata.sort((a, b) => a.first_name.compareTo(b.first_name));
    });
  }
}

class InvestorData {
  String ins_user_id;
  String first_name;
  String last_name;
  String email;
  String firebase_user_id;
  String device_token;
  String profile_image;
  String phoneNumber;
  String role;

  InvestorData(
      {this.ins_user_id,
      this.first_name,
      this.last_name,
      this.email,
      this.firebase_user_id,
      this.device_token,
      this.profile_image,
      this.phoneNumber,
      this.role});
}
