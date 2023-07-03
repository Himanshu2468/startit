import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:startit/main.dart';

class PasswordCheck extends StatefulWidget {
  @override
  _PasswordCheckState createState() => _PasswordCheckState();
}

class _PasswordCheckState extends State<PasswordCheck> {
  DateTime currentBackPressTime;
  final _confirmPassword = FocusNode();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  bool isAgreed = false;

  @override
  void dispose() {
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
              vertical: height * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnglish
                      ? "Your strong password is key to unlock great things."
                      : 'आपका मजबूत पासवर्ड महान चीजों को अनलॉक करने की कुंजी है',
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: height * 0.05),
                Text.rich(
                  TextSpan(
                    text: isEnglish
                        ? 'Enter New Password'
                        : 'नया पासवर्ड दर्ज करें',
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
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: passwordController,
                  obscureText: isHiddenPassword,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_confirmPassword);
                  },
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
                    hintText: isEnglish
                        ? 'Enter your password'
                        : 'अपना पासवर्ड टाइप करें',
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
                    text: isEnglish
                        ? 'Confirm Password'
                        : 'पासवर्ड की पुष्टि कीजिये',
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
                SizedBox(height: height * 0.02),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: isHiddenConfirmPassword,
                  focusNode: _confirmPassword,
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
                    hintText: isEnglish
                        ? 'Enter your password'
                        : 'अपना पासवर्ड डालें',
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
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                        activeColor: Colors.green,
                        value: isAgreed,
                        onChanged: (value) {
                          setState(() {
                            isAgreed = !isAgreed;
                          });
                        }),
                    Text.rich(
                      TextSpan(
                        text: isEnglish ? 'I agree to your ' : 'मैं आपकी ',
                        children: [
                          TextSpan(
                            text: isEnglish ? 'Terms' : 'शर्तों',
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(text: isEnglish ? ' and ' : ' और '),
                          TextSpan(
                            text: isEnglish ? 'Privacy Policy' : 'गोपनीयता',
                            style: TextStyle(color: Colors.blue),
                          ),
                          if (!isEnglish) TextSpan(text: ' नीति से सहमत हूं'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.1),
                ElevatedButton(
                  onPressed: isAgreed
                      ? () {
                          if (passwordController.text.trim().isEmpty ||
                              confirmPasswordController.text.isEmpty) {
                            WebResponseExtractor.showToast(
                                'Please Enter a Password');
                          } else if (passwordController.text !=
                              confirmPasswordController.text) {
                            WebResponseExtractor.showToast(
                                'Passwords do not match');
                          } else if (passwordController.text.length < 8) {
                            WebResponseExtractor.showToast(
                                'Password must have minimum 8 characters');
                          } else
                            setPassword();
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isEnglish ? 'Proceed' : 'आगे बढ़ें',
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Icon(Icons.chevron_right)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      WebResponseExtractor.showToast("Press back again to exit the app");
      return Future.value(false);
    }
    return Future.value(true);
  }

  void setPassword() async {
    Map data = {
      "password": passwordController.text,
      "cpassword": confirmPasswordController.text,
      "user_id": userIdMain,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.SET_PASSWORD),
      body: json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;

      if (jsonData["RETURN_CODE"] == 1) {
        print(jsonData);

        Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcome', (Route<dynamic> route) => false);

        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
  }
}
