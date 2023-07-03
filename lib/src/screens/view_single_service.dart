import 'package:flutter/material.dart';
import 'package:startit/main.dart';
import 'package:video_player/video_player.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;

class ViewSingleService extends StatefulWidget {
  final bool isService;
  final int ppspId;
  final int userId;
  final String email;
  final String phNumber;
  final String insName;
  final String providerName;

  ViewSingleService(this.isService, this.ppspId, this.userId, this.email,
      this.phNumber, this.insName, this.providerName);
  @override
  _ViewSingleServiceState createState() => _ViewSingleServiceState();
}

class _ViewSingleServiceState extends State<ViewSingleService>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Color color;
  String image = "";
  String dob = "";
  String location = "";
  List<ReasonReport> listReportReason = [];
  int reportNo = 0;
  TextEditingController remarksController = TextEditingController();
  String reportRadio = "";
  bool isReported = false;
  List<String> skills = [];
  List<String> skillsList = [];
  String certificate = "";
  String message = "";
  String different = "";

  List<String> categories = [];
  List<String> catList = [];
  List<String> subCategories = [];
  List<String> subCatList = [];
  List<String> microCategories = [];
  List<String> microList = [];
  List<String> domain = [];
  List<String> domainList = [];
  String availability = "";
  String brandName = "";
  String cin = "";
  String teamSize = "";
  String year = "";
  String legalStatus = "";
  String turnover = "";
  String address = "";

  String service_details = "";
  String upload_brochure = "";

  List<String> imageUrlPic = [];
  List<String> documentUrl = [];
  List<VideoPlayerController> _controller = [];
  List<String> documentUrl1 = [];
  List<String> imageUrlPic1 = [];
  List<VideoPlayerController> _controller1 = [];

  List<String> items = [];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    getProfileData();
    // getInvesterData();
  }

  void _handleTabSelection() {
    setState(() {
      color = Colors.blue;
    });
  }

  @override
  void dispose() {
    _controller.forEach((element) {
      element.dispose();
    });
    _controller1.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          widget.isService ? 'Service Profile' : 'Product Detail',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: height,
        color: Colors.blue,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          // padding: EdgeInsets.all(width * 0.1),
          padding: EdgeInsets.fromLTRB(
              width * 0.1, width * 0.04, width * 0.1, width * 0.1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                isReported
                    ? InkWell(
                        onTap: () {
                          WebResponseExtractor.showToast("Already Reported");
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: width * 0.22,
                            height: height * 0.022,
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
                            width: width * 0.22,
                            height: height * 0.022,
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
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    Container(
                      width: width * 0.3,
                      height: width * 0.3,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "http://164.52.192.76:8080/startit/$image",
                        ),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    SizedBox(
                      width: width * 0.45,
                      child: Text(
                        widget.providerName,
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )
                  ],
                ),
                Container(
                  height: height * 0.55,
                  child: nestedTabs(height),
                ),
              ],
            ),
          ),
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

  Widget nestedTabs(double height) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            child: new SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Skills",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      Text(
                        widget.isService ? "Category/Domain" : "Category",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 1
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      Text(
                        "Details",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 2
                                ? Colors.blue
                                : Colors.grey),
                      ),
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
            widget.isService ? sskills() : pskills(),
            widget.isService ? catDomain() : pCat(),
            widget.isService ? details() : pDetails(),
          ],
        ),
      ),
    );
  }

  Widget sskills() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SKILLS:",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    skillsList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: skillsList[index].toString().length < 10
                            ? 85
                            : skillsList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${skillsList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "ADD CERTIFICATE",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                certificate,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "MESSAGE",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "HOW ARE PRODUCT/SERVICE DIFFERENT?",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                different,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ],
      ),
    );
  }

  _launchCaller() async {
    String url = "tel:+91${widget.phNumber}";
    await launch(url);
  }

  Widget catDomain() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SERVICE DELIVERABLE CATEGORIES",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    catList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: catList[index].toString().length < 10
                            ? 85
                            : catList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${catList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "SERVICE DELIVERABLE SUB-CATEGORIES",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    subCatList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: subCatList[index].toString().length < 10
                            ? 85
                            : subCatList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${subCatList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "SERVICE DELIVERABLE MICRO-CATEGORY",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    microList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: microList[index].toString().length < 10
                            ? 85
                            : microList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${microList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "DOMAIN",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    domainList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: domainList[index].toString().length < 10
                            ? 85
                            : domainList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${domainList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "AVAILABILITY",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                availability,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget details() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SERVICE DETAILS",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                service_details,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        child: Image.network(
                                          "http://164.52.192.76:8080/startit/" +
                                              imageUrlPic[0],
                                          fit: BoxFit.cover,
                                        )),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (imageUrlPic.length - 1).toString(),
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
                          width: width * 0.12,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (_controller.length == 1)
                              ? _controller[0].value.initialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller[0].value.aspectRatio,
                                      child: VideoPlayer(_controller[0]),
                                    )
                                  : Container()
                              : Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: height * 0.07,
                                        width: width * 0.06,
                                        child: _controller[0].value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _controller[0]
                                                    .value
                                                    .aspectRatio,
                                                child:
                                                    VideoPlayer(_controller[0]),
                                              )
                                            : Container()),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (_controller.length - 1).toString(),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text(
                "UPLOAD BROCHURE",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                upload_brochure,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              imageUrlPic1.length == 0
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
                          return showDialogFunc(context, imageUrlPic1);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (imageUrlPic1.length == 1)
                              ? Image.network(
                                  "http://164.52.192.76:8080/startit/" +
                                      imageUrlPic1[0],
                                  fit: BoxFit.contain,
                                )
                              : Row(
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        child: Image.network(
                                          "http://164.52.192.76:8080/startit/" +
                                              imageUrlPic1[0],
                                          fit: BoxFit.cover,
                                        )),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (imageUrlPic1.length - 1)
                                                .toString(),
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
              _controller1.length == 0
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
                          return showDialogFuncVideo(context, _controller1);
                        },
                        child: Container(
                          width: width * 0.12,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (_controller1.length == 1)
                              ? _controller1[0].value.initialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller1[0].value.aspectRatio,
                                      child: VideoPlayer(_controller1[0]),
                                    )
                                  : Container()
                              : Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: height * 0.07,
                                        width: width * 0.06,
                                        child: _controller1[0].value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _controller1[0]
                                                    .value
                                                    .aspectRatio,
                                                child: VideoPlayer(
                                                    _controller1[0]),
                                              )
                                            : Container()),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (_controller1.length - 1)
                                                .toString(),
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
              GestureDetector(
                onTap: () {
                  if (documentUrl1.isNotEmpty)
                    return showDialogFuncDocument(context, documentUrl1);
                },
                child: addPictures(
                  'Documents',
                  'pdf/dox/pptx',
                  '',
                  Row(
                    children: [
                      Container(
                        width: width * 0.06,
                        child: Icon(
                          Icons.insert_drive_file,
                          size: width * 0.04,
                          //color: Colors.white,
                        ),
                      ),
                      Center(
                          child: Text(
                        "+" + documentUrl1.length.toString(),
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pskills() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SKILLS",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    skillsList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: skillsList[index].toString().length < 10
                            ? 85
                            : skillsList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${skillsList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "MESSAGE",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                message,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "HOW ARE PRODUCT/SERVICE DIFFERENT?",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                different,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ],
      ),
    );
  }

  // _launchCaller() async {
  //   String url = "tel:+91${widget.phNumber}";
  //   await launch(url);
  // }

  Widget pCat() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PRODUCT DELIVERABLE CATEGORIES",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    catList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: catList[index].toString().length < 10
                            ? 85
                            : catList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${catList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "PRODUCT DELIVERABLE SUB-CATEGORIES",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    subCatList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: subCatList[index].toString().length < 10
                            ? 85
                            : subCatList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${subCatList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "PRODUCT DELIVERABLE MICRO-CATEGORY",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: width,
                child: Wrap(
                  children: List<Widget>.generate(
                    microList.length,
                    (int index) {
                      return Container(
                        height: 20,
                        width: microList[index].toString().length < 10
                            ? 85
                            : microList[index].toString().length * 8.5,
                        margin: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey[500], width: 1.0)),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.loose,
                              child: Container(
                                child: Text(
                                    "${microList[index].toString().replaceAll("[", "").replaceAll("]", "")}",
                                    textScaleFactor: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "BRAND NAME",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                brandName,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "CIN",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                cin,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "TEAM SIZE",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                teamSize,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "YEAR OF ESTABLISHMENT",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                year,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "LEGAL STATUS OF FIRM",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                legalStatus,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "ANNUAL TURNOVER",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                turnover,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "ADDRESS",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                address,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pDetails() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SERVICE DETAILS",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                service_details,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Text(
              //   "PICTURES",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.0,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        child: Image.network(
                                          "http://164.52.192.76:8080/startit/" +
                                              imageUrlPic[0],
                                          fit: BoxFit.cover,
                                        )),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (imageUrlPic.length - 1).toString(),
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
                          width: width * 0.12,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (_controller.length == 1)
                              ? _controller[0].value.initialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller[0].value.aspectRatio,
                                      child: VideoPlayer(_controller[0]),
                                    )
                                  : Container()
                              : Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: height * 0.07,
                                        width: width * 0.06,
                                        child: _controller[0].value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _controller[0]
                                                    .value
                                                    .aspectRatio,
                                                child:
                                                    VideoPlayer(_controller[0]),
                                              )
                                            : Container()),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (_controller.length - 1).toString(),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text(
                "UPLOAD BROCHURE",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                upload_brochure,
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              // Text(
              //   "PICTURES",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     letterSpacing: 1.0,
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              imageUrlPic1.length == 0
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
                          return showDialogFunc(context, imageUrlPic1);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.12,
                          height: MediaQuery.of(context).size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (imageUrlPic1.length == 1)
                              ? Image.network(
                                  "http://164.52.192.76:8080/startit/" +
                                      imageUrlPic1[0],
                                  fit: BoxFit.contain,
                                )
                              : Row(
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        child: Image.network(
                                          "http://164.52.192.76:8080/startit/" +
                                              imageUrlPic1[0],
                                          fit: BoxFit.cover,
                                        )),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (imageUrlPic1.length - 1)
                                                .toString(),
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
              _controller1.length == 0
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
                          return showDialogFuncVideo(context, _controller1);
                        },
                        child: Container(
                          width: width * 0.12,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[300],
                          ),
                          child: (_controller1.length == 1)
                              ? _controller1[0].value.initialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controller1[0].value.aspectRatio,
                                      child: VideoPlayer(_controller1[0]),
                                    )
                                  : Container()
                              : Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        height: height * 0.07,
                                        width: width * 0.06,
                                        child: _controller1[0].value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _controller1[0]
                                                    .value
                                                    .aspectRatio,
                                                child: VideoPlayer(
                                                    _controller1[0]),
                                              )
                                            : Container()),
                                    Container(
                                      width: width * 0.06,
                                      child: Center(
                                          child: Text(
                                        "+" +
                                            (_controller1.length - 1)
                                                .toString(),
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
                  if (documentUrl1.isNotEmpty)
                    return showDialogFuncDocument(context, documentUrl1);
                },
                child: addPictures(
                  'Documents',
                  'pdf/dox/pptx',
                  '',
                  Row(
                    children: [
                      Container(
                        width: width * 0.06,
                        child: Icon(
                          Icons.insert_drive_file,
                          size: width * 0.04,
                          //color: Colors.white,
                        ),
                      ),
                      Center(
                          child: Text(
                        "+" + documentUrl1.length.toString(),
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
              ),
            ],
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
          width: width * 0.14,
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

  void getProfileData() async {
    Map mapData = {"user_id": widget.userId};
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
        var userData = data["data"];

        setState(() {
          image = userData["profile_image"] != null
              ? userData["profile_image"]
              : "";
          dob = userData["dob"] != null
              ? DateFormat('dd MMM yyyy')
                  .format(DateTime.parse(userData["dob"]))
              : "";
          location = "${userData["city_name"]}, ${userData["state_name"]}";
        });
      }
    }
    widget.isService ? getServiceData() : getProductData();
    checkReport();
    getReportReason();
  }

  void checkReport() async {
    Map data = {
      "login_user_id_no": userIdMain,
      "id_no": widget.ppspId,
      "type": widget.isService ? "service" : "product",
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

  void getServiceData() async {
    Map mapData = {"service_id": widget.ppspId};
    print("..............................");
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.GET_SPSINGLE_LIST),
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
            dataObject: "SERVICE_DETAILS");
        var investorData = data["data"];

        Map brochure = WebResponseExtractor.filterWebData(response,
            dataObject: "BROCHURE_MEDIA");
        var brochureInfo = brochure["data"];
        Map serMedia = WebResponseExtractor.filterWebData(response,
            dataObject: "SERVICE_MEDIA");
        var serMediaInfo = serMedia["data"];
        getServiceMediaFromWeb(serMediaInfo);
        getServiceMediaFromWeb1(brochureInfo);

        for (Map ii in investorData["service_category_data"]) {
          categories.add(ii["category_name"]);
        }
        catList = categories.toString().split(",");
        for (Map ii in investorData["service_sub_category"]) {
          subCategories.add(ii["sub_category"]);
        }
        subCatList = subCategories.toString().split(",");
        for (Map ii in investorData["service_fall_category_data"]) {
          microCategories.add(ii["fall_cat_name"]);
        }
        microList = microCategories.toString().split(",");

        setState(() {
          for (Map ii in investorData["skills"]) {
            skills.add(ii["skills"]);
          }
          skillsList = skills.toString().split(",");
          certificate = investorData["certificate_url"] != null
              ? investorData["certificate_url"]
              : "";
          message = investorData["message_for_idea_person"] != null
              ? investorData["message_for_idea_person"]
              : "";
          different = investorData["how_product_different"] != null
              ? investorData["how_product_different"]
              : "";
          for (Map ii in investorData["service_domain"]) {
            domain.add(ii["category_name"]);
          }
          domainList = domain.toString().split(",");
          availability = investorData["availability"] != null
              ? investorData["availability"]
              : "";
          service_details = investorData["product_service_details"] != null
              ? investorData["product_service_details"]
              : "";
          upload_brochure = investorData["brochure_details"] != null
              ? investorData["brochure_details"]
              : "";
        });
      }
    }
  }

  Future<void> getServiceMediaFromWeb1(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        if (idea["file_type_head"] == "picture") {
          imageUrlPic1.add(idea["picture_path"]);
          // print(imageUrlPic1[0] + "ssa");
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
            _controller1.add(vdioe);
          }
        } else if (idea["file_type_head"] == "document") {
          documentUrl1
              .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
        }
      }
    });
  }

  Future<Null> getServiceMediaFromWeb(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        if (idea["file_type_head"] == "picture") {
          imageUrlPic.add(idea["picture_path"]);
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
            _controller.add(vdioe);
            // _controller.add(VideoPlayerController.network(
            //     "http://164.52.192.76:8080/startit/" + idea["picture_path"]));
          }
        } else if (idea["file_type_head"] == "document") {
          documentUrl
              .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
        }
      }
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

  Future<void> getReportReasonFull(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        listReportReason.add(ReasonReport(idea["id"], idea["name"]));
      }
    });
  }

  void submitReport() async {
    Map data = {
      "login_user_id_no": userIdMain,
      "id_no": widget.ppspId,
      "type": widget.isService ? "service" : "product",
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

  void getProductData() async {
    Map mapData = {"product_id": widget.ppspId};
    print("..............................");
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.GET_PPSINGLE_LIST),
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
            dataObject: "SERVICE_DETAILS");
        var investorData = data["data"];

        Map brochure = WebResponseExtractor.filterWebData(response,
            dataObject: "BROCHURE_MEDIA");
        var brochureInfo = brochure["data"];
        Map serMedia = WebResponseExtractor.filterWebData(response,
            dataObject: "SERVICE_MEDIA");
        var serMediaInfo = serMedia["data"];
        for (Map ii in investorData["product_category_data"]) {
          categories.add(ii["category_name"]);
        }

        catList = categories.toString().split(",");

        for (Map ii in investorData["product_sub_category"]) {
          subCategories.add(ii["sub_category"]);
        }

        subCatList = subCategories.toString().split(",");
        for (Map ii in investorData["product_fall_category_data"]) {
          microCategories.add(ii["fall_cat_name"]);
        }

        microList = microCategories.toString().split(",");
        getServiceMediaFromWeb(serMediaInfo);
        getServiceMediaFromWeb1(brochureInfo);

        setState(() {
          for (Map ii in investorData["skills"]) {
            skills.add(ii["skills"]);
          }
          skillsList = skills.toString().split(",");
          message = investorData["message_for_idea_person"] != null
              ? investorData["message_for_idea_person"]
              : "";
          different = investorData["how_product_different"] != null
              ? investorData["how_product_different"]
              : "";
          service_details = investorData["product_service_details"] != null
              ? investorData["product_service_details"]
              : "";
          upload_brochure = investorData["brochure_details"] != null
              ? investorData["brochure_details"]
              : "";
          brandName = investorData["brand_name"] != null
              ? investorData["brand_name"]
              : "";
          cin = investorData["gst_no"] != null ? investorData["gst_no"] : "";
          teamSize = investorData["team_size"] != null
              ? investorData["team_size"]
              : "";
          year = investorData["year_of_establishment"] != null
              ? investorData["year_of_establishment"]
              : "";
          legalStatus = investorData["legal_status_firm"] != null
              ? investorData["legal_status_firm"]
              : "";
          turnover = investorData["annual_turnover"] != null
              ? investorData["annual_turnover"]
              : "";
          address =
              investorData["address"] != null ? investorData["address"] : "";
        });
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
