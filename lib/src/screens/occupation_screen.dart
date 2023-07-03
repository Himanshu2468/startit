import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../main.dart';

class OccupationScreen extends StatefulWidget {
  @override
  _OccupationScreenState createState() => _OccupationScreenState();
}

class _OccupationScreenState extends State<OccupationScreen> {
  int screenNo = 0;

  String text1 = "We will be grateful to know your occupation";

  Dropdown employmentTypeDropDown;
  List<Dropdown> employmentTypeList = [];
  String employmentTypeID = '';
  String employment = '';

  Dropdown tradeDropDown;
  List<Dropdown> tradeList = [];
  String tradeTypeID = '';
  String trade = '';

  Dropdown businessDropDown;
  List<Dropdown> businessList = [];
  String businessTypeID = '';
  String business1 = '';

  Dropdown natureOfWork;
  List<Dropdown> natureOfWorkList = [];
  String nOfWork = '';
  String nOfWorkID = '';

  TextEditingController createUserController1 = TextEditingController();
  TextEditingController createUserController2 = TextEditingController();
  TextEditingController createUserController3 = TextEditingController();

  String jobRadio = "";
  String tradeRadio = "";
  String natureRadio = "";
  String businessRadio = "";

  void initState() {
    super.initState();
    getEmploymentType();
    getTrade();
    getNatureOfWork();
    getBusiness();
    // print(emailMain);
    getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    String move = ModalRoute.of(context).settings.arguments as String;
    String move1 = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      if (move1 == "/occupation") {
        move1 = "/add_modify";
      }
    });
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          isEnglish ? "Occupation" : 'व्यवसाय',
          textScaleFactor: 1,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            padding: EdgeInsets.all(width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (screenNo == 0)
                  headingSelected(
                      isEnglish
                          ? 'We will be grateful to know your occupation'
                          : 'आपका पेशा जानने के लिए हम आभारी होंगे',
                      true),
                if (screenNo == 1)
                  headingSelected(
                      isEnglish
                          ? 'Great to know you do job and want to start your passion here, we are happy'
                          : 'यह जानकर बहुत अच्छा लगा कि आप नौकरी करते हैं और यहां अपना जुनून शुरू करना चाहते हैं, हम खुश हैं',
                      false),
                if (screenNo == 2)
                  headingSelected(
                      isEnglish
                          ? 'Great to know you do study and want to start your passion here, we are happy'
                          : 'यह जानकर बहुत अच्छा लगा कि आप अध्ययन करते हैं और यहां अपना जुनून शुरू करना चाहते हैं, हम खुश हैं',
                      false),
                if (screenNo == 3)
                  headingSelected(
                      isEnglish
                          ? 'Great to know you are self-employed and want to start your passion here, we are happy'
                          : 'यह जानकर बहुत अच्छा लगा कि आप स्व-नियोजित हैं और यहां अपना जुनून शुरू करना चाहते हैं, हम खुश हैं',
                      false),
                if (screenNo == 4)
                  headingSelected(
                      isEnglish
                          ? "Great to know you have a business man , Lets start your journey"
                          : 'यह जानकर बहुत अच्छा लगा कि आप बिजनेस मैन हैं और यहां अपना जुनून शुरू करना चाहते हैं, हम खुश हैं',
                      false),
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  isEnglish ? "Select Your Occupation" : 'अपना व्यवसाय चुनें',
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.orange,
                            value: 1,
                            groupValue: screenNo,
                            onChanged: (val) {
                              setState(() {
                                screenNo = val;
                                jobRadio = 'Job';
                              });
                            }),
                        Text(
                          isEnglish ? "Job" : 'काम',
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.orange,
                            value: 2,
                            groupValue: screenNo,
                            onChanged: (val) {
                              setState(() {
                                screenNo = val;
                                tradeRadio = 'Student';
                              });
                            }),
                        Text(
                          isEnglish ? "Student" : 'छात्र',
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.orange,
                            value: 3,
                            groupValue: screenNo,
                            onChanged: (val) {
                              setState(() {
                                screenNo = val;
                                natureRadio = 'Self Employed';
                              });
                            }),
                        Text(
                          isEnglish ? "Self Employed" : 'स्व नियोजित',
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            activeColor: Colors.orange,
                            value: 4,
                            groupValue: screenNo,
                            onChanged: (val) {
                              setState(() {
                                screenNo = val;
                                businessRadio = 'Business';
                              });
                            }),
                        Text(
                          isEnglish ? "Business" : 'व्यापार',
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (screenNo == 1) job(height, move, move1),
                if (screenNo == 2) student(height, move, move1),
                if (screenNo == 3) selfEmployed(height, move, move1),
                if (screenNo == 4) business(height, move, move1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text headingSelected(String heading, bool center) {
    return Text(
      heading,
      textScaleFactor: 1,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: TextStyle(
          color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w700),
    );
  }

  Widget job(double height, String move, String move1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Job Title' : 'नौकरी का नाम',
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
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: createUserController1,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            focusColor: Colors.white70,
            hintText: 'example_123',
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
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Employment Type' : 'रोजगार के प्रकार',
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
        SizedBox(height: height * 0.02),
        Center(
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
                hint: Text(
                  'Select',
                  textScaleFactor: 1,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 35,
                isExpanded: true,
                value: employmentTypeDropDown,
                underline: SizedBox(),
                onChanged: (Dropdown newValue) {
                  setState(() {
                    employmentTypeDropDown = newValue;
                    employment = employmentTypeDropDown.NAME;
                    employmentTypeID = employmentTypeDropDown.ID;
                  });
                },
                items: employmentTypeList.map((Dropdown valueItem) {
                  return DropdownMenuItem<Dropdown>(
                    value: valueItem,
                    child: Text(
                      valueItem.NAME,
                      textScaleFactor: 1,
                    ),
                  );
                }).toList()),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (createUserController1.text.trim().isEmpty) {
              WebResponseExtractor.showToast('Please Enter Job Title');
            } else if (employmentTypeID == "") {
              WebResponseExtractor.showToast('Please select Employment Type');
            } else {
              jobApi(move);

              Navigator.of(context).pushNamed(move1);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  Widget student(double height, String move, String move1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Trade' : 'व्यापार',
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
        SizedBox(height: height * 0.02),
        Center(
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
              hint: Text(
                'Select',
                textScaleFactor: 1,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 35,
              isExpanded: true,
              underline: SizedBox(),
              value: tradeDropDown,
              onChanged: (Dropdown _value) {
                setState(() {
                  tradeDropDown = _value;
                  trade = tradeDropDown.NAME;
                  tradeTypeID = tradeDropDown.ID;
                });
              },
              items: tradeList.map((Dropdown valueItem) {
                return DropdownMenuItem<Dropdown>(
                  value: valueItem,
                  child: Text(
                    valueItem.NAME,
                    textScaleFactor: 1,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? "University or School" : 'विश्वविद्यालय या स्कूल',
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
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: createUserController2,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            focusColor: Colors.white70,
            hintText: 'Enter your University',
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
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (tradeTypeID == "") {
              WebResponseExtractor.showToast('Please select Trade');
            } else if (createUserController2.text.isEmpty) {
              WebResponseExtractor.showToast('Please Enter University/School');
            } else {
              tradeApi(move);
              Navigator.of(context).pushNamed(move1);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  Widget selfEmployed(double height, String move, String move1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Work Title' : 'कार्य शीर्षक',
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
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: createUserController3,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            focusColor: Colors.white70,
            hintText: 'example_123',
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
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Nature of Work' : 'कार्य की प्रकृति',
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
        SizedBox(height: height * 0.02),
        Center(
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
              hint: Text(
                'Select',
                textScaleFactor: 1,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 35,
              isExpanded: true,
              value: natureOfWork,
              underline: SizedBox(),
              onChanged: (Dropdown newValue) {
                setState(() {
                  natureOfWork = newValue;
                  nOfWork = natureOfWork.NAME;
                  nOfWorkID = natureOfWork.ID;
                });
              },
              items: natureOfWorkList.map(
                (Dropdown valueItem) {
                  return DropdownMenuItem<Dropdown>(
                    value: valueItem,
                    child: Text(
                      valueItem.NAME,
                      textScaleFactor: 1,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (createUserController3.text.isEmpty) {
              WebResponseExtractor.showToast('Please Enter Work Title');
            } else if (nOfWorkID == '') {
              WebResponseExtractor.showToast('Please select Nature of Work');
            } else {
              natureApi(move);
              Navigator.of(context).pushNamed(move1);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  Widget business(double height, String move, String move1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? 'Type of Business' : 'व्यापार के प्रकार',
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
        SizedBox(height: height * 0.02),
        Center(
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
              hint: Text(
                'Select',
                textScaleFactor: 1,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 35,
              isExpanded: true,
              underline: SizedBox(),
              value: businessDropDown,
              onChanged: (Dropdown _value) {
                setState(() {
                  businessDropDown = _value;
                  business1 = businessDropDown.NAME;
                  businessTypeID = businessDropDown.ID;
                });
              },
              items: businessList.map((Dropdown valueItem) {
                return DropdownMenuItem<Dropdown>(
                  value: valueItem,
                  child: Text(
                    valueItem.NAME,
                    textScaleFactor: 1,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (businessTypeID == "") {
              WebResponseExtractor.showToast('Please select Type of Business');
            } else {
              businessApi(move);
              Navigator.of(context).pushNamed(move1);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
  }

  void jobApi(String move) async {
    if (move == "/occupation") {
      Map data = {
        "bip_id": bipId,
        "what_do_you_do": jobRadio,
        "job_title": createUserController1.text,
        "mst_employement_type_id": int.parse(employmentTypeID),
      };
      print(data);
      final response = await http.post(
        Uri.parse(WebApis.ADD_BIP_FINAL),
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
          print(jsonData);
          WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        }
      }
    } else if (move == "/domain") {
      Map data = {
        "what_do_you_do": jobRadio,
        "job_title": createUserController1.text,
        "mst_employement_type_id": int.parse(employmentTypeID),
        "sp_id": spId,
        "user_id": userIdMain,
      };
      print(data);
      final response = await http.post(
        Uri.parse(WebApis.APP_SP_FINAL),
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
          print(jsonData);
          WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        }
      }
    }
  }

  void tradeApi(String move) async {
    print(move);
    if (move == "/occupation") {
      Map data = {
        "bip_id": bipId,
        "what_do_you_do": tradeRadio,
        "mst_trade_id": int.parse(tradeTypeID),
        "university_or_school_name": createUserController2.text,
      };
      print(data);
      final response = await http.post(
        Uri.parse(WebApis.ADD_BIP_FINAL),
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
          print(jsonData);
        }
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    } else if (move == "/domain") {
      Map data = {
        "what_do_you_do": tradeRadio,
        "sp_id": spId,
        "user_id": userIdMain,
        "mst_trade_id": int.parse(tradeTypeID),
        "university_or_school_name": createUserController2.text,
      };

      final response = await http.post(
        Uri.parse(WebApis.APP_SP_FINAL),
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
          print(jsonData);
        }
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
  }

  void businessApi(String move) async {
    if (move == "/occupation") {
      Map data = {
        "what_do_you_do": businessRadio,
        "bip_id": bipId,
        "mst_occupation_business_id": int.parse(businessTypeID),
      };

      final response = await http.post(
        Uri.parse(WebApis.ADD_BIP_FINAL),
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
          print(jsonData);
        }
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    } else if (move == "/domain") {
      Map data = {
        "what_do_you_do": businessRadio,
        "sp_id": spId,
        "mst_occupation_business_id": int.parse(businessTypeID),
      };
      print(data);
      final response = await http.post(
        Uri.parse(WebApis.APP_SP_FINAL),
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map;

        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
  }

  void natureApi(String move) async {
    if (move == "/occupation") {
      Map data = {
        "bip_id": bipId,
        "what_do_you_do": natureRadio,
        "work_title": createUserController3.text,
        "mst_nature_of_work_id": int.parse(nOfWorkID),
      };

      final response = await http.post(
        Uri.parse(WebApis.ADD_BIP_FINAL),
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map;

        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    } else if (move == "/domain") {
      Map data = {
        "what_do_you_do": natureRadio,
        "work_title": createUserController3.text,
        "sp_id": spId,
        "user_id": userIdMain,
        "mst_nature_of_work_id": int.parse(nOfWorkID),
      };

      final response = await http.post(
        Uri.parse(WebApis.APP_SP_FINAL),
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map;

        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    }
  }

  void getEmploymentType() async {
    final response = await http.post(
      Uri.parse(WebApis.EMPLOYMENT_TYPE),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "EMPLOYEEMENT_TYPE_MASTER");

      if (data["code"] == 1) {
        getEmploymentTypeFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getEmploymentTypeFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        employmentTypeList.add(new Dropdown(category["id"], category["name"]));
      }
    });
  }

  void getTrade() async {
    final response = await http.post(
      Uri.parse(WebApis.TRADE),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "TRADE_MASTER");

      if (data["code"] == 1) {
        getTradeFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getTradeFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        tradeList.add(new Dropdown(category["id"], category["name"]));
      }
    });
  }

  void getBusiness() async {
    final response = await http.post(
      Uri.parse(WebApis.BUSINESS),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "BUSINESS_DOMAIN");

      if (data["code"] == 1) {
        await getBusinessFromWeb(data["data"]);
        getProfileData();
      }
    }
  }

  Future<Null> getBusinessFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        businessList.add(new Dropdown(category["id"], category["name"]));
      }
    });
  }

  void getNatureOfWork() async {
    final response = await http.post(
      Uri.parse(WebApis.SELECT_NATURE_WORK),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "NATURE_OF_WORK");

      if (data["code"] == 1) {
        getNatureOfWorkFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getNatureOfWorkFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        natureOfWorkList.add(new Dropdown(category["id"], category["name"]));
      }
    });
  }

  void getProfileData() async {
    Map mapData = {"user_id": userIdMain};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.VIEW_PROFILE),
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
        Map data =
            WebResponseExtractor.filterWebData(response, dataObject: "DETAILS");
        var userData = data["data"];
        print(userData);

        setState(() {
          String occupation = userData["what_do_you_do"] != null
              ? userData["what_do_you_do"]
              : "";

          if (occupation == "Job") {
            screenNo = 1;
            jobRadio = 'Job';
            employmentTypeID = userData["mst_employement_type_id"];
            employmentTypeDropDown = employmentTypeList
                .firstWhere((element) => element.ID == employmentTypeID);
            employment = employmentTypeDropDown.NAME;
            createUserController1.text = userData["job_title"];
          }

          if (occupation == "Student") {
            screenNo = 2;
            tradeRadio = 'Student';
            tradeTypeID = userData["mst_trade_id"];
            tradeDropDown =
                tradeList.firstWhere((element) => element.ID == tradeTypeID);
            trade = tradeDropDown.NAME;
            createUserController2.text = userData["university_or_school_name"];
          }

          if (occupation == "Self Employed") {
            screenNo = 3;
            natureRadio = 'Self Employed';
            nOfWorkID = userData["mst_nature_of_work_id"];
            natureOfWork = natureOfWorkList
                .firstWhere((element) => element.ID == nOfWorkID);
            nOfWork = natureOfWork.NAME;
            createUserController3.text = userData["work_title"];
          }

          if (occupation == "Business") {
            screenNo = 4;
            businessRadio = 'Business';
            businessTypeID = userData["mst_occupation_business_id"];
            print(businessTypeID);
            // print(businessList);
            businessDropDown = businessList
                .firstWhere((element) => element.ID == businessTypeID);
            business1 = businessDropDown.NAME;
          }
        });
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
