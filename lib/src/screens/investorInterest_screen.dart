import 'package:flutter/material.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:startit/main.dart';

class InvestorInterest extends StatefulWidget {
  @override
  _InvestorInterestState createState() => _InvestorInterestState();
}

class _InvestorInterestState extends State<InvestorInterest> {
  DropDown categoryDropDown;
  List<DropDown> categoryList = [];
  String categoryName = "";
  String categoryID = "";
  List categoryIdList = [];

  List<String> pickItemsCatIDList1 = [];

  DropDown subCategoryDropDown;
  List<DropDown> subCategoryList = [];
  String subCategoryName = "";
  String subCategoryID = "";
  List subCategoryIdList = [];

  List<String> pickItemsCatIDList2 = [];

  DropDown functionDropDown;
  List<DropDown> functionList = [];
  String functionName = "";
  String fallId = "";
  List fallIdList = [];

  List<String> pickItemsCatIDList3 = [];

  bool allIdea = false;
  bool allSubIdea = false;
  bool allFunctionalArea = false;

  void initState() {
    super.initState();
    getCategories();
  }

  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      //drawer: Drawer(),
      appBar: AppBar(
        //toolbarHeight: height * 0.1,
        elevation: 0,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          isEnglish ? "Add your interest" : "अपनी रुचि जोड़ें",
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        height: double.maxFinite,
        padding: EdgeInsets.all(width * 0.12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish
                  ? 'Choose categories where you want to Invest'
                  : "श्रेणियां चुनें जहां आप निवेश करना चाहते हैं",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.lightBlue, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.05),
            Container(
              height: height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInterestedIdeaDropDown(
                        width,
                        height,
                        isEnglish
                            ? 'Interested Idea Category'
                            : "इच्छुक आइडिया श्रेणी",
                        isEnglish ? 'Select Category' : "श्रेणी चुनें",
                        isEnglish
                            ? "Interested Idea Category will show the ideas from that specific Category. Example: IT-Software, Financial Services etc."
                            : "इच्छुक आइडिया विशिष्ट श्रेणी के आइडियाज को दिखाएगी। उदाहरण आईटी- सॉफ्टवेयर, वित्तीय सेवाएं आदि।"),
                    SizedBox(height: height * 0.05),
                    buildSubInterestedIdeaDropDown(
                        width,
                        height,
                        isEnglish
                            ? 'Interested Idea Sub-Category'
                            : "इच्छुक आइडिया उप-श्रेणी",
                        isEnglish ? 'Select Category' : "श्रेणी चुनें",
                        isEnglish
                            ? "Interested Idea Sub-Category will show the ideas from that specific Sub-Categoary. Example: Application Software, Banking Services etc."
                            : "इच्छुक आइडिया उप-श्रेणी विशिष्ट के आइडियाज को दिखाएगी। उदाहरण एप्लिकेशन सॉफ्टवेयर, बैंकिंग सेवाएं आदि।"),
                    SizedBox(height: height * 0.05),
                    buildFunctionalAreaDropDown(
                        width,
                        height,
                        isEnglish ? 'Functional Area' : "कार्यात्मक क्षेत्र",
                        isEnglish ? 'Select Category' : "श्रेणी चुनें",
                        isEnglish
                            ? "Functional Area will show the ideas from that specific Functional Area. Example: Utility Software, E-fund Transfer Services etc."
                            : "इच्छुक कार्यात्मक क्षेत्र विशिष्ट कार्यात्मक क्षेत्र से आइडियाज दिखाएगा। उदाहरण यूटिलिटी सॉफ्टवेयर, ई-फंड ट्रांसफर सर्विसेज आदि।"),
                    SizedBox(height: height * 0.06),
                    Center(
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.7,
                        child: ElevatedButton(
                          onPressed: () {
                            if (categoryIdList.isEmpty) {
                              WebResponseExtractor.showToast(
                                  'Please select Category');
                            } else if (subCategoryIdList.isEmpty) {
                              WebResponseExtractor.showToast(
                                  'Please select Sub Category');
                            } else if (fallIdList.isEmpty) {
                              WebResponseExtractor.showToast(
                                  'Please select Functional Area');
                            } else
                              addInvestorIdea();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isEnglish
                                    ? 'Save & Continue'
                                    : "सहेजें और जारी रखें",
                                textScaleFactor: 1,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget buildInterestedIdeaDropDown(double width, double height,
      String heading, String hintText, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text: heading,
            style: TextStyle(fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red[700]),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width * 0.62,
              child: InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: DropdownButton(
                    hint: Text(
                      hintText,
                      textScaleFactor: 1,
                    ),
                    icon: Icon(Icons.expand_more),
                    iconSize: 30,
                    isExpanded: true,
                    isDense: true,
                    underline: SizedBox(),
                    value: categoryDropDown,
                    onChanged: (DropDown _value) {
                      subCategoryDropDown = null;
                      categoryName = _value.NAME;
                      categoryID = _value.ID;
                      setState(() {
                        categoryDropDown = _value;
                      });
                      if (!categoryIdList.contains(categoryID)) {
                        categoryIdList.add(categoryID);
                      }
                      if (!pickItemsCatIDList1.contains(categoryName)) {
                        pickItemsCatIDList1.add(categoryName);
                      }
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
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.info,
                color: Colors.blue,
                size: 20,
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
                        info,
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
        SizedBox(height: height * 0.02),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width * 0.52,
            ),
            Text('All',
                textScaleFactor: 1, style: TextStyle(color: Colors.blue)),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.blue),
              child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  value: allIdea,
                  onChanged: (value) {
                    setState(() {
                      allIdea = value;
                      if (value == true) {
                        categoryIdList.clear();
                        pickItemsCatIDList1.clear();
                        categoryList.forEach((element) {
                          categoryIdList.add(element.ID);
                        });
                        getSubCategory();
                      }
                      if (value == false) {
                        categoryIdList.clear();
                        pickItemsCatIDList1.clear();
                      }
                      print(categoryIdList);
                    });
                  }),
            ),
          ],
        ),
        Container(
          child: Wrap(
            children: [
              ...List.generate(
                pickItemsCatIDList1.length,
                (index) =>
                    list(index, pickItemsCatIDList1[index], Colors.amber[600]),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSubInterestedIdeaDropDown(double width, double height,
      String heading, String hintText, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text: heading,
            style: TextStyle(fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red[700]),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width * 0.62,
              child: InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: DropdownButton(
                  hint: Text(
                    hintText,
                    textScaleFactor: 1,
                  ),
                  icon: Icon(Icons.expand_more),
                  iconSize: 30,
                  isExpanded: true,
                  isDense: true,
                  underline: SizedBox(),
                  value: subCategoryDropDown,
                  onChanged: (DropDown _value) {
                    functionDropDown = null;
                    subCategoryName = _value.NAME;
                    subCategoryID = _value.ID;
                    setState(() {
                      subCategoryDropDown = _value;
                    });
                    if (!subCategoryIdList.contains(subCategoryID)) {
                      subCategoryIdList.add(subCategoryID);
                    }
                    if (!pickItemsCatIDList2.contains(subCategoryName)) {
                      pickItemsCatIDList2.add(subCategoryName);
                    }
                    functionList.clear();
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
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.info,
                color: Colors.blue,
                size: 20,
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
                        info,
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
        SizedBox(height: height * 0.02),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width * 0.52,
            ),
            Text('All',
                textScaleFactor: 1, style: TextStyle(color: Colors.blue)),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.blue),
              child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  value: allSubIdea,
                  onChanged: (value) {
                    setState(() {
                      allSubIdea = value;
                      if (value == true) {
                        subCategoryIdList.clear();
                        pickItemsCatIDList2.clear();
                        subCategoryList.forEach((element) {
                          subCategoryIdList.add(element.ID);
                        });
                        getFunction();
                      }
                      if (value == false) {
                        subCategoryIdList.clear();
                        pickItemsCatIDList2.clear();
                      }
                      print(subCategoryIdList);
                    });
                  }),
            ),
          ],
        ),
        Container(
          child: Wrap(
            children: [
              ...List.generate(
                pickItemsCatIDList2.length,
                (index) =>
                    list2(index, pickItemsCatIDList2[index], Colors.amber[600]),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFunctionalAreaDropDown(double width, double height,
      String heading, String hintText, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text: heading,
            style: TextStyle(fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red[700]),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width * 0.62,
              child: InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: DropdownButton(
                  hint: Text(
                    hintText,
                    textScaleFactor: 1,
                  ),
                  icon: Icon(Icons.expand_more),
                  iconSize: 30,
                  isExpanded: true,
                  isDense: true,
                  underline: SizedBox(),
                  value: functionDropDown,
                  onChanged: (DropDown _value) {
                    fallId = _value.ID;
                    functionName = _value.NAME;
                    setState(() {
                      functionDropDown = _value;
                    });
                    if (!fallIdList.contains(fallId)) {
                      fallIdList.add(fallId);
                    }
                    if (!pickItemsCatIDList3.contains(functionName)) {
                      pickItemsCatIDList3.add(functionName);
                    }
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
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.info,
                color: Colors.blue,
                size: 20,
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
                        info,
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
        SizedBox(height: height * 0.02),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width * 0.52,
            ),
            Text('All',
                textScaleFactor: 1, style: TextStyle(color: Colors.blue)),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.blue),
              child: Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  value: allFunctionalArea,
                  onChanged: (value) {
                    setState(() {
                      allFunctionalArea = value;
                      if (value == true) {
                        fallIdList.clear();
                        pickItemsCatIDList3.clear();
                        functionList.forEach((element) {
                          fallIdList.add(element.ID);
                        });
                      }
                      if (value == false) {
                        fallIdList.clear();
                        pickItemsCatIDList3.clear();
                      }
                      print(fallIdList);
                    });
                  }),
            ),
          ],
        ),
        Container(
          child: Wrap(
            children: [
              ...List.generate(
                pickItemsCatIDList3.length,
                (index) =>
                    list3(index, pickItemsCatIDList3[index], Colors.amber[600]),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget list(int item, String txt, Color clr) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          // height: height * 0.04,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: clr,
          ),
          padding: EdgeInsets.all(8),
          width: width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: width * 0.2,
                  maxWidth: width * 0.45,
                ),
                child: Text(
                  txt,
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pickItemsCatIDList1.remove(pickItemsCatIDList1[item]);
                    categoryIdList.remove(categoryIdList[item]);
                  });
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }

  Widget list2(int item, String txt, Color clr) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          // height: height * 0.04,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: clr,
          ),
          padding: EdgeInsets.all(8),
          width: width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: width * 0.2,
                  maxWidth: width * 0.45,
                ),
                child: Text(
                  txt,
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pickItemsCatIDList2.remove(pickItemsCatIDList2[item]);
                    subCategoryIdList.remove(subCategoryIdList[item]);
                  });
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }

