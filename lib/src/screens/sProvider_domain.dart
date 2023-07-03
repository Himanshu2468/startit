import 'package:flutter/material.dart';
import 'package:startit/main.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceProviderDomain extends StatefulWidget {
  @override
  _ServiceProviderDomainState createState() => _ServiceProviderDomainState();
}

class _ServiceProviderDomainState extends State<ServiceProviderDomain> {
  String bulbColor = "";

  Dropdown domainDropDown;
  List<Dropdown> domainList = [];
  String domain = "";
  String domainID = "";

  List domainIdList = [];

  List<String> runningBusinessCatIDList = [];

  String availabilityRadio = "";

  void initState() {
    getDomain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: Colors.blue,
      //drawer: Drawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          isEnglish ? 'Domain' : "डोमेन",
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        width: width,
        color: Colors.blue,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          padding: EdgeInsets.all(width * 0.13),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    isEnglish ? 'Domain' : "डोमेन",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                Text.rich(
                  TextSpan(
                    text: isEnglish
                        ? 'Select domain for services'
                        : "सेवाओं के लिए डोमेन चुनें",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Container(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<Dropdown>(
                    hint: Text(
                      isEnglish ? 'Select' : "चुनें",
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    icon: Icon(Icons.expand_more),
                    iconSize: 30,
                    focusColor: Colors.blue,
                    isExpanded: true,
                    underline: SizedBox(),
                    value: domainDropDown,
                    onChanged: (Dropdown _value) {
                      setState(() {
                        domainDropDown = _value;
                        domain = domainDropDown.NAME;
                        domainID = domainDropDown.ID;
                      });
                      if (!domainIdList.contains(domainID)) {
                        domainIdList.add(domainID);
                      }
                      if (!runningBusinessCatIDList.contains(domain)) {
                        runningBusinessCatIDList.add(domain);
                      }
                    },
                    items: domainList.map((Dropdown category) {
                      return DropdownMenuItem<Dropdown>(
                        value: category,
                        child: Text(
                          category.NAME,
                          textScaleFactor: 1,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: height * 0.02),
                // list(context, 'Domain A', Colors.amber[600]),
                // SizedBox(height: height * 0.02),
                // list(context, 'Domain B', Colors.blue),
                Container(
                  child: Wrap(
                    children: [
                      ...List.generate(
                        runningBusinessCatIDList.length,
                        (index) => list(
                          index,
                          context,
                          runningBusinessCatIDList[index],
                          Colors.amber[600],
                          // 0.3,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),
                Text(
                  isEnglish ? "Your Availability" : "आपकी उपलब्धता",
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.orange,
                          value: "1",
                          groupValue: bulbColor,
                          onChanged: (val) {
                            bulbColor = val;
                            setState(() {
                              availabilityRadio = 'Full Time';
                            });
                          },
                        ),
                        Text(
                          isEnglish ? 'Full Time' : "पूरा समय",
                          textScaleFactor: 1,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.orange,
                          value: "2",
                          groupValue: bulbColor,
                          onChanged: (val) {
                            bulbColor = val;
                            setState(() {
                              availabilityRadio = 'Part Time';
                            });
                          },
                        ),
                        Text(
                          isEnglish ? "Part Time" : "पार्ट टाईम",
                          textScaleFactor: 1,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.orange,
                          value: "3",
                          groupValue: bulbColor,
                          onChanged: (val) {
                            bulbColor = val;
                            setState(() {
                              availabilityRadio = 'Only available for weekend';
                            });
                          },
                        ),
                        Text(
                          isEnglish
                              ? "Only available for weekends"
                              : "केवल सप्ताहांत के लिए उपलब्ध",
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04),
                Container(
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/sproduct_detail');
                      Navigator.of(context).pushNamed('/service_details');
                      domainApi();
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

  Widget list(int item, BuildContext context, String txt, Color clr) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    runningBusinessCatIDList
                        .remove(runningBusinessCatIDList[item]);
                    domainIdList.remove(domainIdList[item]);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 4.0),
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

  void getDomain() async {
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
      //final jsonData = jsonDecode(response.body) as Map;

      if (data["code"] == 1) {
        getDomainFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getDomainFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        domainList.add(
          new Dropdown(
            category["id"],
            isEnglish ? category["name"] : category["name_hindi"],
          ),
        );
      }
    });
    // if (loadService == true) {
    getServiceDetail();
    // }
  }

  void domainApi() async {
    Map data = {
      "user_id": userIdMain,
      "sp_id": spId,
      "service_id": serviceId,
      "availability": availabilityRadio,
      "mst_service_domain_id": domainIdList.join(","),
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.ADD_DOMAIN),
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
        print(jsonData);
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
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
    String newDomainIds = jsonData["mst_domain_id"];
    List<int> newDomainIdsList = [];

    if (newDomainIds != "") {
      newDomainIdsList = newDomainIds.split(",").map(int.parse).toList();

      for (int newDomainID in newDomainIdsList) {
        domainDropDown =
            domainList.firstWhere((d) => d.id == newDomainID.toString());
        domain = domainDropDown.NAME;
        domainID = domainDropDown.ID;
        if (!domainIdList.contains(newDomainID)) {
          domainIdList.add(newDomainID);
        }
        if (!runningBusinessCatIDList.contains(domain)) {
          runningBusinessCatIDList.add(domain);
        }
      }
      String availability = jsonData["availability"];
      if (availability.contains("Full") || availability.contains("full")) {
        bulbColor = "1";
        availabilityRadio = 'Full Time';
      } else if (availability.contains("Part") ||
          availability.contains("part")) {
        bulbColor = "2";
        availabilityRadio = 'Part Time';
      } else if (availability.contains("Weekend") ||
          availability.contains("weekend")) {
        bulbColor = "3";
        availabilityRadio = 'Only available for weekend';
      }
    }
    setState(() {});
  }
}

class Dropdown {
  String ID;
  String NAME;
  Dropdown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
