import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'idea_title.dart';
import 'chats.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';

import 'package:intl/intl.dart';

class ManageIdeaPerson extends StatefulWidget {
  @override
  _ManageIdeaPersonState createState() => _ManageIdeaPersonState();
}

class _ManageIdeaPersonState extends State<ManageIdeaPerson> {
  bool first = true;
  bool second = false;
  bool three = false;

  ScrollController listController = ScrollController();

  List<InvestorData> investordata = [];

  TextEditingController dateController = TextEditingController();
  String dob = "";

  static final now = DateTime.now();

  TextEditingController timeController = TextEditingController();
  String time = "";

  @override
  void initState() {
    getIdeaPersons();
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
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Manage Idea Person",
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
                            primary: second ? Colors.blue : Colors.transparent,
                            elevation: 0),
                        onPressed: () {
                          listController.animateTo(0.0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.bounceIn);
                          investordata.sort(
                              (a, b) => a.createdDate.compareTo(b.createdDate));
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
                              color: second ? Colors.white : Colors.grey[600]),
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
                height: height - AppBar().preferredSize.height - height * 0.16,
                child: RefreshIndicator(
                  onRefresh: getIdeaPersons,
                  child: ListView.builder(
                    controller: listController,
                    padding: EdgeInsets.all(10),
                    itemCount: investordata.length,
                    itemBuilder: (_, i) => InvestorItem(
                      context,
                      investordata[i].title,
                      investordata[i].email,
                      investordata[i].titlestatus,
                      investordata[i].phone,
                      investordata[i].imageUrl,
                      investordata[i].createdDate,
                      investordata[i].createduser,
                      investordata[i].ideaId,
                      investordata[i].bipUserId,
                      investordata[i].remarks,
                      investordata[i].meetingDate,
                      investordata[i].meetingTime,
                      investordata[i].isReschedule,
                      height,
                      width,
                      investordata[i].receiverFireId,
                      investordata[i].deviceToken,
                      investordata[i].relid,
                      investordata[i].isDecline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget InvestorItem(
      BuildContext ctx,
      String title,
      String email,
      String titlestatus,
      String phone,
      String imageUrl,
      String createdDate,
      String createduser,
      int ideaId,
      String bipUserId,
      String remarks,
      String meetingDate,
      String meetingTime,
      String isReschedule,
      double height,
      double width,
      String receiverFirebaseId,
      String deviceToken,
      String relId,
      bool isDecline) {
    Color statusColor = Colors.red;
    String status = "";

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

    return Card(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.018, vertical: height * 0.015),
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
                            width: width * 0.32,
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
                              Navigator.of(ctx).push(MaterialPageRoute(
                                  builder: (ctx) => IdeaTitle(ideaId)));
                              print("Tap");
                              print(receiverFirebaseId);
                              print(titlestatus);
                            },
                            child: Container(
                              width: width * 0.22,
                              height: height * 0.022,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green[300]),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                child: Text(
                                  "View Idea",
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
                          // if ()
                          if ((receiverFirebaseId != null &&
                                  receiverFirebaseId != "") &&
                              (titlestatus == '1' || titlestatus == '3'))
                            InkWell(
                              onTap: () {
                                print(deviceToken);
                                var data = {
                                  "name": createduser,
                                  "id": receiverFirebaseId,
                                  "userProfileImage": imageUrl,
                                  "receiverId": receiverFirebaseId,
                                  "chat": "user",
                                  'deviceToken':
                                      deviceToken != null ? deviceToken : ""
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
                  Column(
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      InkWell(
                        onTap: () {
                          leaveMeeting(ideaId);
                        },
                        child: Container(
                          width: width * 0.55,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              "Leave",
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
                      SizedBox(
                        height: height * 0.01,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          InkWell(
                            onTap: () {
                              leaveMeeting(ideaId);
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
                                  "Leave",
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
                              _displayMeetingDialog(context).then((value) {
                                if (value == true) {
                                  createMeeting(ideaId, bipUserId);
                                }
                              });
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
                                  "Schedule Meeting",
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
                if (titlestatus == "2" && isReschedule == "Y")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          InkWell(
                            onTap: () {
                              _displayMeetingDialog(context).then((value) {
                                if (value == true) {
                                  createMeeting(ideaId, bipUserId);
                                }
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 25,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  "Reschedule Meeting",
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8),
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
                        children: [
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            width: 120,
                            height: 25,
                            child: Center(
                              child: Text(
                                remarks,
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
                          SizedBox(
                            height: height * 0.01,
                          ),
                        ],
                      ),
                    ],
                  ),
                if (titlestatus == "2" && isReschedule == "N")
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
                if (titlestatus == "3")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.01),
                          InkWell(
                            onTap: () {
                              leaveMeeting(ideaId);
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
                                  "Leave",
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
        getIdeaPersons();
      }
    }
  }

  Future<bool> _displayMeetingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Schedule Meeting",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
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
          dob = DateFormat('yyyy-MM-dd').format(pickedDate);
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

  Future<void> getIdeaPersons() async {
    Map mapData = {"ins_user_id": userIdMain};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.MANAGE_IDEA_PERSON),
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
          dataObject: "MANAGE_BIP");
      if (data["code"] == 1) {
        print(data["data"]);
        getIdeaPersonsFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getIdeaPersonsFromWeb(var jsonData) async {
    investordata.clear();
    setState(() {
      for (Map investor in jsonData) {
        investordata.add(
          InvestorData(
              title:
                  investor["idea_title"] != null ? investor["idea_title"] : "",
              relid: investor["rel_id"] != null ? investor["rel_id"] : "",
              isDecline: investor["decline_by"] == userIdMain.toString()
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
              ideaId: investor["idea_id"] != null
                  ? int.parse(investor["idea_id"])
                  : 0,
              bipUserId: investor["user_id"] != null ? investor["user_id"] : "",
              remarks: investor["remarks"] != null ? investor["remarks"] : "",
              meetingDate: investor["schedulemeetingDate"] != null
                  ? DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(investor["schedulemeetingDate"]))
                  : "",
              meetingTime: investor["schedulemeetingTime"] != null
                  ? investor["schedulemeetingTime"]
                  : "",
              isReschedule: investor["is_reschedule"] != null
                  ? investor["is_reschedule"]
                  : "",
              receiverFireId: investor["firebase_user_id"],
              deviceToken: investor["device_token"]),
        );
      }
      investordata.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  void createMeeting(int ideaId, String bipUserId) async {
    Map mapData = {
      "ins_user_id": userIdMain,
      "bip_user_id": int.parse(bipUserId),
      "idea_id": ideaId,
      "schedulemeetingDate": dob,
      "schedulemeetingTime": time
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.CREATE_MEETING),
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
    getIdeaPersons();
  }

  void leaveMeeting(int ideaId) async {
    Map mapData = {
      "user_id": userIdMain,
      "idea_id": ideaId,
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.LEAVE_MEETING),
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
    getIdeaPersons();
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
  int ideaId;
  String bipUserId;
  String remarks;
  String meetingTime;
  String meetingDate;
  String isReschedule;
  String receiverFireId;
  String deviceToken;
  String relid;
  bool isDecline;
  InvestorData(
      {this.title,
      this.email,
      this.titlestatus,
      this.phone,
      this.imageUrl,
      this.createdDate,
      this.createduser,
      this.ideaId,
      this.bipUserId,
      this.remarks,
      this.meetingDate,
      this.meetingTime,
      this.isReschedule,
      this.receiverFireId,
      this.deviceToken,
      this.relid,
      this.isDecline});
}
