import 'package:flutter/material.dart';
import 'package:startit/src/screens/view_single_service.dart';
import 'package:video_player/video_player.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;

class ViewServiceList extends StatefulWidget {
  final int userId;
  final String email;
  final String phNumber;
  final String insName;
  final bool isService;
  final String providerName;

  ViewServiceList(this.userId, this.email, this.phNumber, this.insName,
      this.isService, this.providerName);
  @override
  _ViewServiceListState createState() => _ViewServiceListState();
}

class _ViewServiceListState extends State<ViewServiceList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Color color;
  String image = "";
  String dob = "";
  String location = "";

  List<ServiceData> serviceData = [];
  List<IdeaData> ideaData = [];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    getProfileData();
    // getInterestsData();
    // getCapabilitiesData();
  }

  void _handleTabSelection() {
    setState(() {
      color = Colors.blue;
    });
  }

  @override
  void dispose() {
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
          'Profile',
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
          padding: EdgeInsets.fromLTRB(
              width * 0.1, width * 0.1, width * 0.1, width * 0.08),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                  height: height * 0.85,
                  child: nestedTabs(height),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nestedTabs(double height) {
    return DefaultTabController(
      length: 2,
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
                        "About",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      Text(
                        widget.isService ? "Services" : "Products",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 1
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
            about(),
            interestIdea(),
            //edit(),
          ],
        ),
      ),
    );
  }

  Widget about() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PHONE",
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
                  GestureDetector(
                    onTap: _launchCaller,
                    child: Text(
                      "(+91) ${widget.phNumber}",
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "EMAIL",
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.047,
                    child: Text(
                      widget.email,
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DATE  OF  BIRTH",
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
                    dob,
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "LOCATION",
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.047,
                    child: Text(
                      location,
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                ],
              )
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

  Widget interestIdea() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return widget.isService
        ? Container(
            height: height,
            child: GridView.builder(
              itemBuilder: (_, i) => ServiceItem(
                serviceData[i].title,
                serviceData[i].date,
                serviceData[i].imageUrl,
                height,
                width,
                context,
                serviceData[i].newServiceId,
              ),
              itemCount: serviceData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 2,
              ),
            ),
          )
        : Container(
            height: height,
            child: GridView.builder(
              // padding: EdgeInsets.all(8),
              itemBuilder: (_, i) => IdeaItem(
                ideaData[i].title,
                // ideaData[i].category,
                ideaData[i].date,
                ideaData[i].imageUrl,
                height,
                width,
                context,
                ideaData[i].ideaId,
              ),
              itemCount: ideaData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 2,
              ),
            ),
          );
  }

  Widget IdeaItem(
    String title,
    // String category,
    String date,
    String imageUrl,
    double height,
    double width,
    BuildContext context,
    int ideaId,
  ) {
    return Padding(
      padding: EdgeInsets.all(width * 0.025),
      child: Card(
        elevation: 5,
        child: GridTile(
          child: Container(
            padding: EdgeInsets.all(width * 0.016),
            margin: EdgeInsets.only(left: width * 0.045, right: width * 0.045),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: height * 0.001,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.12,
                      height: height * 0.08,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: imageUrl != ""
                            ? Image.network(
                                "http://164.52.192.76:8080/startit/$imageUrl",
                                fit: BoxFit.cover,
                              )
                            : SizedBox(
                                child: Icon(Icons.image),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Skills:  ",
                              textScaleFactor: 1,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: width * 0.22,
                              height: height * 0.026,
                              decoration: BoxDecoration(
                                  color: Colors.amber[600],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  (title != null && title != "")
                                      ? title
                                      : "No skills",
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // SizedBox(
                        //   width: width * 0.6,
                        //   child: Text(
                        //     category,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          width: width * 0.22,
                          height: height * 0.026,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              date,
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: height * 0.04,
                  child: ElevatedButton(
                    onPressed: () {
                      // productId = ideaId;
                      // loadedProduct = true;
                      print(ideaId.toString() + "assa");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewSingleService(
                            widget.isService,
                            ideaId,
                            widget.userId,
                            widget.email,
                            widget.phNumber,
                            widget.insName,
                            widget.providerName,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'View Product',
                      textScaleFactor: 1,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ServiceItem(
    String title,
    String date,
    String imageUrl,
    double height,
    double width,
    BuildContext context,
    int newServiceId,
  ) {
    return Card(
      elevation: 5,
      child: GridTile(
        child: Container(
          padding: EdgeInsets.all(width * 0.016),
          margin: EdgeInsets.only(left: width * 0.045, right: width * 0.045),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: height * 0.001,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.12,
                    height: height * 0.08,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "http://164.52.192.76:8080/startit/$imageUrl",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          "Skills: ",
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: width * 0.22,
                        height: height * 0.026,
                        decoration: BoxDecoration(
                            color: Colors.amber[600],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            (title != null && title != "")
                                ? title
                                : "No skills",
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width * 0.22,
                        height: height * 0.026,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            date,
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width * 0.00,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                height: height * 0.04,
                child: ElevatedButton(
                  onPressed: () {
                    // serviceId = newServiceId;
                    // loadService = true;
                    // print(newServiceId.toString() + "assa");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewSingleService(
                          widget.isService,
                          newServiceId,
                          widget.userId,
                          widget.email,
                          widget.phNumber,
                          widget.insName,
                          widget.providerName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'View Service',
                    textScaleFactor: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
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
    widget.isService ? getServices() : getIdeas();
  }

  void getServices() async {
    Map mapData = {"user_id": widget.userId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_MYSERVICES),
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
          dataObject: "SERVICE_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getServicesFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getServicesFromWeb(var jsonData) async {
    setState(() {
      for (Map service in jsonData) {
        serviceData.add(
          ServiceData(
            title: service["skills"] != null ? service["skills"] : "",
            date: service["createdAt"] != null
                ? DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(service["createdAt"]))
                : "",
            imageUrl: service["service_media"] != null
                ? service["service_media"]
                : "",
            newServiceId: int.parse(service["id"]),
          ),
        );
      }
    });
  }

  void getIdeas() async {
    Map mapData = {"user_id": widget.userId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.MY_PRODUCT),
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
          dataObject: "PRODUCT_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getIdeasFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getIdeasFromWeb(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        ideaData.add(
          IdeaData(
            title: idea["skills"] != null ? idea["skills"] : "",
            category: idea["sub_category"] != null ? idea["sub_category"] : "",
            // web: idea["service_media"] != null ? idea["service_media"] : "",
            date: idea["createdAt"] != null
                ? DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(idea["createdAt"]))
                : "",
            imageUrl:
                idea["service_media"] != null ? idea["service_media"] : "",
            description: idea["product_service_details"] != null
                ? idea["product_service_details"]
                : "",
            status: idea["active"] != null ? idea["active"] : "",
            ideaId: int.parse(idea["id"]),
          ),
        );
      }
    });
  }
}

class IdeaData {
  String title;
  String category;
  String date;
  String imageUrl;
  String description;
  String status;
  int ideaId;
  IdeaData(
      {this.title,
      this.category,
      this.date,
      this.imageUrl,
      this.description,
      this.status,
      this.ideaId});
}

// showDialogFunc(context, List<String> img) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return Center(
//         child: Material(
//           type: MaterialType.transparency,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.white,
//             ),
//             padding: EdgeInsets.all(5),
//             height: MediaQuery.of(context).size.height * 0.65,
//             width: MediaQuery.of(context).size.width,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: img.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16.0),
//                           child: Image.network(
//                             "http://164.52.192.76:8080/startit/" + img[index],
//                             fit: BoxFit.fill,
//                             height: MediaQuery.of(context).size.height * 0.65,
//                             width: MediaQuery.of(context).size.width * 0.7,
//                           ),
//                         ),
//                       ),
//                       // SizedBox(
//                       //   height: MediaQuery.of(context).size.width * 0.5,
//                       //   child: Divider(
//                       //     thickness: 5,
//                       //     color: Colors.black,
//                       //   ),
//                       // )
//                     ],
//                   );
//                 }),
//           ),
//         ),
//       );
//     },
//   );
// }

// showDialogFuncDocument(context, List<String> img) {
//   return showDialog(
//     context: context,
//     builder: (context) {
//       return Center(
//         child: Material(
//           type: MaterialType.transparency,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.white,
//             ),
//             padding: EdgeInsets.all(5),
//             height: MediaQuery.of(context).size.height * 0.1,
//             width: MediaQuery.of(context).size.width,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: img.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: GestureDetector(
//                             onTap: () async {
//                               await launch(img[index]);
//                             },
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(16.0),
//                               child: Icon(
//                                 Icons.insert_drive_file,
//                                 size: 50,
//                               ),
//                             )),
//                       ),
//                       // SizedBox(
//                       //   height: MediaQuery.of(context).size.width * 0.5,
//                       //   child: Divider(
//                       //     thickness: 5,
//                       //     color: Colors.black,
//                       //   ),
//                       // )
//                     ],
//                   );
//                 }),
//           ),
//         ),
//       );
//     },
//   );
// }

// showDialogFuncVideo(context, List<VideoPlayerController> vc) {
//   bool istrue = false;
//   return showDialog(
//     barrierDismissible: true,
//     context: context,
//     builder: (context) {
//       return Center(
//         child: Material(
//           type: MaterialType.transparency,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.white,
//             ),
//             padding: EdgeInsets.all(5),
//             height: MediaQuery.of(context).size.height * 0.65,
//             width: MediaQuery.of(context).size.width,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: vc.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: InkWell(
//                           onTap: () {
//                             istrue ? vc[index].play() : vc[index].pause();
//                             istrue = !istrue;
//                           },
//                           child: Container(
//                             height: MediaQuery.of(context).size.height * 0.65,
//                             width: vc.length == 1
//                                 ? MediaQuery.of(context).size.width * 0.95
//                                 : MediaQuery.of(context).size.width * 0.8,
//                             child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(16.0),
//                                 child: vc[index].value.initialized
//                                     ? AspectRatio(
//                                         aspectRatio:
//                                             vc[index].value.aspectRatio,
//                                         child: VideoPlayer(vc[index]),
//                                       )
//                                     : Container()),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }),
//           ),
//         ),
//       );
//     },
//   );
// }

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

class ServiceData {
  String title;
  String category;

  String date;
  String imageUrl;
  String description;
  String status;
  int newServiceId;
  ServiceData(
      {this.title,
      this.category,
      this.date,
      this.imageUrl,
      this.description,
      this.status,
      this.newServiceId});
}
