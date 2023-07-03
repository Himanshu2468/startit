import 'package:flutter/material.dart';
import 'package:startit/main.dart';
import 'package:startit/src/screens/dashboard.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceProviderSkills extends StatefulWidget {
  @override
  _ServiceProviderSkillsState createState() => _ServiceProviderSkillsState();
}

class _ServiceProviderSkillsState extends State<ServiceProviderSkills> {
  List<TextEditingController> createUserController = [
    for (int i = 0; i < 3; i++) TextEditingController()
  ];

  Dropdown skillsDropDown;
  List<Dropdown> skillsList = [];
  String skills = "";
  String skillsID = "";
  List skillsIdList = [];

  List<String> runningBusinessCatIDList = [];

  @override
  void initState() {
    super.initState();
    getSkills();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      //drawer: Drawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          isEnglish
              ? 'Add skills and certificate'
              : "कौशल और प्रमाणपत्र जोड़ें",
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
            padding: EdgeInsets.all(width * 0.13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.05,
                      width: width * 0.71,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4.0),
                          isCollapsed: true,
                          prefixIcon: Icon(Icons.search),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: Colors.grey[300],
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
                        child: DropdownButton(
                          hint: Text(
                            isEnglish
                                ? 'Search For Your Skills'
                                : "अपने कौशल की खोज करें",
                            textScaleFactor: 1,
                          ),
                          style: TextStyle(color: Colors.black),
                          iconSize: 0.0,
                          isExpanded: true,
                          underline: SizedBox(),
                          value: skillsDropDown,
                          onChanged: (_value) {
                            setState(() {
                              skillsDropDown = _value;
                              skills = skillsDropDown.NAME;
                              skillsID = skillsDropDown.ID;
                            });
                            if (!skillsIdList.contains(skillsID)) {
                              skillsIdList.add(skillsID);
                            }
                            if (!runningBusinessCatIDList.contains(skills)) {
                              runningBusinessCatIDList.add(skills);
                            }
                          },
                          items: skillsList.map((Dropdown skills) {
                            return DropdownMenuItem<Dropdown>(
                              value: skills,
                              child: Text(
                                skills.NAME,
                                textScaleFactor: 1,
                              ),
                            );
                          }).toList(),
                        ),
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
                SizedBox(height: height * 0.018),
                // Row(
                //   children: [
                //     list(context, 'C++', Colors.amber[600], 0.3),
                //     SizedBox(width: width * 0.025),
                //     list(context, 'Java', Colors.red, 0.3)
                //   ],
                // ),
                // SizedBox(height: height * 0.018),
                // list(context, 'User Interface', Colors.blue, 0.45),

                Container(
                  child: Wrap(
                    children: [
                      ...List.generate(
                        runningBusinessCatIDList.length,
                        (index) => list(
                          index,
                          context,
                          runningBusinessCatIDList[index],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height * 0.04),
                Text.rich(
                  TextSpan(
                    text: isEnglish ? 'Add Certificate' : "प्रमाणपत्र जोड़ें",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: createUserController.elementAt(0),
                  decoration: InputDecoration(
                    hintText: isEnglish ? 'Enter URL' : "यू आर एल दर्ज करे",
                    filled: true,
                    fillColor: Colors.grey[50],
                    focusColor: Colors.white70,
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
                SizedBox(height: height * 0.03),
                buildTextField(
                    context,
                    width,
                    height,
                    isEnglish
                        ? 'Message For Idea person/Customers'
                        : "आइडिया व्यक्ति/ग्राहकों के लिए संदेश",
                    isEnglish ? 'Write your message' : "अपना संदेश लिखें",
                    1,
                    ""),
                SizedBox(height: height * 0.03),
                buildTextField(
                    context,
                    width,
                    height,
                    isEnglish
                        ? 'How are your product/service different?'
                        : "आपकी सेवाएं/उत्पाद किस प्रकार भिन्न हैं?",
                    isEnglish ? 'Write your answer' : "अपना जबाब लिखें",
                    2,
                    " *"),
                SizedBox(height: height * 0.05),
                Container(
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      if (skills == "" && skillsID == "") {
                        WebResponseExtractor.showToast(
                            'Please select skills'); /////
                      } else if (createUserController
                          .elementAt(2)
                          .text
                          .trim()
                          .isEmpty) {
                        WebResponseExtractor.showToast(
                            "Please fill how your product/service is different");
                      } else {
                        // Navigator.of(context).pushNamed('/sproduct_detail');
                        // Navigator.of(context)
                        //     .pushNamed('/dashboard', arguments: "/domain");
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Dashboard("/domain")),
                            (Route<dynamic> route) => false);
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     '/dashboard', (Route<dynamic> route) => false,
                        //     arguments: "/domain");
                        createUser();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isEnglish ? 'Save & Continue' : "सहेजें और जारी रखें",
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.white, fontSize: 15),
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
      ),
    );
  }

  Widget buildTextField(BuildContext context, double width, double height,
      String heading, String hint, int i, String mandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: heading,
            style: TextStyle(fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: mandatory,
                style: TextStyle(color: Colors.red[700]),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: createUserController.elementAt(i),
          maxLines: 4,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.symmetric(
            //     vertical: width * 0.1, horizontal: width * 0.022),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            focusColor: Colors.white70,
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

  Color selectedColour(int position) {
    Color c;
    if (position % 3 == 0) c = Colors.amber[700];
    if (position % 3 == 1) c = Colors.red[600];
    if (position % 3 == 2) c = Colors.blue[600];
    return c;
  }

  Widget list(int item, BuildContext context, String txt) {
    Color tileColor = selectedColour(item);

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: tileColor,
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: width * 0.55,
              child: Text(
                txt,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(width: 4.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  runningBusinessCatIDList
                      .remove(runningBusinessCatIDList[item]);
                  skillsIdList.remove(skillsIdList[item]);
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
    );
  }

  void createUser() async {
    Map data = {
      "user_id": userIdMain,
      "service_id": serviceId,
      "skills_ids": skillsIdList.join(","),
      "certificate_url": createUserController.elementAt(0).text,
      "message_for_idea_person": createUserController.elementAt(1).text,
      "how_service_different": createUserController.elementAt(2).text,
    };

    final response = await http.post(
      Uri.parse(WebApis.ADD_SERVICE_SKILLS),
      body: json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
  }

  void getSkills() async {
    Map mapData = {
      "category_id": spCategoryIdsMain,
    };
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.SKILLS),
      body: json.encode(mapData),
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
        getskillsFromWeb(data["data"]);
      }
    }

    // if (loadService == true) {
    getServiceDetail();
    // }
  }

  Future<Null> getskillsFromWeb(var jsonData) async {
    setState(() {
      for (Map skill in jsonData) {
        skillsList.add(
          new Dropdown(
            skill["id"],
            isEnglish ? skill["name"] : skill["hindi"],
          ),
        );
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
    String newSkillsIds = jsonData["skills"];
    List<int> newSkillsIdsList = [];

    if (newSkillsIds != "") {
      newSkillsIdsList = newSkillsIds.split(",").map(int.parse).toList();

      for (int newSkillID in newSkillsIdsList) {
        skillsDropDown =
            skillsList.firstWhere((s) => s.id == newSkillID.toString());
        skills = skillsDropDown.NAME;
        skillsID = skillsDropDown.ID;
        if (!skillsIdList.contains(newSkillID)) {
          skillsIdList.add(newSkillID);
        }
        if (!runningBusinessCatIDList.contains(skills)) {
          runningBusinessCatIDList.add(skills);
        }
      }
    }
    setState(() {
      createUserController.elementAt(0).text = jsonData["certificate_url"];
      createUserController.elementAt(1).text =
          jsonData["message_for_idea_person"];
      createUserController.elementAt(2).text =
          jsonData["how_product_different"];
    });
  }
}

class Dropdown {
  String ID;
  String NAME;
  Dropdown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
