import 'package:flutter/material.dart';

import 'package:startit/main.dart';

import 'dart:convert';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;

class AddResource extends StatefulWidget {
  static const routeName = "/add_resources";
  @override
  _AddResourceState createState() => _AddResourceState();
}

class _AddResourceState extends State<AddResource> {
  TextEditingController remarksController = TextEditingController();

  List<DropDown> resourceList = [];
  DropDown resourceDropDown;
  String resourceName = "";
  String resourceID = "";

  List domainIdList = [];

  List<String> runningBusinessCatIDList = [];
  String rci;

  void initState() {
    super.initState();
    getResources();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        // backgroundColor: Colors.blue,
        //drawer: Drawer(),
        appBar: AppBar(
          toolbarHeight: height * 0.1,
          elevation: 0,
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            isEnglish ? "Resource Requirement" : 'संसाधन की आवश्यकता',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
          color: Colors.blue,
          child: Container(
            height: double.maxFinite,
            width: width,
            padding: EdgeInsets.all(width * 0.12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnglish
                        ? 'Add Resource requirement for your idea'
                        : 'अपने आइडिया के लिए संसाधन आवश्यकता जोड़ें',
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.lightBlue, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: height * 0.03),
                  buildDropDown(
                    context,
                    width,
                    height,
                    isEnglish ? 'Select' : 'चुनें',
                  ),
                  SizedBox(height: height * 0.05),
                  Row(
                    children: [
                      Text(
                        isEnglish ? "Remarks" : 'टिप्पणियों',
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
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: TextFormField(
                      controller: remarksController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        focusColor: Colors.white70,
                        hintText: "example_123",

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
                  SizedBox(height: height * 0.05),
                  // Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        if (resourceName == "" && resourceID == "") {
                          WebResponseExtractor.showToast(
                              'Please select atleast one Resource Requirement'); /////
                        } else if (remarksController.text.trim().isEmpty) {
                          WebResponseExtractor.showToast(
                              'Please enter Remarks');
                        } else {
                          addResourceRequirement();
                          Navigator.of(context)
                              .pushNamed("/resource_parameters");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isEnglish
                                ? 'Save & Continue'
                                : 'सहेजें और जारी रखें',
                            textScaleFactor: 1,
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildDropDown(
    BuildContext context,
    double width,
    double height,
    String hintText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  isCollapsed: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10)),
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
                child: DropdownButton(
                    hint: Text(
                      isEnglish ? 'Select' : 'चुनें',
                      textScaleFactor: 1,
                    ),
                    iconSize: 30.0,
                    isExpanded: true,
                    underline: SizedBox(),
                    value: resourceDropDown,
                    onChanged: (DropDown _value) {
                      setState(() {
                        resourceDropDown = _value;
                        resourceName = _value.NAME;
                        resourceID = _value.ID;
                      });
                      if (!domainIdList.contains(resourceID)) {
                        domainIdList.add(resourceID);
                      }

                      if (!runningBusinessCatIDList.contains(resourceName)) {
                        runningBusinessCatIDList.add(resourceName);
                      }
                    },
                    items: resourceList.map((DropDown resource) {
                      return DropdownMenuItem<DropDown>(
                        value: resource,
                        child: Text(
                          resource.NAME,
                          textScaleFactor: 1,
                        ),
                      );
                    }).toList()),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                " *",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
        SizedBox(height: height * 0.015),
        Container(
          child: Wrap(
            children: [
              ...List.generate(
                runningBusinessCatIDList.length,
                (index) => list(index, runningBusinessCatIDList[index],
                    Colors.amber[600], width * 0.5, false),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget list(int item, String txt, Color clr, double width1, bool regu) {
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
          width: width1,
          child: Row(
            mainAxisAlignment:
                regu ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width1 * 0.6,
                child: Text(
                  txt,
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    //count--;
                    runningBusinessCatIDList
                        .remove(runningBusinessCatIDList[item]);
                    domainIdList.remove(domainIdList[item]);
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

  void getResources() async {
    Map data = {
      "category_id": categoryIDMain,
    };
    print(data);

    final response = await http.post(
      Uri.parse(WebApis.RESOURCES),
      body: json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "RESOUCE_REQUIREMEN");

      if (data["code"] == 1) {
        getResourcesFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getResourcesFromWeb(var jsonData) async {
    setState(() {
      for (Map resource in jsonData) {
        resourceList.add(new DropDown(resource["id"], resource["name"]));
      }
    });
    // if (loadedBip == true) {
    getData();
    // }
  }

  void addResourceRequirement() async {
    Map data = {
      "user_id": userIdMain,
      "bip_idea_id": bipIdeaId,
      // "mst_resource_requirement_id": resourceID,
      "mst_resource_requirement_id": domainIdList.join(","),
      "remarks": remarksController.text,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.ADD_BIP_RESOURCES),
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
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
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

        String newCategoryID = userData["mst_resource_requirement_id"];
        List<int> newCatIdsList = [];

        if (newCategoryID != "") {
          newCatIdsList = newCategoryID.split(",").map(int.parse).toList();
          for (int CatID in newCatIdsList) {
            resourceDropDown =
                resourceList.firstWhere((cat) => cat.id == CatID.toString());
            resourceName = resourceDropDown.NAME;
            resourceID = resourceDropDown.ID;
            if (!domainIdList.contains(CatID)) {
              domainIdList.add(CatID);
            }
            if (!runningBusinessCatIDList.contains(resourceName)) {
              runningBusinessCatIDList.add(resourceName);
            }
          }
        }

        setState(() {
          remarksController.text = userData["remarks"];
        });
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
