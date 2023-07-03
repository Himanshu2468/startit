import 'package:flutter/material.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotUderId extends StatefulWidget {
  @override
  _ForgotUderIdState createState() => _ForgotUderIdState();
}

class _ForgotUderIdState extends State<ForgotUderId> {
  Dropdown securityQuestionDropDown;
  List<Dropdown> securityQuestionList = [];
  String securityQuestion = "";
  String securityQuestionID = "";
  TextEditingController createUserController = TextEditingController();
  TextEditingController createUserController2 = TextEditingController();

  void initState() {
    super.initState();
    getSecurityQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.1,
            vertical: height * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.08,
                width: width * 0.4,
                child: Image.asset("assets/images/startitsplash2.PNG"),
              ),
              SizedBox(
                height: height * 0.07,
              ),
              Text(
                "Find Email Id",
                textScaleFactor: 1,
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.05),
              Text.rich(
                TextSpan(
                  text: 'Mobile Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                width: width * 0.8,
                child: TextFormField(
                  controller: createUserController2,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    counter: SizedBox(),
                    contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                    hintText: 'Enter Mobile number',
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text.rich(
                TextSpan(
                  text: 'Security Question',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                width: width * 0.8,
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
                  child: DropdownButton<Dropdown>(
                    icon: Icon(Icons.arrow_drop_down),
                    hint: Text(
                      "Security Question",
                      textScaleFactor: 1,
                    ),
                    value: securityQuestionDropDown,
                    isDense: true,
                    iconSize: 35,
                    isExpanded: true,
                    underline: SizedBox(),
                    onChanged: (Dropdown _value) {
                      setState(() {
                        securityQuestionDropDown = _value;
                        securityQuestion = securityQuestionDropDown.NAME;
                        securityQuestionID = securityQuestionDropDown.ID;
                      });
                    },
                    items: securityQuestionList.map((Dropdown category) {
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text.rich(
                TextSpan(
                  text: 'Answer',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                width: width * 0.8,
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: createUserController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                    hintText: 'Answer',
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
              ),
              SizedBox(height: height * 0.08),
              Center(
                child: Container(
                  height: height * 0.06,
                  width: width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      if (createUserController2.text.trim().isEmpty)
                        WebResponseExtractor.showToast(
                            "Please Enter Mobile Number");
                      else if (createUserController2.text.length != 10) {
                        WebResponseExtractor.showToast(
                            'Please Enter a Valid Mobile Number');
                      } else if (int.parse(createUserController2.text[0]) !=
                              6 &&
                          int.parse(createUserController2.text[0]) != 7 &&
                          int.parse(createUserController2.text[0]) != 8 &&
                          int.parse(createUserController2.text[0]) != 9) {
                        WebResponseExtractor.showToast(
                            'Please Enter a Valid Mobile Number');
                      } else if (securityQuestion == "" &&
                          securityQuestionID == "") {
                        WebResponseExtractor.showToast(
                            'Please Select a Security Question');
                      } else if (createUserController.text.trim().isEmpty)
                        WebResponseExtractor.showToast("Please Enter Answer");
                      else
                        forgotUser();
                    },
                    child: Text(
                      'Save',
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void forgotUser() async {
    Map data = {
      "mobile": createUserController2.text,
      "que_answer": createUserController.text,
      "mst_sec_que_id": int.parse(securityQuestionID)
    };
    final response = await http.post(
      Uri.parse(WebApis.FORGOT_USER_ID),
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
        Navigator.of(context).pushNamed('/login');
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    } else
      WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
  }

  void getSecurityQuestion() async {
    final response = await http.post(
      Uri.parse(WebApis.SECURITY_QUESTION),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      Map data =
          WebResponseExtractor.filterWebData(response, dataObject: "LIST");
      if (data["code"] == 1) {
        getsecurityQuestionFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getsecurityQuestionFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        securityQuestionList
            .add(new Dropdown(category["id"], category["name"]));
      }
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
