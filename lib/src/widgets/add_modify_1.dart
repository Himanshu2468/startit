import 'package:flutter/material.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:startit/main.dart';

class AddModify1 extends StatefulWidget {
  final PageController pageController;
  final int sliderIndex;

  AddModify1(this.pageController, this.sliderIndex);

  @override
  _AddModify1State createState() => _AddModify1State();
}

class _AddModify1State extends State<AddModify1>
    with AutomaticKeepAliveClientMixin<AddModify1> {
  DropDown categoryDropDown;
  List<DropDown> categoryList = [];
  String categoryName = "";

  DropDown subCategoryDropDown;
  List<DropDown> subCategoryList = [];
  String subCategoryName = "";
  String subCategoryID = "";

  DropDown functionDropDown;
  List<DropDown> functionList = [];
  String functionName = "";
  String fallId = "";

  @override
  void initState() {
    recentIdeaTitle = "";
    recentIdeaGroupId = "";
    recentFriendListIds.clear();
    recentUserLink = "";
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isEnglish ? "Idea Category" : 'आइडिया श्रेणी',
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
          Center(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.67,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                      isExpanded: true,
                      hint: Text(
                        'Select',
                        textScaleFactor: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      icon: Icon(Icons.arrow_drop_down_outlined),
                      iconSize: 35,
                      underline: SizedBox(),
                      value: categoryDropDown,
                      onChanged: (DropDown _value) {
                        subCategoryDropDown = null;
                        // categoryName = _value.NAME;
                        // categoryID = _value.ID;
                        setState(() {
                          categoryDropDown = _value;
                          categoryName = _value.NAME;
                          categoryIDMain = _value.ID;
                        });
                        getSubCategory();
                      },
                      items: categoryList.map((DropDown category) {
                        return DropdownMenuItem<DropDown>(
                          value: category,
                          child: Text(
                            category.NAME,
                            textScaleFactor: 1,
                          ),
                        );
                      }).toList()),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: MediaQuery.of(context).size.width * 0.065,
                  icon: Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.orange[50],
                          content: Text(
                            isEnglish
                                ? "Idea Category will define the Category of your idea, in that Category your idea will get listed. Example IT-Software, Financial Services etc."
                                : 'आइडिया श्रेणी आपके आइडिया की श्रेणी को परिभाषित करेगी, उस श्रेणी में आपका आइडिया सूचीबद्ध हो जाएगा। उदाहरण आईटी- सॉफ्टवेयर, वित्तीय सेवाएं आदि।',
                            textScaleFactor: 1,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Text(
                isEnglish ? "Idea Sub-Category" : 'आइडिया उप-श्रेणी',
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
          Center(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.67,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      'Select',
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    icon: Icon(Icons.arrow_drop_down_outlined),
                    iconSize: 35,
                    underline: SizedBox(),
                    value: subCategoryDropDown,
                    onChanged: (DropDown _value) {
                      functionDropDown = null;
                      functionList.clear();
                      subCategoryName = _value.NAME;
                      subCategoryID = _value.ID;
                      setState(() {
                        subCategoryDropDown = _value;
                      });
                      getFunction();
                    },
                    items: subCategoryList.map((DropDown state) {
                      return DropdownMenuItem<DropDown>(
                        value: state,
                        child: Text(
                          state.NAME,
                          textScaleFactor: 1,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: MediaQuery.of(context).size.width * 0.065,
                  icon: Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.orange[50],
                          content: Text(
                            isEnglish
                                ? "Idea Sub-Category will define the Sub-Category of your idea, in that Sub-Category your idea will get listed. Example Application Software, Banking Services etc."
                                : 'आइडिया उप-श्रेणी आपके आइडिया की उप-श्रेणी को परिभाषित करेगी, उस उप-श्रेणी में आपका आइडिया सूचीबद्ध हो जाएगा। उदाहरण एप्लिकेशन सॉफ्टवेयर, बैंकिंग सेवाएं आदि।',
                            textScaleFactor: 1,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Text(
                isEnglish ? "Functional Area" : 'कार्य क्षेत्र',
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
          Center(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.67,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text(
                      'Select',
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    icon: Icon(Icons.arrow_drop_down_outlined),
                    iconSize: 35,
                    underline: SizedBox(),
                    value: functionDropDown,
                    onChanged: (DropDown _value) {
                      fallId = _value.ID;
                      functionName = _value.NAME;
                      setState(() {
                        functionDropDown = _value;
                      });
                    },
                    items: functionList.map((DropDown city) {
                      return DropdownMenuItem<DropDown>(
                        value: city,
                        child: Text(
                          city.NAME,
                          textScaleFactor: 1,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: MediaQuery.of(context).size.width * 0.065,
                  icon: Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(),
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Colors.orange[50],
                              content: Text(
                                isEnglish
                                    ? "Idea Functional Area will define the Functional Area of your idea, in that Functional Area your idea will get listed. Example Utility Software, E-fund Transfer Services etc."
                                    : 'आइडिया फंक्शनल एरिया आपके आइडिया के फंक्शनल एरिया को परिभाषित करेगा, उस फंक्शनल एरिया में आपका आइडिया लिस्ट हो जाएगा। उदाहरण यूटिलिटी सॉफ्टवेयर, ई-फंड ट्रांसफर सर्विसेज आदि।',
                                textScaleFactor: 1,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Icon(Icons.chevron_right)
              ],
            ),
            onPressed: () {
              if (categoryIDMain == "") {
                WebResponseExtractor.showToast('Please select Category');
              } else if (subCategoryID == "") {
                WebResponseExtractor.showToast('Please select Sub Category');
              } else if (fallId == "") {
                WebResponseExtractor.showToast('Please select Functional Area');
              } else {
                addIdeaBip();
                widget.pageController.animateToPage(widget.sliderIndex + 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastLinearToSlowEaseIn);
              }
            },
          ),
        ],
      ),
    );
  }

  void addIdeaBip() async {
    Map data = {
      "bip_idea_id": bipIdeaId,
      "user_id": userIdMain,
      "mst_idea_category_id": int.parse(categoryIDMain),
      "mst_idea_sub_category_id": int.parse(subCategoryID),
      "mst_fall_sub_cat_id": int.parse(fallId)
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.ADD_BIP_IDEA),
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
        bipIdeaId = jsonData["BIP_IDEA_ID"];
      }
      print(bipIdeaId);
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
    }
  }

  @override
  bool get wantKeepAlive => true;

  void getSubCategory() async {
    Map mapData = {"category_id": int.parse(categoryIDMain)};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.SUB_CATEGORY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "SUB_CATEGORY_MASTER");

      if (data["code"] == 1) {
        getSubCategoryFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getSubCategoryFromWeb(var jsonData) async {
    setState(() {
      subCategoryList.clear();

      for (Map subCategory in jsonData) {
        subCategoryList.add(new DropDown(subCategory["id"],
            isEnglish ? subCategory["name"] : subCategory["name_hindi"]));
      }
    });
  }

  void getFunction() async {
    Map mapData = {"scategory_id": int.parse(subCategoryID)};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.FALL_SUB_CATEGORY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "FALL_SUB_CATEGORY_MASTER");

      if (data["code"] == 1) {
        getFunctionsFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getFunctionsFromWeb(var jsonData) async {
    setState(() {
      functionList.clear();

      for (Map function in jsonData) {
        functionList.add(new DropDown(function["id"],
            isEnglish ? function["name"] : function["name_hindi"]));
      }
    });
  }

  void getCategories() async {
    final response = await http.post(
      Uri.parse(WebApis.CATEGORY),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "CATEGORY_MASTER");

      if (data["code"] == 1) {
        getCategoriesFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getCategoriesFromWeb(var jsonData) async {
    setState(() {
      for (Map country in jsonData) {
        categoryList.add(new DropDown(country["id"],
            isEnglish ? country["name"] : country["name_hindi"]));
      }
    });

    // if (loadedBip == true) {
    getData();
    // }
  }

  void getData() async {
    Map mapData = {"idea_id": bipIdeaId};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.VIEW_IDEA),
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
            dataObject: "IDEA_DETAILS");

        var userData = data["data"];

        categoryIDMain = userData["mst_idea_category_id"];
        subCategoryID = userData["mst_idea_sub_category_id"];
        fallId = userData["mst_fall_sub_cat_id"];

        categoryDropDown =
            categoryList.firstWhere((cat) => cat.ID == categoryIDMain);
        categoryName = categoryDropDown.NAME;

        await getSubCategory();

        subCategoryDropDown =
            subCategoryList.firstWhere((subCat) => subCat.ID == subCategoryID);
        subCategoryName = subCategoryDropDown.NAME;

        await getFunction();

        functionDropDown = functionList.firstWhere((fun) => fun.ID == fallId);
        categoryName = categoryDropDown.NAME;

        setState(() {});
      }
    }
  }
}

class DropDown {
  String ID;
  String NAME;
  DropDown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
