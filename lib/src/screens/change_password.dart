import 'package:flutter/material.dart';
import 'package:startit/main.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isHiddenOldPassword = true;
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;

  TextEditingController createUserController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
              SizedBox(
                height: height * 0.07,
              ),
              Text(
                "Password",
                textScaleFactor: 1,
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                "Change",
                textScaleFactor: 1,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: height * 0.05),
              Text.rich(
                TextSpan(
                  text: 'Enter Old Password',
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
              TextFormField(
                controller: createUserController,
                obscureText: isHiddenOldPassword,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isHiddenOldPassword = !isHiddenOldPassword;
                      });
                    },
                    child: Icon(
                      isHiddenOldPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  hintText: 'Enter your password',
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
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text.rich(
                TextSpan(
                  text: 'Enter New Password',
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
              SizedBox(height: height * 0.01),
              TextFormField(
                controller: passwordController,
                obscureText: isHiddenPassword,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isHiddenPassword = !isHiddenPassword;
                      });
                    },
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  hintText: 'Enter your password',
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
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text.rich(
                TextSpan(
                  text: 'Confirm Password',
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
              SizedBox(height: height * 0.01),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: isHiddenConfirmPassword,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        isHiddenConfirmPassword = !isHiddenConfirmPassword;
                      });
                    },
                    child: Icon(
                      isHiddenConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  hintText: 'Enter your password',
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
              SizedBox(height: height * 0.09),
              Center(
                child: Container(
                  height: height * 0.06,
                  width: width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      if (createUserController.text.trim().isEmpty) {
                        WebResponseExtractor.showToast(
                            'Please Enter Old Password');
                      } else if (passwordController.text.trim().isEmpty ||
                          confirmPasswordController.text.trim().isEmpty) {
                        WebResponseExtractor.showToast(
                            'Please Enter a Password');
                      } else if (passwordController.text.trim() !=
                          confirmPasswordController.text.trim()) {
                        WebResponseExtractor.showToast(
                            'Passwords do not match');
                      } else if (createUserController.text.length < 8 ||
                          passwordController.text.length < 8) {
                        WebResponseExtractor.showToast(
                            'Password must have minimum 8 characters');
                      } else
                        changePassword();
                    },
                    child: Text(
                      'Save',
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changePassword() async {
    Map data = {
      "old_password": createUserController.text,
      "password": passwordController.text,
      "user_id": userIdMain,
    };
    print(data);

    final response = await http.post(
      Uri.parse(WebApis.CHANGE_PASSWORD),
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
        // addFirebaseId();

        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    } else
      WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
  }
}
