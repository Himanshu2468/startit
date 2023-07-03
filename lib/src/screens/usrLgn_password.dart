import 'package:flutter/material.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController createController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.1,
            vertical: height * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.05),
              Container(
                height: height * 0.08,
                width: width * 0.5,
                child: Image.asset("assets/images/startitsplash2.PNG"),
              ),
              SizedBox(height: height * 0.1),
              Text(
                "Forgot Password?",
                textScaleFactor: 1,
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.08),
              Text.rich(
                TextSpan(
                  text: 'Email',
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
                  controller: createController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                    hintText: 'example@gmail.com',
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
              // SizedBox(height: 5),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 0.5),
                child: TextButton(
                  child: Text(
                    'Login?',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/user_login");
                  },
                ),
              ),
              SizedBox(height: height * 0.15),
              Center(
                child: Container(
                  height: height * 0.06,
                  width: width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      if (createController.text.trim().isEmpty) {
                        WebResponseExtractor.showToast('Please Enter Email Id');
                      } else if (!createController.text.contains('@') ||
                          !createController.text.contains('.')) {
                        WebResponseExtractor.showToast(
                            'Please Enter a Valid Email Id');
                      } else {
                        forgotUser();
                      }
                    },
                    child: Text(
                      'Submit',
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
      "email": createController.text,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.FORGOT_PASSWORD),
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
        Navigator.of(context).pop();
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
      WebResponseExtractor.showToast(
          "We couldn't find an account associated with ${createController.text} Please try with an alternate email.");
    } else
      WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
  }
}
