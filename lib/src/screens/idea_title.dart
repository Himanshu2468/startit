import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startit/main.dart';

import 'package:video_player/video_player.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;

class IdeaTitle extends StatefulWidget {
  final int ideaId;

  IdeaTitle(this.ideaId);
  @override
  _IdeaTitleState createState() => _IdeaTitleState();
}

class _IdeaTitleState extends State<IdeaTitle>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var color;

  String moveVariable = "";
  bool isReported = false;
  String summaryBackup = "";
  String uniqueBackup = "";
  String useCaseBackup = "";
  List<String> imageUrlPicBackup = [];
  List<VideoPlayerController> videoUrlPicBackup = [];
  List<String> docUrlPicBackup = [];

  List<ReasonReport> listReportReason = [];
  int reportNo = 0;
  TextEditingController remarksController = TextEditingController();
  String reportRadio = "";

  String title = "";
  // String name = "";
  String summary = "";
  String unique = "";
  String useCase = "";
  String location = "";
  String subCategory = "";
  String date = "";
  List<String> videoUrlPic = [];
  int j = 0, k = 0;
  // List<VideoPlayerController> _controller;

  List<String> imageUrlPic = [];
  List<String> documentUrl = [];
  List<VideoPlayerController> _controller = [];

  bool likeIdea = false;
  bool ideaLikedByPPorSP = false;
  int likeCount = 0;

  @override
  void initState() {
    getMoveVariable();
    isIdeaAlreadyLiked(widget.ideaId);
    getIdeaDetail();
    checkReport();
    getReportReason();
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      color = Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        textScaleFactor: 1,
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: height * 0.005),
              const Divider(
                height: 20,
                thickness: 0.5,
                indent: 10,
                endIndent: 20,
                color: Colors.white38,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Column(
              //       children: [
              //         Icon(
              //           Icons.star_outline,
              //           color: Colors.white,
              //         ),
              //         SizedBox(height: height * 0.004),
              //         Text('Save',
              //             style: TextStyle(color: Colors.white, fontSize: 12)),
              //       ],
              //     ),
              //     Column(
              //       children: [
              //         Icon(
              //           Icons.share_outlined,
              //           color: Colors.white,
              //         ),
              //         SizedBox(height: height * 0.004),
              //         Text('Share',
              //             style: TextStyle(color: Colors.white, fontSize: 12)),
              //       ],
              //     ),
              //     Column(
              //       children: [
              //         Icon(
              //           Icons.source_outlined,
              //           color: Colors.white,
              //         ),
              //         SizedBox(height: height * 0.004),
              //         Text('Similar Ideas',
              //             style: TextStyle(color: Colors.white, fontSize: 12)),
              //       ],
              //     ),
              //   ],
              // ),
              // SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
      body: nestedTabs(),
    );
  }

  Widget nestedTabs() {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            color: Colors.grey[100],
            child: new SafeArea(
              child: Column(
                children: <Widget>[
                  new Expanded(child: new Container()),
                  new TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    labelPadding: EdgeInsets.all(10.0),
                    indicatorColor: Colors.blue,
                    indicatorWeight: 3.0,
                    tabs: [
                      Text(
                        "Idea Person",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      Text("Documents",
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: _tabController.index == 1
                                  ? Colors.blue
                                  : Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            IdeaDetails(),
            showDocuments(),
          ],
        ),
      ),
    );
  }

  showDialogReport(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please select problem",
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  "If someone is in immediate danger get help before reporting to STARTiT. Don't Wait",
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height *
                            0.35, ///////////////////
                        child: ListView.builder(
                          itemCount: listReportReason.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: Radio(
                                        activeColor: Colors.orange,
                                        value: int.parse(
                                            listReportReason[index].id),
                                        groupValue: reportNo,
                                        onChanged: (val) {
                                          setState(() {
                                            reportNo = val;
                                            reportRadio =
                                                listReportReason[index].id;
                                          });
                                        }),
                                  ),
                                  Text(
                                    listReportReason[index].reason,
                                    textScaleFactor: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Remarks",
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
                      Container(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: remarksController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[50],
                            focusColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            // suffixIcon: Icons(Icon.),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'CANCEL',
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context, false); ///////////////////
                },
              ),
              TextButton(
                child: Text(
                  'REPORT',
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.red[300]),
                ),
                onPressed: () {
                  if (reportRadio.isEmpty) {
                    WebResponseExtractor.showToast('Please select problem');
                  } else if (remarksController.text.trim() == "") {
                    WebResponseExtractor.showToast('Please enter remarks');
                  } else {
                    // show=false;
                    submitReport();
                    Navigator.pop(
                        context, true); ///////////////////////////////////
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget showDocuments() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // imageUrlPic.isEmpty
          //     ? Column(
          //         children: [
          //           SizedBox(
          //             height: 20,
          //           ),
          //           Padding(
          //             padding: EdgeInsets.all(5),
          //             child: Icon(Icons.photo),
          //           ),
          //           SizedBox(
          //             height: 20,
          //           ),
          //           Text("No Documents")
          //         ],
          //       )
          // : Container(
          //     padding: EdgeInsets.only(
          //         top: MediaQuery.of(context).size.height * 0.05),
          //     height: MediaQuery.of(context).size.height * 0.6,
          //     width: MediaQuery.of(context).size.width * 0.8,
          //     child: ListView.builder(
          //       itemCount: imageUrlPic.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         return Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(16.0),
          //             child: Image.network(
          //               imageUrlPic[index],
          //               fit: BoxFit.fill,
          //               height: MediaQuery.of(context).size.height * 0.3,
          //               width: MediaQuery.of(context).size.width * 0.4,
          //             ),
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          imageUrlPic.length == 0
              ? addPictures(
                  'Pictures',
                  'jpeg/png',
                  '',
                  Icon(Icons.photo),
                )
              : addPictures(
                  'Pictures',
                  'jpeg/png',
                  '',
                  GestureDetector(
                    onTap: () {
                      return showDialogFunc(context, imageUrlPic);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      child: (imageUrlPic.length == 1)
                          ? Image.network(
                              "http://164.52.192.76:8080/startit/" +
                                  imageUrlPic[0],
                              fit: BoxFit.contain,
                            )
                          : Row(
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: MediaQuery.of(context).size.width *
                                        0.14,
                                    child: Image.network(
                                      "http://164.52.192.76:8080/startit/" +
                                          imageUrlPic[0],
                                      fit: BoxFit.cover,
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  child: Center(
                                      child: Text(
                                    "+" + (imageUrlPic.length - 1).toString(),
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          // Text(
          //   "VIDEOS",
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.bold,
          //     letterSpacing: 1.0,
          //   ),
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          _controller.length == 0
              ? addPictures(
                  'Video',
                  'mp4',
                  '',
                  Icon(Icons.video_call_outlined
                      //color: Colors.white,

                      ),
                )
              : addPictures(
                  'Video',
                  'mp4',
                  '',
                  GestureDetector(
                    onTap: () {
                      return showDialogFuncVideo(context, _controller);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.12,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[300],
                      ),
                      child: (_controller.length == 1)
                          ? _controller[0].value.initialized
                              ? AspectRatio(
                                  aspectRatio: _controller[0].value.aspectRatio,
                                  child: VideoPlayer(_controller[0]),
                                )
                              : Container()
                          : Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: MediaQuery.of(context).size.width *
                                        0.14,
                                    child: _controller[0].value.initialized
                                        ? AspectRatio(
                                            aspectRatio: _controller[0]
                                                .value
                                                .aspectRatio,
                                            child: VideoPlayer(_controller[0]),
                                          )
                                        : Container()),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.14,
                                  child: Center(
                                      child: Text(
                                    "+" + (_controller.length - 1).toString(),
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                )
                              ],
                            ),
                    ),
                  ),
                ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          // Text(
          //   "DOCUMENTS",
          //   style: TextStyle(
          //     fontSize: 14,
          //     fontWeight: FontWeight.bold,
          //     letterSpacing: 1.0,
          //   ),
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          GestureDetector(
            onTap: () {
              if (documentUrl.isNotEmpty)
                return showDialogFuncDocument(context, documentUrl);
            },
            child: addPictures(
              'Documents',
              'pdf/dox/pptx',
              '',
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.14,
                    child: Icon(
                      Icons.insert_drive_file,
                      size: MediaQuery.of(context).size.width * 0.06,
                      //color: Colors.white,
                    ),
                  ),
                  Center(
                      child: Text(
                    "+" + documentUrl.length.toString(),
                    textScaleFactor: 1,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addPictures(String txt, String txt1, String txt2, Widget icon) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txt,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
        SizedBox(height: height * 0.005),
        Container(
          width: width * 0.3,
          height: height * 0.07,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          child: icon,
        ),
        SizedBox(height: height * 0.005),
        Text(
          txt1,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 9,
          ),
        ),
        Text(
          txt2,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 9,
          ),
        ),
        SizedBox(height: height * 0.01),
      ],
    );
  }

  Widget IdeaDetails() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.only(left: 28.0, right: 28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            isReported
                ? InkWell(
                    onTap: () {
                      WebResponseExtractor.showToast("Already Reported");
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.22,
                        height: MediaQuery.of(context).size.height * 0.022,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red[300]),
                            borderRadius: BorderRadius.circular(3)),
                        child: Center(
                          child: Text(
                            "Reported",
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red[300],
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      showDialogReport(context);
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.22,
                        height: MediaQuery.of(context).size.height * 0.022,
                        margin: EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red[300]),
                            borderRadius: BorderRadius.circular(3)),
                        child: Center(
                          child: Text(
                            "Report",
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red[300],
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Card(
              elevation: 2.5,
              shadowColor: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Highlights',
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        // if (moveVariable == "/product_provider" ||
                        //     moveVariable == "/domain")
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  addLike(widget.ideaId);
                                },
                                child: ideaLikedByPPorSP
                                    ? Icon(Icons.thumb_up_alt_rounded,
                                        color: Colors.blue)
                                    : Icon(Icons.thumb_up_alt_outlined,
                                        color: Colors.blue),
                              ),
                              SizedBox(width: 4),
                              Text(
                                likeCount.toString() + " Likes",
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      children: [
                        Icon(Icons.place_outlined),
                        SizedBox(width: 4),
                        Text(location,
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012),
                    Row(
                      children: [
                        Icon(Icons.category),
                        SizedBox(width: 4),
                        SizedBox(
                          width: 220,
                          child: Text(
                            subCategory,
                            textScaleFactor: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      children: [
                        Icon(Icons.schedule_outlined),
                        SizedBox(width: 4),
                        Text(date,
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    if (moveVariable == "/capabilities")
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () {
                              if (likeIdea == false) {
                                interested();
                                addLike(widget
                                    .ideaId); //khushbu - I think here is the problem
                              } else
                                WebResponseExtractor.showToast(
                                    "Idea already Shortlisted");
                            },
                            style: ElevatedButton.styleFrom(
                                primary: likeIdea == true
                                    ? Colors.green
                                    : Colors.blue),
                            child: Text(
                              likeIdea == true
                                  ? 'SHORTLISTED'
                                  : 'I AM INTERESTED',
                              textScaleFactor: 1,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text('Idea Summary',
                textScaleFactor: 1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              summary,
              textScaleFactor: 1,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text('What Makes Our Idea Unique?',
                textScaleFactor: 1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              unique,
              textScaleFactor: 1,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text('Use Case Or Study',
                textScaleFactor: 1,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              useCase,
              textScaleFactor: 1,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ],
        ),
      ),
    );
  }

  void getMoveVariable() async {
    final prefs = await SharedPreferences.getInstance();
    final extractUserData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    moveVariable = extractUserData["move"];
    print("move: $moveVariable");
  }

  void interested() async {
    Map mapData = {"ins_user_id": userIdMain, "idea_id": widget.ideaId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.I_M_INTERESTED),
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
        setState(() {
          likeIdea = true;
        });
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
  }

  void getIdeaDetail() async {
    Map mapData = {"idea_id": widget.ideaId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.VIEW_IDEA),
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
          dataObject: "IDEA_DETAILS");
      Map jsonData1 = WebResponseExtractor.filterWebData(response,
          dataObject: "IDEA_MEDIA");
      Map jsonData2 = WebResponseExtractor.filterWebData(response,
          dataObject: "MEDIA_PRIVACY");
      if (data["code"] == 1) {
        print(data["data"]);
        getIdeaDetailFromWeb(data["data"]);
      }
      Map bipData = WebResponseExtractor.filterWebData(response,
          dataObject: "BIP_DETAILS");
      if (bipData["code"] == 1) {
        print(bipData["data"]);
        getBipDetailFromWeb(bipData["data"]);
      }
      print(jsonData1);
      print(jsonData2);
      if (jsonData2["data"] != null) {
        getIdeasFromWeb12(jsonData1["data"], jsonData2["data"]);
      } else if (moveVariable == "/capabilities") {
        getInterestedIdeas();
      }
    }
  }

  Future<Null> getIdeaDetailFromWeb(var jsonData) async {
    summaryBackup =
        jsonData["idea_summary"] != null ? jsonData["idea_summary"] : "";
    uniqueBackup = jsonData["how_your_idea_is_unique"] != null
        ? jsonData["how_your_idea_is_unique"]
        : "";
    useCaseBackup = jsonData["use_case_or_story"] != null
        ? jsonData["use_case_or_story"]
        : "";
    setState(() {
      title = jsonData["idea_title"] != null ? jsonData["idea_title"] : "";

      if (jsonData["idea_summary_ins_can_read"] == "Y") {
        summary = summaryBackup;
      }
      if (jsonData["idea_uniqueness_ins_can_read"] == "Y") {
        unique = uniqueBackup;
      }
      if (jsonData["idea_case_study_ins_can_read"] == "Y") {
        useCase = useCaseBackup;
      }
      subCategory = jsonData["sub_category_name"] != null
          ? jsonData["sub_category_name"]
          : "";
      date = jsonData["createdAt"] != null
          ? DateFormat('dd MMM yyyy')
              .format(DateTime.parse(jsonData["createdAt"]))
          : "";
      likeCount = jsonData["likes_count"] != null
          ? int.parse(jsonData["likes_count"])
          : 0;
    });
  }

  void checkReport() async {
    Map data = {
      "login_user_id_no": userIdMain,
      "id_no": widget.ideaId,
      "type": "idea",
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.CHECK_REPORTED),
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
        isReported = true;
      } else {
        isReported = false;
      }
    }
  }

  Future<Null> getBipDetailFromWeb(var jsonData) async {
    setState(() {
      location = "${jsonData["city_name"]}, ${jsonData["state_name"]}";
    });
  }

  void getReportReason() async {
    Map mapData = {};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.GET_REPORT_REASON),
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
            WebResponseExtractor.filterWebData(response, dataObject: "DATA");
        var userData = data["data"];
        getReportReasonFull(userData);
      }
    }
  }

  void submitReport() async {
    Map data = {
      "login_user_id_no": userIdMain,
      "id_no": widget.ideaId,
      "type": "idea",
      "reasion_id": reportRadio,
      "remarks": remarksController.text,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.REPORT_PERSON),
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
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        setState(() {
          isReported = true;
        });
      }
    }
  }

  Future<void> getReportReasonFull(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        listReportReason.add(ReasonReport(idea["id"], idea["name"]));
      }
    });
  }

  Future<Null> getIdeasFromWeb12(var jsonData, var jsonData1) async {
    for (Map idea in jsonData) {
      // }
      if (idea["file_type_head"] == "picture") {
        imageUrlPicBackup.add(idea["picture_path"]);
        // imageUrlPicBackup
        //   .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
      }
      // File.writeAsBytes(response.bodyBytes);
      else if (idea["file_type_head"] == "video") {
        if (idea["picture_path"] != null && idea["picture_path"] != "") {
          VideoPlayerController vdioe;
          vdioe = VideoPlayerController.network(
              "http://164.52.192.76:8080/startit/" + idea["picture_path"])
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {
                // vdioe.play();
              });
            });
          videoUrlPicBackup.add(vdioe);
        }
      } else if (idea["file_type_head"] == "documents") {
        docUrlPicBackup
            .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
      }
    }
    setState(() {
      if (jsonData1["picture_path_ins_can_see"] == "Y") {
        // imageUrlPic = imageUrlPicBackup;
        imageUrlPic = imageUrlPicBackup;
      }

      if (jsonData1["video_path_ins_can_see"] == "Y") {
        _controller = videoUrlPicBackup;
      }

      if (jsonData1["doc_path_ins_can_see"] == "Y") {
        documentUrl = docUrlPicBackup;
      }
      // File.writeAsBytes(response.bodyBytes);
      //   else if (idea["file_type_head"] == "video") {
      //     videoUrlPic
      //         .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
      //     _controller.add(VideoPlayerController.network(videoUrlPic[j])
      //       ..initialize().then((_) {
      //         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      //         setState(() {
      //           _controller[j].play();
      //         });
      //       }));
      //     j = j + 1;
      //   } else if (idea["file_type_head"] == "documents") {
      //     k = k + 1;
      //   }
      // }
    });
    if (moveVariable == "/capabilities") {
      getInterestedIdeas();
    }
  }

  void getInterestedIdeas() async {
    Map mapData = {"ins_user_id": userIdMain};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_INTERESTED_IDEAS_LIST),
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
          WebResponseExtractor.filterWebData(response, dataObject: "LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getInterestedIdeasFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getInterestedIdeasFromWeb(var jsonData) async {
    Map ourIdea = {};
    for (var idea in jsonData) {
      if (idea["idea_id"] == widget.ideaId.toString()) {
        setState(() {
          likeIdea = true;
        });
        ourIdea = idea;
        setCustomPrivacy(ourIdea);
        break;
      }
    }
  }

  void setCustomPrivacy(var jsonMap) {
    if (jsonMap["idea_uniqueness_ins_can_read"] == null &&
        jsonMap["idea_summary_ins_can_read"] == null &&
        jsonMap["idea_case_study_ins_can_read"] == null &&
        jsonMap["picture_path_ins_can_see"] == null &&
        jsonMap["video_path_ins_can_see"] == null &&
        jsonMap["doc_path_ins_can_see"] == null) {
      //do Nothing
    } else {
      setState(() {
        if (jsonMap["idea_summary_ins_can_read"] == "Y") {
          summary = summaryBackup;
        } else
          summary = "";
        if (jsonMap["idea_uniqueness_ins_can_read"] == "Y") {
          unique = uniqueBackup;
        } else
          unique = "";
        if (jsonMap["idea_case_study_ins_can_read"] == "Y") {
          useCase = useCaseBackup;
        } else
          useCase = "";
        if (jsonMap["picture_path_ins_can_see"] == "Y") {
          imageUrlPic = imageUrlPicBackup;
        } else
          imageUrlPic = [];
      });
    }
  }

  void addLike(int ideaId) async {
    Map data = {
      "user_id": userIdMain,
      "idea_id": ideaId,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.IDEA_LIKES),
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
        setState(() {
          ideaLikedByPPorSP = !ideaLikedByPPorSP;
          ideaLikedByPPorSP
              ? likeCount = likeCount + 1
              : likeCount = likeCount - 1;
        });
      }
    }
    ideaLikedByPPorSP
        ? WebResponseExtractor.showToast("Idea Liked")
        : WebResponseExtractor.showToast("Idea Unliked");
  }

  void isIdeaAlreadyLiked(int ideaId) async {
    Map mapData = {
      "user_id": userIdMain,
      "idea_id": ideaId,
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.IS_IDEA_ALREADY_LIKED),
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
        if (jsonData["Count"] == 1) {
          setState(() {
            ideaLikedByPPorSP = true;
          });
        }
      }
    }
  }
}

