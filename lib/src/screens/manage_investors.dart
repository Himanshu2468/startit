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

class ManageInvestors extends StatefulWidget {
  @override
  _ManageInvestorsState createState() => _ManageInvestorsState();
}

class _ManageInvestorsState extends State<ManageInvestors> {
  bool first = true;
  bool second = false;
  bool three = false;

  ScrollController listController = ScrollController();

  TextEditingController remarksController = TextEditingController();
  TextEditingController storyController = TextEditingController();

  TextEditingController dateController = TextEditingController();
  String dob = "";

  static final now = DateTime.now();

  TextEditingController timeController = TextEditingController();
  String time = "";

  List<InvestorData> investordata = [];

  bool showIdeaSummaryGlobal = false;
  bool showIdeaUniquenessGlobal = false;
  bool showIdeaCaseStudyGlobal = false;
  bool showMediaPicturesGlobal = false;
  bool showMediaVideosGlobal = false;
  bool showMediaDocsGlobal = false;

  String bulbColor = "Y";

  @override
  void initState() {
    getInvestors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    String move = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      drawer: AppDrawer(move),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Manage Investors",
          textScaleFactor: 1,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
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
                SizedBox(height: height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height * 0.03,
                        width: width * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: first ? Colors.blue : Colors.transparent,
                              elevation: 0),
                          onPressed: () {
                            setState(() {
                              investordata
                                  .sort((a, b) => a.title.compareTo(b.title));
                              first = true;
                              second = false;
                              three = false;
                            });
                            listController.animateTo(0.0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceIn);
                          },
                          child: Text(
                            "NAME A-Z",
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 10,
                                color: first ? Colors.white : Colors.grey[600]),
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.03,
                        width: width * 0.22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color: Colors.blue,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  second ? Colors.blue : Colors.transparent,
                              elevation: 0),
                          onPressed: () {
                            listController.animateTo(0.0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceIn);
                            investordata.sort((a, b) =>
                                a.createdDate.compareTo(b.createdDate));
                            setState(() {
                              first = false;
                              second = true;
                              three = false;
                            });
                          },
                          child: Text(
                            "OLDEST",
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 10,
                                color:
                                    second ? Colors.white : Colors.grey[600]),
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.03,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // color: Colors.blue,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: three ? Colors.blue : Colors.transparent,
                              elevation: 0),
                          onPressed: () {
                            listController.animateTo(0.0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.bounceIn);
                            setState(() {
                              investordata.sort((a, b) =>
                                  b.createdDate.compareTo(a.createdDate));
                              first = false;
                              second = false;
                              three = true;
                            });
                          },
                          child: Text(
                            "NEWEST",
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 10,
                                color: three ? Colors.white : Colors.grey[600]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  height: height - AppBar().preferredSize.height,
                  child: ListView.builder(
                    controller: listController,
                    padding: EdgeInsets.all(8),
                    itemCount: investordata.length,
                    itemBuilder: (_, i) => InvestorItem(
                        investordata[i].title,
                        investordata[i].email,
                        investordata[i].titlestatus,
                        investordata[i].phone,
                        investordata[i].imageUrl,
                        investordata[i].createdDate,
                        investordata[i].createduser,
                        investordata[i].relId,
                        investordata[i].remarks,
                        investordata[i].ideaId,
                        investordata[i].meetingDate,
                        investordata[i].meetingTime,
                        investordata[i].successStory,
                        investordata[i].insUserId,
                        investordata[i].customIdeaSummary,
                        investordata[i].customIdeaUniqueness,
                        investordata[i].customIdeaCaseStudy,
                        investordata[i].customMediaPicture,
                        investordata[i].customMediaVideo,
                        investordata[i].customMediaDoc,
                        investordata[i].receiverFireId,
                        investordata[i].deviceToken,
                        investordata[i].isDecline,
                        height,
                        width),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget InvestorItem(
      String title,
      String email,
      String titlestatus,
      String phone,
      String imageUrl,
      String createdDate,
      String createduser,
      String relId,
      String remarks,
      String ideaId,
      String meetingDate,
      String meetingTime,
      String successStory,
      String insUserId,
      bool showIdeaSummary,
      bool showIdeaUniqueness,
      bool showIdeaCaseStudy,
      bool showMediaPictures,
      bool showMediaVideos,
      bool showMediaDocs,
      String receiverFirebaseId,
      String deviceToken,
      bool isDecline,
      double height,
      double width) {
    Color statusColor = Colors.red;
    String status = "";
    bool noIdeaSelected = false;

    if (titlestatus == "0") {
      status = "Pending";
      statusColor = Colors.orange;
    } else if (titlestatus == "1") {
      status = "Accepted";
      statusColor = Colors.green;
    } else if (titlestatus == "2") {
      status = "Declined";
      statusColor = Colors.red;
    } else if (titlestatus == "3") {
      status = "Meeting Scheduled";
      statusColor = Colors.green;
    } else if (titlestatus == "4") {
      status = "Left";
      statusColor = Colors.red;
    }

    if (showIdeaSummary == false &&
        showIdeaUniqueness == false &&
        showIdeaCaseStudy == false) {
      noIdeaSelected = true;
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
                "http://164.52.192.76:8080/startit/$imageUrl",
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
                              title,
                              textScaleFactor: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            createduser,
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              print(isDecline);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MIViewProfile(
                                    int.parse(insUserId),
                                    email,
                                    phone,
                                    createduser,
                                    ideaId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: width * 0.22,
                              height: height * 0.022,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green[300]),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                child: Text(
                                  "View Profile",
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.green[300],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // if (receiverFirebaseId != null &&
                          //     receiverFirebaseId != "")
                          if (receiverFirebaseId != null &&
                              receiverFirebaseId != "")
                            InkWell(
                              onTap: () {
                                var data = {
                                  "name": createduser,
                                  "id": receiverFirebaseId,
                                  "userProfileImage": imageUrl,
                                  "receiverId": receiverFirebaseId,
                                  "chat": "user",
                                  'deviceToken': deviceToken
                                };
                                print(data);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(data)),
                                );
                              },
                              child: Container(
                                width: width * 0.22,
                                height: height * 0.022,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(3)),
                                child: Center(
                                  child: Text(
                                    "Chat",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.015),
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
                //           textScaleFactor: 1,
                //           style: TextStyle(
                //             fontSize: 10,
                //             letterSpacing: 1.0,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         SizedBox(height: 5),
                //         Text(
                //           phone,
                //           textScaleFactor: 1,
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
                //             textScaleFactor: 1,
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
                //           textScaleFactor: 1,
                //           style: TextStyle(color: Colors.grey, fontSize: 10),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // SizedBox(height: height * 0.01),
                SizedBox(
                  width: width * 0.6,
                  child: Divider(
                    color: Colors.grey[300],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Created",
                    //       textScaleFactor: 1,
                    //       style: TextStyle(
                    //           fontSize: 10, fontWeight: FontWeight.bold),
                    //     ),
                    //     SizedBox(
                    //       height: 5,
                    //     ),
                    //     Container(
                    //       width: 80,
                    //       height: 25,
                    //       decoration: BoxDecoration(
                    //           color: Colors.blue[200],
                    //           border: Border.all(color: Colors.blue),
                    //           borderRadius: BorderRadius.circular(5)),
                    //       child: Center(
                    //         child: Text(
                    //           createdDate,
                    //           textScaleFactor: 1,
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //               fontSize: 10),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   width: width * 0.06,
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status",
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: width * 0.54,
                          height: 25,
                          decoration: BoxDecoration(
                              border: Border.all(color: statusColor),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              status,
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (titlestatus == "0")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          InkWell(
                            onTap: () {
                              _declineDialog(
                                context,
                              ).then(
                                (val) {
                                  if (val == true) {
                                    declineInvestor(titlestatus, relId);
                                  }
                                },
                              );
                            },
                            child: Container(
                              width: 80,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  "Decline",
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: width * 0.06,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          InkWell(
                            onTap: () {
                              acceptInvestor(1, relId);
                            },
                            child: Container(
                              width: 120,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  "Accept",
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (titlestatus == "4" || titlestatus == "2")
                  if (isDecline)
                    Column(
                      children: [
                        SizedBox(
                          height: height * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            reconnectInvestor(relId);
                          },
                          child: Container(
                            width: width * 0.54,
                            height: 25,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "Reconnect",
                                textScaleFactor: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                if (titlestatus == "1")
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SizedBox(
                        width: width * 0.55,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  _declineDialog(
                                    context,
                                  ).then(
                                    (val) {
                                      if (val == true) {
                                        declineInvestor(titlestatus, relId);
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      "Decline",
                                      textScaleFactor: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  {
                                    showIdeaSummaryGlobal = showIdeaSummary;
                                    showIdeaUniquenessGlobal =
                                        showIdeaUniqueness;
                                    showIdeaCaseStudyGlobal = showIdeaCaseStudy;
                                  }
                                  showPrivacyDialog(
                                    context,
                                    "Idea Privacy",
                                    "Idea Summary",
                                    "Idea Uniqueness",
                                    "Your Case Study",
                                  ).then((val) {
                                    if (val == true) {
                                      addIdeaPrivacy(relId);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green[300],
                                      border:
                                          Border.all(color: Colors.green[300]),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      "Show Idea",
                                      textScaleFactor: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: noIdeaSelected
                                    ? () {
                                        WebResponseExtractor.showToast(
                                            "Atleast one Idea Privacy is required");
                                      }
                                    : () {
                                        {
                                          showMediaPicturesGlobal =
                                              showMediaPictures;
                                          showMediaVideosGlobal =
                                              showMediaVideos;
                                          showMediaDocsGlobal = showMediaDocs;
                                        }
                                        showPrivacyDialog(
                                          context,
                                          "Media Privacy",
                                          "Pictures",
                                          "Videos",
                                          "Documents",
                                        ).then((val) {
                                          if (val == true) {
                                            addMediaPrivacy(
                                              relId,
                                            );
                                          }
                                        });
                                      },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: noIdeaSelected
                                          ? Colors.grey
                                          : Colors.green[300],
                                      border: Border.all(
                                          color: noIdeaSelected
                                              ? Colors.grey
                                              : Colors.green[300]),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      "Show Media",
                                      textScaleFactor: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                if (titlestatus == "2")
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        width: width * 0.55,
                        child: Text(
                          remarks,
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                if (titlestatus == "3" && successStory == "")
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.01),
                              InkWell(
                                onTap: () {
                                  _declineDialog(
                                    context,
                                  ).then(
                                    (val) {
                                      if (val == true) {
                                        declineInvestor(titlestatus, relId);
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  width: 80,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      "Decline",
                                      textScaleFactor: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: width * 0.06,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.01),
                              InkWell(
                                onTap: () {
                                  _successStoryDialog(context).then(
                                    (val) {
                                      if (val == true) {
                                        addSuccessStory(ideaId);
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  width: 120,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      "Success Story",
                                      textScaleFactor: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        width: width * 0.55,
                        child: Text(
                          "at $meetingDate $meetingTime",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                if (titlestatus == "3" && successStory != "")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          InkWell(
                            onTap: () {
                              _declineDialog(
                                context,
                              ).then(
                                (val) {
                                  if (val == true) {
                                    declineInvestor(titlestatus, relId);
                                  }
                                },
                              );
                            },
                            child: Container(
                              width: 80,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  "Decline",
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: width * 0.06,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          Container(
                            width: 120,
                            height: 25,
                            child: Center(
                              child: Text(
                                "at $meetingDate $meetingTime",
                                textScaleFactor: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showPrivacyDialog(
    BuildContext context,
    String title,
    String heading1,
    String heading2,
    String heading3,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            textScaleFactor: 1,
            style: TextStyle(color: Colors.black),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          heading1,
                          textScaleFactor: 1,
                        ),
                        SizedBox(width: 16),
                        Checkbox(
                          value: title == "Idea Privacy"
                              ? showIdeaSummaryGlobal
                              : showMediaPicturesGlobal,
                          onChanged: (val) {
                            if (title == "Idea Privacy") {
                              setState(() {
                                showIdeaSummaryGlobal = val;
                              });
                            } else
                              setState(() {
                                showMediaPicturesGlobal = val;
                              });
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          heading2,
                          textScaleFactor: 1,
                        ),
                        SizedBox(width: 16),
                        Checkbox(
                          value: title == "Idea Privacy"
                              ? showIdeaUniquenessGlobal
                              : showMediaVideosGlobal,
                          onChanged: (val) {
                            if (title == "Idea Privacy") {
                              setState(() {
                                showIdeaUniquenessGlobal = val;
                              });
                            } else
                              setState(() {
                                showMediaVideosGlobal = val;
                              });
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          heading3,
                          textScaleFactor: 1,
                        ),
                        SizedBox(width: 16),
                        Checkbox(
                          value: title == "Idea Privacy"
                              ? showIdeaCaseStudyGlobal
                              : showMediaDocsGlobal,
                          onChanged: (val) {
                            if (title == "Idea Privacy") {
                              setState(() {
                                showIdeaCaseStudyGlobal = val;
                              });
                            } else
                              setState(() {
                                showMediaDocsGlobal = val;
                              });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          backgroundColor: Colors.amber[100],
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                textScaleFactor: 1,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text(
                'OK',
                textScaleFactor: 1,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _successStoryDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Success Story",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            maxLines: 4,
            controller: storyController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Write your Success Story",
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
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                textScaleFactor: 1,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text(
                'OK',
                textScaleFactor: 1,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _declineDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState1) {
          return AlertDialog(
            // title: Text(
            //   title,
            //   style: TextStyle(color: Colors.black),
            // ),
            title: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: Colors.green,
                      value: "Y",
                      groupValue: bulbColor,
                      onChanged: (val) {
                        setState1(() {
                          bulbColor = val;
                        });
                      },
                    ),
                    Text(
                      isEnglish ? "Reschedule" : 'Reschedule',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                SizedBox(width: 30),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: Colors.red,
                      value: "N",
                      groupValue: bulbColor,
                      onChanged: (val) {
                        setState1(() {
                          bulbColor = val;
                        });
                      },
                    ),
                    Text(
                      isEnglish ? "Decline" : 'Decline',
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ],
            ),
            content: StatefulBuilder(builder: (context, setState2) {
              return bulbColor == "Y" ? dateTimeUi() : remarksUI();
            }),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'CANCEL',
                  textScaleFactor: 1,
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: Text(
                  'OK',
                  textScaleFactor: 1,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
      },
    );
  }

  Widget dateTimeUi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          readOnly: true,
          controller: dateController,
          onTap: _presentDatePicker,
          decoration: InputDecoration(
            hintText: "Choose Date",
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
        SizedBox(height: 10),
        TextFormField(
          readOnly: true,
          controller: timeController,
          onTap: _presentTimePicker,
          decoration: InputDecoration(
            hintText: "Choose Time",
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
    );
  }

  Widget remarksUI() {
    return TextField(
      maxLines: 4,
      controller: remarksController,
      decoration: InputDecoration(
        hintText: "Write the message for the investor",
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
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 10, now.month, now.day),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        dateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
        setState(() {
          // dob = DateFormat('yyyy-MM-dd').format(pickedDate);
          dob = dateController.text;
        });
      }
      print(dob);
    });
  }

  void _presentTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      } else
        timeController.text = DateFormat.jm().format(DateFormat("hh:mm")
            .parse("${pickedTime.hour}:${pickedTime.minute}"));
      setState(() {
        time = timeController.text;
      });
      print(time);
    });
  }

  void getInvestors() async {
    Map mapData = {"bip_id": bipId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.MANAGE_INVESTORS),
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
          dataObject: "MANAGE_INSVESTOR");
      if (data["code"] == 1) {
        print(data["data"]);
        getInvestorsFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getInvestorsFromWeb(var jsonData) async {
    investordata.clear();
    setState(() {
      for (Map investor in jsonData) {
        investordata.add(
          InvestorData(
              title:
                  investor["idea_title"] != null ? investor["idea_title"] : "",
              isDecline: userIdMain.toString() == investor["decline_by"]
                  ? true
                  : false,
              email: investor["email"] != null ? investor["email"] : "",
              titlestatus: investor["status"] != null ? investor["status"] : "",
              phone: investor["mobile"] != null ? investor["mobile"] : "",
              imageUrl: investor["profile_image"] != null
                  ? investor["profile_image"]
                  : "",
              createdDate: investor["createdAt"] != null
                  ? DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(investor["createdAt"]))
                  : "",
              createduser: "${investor["first_name"]} ${investor["last_name"]}",
              relId: investor["rel_id"] != null ? investor["rel_id"] : "",
              remarks: investor["remarks"] != null ? investor["remarks"] : "",
              ideaId: investor["id"] != null ? investor["id"] : "",
              meetingDate: investor["schedulemeetingDate"] != null
                  ? DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(investor["schedulemeetingDate"]))
                  : "",
              meetingTime: investor["schedulemeetingTime"] != null
                  ? investor["schedulemeetingTime"]
                  : "",
              successStory: investor["success_story"] != null
                  ? investor["success_story"]
                  : "",
              insUserId: investor["ins_user_id"],
              customIdeaSummary:
                  reverseCheck(investor["idea_summary_ins_can_read"]),
              customIdeaUniqueness:
                  reverseCheck(investor["idea_uniqueness_ins_can_read"]),
              customIdeaCaseStudy:
                  reverseCheck(investor["idea_case_study_ins_can_read"]),
              customMediaPicture:
                  reverseCheck(investor["picture_path_ins_can_see"]),
              customMediaVideo:
                  reverseCheck(investor["video_path_ins_can_see"]),
              customMediaDoc: reverseCheck(investor["doc_path_ins_can_see"]),
              receiverFireId: investor["firebase_user_id"],
              deviceToken: investor["device_token"] != null
                  ? investor["device_token"]
                  : ""),
        );
      }
      investordata.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  void acceptInvestor(int status, String relId) async {
    Map mapData = {
      "bip_id": bipId,
      "ins_intrest_idea_status": status,
      "rel_id": int.parse(relId)
    };

    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.ACCEPT_REQUEST),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;

      if (jsonData["RETURN_CODE"] == 1) {
        print(jsonData);
        setState(() {});
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
    getInvestors();
  }

  void reconnectInvestor(String relId) async {
    Map mapData = {"user_id": userIdMain, "rel_ins_id_no": int.parse(relId)};

    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.RECONNECT_USER),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;

      if (jsonData["RETURN_CODE"] == 1) {
        print(jsonData);
        setState(() {});
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        getInvestors();
      }
    }
  }

  void declineInvestor(String titlestatus, String relId) async {
    Map mapData = {
      "user_id": userIdMain,
      "ins_intrest_idea_status": int.parse(titlestatus),
      "rel_id": int.parse(relId),
      "idea_remarks": remarksController.text,
      "type": bulbColor,
      "schedulemeetingDate": dob,
      "schedulemeetingTime": time,
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.DECLINE_REQUEST),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;

      if (jsonData["RETURN_CODE"] == 1) {
        print(jsonData);
        setState(() {});
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
    getInvestors();
  }

  String check(bool c) {
    if (c == true) {
      return "Y";
    } else {
      return "N";
    }
  }

  bool reverseCheck(String s) {
    if (s == "Y") {
      return true;
    } else
      return false;
  }

  void addIdeaPrivacy(String relId) async {
    Map mapData = {
      "user_id": userIdMain,
      "rel_id": int.parse(relId),
      "idea_uniqueness_ins_can_read": check(showIdeaUniquenessGlobal),
      "idea_summary_ins_can_read": check(showIdeaSummaryGlobal),
      "idea_case_study_ins_can_read": check(showIdeaCaseStudyGlobal),
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.ADD_CUSTOM_IDEA_PRIVACY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      if (jsonData["RETURN_CODE"] == 1) {
        print(jsonData);
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
    if (showIdeaSummaryGlobal == false &&
        showIdeaUniquenessGlobal == false &&
        showIdeaCaseStudyGlobal == false) {
      showMediaPicturesGlobal = false;
      showMediaVideosGlobal = false;
      showMediaDocsGlobal = false;
      addMediaPrivacy(
        relId,
      );
    }

    getInvestors();
  }

  void addMediaPrivacy(String relId) async {
    Map mapData = {
      "user_id": userIdMain,
      "rel_id": int.parse(relId),
      "picture_path_ins_can_see": check(showMediaPicturesGlobal),
      "video_path_ins_can_see": check(showMediaVideosGlobal),
      "doc_path_ins_can_see": check(showMediaDocsGlobal),
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.ADD_CUSTOM_MEDIA_PRIVACY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;

      if (jsonData["RETURN_CODE"] == 1) {
        print(jsonData);

        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
    getInvestors();
  }

  void addSuccessStory(ideaId) async {
    Map mapData = {
      "user_id": userIdMain,
      "idea_id": int.parse(ideaId),
      "success_story": storyController.text,
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.ADD_SUCCESS_STORY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;

      if (jsonData["RETURN_CODE"] == 1) {
        print(jsonData);

        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
    getInvestors();
  }
}

class InvestorData {
  String title;
  String email;
  String titlestatus;
  String phone;
  String imageUrl;
  String createdDate;
  String createduser;
  String relId;
  String remarks;
  String ideaId;
  String meetingTime;
  String meetingDate;
  String successStory;
  String insUserId;
  bool customIdeaSummary;
  bool customIdeaUniqueness;
  bool customIdeaCaseStudy;
  bool customMediaPicture;
  bool customMediaVideo;
  bool customMediaDoc;
  String receiverFireId;
  String deviceToken;
  bool isDecline;

  InvestorData(
      {this.title,
      this.email,
      this.titlestatus,
      this.phone,
      this.imageUrl,
      this.createdDate,
      this.createduser,
      this.relId,
      this.remarks,
      this.ideaId,
      this.meetingDate,
      this.meetingTime,
      this.successStory,
      this.insUserId,
      this.customIdeaSummary,
      this.customIdeaUniqueness,
      this.customIdeaCaseStudy,
      this.customMediaPicture,
      this.customMediaVideo,
      this.customMediaDoc,
      this.receiverFireId,
      this.deviceToken,
      this.isDecline});
}
