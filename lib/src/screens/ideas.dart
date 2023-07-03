import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';
import 'package:startit/src/screens/likes_screen.dart';
import 'package:startit/src/screens/success_path.dart';
import 'package:startit/src/screens/visitors_screen.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';

class Ideas extends StatefulWidget {
  @override
  _IdeasState createState() => _IdeasState();
}

class _IdeasState extends State<Ideas> {
  List<String> imageList = [
    "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
    "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
    "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
  ];

  List<IdeaData> ideaData = [
    // IdeaData(
    //     "Idea One",
    //     "Ideaone.com",
    //     "12.07.2000",
    //     "assets/images/ideaone.jpg",
    //     "Ideas can also be mental representational images of some object. Many philosophers have considered ideas to be a fundamental ontological.",
    //     "In Progress"),
  ];

  @override
  void initState() {
    getIdeas();
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
          "Ideas",
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
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )),
          padding: EdgeInsets.only(top: width * 0.05),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04),
                width: width * 0.32,
                height: height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    isRemember = true;
                    isRemember1 = true;
                    isRemember2 = true;
                    isRemember3 = true;
                    isRemember4 = true;
                    isRemember5 = true;
                    isRemember6 = true;
                    isRemember7 = true;
                    isRemember8 = true;
                    isRememberMe = false;
                    isRememberMe1 = false;
                    isRememberMe2 = false;
                    isRememberMe3 = false;
                    isRememberMe4 = false;
                    isRememberMe5 = false;
                    isRememberMe6 = false;
                    isRememberMe7 = false;
                    isRememberMe8 = false;
                    bipIdeaId = 0;
                    loadedBip = false;
                    Navigator.of(context).pushNamed("/add_modify");
                  },
                  child: Text(
                    'Add Idea +',
                    textScaleFactor: 1,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                height: height - AppBar().preferredSize.height - height * 0.2,
                child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemBuilder: (_, i) => IdeaItem(
                    ideaData[i].title,
                    ideaData[i].category,
                    ideaData[i].web,
                    ideaData[i].date,
                    ideaData[i].imageUrl,
                    ideaData[i].description,
                    ideaData[i].status,
                    height,
                    width,
                    imageList,
                    context,
                    ideaData[i].ideaId,
                    ideaData[i].likesCount,
                    ideaData[i].visitsCount,
                  ),
                  itemCount: ideaData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 2,
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.05,
              // )
            ],
          ),
        ),
      ),
    );
  }

  void getIdeas() async {
    Map mapData = {"user_id": userIdMain};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.IDEA_LIST),
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
        //print(data["data"]);
        getIdeasFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getIdeasFromWeb(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        ideaData.add(
          IdeaData(
            title: idea["idea_title"] != null ? idea["idea_title"] : "",
            category:
                idea["category_name"] != null ? idea["category_name"] : "",
            web: idea["idea_image"] != null ? idea["idea_image"] : "",
            date: idea["success_story"] != null
                ? DateFormat('dd.MMM.yyyy')
                    .format(DateTime.parse(idea["success_story"]))
                : "",
            imageUrl: idea["idea_image"] != null ? idea["idea_image"] : "",
            description:
                idea["idea_summary"] != null ? idea["idea_summary"] : "",
            // status: idea["active"] != null ? idea["active"] : "",
            status: idea["complete_per"] != null ? idea["complete_per"] : "",
            ideaId: int.parse(idea["id"]),
            likesCount:
                idea["likecount"] != null ? idea["likecount"].toString() : "",
            visitsCount:
                idea["viewcount"] != null ? idea["viewcount"].toString() : "",
          ),
        );
      }
    });
  }
}

Widget IdeaItem(
  String title,
  String category,
  String web,
  String date,
  String imageUrl,
  String description,
  String status,
  double height,
  double width,
  List<String> imagesList,
  BuildContext context,
  int ideaId,
  String likesCount,
  String visitsCount,
) {
  String statusDescription = "";

  // if (status == "0") {
  //   statusDescription = "In Progress";
  // }

  return Padding(
    padding: EdgeInsets.all(width * 0.025),
    child: Card(
      elevation: 5,
      child: GridTile(
        child: Container(
          padding: EdgeInsets.all(width * 0.025),
          margin: EdgeInsets.only(left: width * 0.045, right: width * 0.045),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: height * 0.001,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    width: width * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          title,
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: width * 0.3,
                        child: Text(
                          category,
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                  // SizedBox(
                  //   width: width * 0.00,
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          // width: width * 0.2,
                          // height: height * 0.026,
                          width: width * 0.18,
                          height: height * 0.08,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[100],
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              // statusDescription,
                              "Idea Completion " + " ($status%)",
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          )),
                      SizedBox(
                        height: height * 0.06,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    description,
                    textScaleFactor: 1,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey, height: 1.5),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Container(
                      //   margin: EdgeInsets.only(left: width * 0.13),
                      //   child: ImageStack(
                      //     imageList: imagesList,
                      //     imageRadius: 35,
                      //     imageCount: 3,
                      //     imageBorderWidth: 3,
                      //     totalCount: imagesList.length,
                      //   ),
                      // ),
                      // SizedBox(width: width * 0.1),
                      GestureDetector(
                        onTap: visitsCount == "0"
                            ? () {
                                WebResponseExtractor.showToast(
                                    "Visitors are on their way :)");
                              }
                            : () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        VisitorsScreen(ideaId)));
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.travel_explore_rounded,
                              color: Colors.blue,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              visitsCount + " Visits",
                              textScaleFactor: 1,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: likesCount == "0"
                            ? () {
                                WebResponseExtractor.showToast(
                                    "No Likes yet :(");
                              }
                            : () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LikesScreen(ideaId)));
                              },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (likesCount != '0')
                              Icon(
                                Icons.thumb_up_alt_rounded,
                                color: Colors.blue,
                                size: 16,
                              ),
                            SizedBox(width: 4),
                            if (likesCount != '0')
                              Text(
                                likesCount + " Likes",
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12.0),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              GestureDetector(
                onTap: () {
                  print(ideaId);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SucessPath(ideaId, title)));
                },
                child: Align(
                  // alignment: Alignment.centerRight,
                  child: Text(
                    "Success Path",
                    textScaleFactor: 1,
                    style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                        color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                height: height * 0.04,
                child: ElevatedButton(
                  onPressed: () {
                    isRemember = true;
                    isRemember1 = true;
                    isRemember2 = true;
                    isRemember3 = true;
                    isRemember4 = true;
                    isRemember5 = true;
                    isRemember6 = true;
                    isRemember7 = true;
                    isRemember8 = true;
                    isRememberMe = false;
                    isRememberMe1 = false;
                    isRememberMe2 = false;
                    isRememberMe3 = false;
                    isRememberMe4 = false;
                    isRememberMe5 = false;
                    isRememberMe6 = false;
                    isRememberMe7 = false;
                    isRememberMe8 = false;
                    bipIdeaId = ideaId;
                    loadedBip = true;
                    Navigator.of(context).pushNamed("/add_modify");
                  },
                  child: Text(
                    'Edit Idea',
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

class IdeaData {
  String title;
  String category;
  String web;
  String date;
  String imageUrl;
  String description;
  String status;
  int ideaId;
  String likesCount;
  String visitsCount;
  IdeaData({
    this.title,
    this.category,
    this.web,
    this.date,
    this.imageUrl,
    this.description,
    this.status,
    this.ideaId,
    this.likesCount,
    this.visitsCount,
  });
}