showDialogFuncVideo(context, List<VideoPlayerController> vc) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vc.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: vc.length == 1
                                ? MediaQuery.of(context).size.width * 0.95
                                : MediaQuery.of(context).size.width * 0.8,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: vc[index].value.initialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            vc[index].value.aspectRatio,
                                        child: VideoPlayer(vc[index]),
                                      )
                                    : Container()),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            IconButton(
                              iconSize: 30,
                              icon: Icon(!vc[index].value.isPlaying
                                  ? Icons.play_arrow
                                  : Icons.pause),
                              onPressed: () {
                                !vc[index].value.isPlaying
                                    ? vc[index].play()
                                    : vc[index].pause();
                                setState(() {});
                                vc[index].setLooping(true);
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  }),
            ),
          ),
        );
      });
    },
  );
}

showDialogFuncDocument(context, List<String> img) {
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
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: img.length,
                itemBuilder: (BuildContext context, int index) {
                  String docType = img[index].split(".").last;
                  IconData customIcon;
                  Color clr;
                  if (docType == "pdf") {
                    customIcon = myIcons.MaterialCommunityIcons.pdf_box;
                    clr = Colors.red;
                  }
                  if (docType == "xlsx") {
                    customIcon = myIcons.MaterialCommunityIcons.file_excel_box;
                    clr = Colors.green[700];
                  }
                  if (docType == "docx" || docType == "doc") {
                    customIcon = myIcons.MaterialCommunityIcons.file_word_box;
                    clr = Colors.blue[700];
                  }
                  if (docType == "pptx") {
                    customIcon =
                        myIcons.MaterialCommunityIcons.file_powerpoint_box;
                    clr = Colors.orange[700];
                  }
                  print(docType);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () async {
                              await launch(img[index]);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Icon(
                                customIcon,
                                color: clr,
                                size: 50,
                              ),
                            )),
                      ),
                    ],
                  );
                }),
          ),
        ),
      );
    },
  );
}

showDialogFunc(context, List<String> img) {
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
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: img.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            "http://164.52.192.76:8080/startit/" + img[index],
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // SizedBox(
                      //   height: MediaQuery.of(context).size.width * 0.5,
                      //   child: Divider(
                      //     thickness: 5,
                      //     color: Colors.black,
                      //   ),
                      // )
                    ],
                  );
                }),
          ),
        ),
      );
    },
  );
}

class ReasonReport {
  String id;
  String reason;
  ReasonReport(this.id, this.reason);
}
