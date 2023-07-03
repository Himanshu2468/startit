import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:startit/src/screens/chats.dart';
import 'package:startit/src/screens/mng_invt_viewProfile.dart';
import 'package:startit/src/screens/suggested_ideas.dart';
import 'package:startit/src/screens/view_service_list.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:startit/src/widgets/suggested_ideas_dashboard.dart';
import 'package:startit/src/widgets/suggested_ideas_investor.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import '../widgets/app_drawer.dart';

class Dashboard extends StatefulWidget {
  @override
  String move = "";
  Dashboard([this.move]);
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TabController _tabController1;
  var color;
  DateTime currentBackPressTime;

  int notifiationCount = 0;

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
  // bool isSet=false;

  @override
  void initState() {
    if (widget.move == "/occupation") getIdeas();
    getNotifications();
    if (widget.move == "/capabilities") getIns();
    // getInvestors();
    super.initState();
    if (widget.move == "/occupation") {
      _tabController = new TabController(vsync: this, length: 3);
      _tabController.addListener(_handleTabSelection);
    } else if (widget.move == "/capabilities") {
      _tabController1 = new TabController(vsync: this, length: 2);
      _tabController1.addListener(_handleTabSelection);
    }
  }

  void _handleTabSelection() {
    setState(() {
      color = Colors.blue;
    });
  }

  IdeaData ideaData = IdeaData(); ////////////////////

  List<MeetingData> meetingData = [
    // MeetingData(
    //   title: "Meeting Title",
    //   date: "Summary",
    //   remarks: "6391 Elgin St. Celina, Delaware 10299 ",
    //   time: "Sep 31 2021 9:00 - 13:00",
    // ),
    // MeetingData(
    //   title: "Meeting Title",
    //   date: "Summary",
    //   remarks: "6391 Elgin St. Celina, Delaware 10299 ",
    //   time: "Sep 31 2021 9:00 - 13:00",
    // ),
    // MeetingData(
    //   title: "Meeting Title",
    //   date: "Summary",
    //   remarks: "6391 Elgin St. Celina, Delaware 10299 ",
    //   time: "Sep 31 2021 9:00 - 13:00",
    // ),
  ];

  List<ProviderData> spData = [];

