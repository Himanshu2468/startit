import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _lastNameFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _securityFocusNode = FocusNode();
  final _answerFocusNode = FocusNode();

  Dropdown securityQuestionDropDown;
  List<Dropdown> securityQuestionList = [];
  String securityQuestion = "";
  String securityQuestionID = "";

  List<TextEditingController> createUserController = [
    for (int i = 0; i < 5; i++) TextEditingController()
  ];

  void initState() {
    super.initState();
    getSecurityQuestion();
  }

  String facebookId = "";
  String googleId = "";
  bool googleDataUsed = false;

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    _mobileFocusNode.dispose();
    _emailFocusNode.dispose();
    _securityFocusNode.dispose();
    _answerFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> dataFromGoogle =
        ModalRoute.of(context).settings.arguments as Map<String, String>;

    if (dataFromGoogle != null && googleDataUsed == false) {
      createUserController[0].text = dataFromGoogle["first_name"];
      createUserController[1].text = dataFromGoogle["last_name"];
      if (dataFromGoogle["email"] != "" || dataFromGoogle["email"] != null)
        createUserController[3].text = dataFromGoogle["email"];
      googleId = dataFromGoogle["google_id"];
      facebookId = dataFromGoogle["facebook_id"];
      googleDataUsed = true;
    }

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.13,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [Image.asset("assets/images/StartItlogo.png")],
              // ),
              Center(
                child: Container(
                  height: height * 0.06,
                  width: width * 0.6,
                  child: Image.asset("assets/images/startitsplash2.PNG"),
                ),
              ),
              SizedBox(
                height: height * 0.045,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/group.png'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  isEnglish
                      ? 'Let\'s Start Something New'
                      : 'चलो कुछ नया शुरू करते हैं',
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: isEnglish ? 'First Name' : 'नाम',
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
                        color: Colors.white38,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Center(
                          child: TextFormField(
                            controller: createUserController.elementAt(0),
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_lastNameFocusNode);
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10.0, top: 10.0),
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
                      ),
                    ],
                  ),
                  SizedBox(width: width * 0.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEnglish ? 'Last Name' : 'अंतिम नाम',
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
                          controller: createUserController.elementAt(1),
                          textCapitalization: TextCapitalization.words,
                          focusNode: _lastNameFocusNode,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_mobileFocusNode);
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10.0, top: 10.0),
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
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text.rich(
                TextSpan(
                  text: isEnglish ? 'Mobile Number' : 'मोबाइल',
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
                width: width * 0.7,
                child: TextFormField(
                  controller: createUserController.elementAt(2),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 10,
                  focusNode: _mobileFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                  decoration: InputDecoration(
                    counter: SizedBox(),
                    contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                    hintText: isEnglish
                        ? 'Enter Mobile number'
                        : 'मोबाइल नंबर दर्ज करें',
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
                  text: isEnglish ? 'Email' : 'ईमेल',
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
                width: width * 0.7,
                child: TextFormField(
                  controller: createUserController.elementAt(3),
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _emailFocusNode,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.7,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4.0),
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
                            isEnglish ? "Security Question" : 'गुप्त प्रश्न',
                            textScaleFactor: 1,
                          ),
                          value: securityQuestionDropDown,
                          isDense: true,
                          iconSize: 35,
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (Dropdown _value) {
                            FocusScope.of(context)
                                .requestFocus(_answerFocusNode);
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
                    Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          " *",
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.7,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: createUserController.elementAt(4),
                      focusNode: _answerFocusNode,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                        hintText: isEnglish ? 'Answer' : 'उत्तर',
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
                  Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        " *",
                        textScaleFactor: 1,
                        style: TextStyle(color: Colors.red),
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              ElevatedButton(
                onPressed: () {
                  if (createUserController[0].text.trim().isEmpty) {
                    WebResponseExtractor.showToast('Please Enter First Name');
                  } else if (createUserController[2].text.trim().isEmpty) {
                    WebResponseExtractor.showToast(
                        'Please Enter Mobile Number');
                  } else if (createUserController[2].text.length != 10) {
                    WebResponseExtractor.showToast(
                        'Please Enter a Valid Mobile Number');
                  } else if (int.parse(createUserController[2].text[0]) != 6 &&
                      int.parse(createUserController[2].text[0]) != 7 &&
                      int.parse(createUserController[2].text[0]) != 8 &&
                      int.parse(createUserController[2].text[0]) != 9) {
                    WebResponseExtractor.showToast(
                        'Please Enter a Valid Mobile Number');
                  } else if (createUserController[3].text.trim().isEmpty) {
                    WebResponseExtractor.showToast('Please Enter Email Id');
                  } else if (!createUserController[3].text.contains('@') ||
                      !createUserController[3].text.contains('.')) {
                    WebResponseExtractor.showToast(
                        'Please Enter a Valid Email Id');
                  } else if (securityQuestion == "" &&
                      securityQuestionID == "") {
                    WebResponseExtractor.showToast(
                        'Please Select a Security Question');
                  } else if (createUserController[4].text.trim().isEmpty) {
                    WebResponseExtractor.showToast('Please Enter Answer');
                  } else
                    createUser();
                },
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isEnglish ? 'Facing Difficulty?' : 'कठिनाई का सामना ?',
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        isEnglish ? 'Need Help' : 'मदद की ज़रूरत है',
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginFirebase(String email) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    // User loggedUser;
    final FirebaseMessaging _fcm = FirebaseMessaging();
    String fcmToken = await _fcm.getToken();
    String firebaseid;
    try {
      // Register to firebase
      final newUser = await _auth.signInWithEmailAndPassword(
          email: email, password: "1234567");

      if (newUser != null) {
        // print("firebase ID:" + newUser.user.uid);
        // print("Device Id ----: "+userDeviceToken);
        firebaseid = newUser.user.uid;
        if (userFirebaseId != firebaseid || userDeviceToken != fcmToken) {
          userFirebaseId = firebaseid;
          print(userFirebaseId);
          userDeviceToken = fcmToken;
          addFirebaseId();
        }
      } else {
        registerFirebase(email);
      }
    } catch (e) {
      print(e);
      if (e.code == "ERROR_USER_NOT_FOUND") {
        registerFirebase(email);
      }
    }
    // return firebaseid;
  }

  static registerFirebase(String email) async {
    // User loggedUser;
    final _auth = FirebaseAuth.instance;
    try {
      // Register to firebase
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: "1234567",
      );
      //loggedUser = await _auth.currentUser();
      if (newUser != null) {
        userFirebaseId = newUser.user.uid;
        // addFirebaseId();
      }
      print(userFirebaseId);
      print(newUser);
    } catch (e) {
      print(e);
    }
  }

  void createUser() async {
    Map data = {
      "first_name": createUserController.elementAt(0).text,
      "last_name": createUserController.elementAt(1).text,
      "mobile": createUserController.elementAt(2).text,
      "email": createUserController.elementAt(3).text,
      "mst_sec_que_id": int.parse(securityQuestionID),
      "que_answer": createUserController.elementAt(4).text,
      "facebook_id": facebookId,
      "google_id": googleId,
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.SIGNUP),
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
        await setState(() {
          userIdMain = jsonData["USER_ID"];
          mobile = jsonData["MOBILE"];
          otp = jsonData["MOBILE_OTP"];
          name =
              "${createUserController.elementAt(0).text.trim()} ${createUserController.elementAt(1).text.trim()}";
          emailMain = createUserController.elementAt(3).text;
        });
        print(userIdMain);
        print(mobile);
        print(otp);
        await registerFirebase(createUserController.elementAt(3).text);
        addFirebaseId();
        Navigator.of(context).pushNamed('/otp');
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    } else
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
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
    // test nowsole

    setState(() {
      // what is happening >
      for (Map category in jsonData) {
        //print("HIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII" + answerType["AnswerType"]); // is that prints ? NO
        securityQuestionList.add(new Dropdown(category["id"],
            isEnglish == true ? category["name"] : category["hindi_name"]));
      }
    });
  }

  void addFirebaseId() async {
    Map mapData = {
      "user_id": userIdMain,
      "device_token": userDeviceToken,
      "firebase_user_id": userFirebaseId
    };
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.ADD_TOKEN_ID),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {}
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
