import 'package:flutter/material.dart';
import 'package:startit/main.dart';
import 'package:startit/src/screens/dashboard.dart';
import '../services/WebResponseExtractor.dart';
import '../services/WebApis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProviderSkills extends StatefulWidget {
  @override
  _ProductProviderSkillsState createState() => _ProductProviderSkillsState();
}

class _ProductProviderSkillsState extends State<ProductProviderSkills> {
  Dropdown skillsDropDown;
  List<Dropdown> skillsList = [];
  String skills = "";
  String skillsID = "";
  List skillsIdList = [];
  List<String> runningBusinessCatIDList = [];

  TextEditingController messageController = TextEditingController();
  TextEditingController differenceController = TextEditingController();
  int count = 0;
  @override
  void initState() {
    super.initState();
    getSkills();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          isEnglish ? "Skills" : "कौशल",
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
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            padding: EdgeInsets.all(width * 0.1),
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: width * 0.7,
                        child: Text(
                          isEnglish ? "Add Your Skills" : "अपना कौशल जोड़ें",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                        width: width * 0.7,
                        child: Text(
                          isEnglish
                              ? 'This section will show your uniqueness over competitors'
                              : "यह खंड प्रतिस्पर्धियों पर आपकी विशिष्टता दिखाएगा",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                                  count = 1;
                                });
                                if (!skillsIdList.contains(skillsID)) {
                                  skillsIdList.add(skillsID);
                                }
                                if (!runningBusinessCatIDList
                                    .contains(skills)) {
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
                    Container(
                      child: Wrap(
                        children: [
                          ...List.generate(
                            runningBusinessCatIDList.length,
                            (index) => list3(
                              index,
                              context,
                              runningBusinessCatIDList[index],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.018),
                    //list3(context, 'User Interface', Colors.blue, 0.45),
                    SizedBox(height: height * 0.04),
                    buildTextField3(
                        context,
                        width,
                        height,
                        messageController,
                        isEnglish
                            ? 'Message For Idea person/Customers'
                            : "आइडिया व्यक्ति/ग्राहकों के लिए संदेश",
                        isEnglish ? 'Write your message' : "अपना संदेश लिखें",
                        true,
                        ""),
                    SizedBox(height: height * 0.03),
                    buildTextField3(
                        context,
                        width,
                        height,
                        differenceController,
                        isEnglish
                            ? 'How are your product/service different?'
                            : "आपके उत्पाद/सेवाएं किस प्रकार भिन्न हैं?",
                        isEnglish ? 'Write your answer' : "अपना जबाब लिखें",
                        false,
                        " *"),
                    SizedBox(height: height * 0.05),
                    Container(
                      height: height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {
                          if (skills == "" && skillsID == "") {
                            WebResponseExtractor.showToast(
                                'Please select skills'); /////
                          } else if (differenceController.text.trim().isEmpty) {
                            WebResponseExtractor.showToast(
                                "Please write how are your product/service is different");
                          } else {
                            // Navigator.of(context).pushNamed('/dashboard',
                            String q = "/product_provider";
                            //     arguments: "/product_provider");
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     Dashboard(q), (Route<dynamic> route) => false);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Dashboard("/product_provider")),
                                (Route<dynamic> route) => false);
                            addSkills();
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
        ),
      ),
    );
  }

  Widget buildTextField3(
      BuildContext context,
      double width,
      double height,
      TextEditingController controller,
      String heading,
      String hint,
      bool first,
      String mandatory) {
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
              ]),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          maxLines: 3,
          controller: controller,
          decoration: InputDecoration(
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

  void addSkills() async {
    Map data = {
      "user_id": userIdMain,
      "product_id": productId,
      "skills": skillsIdList.join(","),
      "message_for_idea_person": messageController.text,
      "how_product_different": differenceController.text,
    };
    print(data);
    final response = await http.post(Uri.parse(WebApis.ADD_PRODUCT_SKILLS),
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        });
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      if (jsonData["RETURN_CODE"] == 1) {
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
  }

  Color selectedColour(int position) {
    Color c;
    if (position % 3 == 0) c = Colors.amber[700];
    if (position % 3 == 1) c = Colors.red[600];
    if (position % 3 == 2) c = Colors.blue[600];
    return c;
  }

  Widget list3(int item, BuildContext context, String txt) {
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

  void getSkills() async {
    Map mapData = {
      "category_id": ppCategoryIdsMain,
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

    // if (loadedProduct == true) {
    getCapabilitiesData();
    // }
  }

  void getCapabilitiesData() async {
    Map mapData = {"product_id": productId};

    final response = await http.post(
      Uri.parse(WebApis.VIEW_SINGLE_PRODUCT),
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
            dataObject: "SERVICE_DETAILS");
        Map data1 = WebResponseExtractor.filterWebData(response,
            dataObject: "BROCHURE_MEDIA");
        Map data2 = WebResponseExtractor.filterWebData(response,
            dataObject: "SERVICE_MEDIA");

        var userData = data["data"];

        setState(
          () {
            if (userData["message_for_idea_person"] != null)
              messageController.text = userData["message_for_idea_person"];
            if (userData["how_product_different"] != null)
              differenceController.text = userData["how_product_different"];
            if (userData["skills"] != null) {
              String newSkillsIds = userData["skills"];

              List<int> newSkillsIdsList = [];

              if (newSkillsIds != "") {
                newSkillsIdsList =
                    newSkillsIds.split(",").map(int.parse).toList();

                for (int newSkillID in newSkillsIdsList) {
                  skillsDropDown = skillsList
                      .firstWhere((s) => s.id == newSkillID.toString());
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
            }
          },
        );
      }
    }
  }
}

class Dropdown {
  String ID;
  String NAME;
  Dropdown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
