import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:startit/main.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:startit/src/widgets/loadingIndicator.dart';
import '../../main.dart';
import '../screens/idea_title.dart';
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';

class SuggestedIdeasDashboard extends StatefulWidget {
  @override
  _SuggestedIdeasDashboardState createState() =>
      _SuggestedIdeasDashboardState();
}

class _SuggestedIdeasDashboardState extends State<SuggestedIdeasDashboard> {
  TextEditingController searchController = TextEditingController();
  List<SuggestedIdeaModel> backupSuggestedIdeaData = [];
  List<SuggestedIdeaModel> suggestedIdeaData = [];
  List<String> suggestionsList = [];
  String move = "";

  bool dataLoadedFirstTime = false;

  List<String> imageList = [
    // "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
    // "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
    // "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
  ];

  @override
  void initState() {
    getSuggestedIdeas("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      height: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      // padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: dataLoadedFirstTime
          ? SingleChildScrollView(
              child: Column(
              children: [
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (text) {
                      getSuggestions(text);
                    },
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
                      getSuggestedIdeas(text);
                    },
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.black87),
                      hintText: isEnglish ?'Search' : "खोज",
                      hintStyle: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w500),
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      // focusedBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(50),
                      //   borderSide: BorderSide(
                      //     color: Colors.blue,
                      //     width: 1.0,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: width * 0.85,
                      height: height * 0.8,
                      child: suggestedIdeaData.length == 0
                          ? Center(
                              child: Text(
                                "No Data found",
                                textScaleFactor: 1,
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: getSuggestedIdeas,
                              // backgroundColor: Colors.blue,
                              color: Colors.blue,
                              // displacement: 200,
                              // strokeWidth: 5,
                              child: GridView.builder(
                                  padding: EdgeInsets.only(top: width * 0.06),
                                  itemCount: suggestedIdeaData.length,
                                  itemBuilder: (_, i) => box(
                                        context,
                                        suggestedIdeaData[i].title,
                                        suggestedIdeaData[i].name,
                                        suggestedIdeaData[i].address,
                                        suggestedIdeaData[i].image,
                                        suggestedIdeaData[i].ideaId,
                                        suggestedIdeaData[i].summary,
                                        suggestedIdeaData[i].imagesList,
                                        suggestedIdeaData[i].likesCount,
                                        suggestedIdeaData[i].date,
                                        suggestedIdeaData[i].cat,
                                      ),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  )),
                            ),
                    ),
                    if (suggestionsList.length != 0 &&
                        searchController.text.length != 0)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.builder(
                          itemCount: suggestionsList.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              title: Text(
                                suggestionsList[index],
                                textScaleFactor: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: suggestionsList[index] == "No Data Found"
                                  ? null
                                  : () {
                                      setState(() {
                                        searchController.text =
                                            suggestionsList[index];
                                        FocusScope.of(context).unfocus();

                                        getSuggestedIdeas(
                                            searchController.text);
                                      });
                                    },
                            );
                          },
                        ),
                      ),
                  ],
                ),
                // SizedBox(height: height * 0.04),
                // Container(
                //   height: height * 0.05,
                //   width: width * 0.7,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           'Continue',
                //           style: TextStyle(color: Colors.white, fontSize: 15),
                //         ),
                //         Icon(Icons.chevron_right),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ))
          : Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            ),
    );
  }

  Widget box(
    BuildContext context,
    String title,
    String bipName,
    String address,
    String image,
    int ideaId,
    String summary,
    List<String> imagesList,
    String likesCount,
    String date,
    String cat,
  ) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(left: 2),
      // height: height * 0.32,
      // width: width * 0.33,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.4,
          color: Colors.black54,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  height: 13,
                  width: 70,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(10))),
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
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8),
                CircleAvatar(
                  backgroundImage:
                      NetworkImage("http://164.52.192.76:8080/startit/$image"),
                ),
                SizedBox(height: height * 0.012),
                SizedBox(
                  height: height * 0.02,
                  child: Text(
                    title,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: height * 0.006),
                Container(
                  width: width * 0.14,
                  height: height * 0.016,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      date,
                      textScaleFactor: 1,
                      // "Aug 2021",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 7, color: Colors.grey[600]),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.006),
                // SizedBox(
                //   height: height * 0.02,
                //   child: Text(
                //     "By $bipName",
                //     style: TextStyle(
                //       fontSize: 8,
                //       fontWeight: FontWeight.w400,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                SizedBox(
                  height: height * 0.025,
                  child: Text(
                    summary,
                    textScaleFactor: 1,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: height * 0.012),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: width * 0.1),
                      child: ImageStack(
                        imageList: imagesList,
                        imageRadius: 20,
                        imageCount: 3,
                        imageBorderWidth: 3,
                        totalCount: imagesList.length,
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    // GestureDetector(
                    //   onTap: visitsCount == "0"
                    //       ? () {
                    //           WebResponseExtractor.showToast(
                    //               "Visitors are on their way :)");
                    //         }
                    //       : () {
                    //           Navigator.of(context).push(MaterialPageRoute(
                    //               builder: (context) =>
                    //                   VisitorsScreen(ideaId)));
                    //         },
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Icon(
                    //         Icons.travel_explore_rounded,
                    //         color: Colors.blue,
                    //         size: 16,
                    //       ),
                    //       SizedBox(width: 4),
                    //       Text(
                    //         visitsCount + " Visits",
                    //         style:
                    //             TextStyle(color: Colors.grey, fontSize: 12.0),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up_alt_rounded,
                          color: Colors.blue,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          likesCount + " Likes",
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.grey, fontSize: 9.0),
                        ),
                      ],
                    )
                  ],
                ),

                // SizedBox(
                //   height: height * 0.04,
                //   child: Text(
                //     address,
                //     style: TextStyle(
                //       fontSize: 10,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                SizedBox(height: height * 0.01),
                Container(
                  // width: width * 0.23,
                  // height: height * 0.02,
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      addVisit(context, ideaId);
                    },
                    child: Text(
                      move == "/capabilities"
                          ? isEnglish
                              ? 'Connect'
                              : "जुडिये"
                          : 'View Idea',
                      textScaleFactor: 1,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> getSuggestedIdeas([String searchString = ""]) async {
    suggestionsList.clear();
    if (dataLoadedFirstTime == true) {
      LoadingIndicator.loadingIndicator(context);
    }
    Map mapData = {
      "user_id": userIdMain,
      "search_query": searchString,
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_SUGGESTED_IDEAS),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (dataLoadedFirstTime == true) Navigator.of(context).pop();
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "SUGGESTED_IDEA_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getSuggestedIdeasFromWeb(data["data"]);
        dataLoadedFirstTime = true;
      }
    }
  }

  Future<Null> getSuggestedIdeasFromWeb(var jsonData) async {
    backupSuggestedIdeaData.clear();
    suggestedIdeaData.clear();
    for (Map idea in jsonData) {
      suggestedIdeaData.add(
        SuggestedIdeaModel(
          title: idea["idea_title"] != null ? idea["idea_title"] : "",
          name:
              idea["idea_person_name"] != null ? idea["idea_person_name"] : "",
          address: "${idea["city"]}, ${idea["state"]}",
          image: idea["picture_path"] != "" ? idea["picture_path"] : "",
          ideaId: int.parse(idea["id"]),
          summary: idea["idea_summary"] != null ? idea["idea_summary"] : "",
          likesCount:
              idea["likecount"] != null ? idea["likecount"].toString() : "",
          date: idea["createdAt"] != null
              ? DateFormat('MMM yyyy').format(DateTime.parse(idea["createdAt"]))
              : "",
          cat: idea["category_name"] != null ? idea["category_name"] : "",
          imagesList: await getSuggestedIdeasVisitorsFromWeb(
              idea["visitor_list"] != null ? idea["visitor_list"] : ""),
        ),
      );
    }
    setState(() {});
    backupSuggestedIdeaData = suggestedIdeaData;
  }

  Future<List<String>> getSuggestedIdeasVisitorsFromWeb(var jsonData) async {
    List<String> img = [];
    // backupSuggestedIdeaData.clear();
    // suggestedIdeaData.clear();
    setState(() {
      for (Map Ideaa in jsonData) {
        if (Ideaa['profile_image'] != null || Ideaa['profile_image'] != "")
          img.add(
              "http://164.52.192.76:8080/startit/" + Ideaa['profile_image']);
        else
          img.add(
              "https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png");
      }
    });
    return img;
    // backupSuggestedIdeaData = suggestedIdeaData;
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
            .push(MaterialPageRoute(builder: (ctx) => IdeaTitle(ideaId)))
            .then((value) {
          searchController.text = '';
          backupSuggestedIdeaData.clear();
          suggestedIdeaData.clear();
          suggestionsList.clear();
          // String move = "";

          // bool dataLoadedFirstTime = false;

          imageList.clear();
          getSuggestedIdeas("");
        });
      }
    }
  }

  void getSuggestions(String searchString) async {
    Map mapData = {
      "search_by_keyword": searchString,
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_SUGGESTIONS),
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
          dataObject: "SEARCH_LIST");
      if (data["code"] == 1) {
        final suggestionData = data["data"];
        print(suggestionData);
        if (suggestionData != null) {
          suggestionsList.clear();
          setState(() {
            for (Map suggestion in suggestionData) {
              suggestionsList.add(suggestion["value"]);
            }
          });
          print(suggestionsList);
        } else {
          setState(() {
            suggestionsList.clear();
            suggestionsList.add("No Data Found");
          });
        }
      }
    }
  }

  // void getSuggestedIdeas() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final extractUserData =
  //       json.decode(prefs.getString("userData")) as Map<String, Object>;
  //   move = extractUserData["move"];
  //   print("move: $move");

  //   if (move == "/capabilities") {
  //     Map mapData = {"ins_user_id": userIdMain};
  //     print(mapData);

  //     final response = await http.post(
  //       Uri.parse(WebApis.GET_SUGGESTED_IDEAS_LIST),
  //       body: json.encode(mapData),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json'
  //       },
  //     );
  //     print(response.statusCode);
  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       Map data = WebResponseExtractor.filterWebData(response,
  //           dataObject: "IDEA_LIST");
  //       if (data["code"] == 1) {
  //         print(data["data"]);
  //         getSuggestedIdeasFromWeb(data["data"]);
  //       }
  //     }
  //   }

  //   if (move == "/product_provider") {
  //     Map mapData = {"pp_id": ppId};
  //     print(mapData);

  //     final response = await http.post(
  //       Uri.parse(WebApis.GET_SUGGESTED_IDEAS_PP_LIST),
  //       body: json.encode(mapData),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json'
  //       },
  //     );
  //     print(response.statusCode);
  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       Map data = WebResponseExtractor.filterWebData(response,
  //           dataObject: "IDEA_LIST");
  //       if (data["code"] == 1) {
  //         print(data["data"]);
  //         getSuggestedIdeasFromWeb(data["data"]);
  //       }
  //     }
  //   }

  //   if (move == "/domain") {
  //     Map mapData = {"sp_id": spId};
  //     print(mapData);

  //     final response = await http.post(
  //       Uri.parse(WebApis.GET_SUGGESTED_IDEAS_SP_LIST),
  //       body: json.encode(mapData),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json'
  //       },
  //     );
  //     print(response.statusCode);
  //     print(response.body);

  //     if (response.statusCode == 200) {
  //       Map data = WebResponseExtractor.filterWebData(response,
  //           dataObject: "IDEA_LIST");
  //       if (data["code"] == 1) {
  //         print(data["data"]);
  //         getSuggestedIdeasFromWeb(data["data"]);
  //       }
  //     }
  //   }
  // }

}

class SuggestedIdeaModel {
  String title;
  String name;
  String address;
  String image;
  int ideaId;
  String summary;
  String likesCount;
  String date;
  String cat;
  List<String> imagesList;

  SuggestedIdeaModel({
    this.title,
    this.name,
    this.address,
    this.image,
    this.ideaId,
    this.summary,
    this.likesCount,
    this.date,
    this.cat,
    this.imagesList,
  });
}
