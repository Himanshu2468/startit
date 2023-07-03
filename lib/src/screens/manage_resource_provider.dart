import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:startit/main.dart';
import 'package:startit/src/screens/chats.dart';
import 'package:startit/src/screens/view_service_list.dart';
import '../widgets/app_drawer.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManageResourceProvider extends StatefulWidget {
  @override
  _ManageProvidersState createState() => _ManageProvidersState();
}

class _ManageProvidersState extends State<ManageResourceProvider>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  var color;
  bool first = true;
  bool second = false;
  bool three = false;
  bool fourth = false;

  DropDown categoryDropDown;
  List<DropDown> categoryList = [];
  String categoryName = "";
  String categoryID = "0";
  List categoryIdList = [];
  List<String> pickItemsCatIDList1 = [];

  DropDown subCategoryDropDown;
  List<DropDown> subCategoryList = [];
  String subCategoryName = "";
  String subCategoryID = "0";
  List subCategoryIdList = [];
  List<String> pickItemsCatIDList2 = [];

  DropDown functionDropDown;
  List<DropDown> functionList = [];
  String functionName = "";
  String fallId = "0";
  List fallIdList = [];
  List<String> pickItemsCatIDList3 = [];

  TextEditingController domainController = TextEditingController();
  TextEditingController brandController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    getCategories();
    getServiceProviders();
    getProductProviders();
  }

  void _handleTabSelection() {
    setState(() {
      color = Colors.blue;
    });
  }

  List<ProviderData> spData = [];

  List<ProviderData> ppData = [];

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
          "Manage Resource Providers",
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
          padding: EdgeInsets.only(top: width * 0.09),
          child: nestedTabs(height, width),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_alt_outlined),
        onPressed: () {
          showDialogCat(context, height, width).then((val) {
            if (val == true) {
              print(categoryID + "asdfsadsa");
              print(subCategoryID);
              print(fallId);
              getServiceProviders();
              getProductProviders();
            } else
              return;
          });
        },
      ),
    );
  }

  Widget nestedTabs(double height, double width) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            child: new SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        "Service-Provider",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      Text(
                        "Product-Provider",
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
            Container(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
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
                    spData[i].useridsppp),
                itemCount: spData.length,
              ),
            ),
            Container(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
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
                    ppData[i].useridsppp),
                itemCount: ppData.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> showDialogCat(BuildContext cxt, double height, double width) {
    return showDialog(
      context: cxt,
      builder: (cxt) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          content: SizedBox(
            width: width * 0.7,
            height: height * 0.7,
            child: StatefulBuilder(
              builder: (BuildContext cxt, StateSetter setState1) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter Categories',
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.04),
                      Container(
                        height: height * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.55,
                              child: TextFormField(
                                textCapitalization: TextCapitalization.words,
                                // initialValue: investedProject,
                                controller: _tabController.index == 0
                                    ? domainController
                                    : brandController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 6.0, vertical: 10.0),
                                  isCollapsed: true,
                                  hintText: _tabController.index == 0
                                      ? 'Enter Domain'
                                      : "Enter Brand",
                                  focusColor: Colors.white70,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            buildCategoryDropDown(
                                context,
                                setState1,
                                width,
                                height,
                                'Deliverable- Category',
                                'Select Category',
                                "Deliverable Category will define the Category of your products/services, in that Category your products/services will get listed. Example: IT-Software, Financial Services etc."),
                            SizedBox(height: height * 0.02),
                            SizedBox(height: height * 0.05),
                            buildSubCategoryDropDown(
                                context,
                                setState1,
                                width,
                                height,
                                'Deliverable- Sub Category',
                                'Select Category',
                                "Deliverable Sub Category will define the Category of your products/services, in that Category your products/services will get listed. Example: Application Software, Banking Services etc."),
                            SizedBox(height: height * 0.02),
                            SizedBox(height: height * 0.05),
                            buildFunctionDropDown(
                                context,
                                setState1,
                                width,
                                height,
                                'Functional Area',
                                'Select',
                                "Idea Functional Area will define the Functional Area of your products/services, in that Functional Area your products/services will get listed. Example: Accounting Application, E-fund Transfer Services etc."),
                            SizedBox(height: height * 0.03),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildCategoryDropDown(
      BuildContext context,
      StateSetter setState1,
      double width,
      double height,
      String heading,
      String hintText,
      String info) {
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width * 0.53,
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
                    setState1(() {
                      categoryDropDown = _value;
                    });
                    // if (!categoryIdList.contains(categoryID)) {

                    //   categoryIdList.add(categoryID);
                    // }
                    // if (!pickItemsCatIDList1.contains(categoryName)) {
                    //   pickItemsCatIDList1.add(categoryName);
                    // }
                    getSubCategory(setState1);
                  },
                  items: categoryList.map(
                    (DropDown category) {
                      return DropdownMenuItem<DropDown>(
                        value: category,
                        child: Text(
                          category.NAME,
                          textScaleFactor: 1,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
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
      ],
    );
  }

  Widget buildSubCategoryDropDown(
      BuildContext context,
      StateSetter setState1,
      double width,
      double height,
      String heading,
      String hintText,
      String info) {
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width * 0.53,
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
                    setState1(() {
                      subCategoryDropDown = _value;
                    });
                    if (!subCategoryIdList.contains(subCategoryID)) {
                      subCategoryIdList.add(subCategoryID);
                    }
                    if (!pickItemsCatIDList2.contains(subCategoryName)) {
                      pickItemsCatIDList2.add(subCategoryName);
                    }
                    getFunction(setState1);
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
      ],
    );
  }

  Widget buildFunctionDropDown(
      BuildContext context,
      StateSetter setState1,
      double width,
      double height,
      String heading,
      String hintText,
      String info) {
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: width * 0.53,
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
                    setState1(() {
                      functionDropDown = _value;
                    });
                    // if (!fallIdList.contains(fallId)) {
                    //   //this .clear line must be removed and List3(yellow boxes) must be
                    //   //added to show the selected categories
                    //   //if multiple fallIds are sent
                    //   fallIdList.clear();
                    //   fallIdList.add(fallId);
                    // }
                    // if (!pickItemsCatIDList3.contains(functionName)) {
                    //   pickItemsCatIDList3.add(functionName);
                    // }
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
      ],
    );
  }

  void getCategories() async {
    final response = await http.post(
      Uri.parse(WebApis.DEL_CATEGORY),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "DELIVERABLE_CATEGORY");

      if (data["code"] == 1) {
        getCategoriesFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getCategoriesFromWeb(var jsonData) async {
    setState(() {
      for (Map country in jsonData) {
        categoryList.add(new DropDown(country["id"], country["name"]));
      }
    });
  }

  void getSubCategory(StateSetter setState1) async {
    // Map mapData = {"deliverable_category_id": categoryIdList.join(",")};
    Map mapData = {"deliverable_category_id": categoryID};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.DEL_SUBCATEGORY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "DELIVERABLE_SUB_CATEGORY");

      if (data["code"] == 1) {
        getSubCategoryFromWeb(data["data"], setState1);
      }
    }
  }

  Future<Null> getSubCategoryFromWeb(
      var jsonData, StateSetter setState1) async {
    setState1(() {
      subCategoryList.clear();

      for (Map subCategory in jsonData) {
        subCategoryList
            .add(new DropDown(subCategory["id"], subCategory["name"]));
      }
    });
  }

  void getFunction(StateSetter setState1) async {
    // Map mapData = {"deliverable_sub_category_id": subCategoryIdList.join(",")};
    Map mapData = {"deliverable_sub_category_id": subCategoryID};

    final response = await http.post(
      Uri.parse(WebApis.DEL_FUNCTIONAL_CATEGORY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "DELIVERABLE_FUNCTIONAL_CATEGORY");

      if (data["code"] == 1) {
        getFunctionsFromWeb(data["data"], setState1);
      }
    }
  }

  Future<Null> getFunctionsFromWeb(var jsonData, StateSetter setState1) async {
    setState1(() {
      functionList.clear();

      for (Map function in jsonData) {
        functionList.add(new DropDown(function["id"], function["name"]));
      }
    });
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
      String userIdPPSP) {
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
              builder: (context) => ViewServiceList(int.parse(userIdPPSP),
                  providerEmail, providerMobile, providerMobile, isService,providerName)),
        );
      },
      child: Card(
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

  void getProductProviders() async {
    Map mapData = {
      "bip_id": bipId,
      "brand_name": brandController.text,
      "mst_del_category_id": int.parse(categoryID),
      "mst_del_sub_category_id": int.parse(subCategoryID),
      "mst_del_fun_category_id": int.parse(fallId),
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_PRODUCT_PROVIDERS),
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
          dataObject: "PRODUCT_PROVIDER");
      if (data["code"] == 1) {
        print(data["data"]);
        getProductProvidersFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getProductProvidersFromWeb(var jsonData) async {
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

  void getServiceProviders() async {
    Map mapData = {
      "bip_id": bipId,
      "domain_name": domainController.text,
      "mst_del_category_id": int.parse(categoryID),
      "mst_del_sub_category_id": int.parse(subCategoryID),
      "mst_del_fun_category_id": int.parse(fallId),
    };
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_SERVICE_PROVIDERS),
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
          dataObject: "SERVICE_PROVIDER");
      if (data["code"] == 1) {
        print(data["data"]);
        getServiceProvidersFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getServiceProvidersFromWeb(var jsonData) async {
    spData.clear();
    setState(() {
      for (Map provider in jsonData) {
        spData.add(
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
    print(spData.length);
    print("object");
    print(spData[0].providerId);
  }
}

class ProviderData {
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

class DropDown {
  String ID;
  String NAME;
  DropDown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
