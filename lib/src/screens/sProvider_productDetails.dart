import 'package:flutter/material.dart';
import 'package:startit/main.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceProviderProductDetails extends StatefulWidget {
  @override
  _ServiceProviderProductDetailsState createState() =>
      _ServiceProviderProductDetailsState();
}

class _ServiceProviderProductDetailsState
    extends State<ServiceProviderProductDetails> {
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

  void initState() {
    super.initState();
    getCategories();
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
          isEnglish ? 'Service detail' : "सेवा विवरण",
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            padding: EdgeInsets.all(width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      isEnglish
                          ? 'Add categories to be deliver your Services effectively'
                          : "अपनी सेवाएं प्रभावी ढंग से वितरित करने के लिए श्रेणियां जोड़ें",
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.04),
                Container(
                  height: height * 0.68,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildCategoryDropDown(
                            context,
                            width,
                            height,
                            isEnglish
                                ? 'Service Deliverable - Category'
                                : "सेवा प्रदेय - श्रेणी",
                            isEnglish ? 'Select Category' : "श्रेणी चुनें",
                            isEnglish
                                ? "Service Deliverable Category will define the Category of your Services, in that Category your Services will get listed. Example: IT Software, Financial Services etc."
                                : "सेवा प्रदेय- श्रेणी आपके आइडिया की श्रेणी को परिभाषित करेगी, उस श्रेणी में आपकी सेवाएँ सूचीबद्ध होंगी। उदाहरण आईटी- सॉफ्टवेयर, वित्तीय सेवाएं आदि।"),
                        SizedBox(height: height * 0.02),
                        Container(
                          child: Wrap(
                            children: [
                              ...List.generate(
                                pickItemsCatIDList1.length,
                                (index) => list1(
                                  index,
                                  pickItemsCatIDList1[index],
                                  Colors.amber[600],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        buildSubCategoryDropDown(
                            context,
                            width,
                            height,
                            isEnglish
                                ? 'Service Deliverable - Sub Category'
                                : "सेवा प्रदेय - उप श्रेणी",
                            isEnglish ? 'Select Category' : "श्रेणी चुनें",
                            isEnglish
                                ? "Service Deliverable Sub Category will define the Sub-Category of your Services, in that Sub-Category your Services will get listed. Example: Application Software, Banking Services etc."
                                : "सेवा प्रदेय-उप श्रेणी आपकी सेवाओं की उप-श्रेणी को परिभाषित करेगी, उस उप-श्रेणी में आपकी सेवाएं सूचीबद्ध होंगी। उदाहरण एप्लिकेशन सॉफ्टवेयर, बैंकिंग सेवाएं आदि।"),
                        SizedBox(height: height * 0.02),
                        Container(
                          child: Wrap(
                            children: [
                              ...List.generate(
                                pickItemsCatIDList2.length,
                                (index) => list2(
                                  index,
                                  pickItemsCatIDList2[index],
                                  Colors.amber[600],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        buildFunctionDropDown(
                            context,
                            width,
                            height,
                            isEnglish
                                ? 'Functional Area'
                                : "कार्यात्मक क्षेत्र",
                            isEnglish ? 'Select' : "चुनें",
                            isEnglish
                                ? "Service Functional Area will define the Functional Area of your Services, in that Functional Area your Services will get listed. Example: Utility Software, E-fund Transfer Services etc."
                                : "सेवाएँ कार्यात्मक क्षेत्र आपकी सेवाओं के कार्यात्मक क्षेत्र को परिभाषित करेगा, उस कार्यात्मक क्षेत्र में आपकी सेवाएँ सूचीबद्ध होंगी। उदाहरण यूटिलिटी सॉफ्टवेयर, ई-फंड ट्रांसफर सर्विसेज आदि।"),
                        SizedBox(height: height * 0.02),
                        Container(
                          child: Wrap(
                            children: [
                              ...List.generate(
                                pickItemsCatIDList3.length,
                                (index) => list3(
                                    index,
                                    pickItemsCatIDList3[index],
                                    Colors.amber[600]),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        Container(
                          height: height * 0.05,
                          child: ElevatedButton(
                            onPressed: () {
                              spCategoryIdsMain = categoryIdList.join(",");
                              if (categoryID == "") {
                                WebResponseExtractor.showToast(
                                    'Please select Category');
                              } else if (subCategoryID == "") {
                                WebResponseExtractor.showToast(
                                    'Please select Sub Category');
                              } else if (fallId == "") {
                                WebResponseExtractor.showToast(
                                    'Please select Functional Area');
                              } else {
                                addProduct();
                                // Navigator.of(context)
                                //     .pushNamed('/service_details');
                                Navigator.of(context).pushNamed('/skills');
                              }
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryDropDown(BuildContext context, double width,
      double height, String heading, String hintText, String info) {
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
              width: width * 0.63,
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
                    subCategoryList.clear();
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

  Widget buildSubCategoryDropDown(BuildContext context, double width,
      double height, String heading, String hintText, String info) {
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
              width: width * 0.63,
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
                    functionList.clear();
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

  Widget buildFunctionDropDown(BuildContext context, double width,
      double height, String heading, String hintText, String info) {
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
              width: width * 0.63,
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

  Widget list1(int item, String txt, Color clr) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: height * 0.04,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: clr,
          ),
          padding: EdgeInsets.only(left: width * 0.04),
          width: width * 0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.58,
                child: Text(
                  txt,
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
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
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
      ],
    );
  }

  Widget list2(int item, String txt, Color clr) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: height * 0.04,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: clr,
          ),
          padding: EdgeInsets.only(left: width * 0.04),
          width: width * 0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.58,
                child: Text(
                  txt,
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
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
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
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

  void addProduct() async {
    Map data = {
      "user_id": userIdMain,
      "service_id": serviceId,
      "mst_del_category_id": categoryIdList.join(","),
      "mst_del_sub_category_id": subCategoryIdList.join(","),
      "mst_del_fun_category_id": fallIdList.join(","),
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.SERVICE_CATEGORY),
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
        serviceId = jsonData["SERVICE_ID"];
        print(serviceId);
      }
      WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
    }
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
    // if (loadService == true) {
    getServiceDetail();
    // }
  }

  Future<Null> getCategoriesFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        categoryList.add(new DropDown(category["id"],
            isEnglish ? category["name"] : category["name_hindi"]));
      }
    });
  }

  void getSubCategory() async {
    Map mapData = {"deliverable_category_id": categoryIdList.join(",")};
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
    Map mapData = {"deliverable_sub_category_id": subCategoryIdList.join(",")};

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

  void getServiceDetail() async {
    Map mapData = {"service_id": serviceId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.VIEW_SERVICE),
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
          dataObject: "SERVICE_DETAILS");
      if (data["code"] == 1) {
        print(data["data"]);
        getServiceDetailFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getServiceDetailFromWeb(var jsonData) async {
    String newCategoryID = jsonData["mst_del_category_id"];
    String newSubCategoryID = jsonData["mst_del_sub_category_id"];
    String newFunctionalCategoryID = jsonData["mst_del_fun_category_id"];
    List<int> newCatIdsList = [];
    List<int> newSubCatIdsList = [];
    List<int> newFunIdsList = [];

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
      newSubCatIdsList = newSubCategoryID.split(",").map(int.parse).toList();
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

class DropDown {
  String ID;
  String NAME;
  DropDown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
