import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../screens/idea_title.dart';
import 'package:intl/intl.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';

class AllIdeas extends StatefulWidget {
  @override
  _AllIdeasState createState() => _AllIdeasState();
}

class _AllIdeasState extends State<AllIdeas>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var color;

  @override
  void initState() {
    getAllIdeas();
    super.initState();
    // _tabController = new TabController(vsync: this, length: 4);
    // _tabController.addListener(_handleTabSelection);
  }

  // void _handleTabSelection() {
  //   setState(() {
  //     color = Colors.blue;
  //   });
  // }

  List<IdeaData> backupIdeaData = [];
  List<IdeaData> ideaData = [];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    String move = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: AppDrawer(move),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "All Ideas",
          textScaleFactor: 1,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[100],
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: height * 0.03,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: height * 0.1,
                    width: width * 0.85,
                    child: TextFormField(
                      onChanged: (text) {
                        text = text.toLowerCase();
                        setState(() {
                          ideaData = backupIdeaData.where((idea) {
                            String ideaTitle = idea.title.toLowerCase();
                            String ideaDescription =
                                idea.description.toLowerCase();
                            String ideaContent = "$ideaTitle $ideaDescription";
                            return ideaContent.contains(text);
                          }).toList();
                        });
                      },
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.black87),
                        hintText: 'Search for Ideas',
                        hintStyle: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: height * 0.75,
                child: BIP(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget nestedTabs() {
  //   return DefaultTabController(
  //     length: 4,
  //     child: new Scaffold(
  //       appBar: new PreferredSize(
  //         preferredSize: Size.fromHeight(kToolbarHeight),
  //         child: new Container(
  //           color: Colors.grey[100],
  //           padding: EdgeInsets.only(left: 30),
  //           child: new SafeArea(
  //             child: Column(
  //               children: <Widget>[
  //                 new Expanded(child: new Container()),
  //                 new TabBar(
  //                   isScrollable: true,
  //                   controller: _tabController,
  //                   labelPadding: EdgeInsets.all(10.0),
  //                   indicatorColor: Colors.blue,
  //                   indicatorWeight: 3.0,
  //                   tabs: [
  //                     Text(
  //                       "Business Interested Person",
  //                       style: TextStyle(
  //                           color: _tabController.index == 0
  //                               ? Colors.blue
  //                               : Colors.grey),
  //                     ),
  //                     Text("Investor",
  //                         style: TextStyle(
  //                             color: _tabController.index == 1
  //                                 ? Colors.blue
  //                                 : Colors.grey)),
  //                     Text("Product-Provider",
  //                         style: TextStyle(
  //                             color: _tabController.index == 2
  //                                 ? Colors.blue
  //                                 : Colors.grey)),
  //                     Text("Service-Provider",
  //                         style: TextStyle(
  //                             color: _tabController.index == 3
  //                                 ? Colors.blue
  //                                 : Colors.grey)),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       body: new TabBarView(
  //         controller: _tabController,
  //         children: <Widget>[
  //           BIP(),
  //           Container(
  //             // height: 200.0,
  //             child: Center(child: Text('Investor')),
  //           ),
  //           Container(
  //             // height: 200.0,
  //             child: Center(child: Text('Product-Provider')),
  //           ),
  //           Container(
  //             //height: 200.0,
  //             child: Center(child: Text('Service-Provider')),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget BIP() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[100],
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).size.height * 0.2,
        child: ListView.builder(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          itemCount: ideaData.length,
          itemBuilder: (_, i) => IdeaItem(
              ideaData[i].title,
              ideaData[i].cat,
              ideaData[i].date,
              ideaData[i].description,
              MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width,
              context,
              ideaData[i].ideaId,
              ideaData[i].likesCount),
        ),
      ),
    );
  }

  Widget IdeaItem(
      String title,
      String cat,
      String date,
      String description,
      double height,
      double width,
      BuildContext ctx,
      int ideaId,
      String likesCount) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.02),
      child: Card(
        elevation: 0,
        child: Container(
          width: width * 0.8,
          height: height * 0.2,
          margin: EdgeInsets.only(left: width * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      height: 24,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(5))),
                      child: Center(
                        child: Text(
                          cat,
                          textScaleFactor: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 8,
                          ),
                        ),
                      )),
                ],
              ),
              Text(
                title,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(right: 5),
                child: Text(
                  description,
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          addVisit(ctx, ideaId);
                        },
                        child: Text(
                          "Read more",
                          textScaleFactor: 1,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500),
                        )),
                    Text(
                      "Posted on $date",
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up_alt_rounded,
                          color: Colors.blue,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          likesCount + " Likes",
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.025)
            ],
          ),
        ),
      ),
    );
  }

  void getAllIdeas() async {
    Map mapData = {"user_id": userIdMain};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.ALL_IDEA),
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
          WebResponseExtractor.filterWebData(response, dataObject: "IDEA_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getAllIdeasFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getAllIdeasFromWeb(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        ideaData.add(
          IdeaData(
            title: idea["idea_title"] != null ? idea["idea_title"] : "",
            cat: idea["category_name"] != null ? idea["category_name"] : "",
            date: idea["createdAt"] != null
                ? DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(idea["createdAt"]))
                : "",
            description:
                idea["idea_summary"] != null ? idea["idea_summary"] : "",
            ideaId: int.parse(idea["id"]),
            likesCount:
                idea["likecount"] != null ? idea["likecount"].toString() : "",
          ),
        );
      }
    });
    backupIdeaData = ideaData;
  }

  void addVisit(BuildContext ctx, int ideaId) async {
    Map data = {
      "user_id": userIdMain,
      "idea_id": ideaId,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.IDEA_VISITS),
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
        Navigator.of(ctx)
            .push(MaterialPageRoute(builder: (ctx) => IdeaTitle(ideaId)));
      }
    }
  }
}

class IdeaData {
  String title;
  String cat;
  String date;
  String description;
  int ideaId;
  String likesCount;
  IdeaData({
    this.title,
    this.cat,
    this.date,
    this.description,
    this.ideaId,
    this.likesCount,
  });
}
