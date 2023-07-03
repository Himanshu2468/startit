import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:startit/main.dart';
import 'dart:async';

class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _otp1 = FocusNode();
  final _otp2 = FocusNode();
  final _otp3 = FocusNode();
  final _otp4 = FocusNode();
  final _otp5 = FocusNode();
  final _otp6 = FocusNode();

  List<TextEditingController> createUserController = [
    for (int i = 0; i < 6; i++) TextEditingController()
  ];

  Timer _timer;
  int n = 60;
  bool resendOtpAllowed = false;

  void _startTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (n > 0) {
          n--;
        } else {
          _timer.cancel();
          resendOtpAllowed = true;
        }
      });
    });
  }

  void initState() {
    super.initState();
    _startTimer();
    otpManagement();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _otp1.dispose();
    _otp2.dispose();
    _otp3.dispose();
    _otp4.dispose();
    _otp5.dispose();
    _otp6.dispose();
  }

  void nextField({String value, FocusNode focusNode}) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.13,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: height * 0.08,
                  width: width * 0.6,
                  child: Image.asset("assets/images/startitsplash2.PNG"),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  isEnglish ? 'Enter OTP' : 'ओटीपी दर्ज करें',
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  isEnglish
                      ? 'Because we want to know it is you'
                      : 'क्योंकि हम जानना चाहते हैं कि यह आप हैं',
                  textScaleFactor: 1,
                  style: TextStyle(
                    //color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  isEnglish ? 'E-mail/ SMS' : 'ईमेल/ एसएमएस',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  buildOtpTextFeild(createUserController.elementAt(0), _otp2,
                      _otp1), //////////
                  SizedBox(width: 10),
                  buildOtpTextFeild(
                      createUserController.elementAt(1), _otp3, _otp2),
                  SizedBox(width: 10),
                  buildOtpTextFeild(
                      createUserController.elementAt(2), _otp4, _otp3),
                  SizedBox(width: 10),
                  buildOtpTextFeild(
                      createUserController.elementAt(3), _otp5, _otp4),
                  SizedBox(width: 10),
                  buildOtpTextFeild(
                      createUserController.elementAt(4), _otp6, _otp5),
                  SizedBox(width: 10),
                  buildOtpTextFeild(createUserController.elementAt(5), _otp6,
                      _otp6), ////////////////
                ],
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  isEnglish ? 'Timer 00:$n sec' : 'घड़ी  00:$n sec',
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 0.5),
                child: TextButton(
                  child: Text(
                    isEnglish ? 'Resend OTP' : 'ओटीपी पुनः भेजें',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: resendOtpAllowed ? Colors.red : Colors.grey,
                    ),
                  ),
                  onPressed: resendOtpAllowed ? resendOtp : null,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[600],
                  minimumSize: Size(double.maxFinite, 45),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                onPressed: () {
                  if (createUserController.elementAt(0).text.isEmpty ||
                      createUserController.elementAt(1).text.isEmpty ||
                      createUserController.elementAt(2).text.isEmpty ||
                      createUserController.elementAt(3).text.isEmpty ||
                      createUserController.elementAt(4).text.isEmpty ||
                      createUserController.elementAt(5).text.isEmpty) {
                    WebResponseExtractor.showToast('Please Enter a Valid OTP');
                  } else if (createUserController.elementAt(0).text +
                          createUserController.elementAt(1).text +
                          createUserController.elementAt(2).text +
                          createUserController.elementAt(3).text +
                          createUserController.elementAt(4).text +
                          createUserController.elementAt(5).text !=
                      otp.toString()) {
                    WebResponseExtractor.showToast('Invalid OTP');
                  } else
                    verifyOtp();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtpTextFeild(
      TextEditingController controller, FocusNode focus, FocusNode node) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.10,
      child: TextFormField(
        showCursor: false,
        controller: controller,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
        focusNode: node,
        onChanged: (value) {
          nextField(value: value, focusNode: focus);
        },
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  void resendOtp() async {
    Map data = {
      "mobile": mobile,
      "user_id": userIdMain,
    };
    print(data);

    final response = await http.post(
      Uri.parse(WebApis.RESEND_OTP),
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
        resendOtpAllowed = false;
        n = 30;
        _startTimer();
        otp = jsonData["MOBILE_OTP"];
        print(otp);
        otpManagement();
        setState(() {});
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
    WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
  }

  void otpManagement() {
    // createUserController.elementAt(0).text = otp.toString()[0];
    // createUserController.elementAt(1).text = otp.toString()[1];
    // createUserController.elementAt(2).text = otp.toString()[2];
    // createUserController.elementAt(3).text = otp.toString()[3];
    // createUserController.elementAt(4).text = otp.toString()[4];
    // createUserController.elementAt(5).text = otp.toString()[5];
  }

  void verifyOtp() async {
    Map data = {
      "mobile": mobile,
      "user_id": userIdMain,
      "mobile_otp": otp,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.VERIFY_OTP),
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
        _timer.cancel();
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/password-check', (Route<dynamic> route) => false);
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
  }
}