  List<ProviderData> ppData = [];
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    // String move1 = ModalRoute.of(context).settings.arguments as String;
    // if (move1 != "" && move1 != null) widget.move = move1;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: AppDrawer(widget.move),
        appBar: dashBoardAppBar(),
        body: Container(
          color: Colors.blue,
          child: widget.move == "/occupation" || widget.move == "/capabilities"
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  // padding: EdgeInsets.all(width * 0.1),
                  padding: EdgeInsets.only(
                    top: width * 0.05,
                    bottom: width * 0.05,
                    left: width * 0.05,
                    right: width * 0.05,
                  ),
                  child:
                      // (widget.move == "/occupation" ||
                      //         widget.move == "/capabilities")
                      // ?
                      nestedTabs()
                  // : Container(
                  //     child: Center(
                  //       child: Text('E-Commerce'),
                  //     ),
                  //   ),
                  )
              : SuggestedIdeasDashboard(),
        ),
      ),
    );
    // widget.move == "/product_provider" || widget.move == "/domain"
    //   SuggestedIdeas();
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

  AppBar dashBoardAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.blue,
      centerTitle: true,
      elevation: 0.0,
      title: Text(
        'Dashboard',
        textScaleFactor: 1,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        notificationButton(),
      ],
    );
  }

  Widget notificationButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/inAppNotification")
            .then((value) => getNotifications());
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Icon(
              Icons.notifications_active_rounded,
              size: 32,
            ),
            if (notifiationCount != 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepOrange,
                  ),
                  child: Center(
                    child: Text(
                      notifiationCount.toString(),
                      textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget nestedTabs() {
    if (widget.move == "/occupation")
      return DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
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
                          isEnglish ? "Home" : "होम",
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: _tabController.index == 0
                                  ? Colors.blue
                                  : Colors.grey),
                        ),
                        Text(
                          isEnglish ? "Meetings" : "बैठक सूची",
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: _tabController.index == 1
                                  ? Colors.blue
                                  : Colors.grey),
                        ),
                        Text(
                          isEnglish ? "Investors" : "इन्वेस्टर",
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
              home(),
              meetings(),
              bInvestors(),
            ],
          ),
        ),
      );
    else if (widget.move == "/capabilities")
      return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      isScrollable: true,
                      controller: _tabController1,
                      labelPadding: EdgeInsets.all(10.0),
                      indicatorColor: Colors.blue,
                      indicatorWeight: 3.0,
                      tabs: [
                        // if(widget.move="")
                        Text(
                          isEnglish ? "Home" : "होम",
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: _tabController1.index == 0
                                  ? Colors.blue
                                  : Colors.grey),
                        ),

                        Text(
                          isEnglish ? "Meetings" : "बैठक सूची",
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: _tabController1.index == 1
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
            controller: _tabController1,
            children: <Widget>[
              SuggestedIdeasInvestor(),
              // Container(
              //   child: Center(
              //     child: Text('E-Commerce'),
              //   ),
              // ),
              meetings(),
            ],
          ),
        ),
      );
  }

  Widget home() {
    //home tab
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.05),
          Container(
            height: height * 0.2,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16, right: 6),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/ideas");
                    },
                    child: Card(
                      elevation: 5,
                      child: GridTile(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, top: 12, right: 0, bottom: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(
                                  //   width: width * 0.17,
                                  //   height: height * 0.11,
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     child: Image.network(
                                  //       "http://164.52.192.76:8080/startit/$imageUrl",
                                  //       fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    width: width * 0.17,
                                    height: height * 0.11,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                          "assets/images/Design.png"),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                  ),

                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.24,
                                        child: Text(
                                          //title,
                                          isEnglish ? "My Ideas" : "मेरा विचार",
                                          textScaleFactor: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.008,
                                      ),
                                      // CircularPercentIndicator(
                                      //   radius: 55.0,
                                      //   lineWidth: 6.0,
                                      //   percent: ideaData.status != null
                                      //       ? ideaData.status * 0.01
                                      //       : 0,
                                      //   center: Text(ideaData.status != null
                                      //       ? ideaData.status
                                      //           .toString()
                                      //           .replaceAll(".0", "")
                                      //       : "0"),
                                      //   progressColor: Colors.red[400],
                                      //   backgroundColor: Colors.red[100],
                                      //   circularStrokeCap:
                                      //       CircularStrokeCap.round,
                                      //   animation: true,
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10),
                                        child: Text(
                                          ideaData.status != null
                                              ? ideaData.status
                                                  .toString()
                                                  .replaceAll(".0", "")
                                              : "0",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_up_rounded,
                                        color: Colors.green,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      // Text(
                                      //   ideaData.likesCount,
                                      //   // "20",
                                      //   style: TextStyle(
                                      //       color: Colors.grey, fontSize: 12.0),
                                      // ),
                                      Text(
                                        ideaData.likesCount != null
                                            ? ideaData.likesCount
                                            : "0",
                                        textScaleFactor: 1,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12.0),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: width * 0.2),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        color: Colors.grey[600],
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        // ideaData.visitsCount,
                                        ideaData.visitsCount != null
                                            ? ideaData.visitsCount
                                            : "0",
                                        textScaleFactor: 1,
                                        // "200",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12.0),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.03,
                // ),
                Container(
                  width: width * 0.65,
                  margin: EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/manage-investors");
                    },
                    child: Card(
                      elevation: 5,
                      child: GridTile(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12, top: 12, right: 0, bottom: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(
                                  //   width: width * 0.17,
                                  //   height: height * 0.11,
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     child: Image.network(
                                  //       "http://164.52.192.76:8080/startit/$imageUrl",
                                  //       fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // ),
                                  Container(
                                    width: width * 0.17,
                                    height: height * 0.13,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                          "assets/images/Investment.png"),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Colors.grey[300],
                                    ),
                                  ),

                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 0.38,
                                        // height: height *0.04,
                                        child: Text(
                                          isEnglish
                                              ? "Interested Investors"
                                              : "इच्छुक निवेशक",
                                          textScaleFactor: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              // fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.008,
                                      ),
                                      // CircularPercentIndicator(
                                      //   radius: 65.0,
                                      //   lineWidth: 6.0,
                                      //   percent: ideaData.insVisit != null
                                      //       ? ideaData.insVisit * 0.01
                                      //       : 0,
                                      //   center: Text(ideaData.insVisit != null
                                      //       ? ideaData.insVisit
                                      //           .toString()
                                      //           .replaceAll(".0", "")
                                      //       : "0"),
                                      //   progressColor: Colors.red[400],
                                      //   backgroundColor: Colors.red[100],
                                      //   circularStrokeCap:
                                      //       CircularStrokeCap.round,
                                      //   animation: true,
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10),
                                        child: Text(
                                          ideaData.insVisit != null
                                              ? ideaData.insVisit
                                                  .toString()
                                                  .replaceAll(".0", "")
                                              : "0",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 28,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.05),
          if (spData.length > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnglish
                      ? "Suggested Service Provider"
                      : "सुझाए गए सेवा प्रदाता",
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 18,
                    // decoration: TextDecoration.underline,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).size.height *
                          0.48, /////////////////////////////
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: MediaQuery.of(context).size.width,
                        childAspectRatio: 6.8 / 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 10),
                    itemBuilder: (_, i) => providerItem(
                        spData[i].providerId,
                        spData[i].providerName,
                        spData[i].providerEmail,
                        spData[i].providerMobile,
                        spData[i].createdDate,
                        spData[i].lastLoggedIn,
                        spData[i].imageUrl,
                        height,
                        width,
                        spData[i].receiverFireId,
                        spData[i].deviceToken,
                        true,
                        spData[i].useridsppp,
                        context),
                    itemCount: spData.length,
                  ),
                ),
                if (spData.length >= 3)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          "/manage-resource-provider",
                          arguments: widget.move);
                    },
                    child: Center(
                      child: Container(
                        width: width * 0.5,
                        height: height * 0.04,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "View More",
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          if (ppData.length > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    isEnglish
                        ? "Suggested Product Provider"
                        : "सुझाए गए उत्पाद प्रदाता",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8),
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).size.height *
                          0.48, /////////////////////////////
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: MediaQuery.of(context).size.width,
                        childAspectRatio: 6.8 / 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 10),
                    itemBuilder: (_, i) => providerItem(
                        ppData[i].providerId,
                        ppData[i].providerName,
                        ppData[i].providerEmail,
                        ppData[i].providerMobile,
                        ppData[i].createdDate,
                        ppData[i].lastLoggedIn,
                        ppData[i].imageUrl,
                        height,
                        width,
                        ppData[i].receiverFireId,
                        ppData[i].deviceToken,
                        false,
                        ppData[i].useridsppp,
                        context),
                    itemCount: ppData.length,
                  ),
                ),
                if (ppData.length >= 3)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          "/manage-resource-provider",
                          arguments: widget.move);
                    },
                    child: Center(
                      child: Container(
                        width: width * 0.5,
                        height: height * 0.04,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "View More",
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget meetings() {
    //meeting tab
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.03),
          if (meetingData.length == 0)
            Align(
              alignment: Alignment.topCenter,
              child: Center(
                child: Text(
                  'No data found',
                  textScaleFactor: 1,
                ),
              ),
            ), ////////
          if (meetingData.length >= 3)
            GestureDetector(
              onTap: () {
                widget.move == "/occupation"
                    ? Navigator.of(context)
                        .pushNamed("/manage-investors", arguments: widget.move)
                    : Navigator.of(context).pushNamed("/manage-idea-person",
                        arguments: widget.move);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Text(
                    "See all",
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Colors.blue),
                  ),
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).size.height *
                    0.23, /////////////////////////////
            child: GridView.builder(
              physics: new NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width,
                  childAspectRatio: 3 / 1.2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 20),
              itemBuilder: (_, i) => MeetingItem(
                meetingData[i].title,
                meetingData[i].date,
                meetingData[i].remarks,
                height,
                width,
                context,
                meetingData[i].time,
                meetingData[i].year,
              ),
              itemCount: meetingData.length,
            ),
          ),
        ],
      ),
    );
  }

  void getIdeas() async {
    Map mapData = {"bip_id": bipId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.BIP_DASHBOARD),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "SUGGESTED_SP");
      ideaData.status = double.parse(jsonData["TOTAL_IDEA_COUNT"].toString());
      print(ideaData.status);
      ideaData.likesCount = jsonData["TOTAL_LIKE"];
      ideaData.visitsCount = jsonData["TOTAL_VISITOR"];
      ideaData.insVisit = double.parse(jsonData["TOTAL_INSVESTOR"].toString());
      Map data1 = WebResponseExtractor.filterWebData(response,
          dataObject: "LATEST_MEETING");
      Map data2 = WebResponseExtractor.filterWebData(response,
          dataObject: "LATEST_INSVESTOR");
      Map data3 = WebResponseExtractor.filterWebData(response,
          dataObject: "SUGGESTED_PP");
      if (data["code"] == 1) {
        //sugg sp
        await getIdeasFromWeb(data["data"]);
      }
      if (data1["code"] == 1) {
        // meeting
        await getIdeasFromWeb1(data1["data"]);
      }

      if (data2["code"] == 1) {
        // sugg ins
        await getInvestorsFromWeb(data2["data"]);
      }
      if (data3["code"] == 1) {
        // sugg pp
        await getIdeasFromWeb2(data3["data"]);
      }
    }
    // setState(() {
    //  isSet=true;
    // });
  }
  // loadingIndicator() {
  //   return showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return Center(
  //           child: SizedBox(
  //             width: 20,
  //             height: 20,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               color: Colors.white,
  //             ),
  //           ),
  //         );
  //       });
  // }

  Future<Null> getIdeasFromWeb(var jsonData) async {
    spData.clear();
    setState(() {
      for (Map provider in jsonData) {
        spData.add(
          ProviderData(
              useridsppp:
                  provider["user_id"] != null ? provider["user_id"] : "",
              providerId:
                  provider["id"] != null ? provider["id"] : "", ///////////
              providerName:
                  "${provider["first_name"]} ${provider["last_name"]}",
              providerEmail: provider["email"] != null ? provider["email"] : "",
              providerMobile:
                  provider["mobile"] != null ? provider["mobile"] : "",
              createdDate: provider["createdAt"] != null
                  ? DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(provider["createdAt"]))
                  : "",
              lastLoggedIn: provider["last_loged_in"] != null
                  ? DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(provider["last_loged_in"]))
                  : "",
              imageUrl: provider["profile_image"] != null
                  ? provider["profile_image"]
                  : "",
              receiverFireId: provider["firebase_user_id"],
              deviceToken: provider["device_token"]),
        );
      }
    });
  }

  Future<Null> getIdeasFromWeb1(var jsonData) async {
    setState(() {
      for (Map meeting in jsonData) {
        meetingData.add(
          MeetingData(
            title: meeting["idea_title"] != null ? meeting["idea_title"] : "",
            remarks: meeting["remarks"] != null ? meeting["remarks"] : "",
            date: meeting["re_schedulemeetingDate"] != null
                ? DateFormat('dd MMM')
                    .format(DateTime.parse(meeting["re_schedulemeetingDate"]))
                : "",
            time: meeting["re_schedulemeetingTime"] != null
                ? meeting["re_schedulemeetingTime"]
                : "",
            year: meeting["re_schedulemeetingDate"] != null
                ? DateFormat('yyyy')
                    .format(DateTime.parse(meeting["re_schedulemeetingDate"]))
                : "",
          ),
        );
      }
    });
    print(meetingData.length);
    print("dhddddddddddddddddd");
  }

  Future<Null> getIdeasFromWeb2(var jsonData) async {
    ppData.clear();
    setState(() {
      for (Map provider in jsonData) {
        ppData.add(
          ProviderData(
              useridsppp:
                  provider["user_id"] != null ? provider["user_id"] : "",
              providerId: provider["id"] != null ? provider["id"] : "",
              providerName:
                  "${provider["first_name"]} ${provider["last_name"]}",
              providerEmail: provider["email"] != null ? provider["email"] : "",
              providerMobile:
                  provider["mobile"] != null ? provider["mobile"] : "",
              createdDate: provider["createdAt"] != null
                  ? DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(provider["createdAt"]))
                  : "",
              lastLoggedIn: provider["last_loged_in"] != null
                  ? DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(provider["last_loged_in"]))
                  : "",
              imageUrl: provider["profile_image"] != null
                  ? provider["profile_image"]
                  : "",
              receiverFireId: provider["firebase_user_id"],
              deviceToken: provider["device_token"]),
        );
      }
    });
    print(ppData.length);
  }

  void getIns() async {
    Map mapData = {"ins_id": insId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.INS_DASHBOARD_SUGGESTED_IDEAS),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map data1 = WebResponseExtractor.filterWebData(response,
          dataObject: "LATEST_MEETING");
      if (data1["code"] == 1) {
        // meeting
        await getIdeasFromWeb1(data1["data"]);
      }
    }
  }

  Widget bInvestors() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        // SizedBox(height: height * 0.03),       ////////////////////////
        if (investordata.length == 0)
          Align(
            alignment: Alignment.topCenter,
            child: Center(
              child: Text(
                'No data found',
                textScaleFactor: 1,
              ),
            ),
          ),
        Container(
          height: height - AppBar().preferredSize.height - height * 0.2,
          child: ListView.builder(
            controller: listController,
            padding: EdgeInsets.all(8),
            itemCount:
                investordata.length, /////////////////////////////////////
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
              height,
              width,
              i,
            ),
          ),
        ),
        // Center(
        //   child: Container(
        //     height: height * 0.04,
        //     width: width * 0.4,
        //     margin: EdgeInsets.only(top: 5),
        //     child: ElevatedButton(
        //       onPressed: () {},
        //       child: Text(
        //         'View More',
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
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
    notifiationCount = 0;
    setState(() {
      for (Map notification in jsonData) {
        if (notification["SeenOrNot"] == "N") {
          notifiationCount++;
        }
      }
    });
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
    double height,
    double width,
    int i,
  ) {
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

    return Column(
      children: [
        Card(
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  print("Tap");
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => MIViewProfile(
                                          int.parse(insUserId),
                                          email,
                                          phone,
                                          createduser,
                                          ideaId),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: width * 0.22,
                                  height: height * 0.022,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.green[300]),
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
                                          builder: (context) =>
                                              ChatScreen(data)),
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
                    //           style:
                    //               TextStyle(color: Colors.grey, fontSize: 10),
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
                    //           style:
                    //               TextStyle(color: Colors.grey, fontSize: 10),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: height * 0.01),
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
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                        showIdeaCaseStudyGlobal =
                                            showIdeaCaseStudy;
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
                                          color: Colors.amber[700],
                                          border: Border.all(
                                              color: Colors.amber[700]),
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                              showMediaDocsGlobal =
                                                  showMediaDocs;
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
                                              : Colors.amber[700],
                                          border: Border.all(
                                              color: noIdeaSelected
                                                  ? Colors.grey
                                                  : Colors.amber[700]),
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
                                          border:
                                              Border.all(color: Colors.green),
                                          borderRadius:
                                              BorderRadius.circular(5)),
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
        ),
        if (i >= 4) //////////////////////////////
          Center(
            child: Container(
              height: height * 0.05,
              width: width * 0.6,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/manage-investors", arguments: widget.move);
                },
                child: Text(
                  'View More',
                  textScaleFactor: 1,
                ),
              ),
            ),
          ),
      ],
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

  // void getInvestors() async {
  //   Map mapData = {"bip_id": bipId};
  //   print(mapData);

  //   final response = await http.post(
  //     Uri.parse(WebApis.MANAGE_INVESTORS),
  //     body: json.encode(mapData),
  //     headers: {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json'
  //     },
  //   );
  //   print(response.statusCode);
  //   print(response.body);

  //   if (response.statusCode == 200) {
  //     Map data = WebResponseExtractor.filterWebData(response,
  //         dataObject: "MANAGE_INSVESTOR");
  //     if (data["code"] == 1) {
  //       print(data["data"]);
  //       getInvestorsFromWeb(data["data"]);
  //     }
  //   }
  // }

  Future<Null> getInvestorsFromWeb(var jsonData) async {
    investordata.clear();
    setState(() {
      for (Map investor in jsonData) {
        investordata.add(
          InvestorData(
              title:
                  investor["idea_title"] != null ? investor["idea_title"] : "",
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
      print(investordata.length);
      print("dhddoooooooooooooooooo");
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
    // getInvestors();
    getIdeas();
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
    // getInvestors();
    getIdeas();
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

    // getInvestors();
    getIdeas();
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
    // getInvestors();
    getIdeas();
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
    // getInvestors();
    getIdeas();
  }
}

Widget providerItem(
  String providerId,
  String providerName,
  String providerEmail,
  String providerMobile,
  String createdDate,
  String lastLoggedIn,
  String imageUrl,
  double height,
  double width,
  String receiverFirebaseId,
  String deviceToken,
  bool isService,
  String userIdPPSP,
  BuildContext context,
) {
  String useStatus = "Active";
  Color statusColor = Colors.green[300];
  if (lastLoggedIn == "") {
    lastLoggedIn = createdDate;
    useStatus = "Inactive";
    statusColor = Colors.red[300];
  }

  return GestureDetector(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ViewServiceList(
                int.parse(userIdPPSP),
                providerEmail,
                providerMobile,
                providerMobile,
                isService,
                providerName)),
      );
    },
    child: Card(
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      elevation: 5,
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
              backgroundColor:
                  imageUrl == "" ? Colors.grey[400] : Colors.transparent,
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
                              providerName,
                              textScaleFactor: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text(
                          //   createduser,
                          //   style: TextStyle(color: Colors.grey, fontSize: 10),
                          // ),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            child: Container(
                              width: width * 0.22,
                              height: height * 0.022,
                              decoration: BoxDecoration(
                                  border: Border.all(color: statusColor),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                child: Text(
                                  useStatus,
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          if (receiverFirebaseId != null &&
                              receiverFirebaseId != "")
                            InkWell(
                              onTap: () {
                                print(deviceToken);
                                var data = {
                                  "name": providerName,
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
                //           textScaleFactor: 1,
                //           style: TextStyle(
                //             fontSize: 10,
                //             letterSpacing: 1.0,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //         SizedBox(height: 5),
                //         Text(
                //           providerMobile,
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
                //           providerEmail,
                //           textScaleFactor: 1,
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
                //           "Last Seen on",
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
                //               color: Colors.green[200],
                //               border: Border.all(color: Colors.green),
                //               borderRadius: BorderRadius.circular(5)),
                //           child: Center(
                //             child: Text(
                //               lastLoggedIn,
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
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget MeetingItem(
  String title,
  String date,
  String remarks,
  double height,
  double width,
  BuildContext context,
  String time,
  String year,
) {
  return Card(
    elevation: 8,
    child: GridTile(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 12, top: 15, right: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width * 0.25,
              height: height * 0.15,
              margin: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
                  SizedBox(height: height * 0.025),
                  Text(
                    // "Sep 21",
                    // DateFormat('dd MMM')
                    //   .format(DateTime.parse(date)).toString(),
                    date,
                    textScaleFactor: 1,
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    // "2021",
                    year,
                    textScaleFactor: 1,

                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    // "9:00 - 13:00",
                    time, textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      title,
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      remarks,
                      textScaleFactor: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.004,
                  ),
                  // Container(
                  //   height: height * 0.045,
                  //   width: width * 0.3,
                  //   child: OutlinedButton(
                  //     onPressed: null,
                  //     style: ButtonStyle(
                  //       shape: MaterialStateProperty.all(
                  //         RoundedRectangleBorder(
                  //           side: BorderSide(color: Colors.blue),
                  //           borderRadius: BorderRadius.circular(30.0),
                  //         ),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       "View",
                  //       style: TextStyle(color: Colors.blue),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class IdeaData {
  // Home
  double insVisit;
  String imageUrl;
  double status;
  String likesCount;
  String visitsCount;
  IdeaData({
    this.insVisit,
    this.imageUrl,
    this.status,
    this.likesCount,
    this.visitsCount,
  });
}

class ProviderData {
  // Home - Suggested SP PP
  String providerId;
  String providerName;
  String providerEmail;
  String providerMobile;
  String createdDate;
  String lastLoggedIn;
  String imageUrl;
  String receiverFireId;
  String deviceToken;
  String useridsppp;
  ProviderData(
      {this.providerId,
      this.providerName,
      this.providerEmail,
      this.providerMobile,
      this.createdDate,
      this.lastLoggedIn,
      this.imageUrl,
      this.receiverFireId,
      this.deviceToken,
      this.useridsppp});
}

class MeetingData {
  // Meetings
  String title;
  String date;
  String remarks;
  String time;
  String year;
  MeetingData({
    this.title,
    this.date,
    this.remarks,
    this.time,
    this.year,
  });
}

class InvestorData {
  //Investors
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

  InvestorData({
    this.title,
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
  });
}