  Widget list3(int item, String txt, Color clr) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          // height: height * 0.04,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: clr,
          ),
          padding: EdgeInsets.all(8),
          width: width * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: width * 0.2,
                  maxWidth: width * 0.45,
                ),
                child: Text(
                  txt,
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pickItemsCatIDList3.remove(pickItemsCatIDList3[item]);
                    fallIdList.remove(fallIdList[item]);
                  });
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }

  void addInvestorIdea() async {
    Map data = {
      "user_id": userIdMain,
      "mst_idea_category_id": categoryIdList.join(","),
      "mst_idea_sub_category_id": subCategoryIdList.join(","),
      "mst_fall_sub_category_id": fallIdList.join(","),
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.ADD_EDIT_INVESTOR_IDEA),
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
        insIdeaId = jsonData["INS_IDEA_ID"];
      }
      if (loadIns == true) {
        Navigator.of(context).pushNamed('/resource');
      } else
        Navigator.of(context).pushNamed('/capabilities');
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
    }
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
      for (Map category in jsonData) {
        categoryList.add(
          new DropDown(
            category["id"],
            isEnglish ? category["name"] : category["name_hindi"],
          ),
        );
      }
    });
    // if (loadIns == true) {
    getInterestsData();
    // }
  }

  void getSubCategory() async {
    Map mapData = {"category_ids": categoryIdList.join(",")};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.INS_SUB_CATEGORY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "SUB_CATEGORY");

      if (data["code"] == 1) {
        getSubCategoryFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getSubCategoryFromWeb(var jsonData) async {
    subCategoryDropDown = null;
    subCategoryList.clear();
    setState(() {
      for (Map subCategory in jsonData) {
        subCategoryList.add(
          new DropDown(
            subCategory["id"],
            isEnglish ? subCategory["name"] : subCategory["name_hindi"],
          ),
        );
      }
    });
  }

  void getFunction() async {
    Map mapData = {"sub_category_ids": subCategoryIdList.join(",")};
    print(WebApis.INS_FALL_SUB_CATEGORY);
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.INS_FALL_SUB_CATEGORY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "FUNCTIONAL_CATEGORY");

      if (data["code"] == 1) {
        getFunctionsFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getFunctionsFromWeb(var jsonData) async {
    setState(() {
      functionList.clear();

      for (Map function in jsonData) {
        functionList.add(
          new DropDown(
            function["id"],
            isEnglish ? function["name"] : function["name_hindi"],
          ),
        );
      }
    });
  }

  void getInterestsData() async {
    Map mapData = {"user_id": userIdMain};

    final response = await http.post(
      Uri.parse(WebApis.MY_INTERESTS),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(WebApis.MY_INTERESTS);
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        Map data = WebResponseExtractor.filterWebData(response,
            dataObject: "INS_IDEA");
        var userData = data["data"];

        String newCategoryID = userData["mst_idea_category_id"];
        String newSubCategoryID = userData["mst_idea_sub_category_id"];
        String newFunctionalCategoryID = userData["mst_fall_sub_cat_id"];
        List<int> newCatIdsList = [];
        List<int> newSubCatIdsList = [];
        List<int> newFunIdsList = [];

        newCategoryID = newCategoryID.replaceAll("null,", "");
        newSubCategoryID = newSubCategoryID.replaceAll("null,", "");

        if (newCategoryID != "") {
          newCatIdsList = newCategoryID.split(",").map(int.parse).toList();
          for (int CatID in newCatIdsList) {
            categoryDropDown =
                categoryList.firstWhere((cat) => cat.id == CatID.toString());
            categoryName = categoryDropDown.NAME;
            categoryID = categoryDropDown.ID;
            if (!categoryIdList.contains(CatID)) {
              categoryIdList.add(CatID);
            }
            if (!pickItemsCatIDList1.contains(categoryName)) {
              pickItemsCatIDList1.add(categoryName);
            }
          }
        }

        await getSubCategory();

        if (newSubCategoryID != "") {
          newSubCatIdsList =
              newSubCategoryID.split(",").map(int.parse).toList();
          for (int subCatID in newSubCatIdsList) {
            subCategoryDropDown = subCategoryList
                .firstWhere((subCat) => subCat.id == subCatID.toString());
            subCategoryName = subCategoryDropDown.NAME;
            subCategoryID = subCategoryDropDown.ID;
            if (!subCategoryIdList.contains(subCatID)) {
              subCategoryIdList.add(subCatID);
            }
            if (!pickItemsCatIDList2.contains(subCategoryName)) {
              pickItemsCatIDList2.add(subCategoryName);
            }
          }
        }

        await getFunction();

        if (newFunctionalCategoryID != "") {
          newFunIdsList =
              newFunctionalCategoryID.split(",").map(int.parse).toList();
          for (int FunID in newFunIdsList) {
            functionDropDown =
                functionList.firstWhere((fun) => fun.id == FunID.toString());
            functionName = functionDropDown.NAME;
            fallId = functionDropDown.ID;
            if (!fallIdList.contains(FunID)) {
              fallIdList.add(FunID);
            }
            if (!pickItemsCatIDList3.contains(functionName)) {
              pickItemsCatIDList3.add(functionName);
            }
          }
        }

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
