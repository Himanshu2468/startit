import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startit/src/screens/dashboard.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:startit/src/services/googleSignInApi.dart';
import '../../main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:startit/src/services/facebookSignInApi.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String move = "";
  bool isRememberMe = false;
  bool emailVerified = false;
  bool isHiddenPassword = true;
  @override
  void initState() {
    super.initState();
    preFilled();
  }

  Future<void> preFilled() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userRemember")) {
      return;
    }
    final extractUserData =
        json.decode(prefs.getString("userRemember")) as Map<String, Object>;
    emailController.text = extractUserData["email"];
    setState(() {
      emailVerified = true;
    });
    passwordController.text = extractUserData["password"];
    print(passwordController.text);
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);

    if (regex.hasMatch(value)) {
      return true;
    } else if (int.tryParse(value) != null) {
      if (value.length != 10) {
        return false;
      } else if (int.parse(value[0]) != 6 &&
          int.parse(value[0]) != 7 &&
          int.parse(value[0]) != 8 &&
          int.parse(value[0]) != 9) {
        return false;
      } else {
        return true;
      }
    } else
      return false;
  }

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
              Container(
                height: height * 0.08,
                width: width * 0.4,
                child: Image.asset("assets/images/startitsplash2.PNG"),
              ),
              SizedBox(
                height: height * 0.07,
              ),
              Text(
                isEnglish
                    ? "Login to your passion"
                    : 'अपने जुनून में लॉगिन करें',
                textScaleFactor: 1,
                style: TextStyle(color: Colors.lightBlue, fontSize: 24),
              ),
              SizedBox(height: height * 0.05),
              Text(
                isEnglish ? 'Mobile Number / Email' : 'मोबाइल / ईमेल',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    emailVerified = validateEmail(value.trim());
                  });
                },
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  focusColor: Colors.white70,
                  hintText: isEnglish
                      ? 'Enter Mobile Number / Email'
                      : 'अपना यूजर मोबाइल / ईमेल टाइप करें',
                  suffixIcon: emailVerified
                      ? Icon(
                          Icons.check_box_rounded,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.check_box_outlined,
                          color: Colors.grey,
                        ),
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
              Text(
                isEnglish ? 'Password' : 'पासवर्ड',
                textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: height * 0.02),
              TextFormField(
                controller: passwordController,
                obscureText: isHiddenPassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  focusColor: Colors.white70,
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
                  hintText:
                      isEnglish ? 'Enter your password' : 'अपना पासवर्ड डालें',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: isRememberMe,
                          onChanged: (value) {
                            setState(() {
                              isRememberMe = !isRememberMe;
                            });
                          }),
                      Text(
                        isEnglish ? "Remember me" : 'मुझे याद रखें',
                        textScaleFactor: 1,
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Text(
                          isEnglish ? "Forgot Email Id?" : 'यूजर आईडी भूल गए?',
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/forgot_uderId');
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        child: Text(
                          isEnglish ? "Forgot Password?" : 'पासवर्ड भूल गए?',
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/forgot_password');
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: width * 0.03,
                        child: Image.asset("assets/images/google.png"),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          googleSignIn();
                        },
                        child: Text(
                          isEnglish
                              ? "Join with Google"
                              : 'गूगल के माध्यम से जुड़ें',
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   width: width * 0.04,
                  // ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: width * 0.03,
                        child: Image.asset("assets/images/facebook.png"),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () {
                          signInFB();
                        },
                        child: Text(
                          isEnglish
                              ? "Join with Facebook"
                              : 'फेसबुक के माध्यम से जुड़ें',
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.blue, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: width * 0.02,
              //     ),
              //     CircleAvatar(
              //       backgroundColor: Colors.white,
              //       radius: width * 0.03,
              //       child: Image.asset("assets/images/linkedIn.png"),
              //     ),
              //     SizedBox(
              //       width: 4,
              //     ),
              //     GestureDetector(
              //       child: Text(
              //         "Join with LinkedIn",
              //         style: TextStyle(color: Colors.blue),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: height * 0.05),
              ElevatedButton(
                onPressed: () async {
                  if (emailController.text.trim().isEmpty) {
                    WebResponseExtractor.showToast(
                        'Please Enter Mobile Number or Email Id');
                  } else if (int.tryParse(emailController.text) != null) {
                    if (emailController.text.length != 10) {
                      WebResponseExtractor.showToast(
                          'Mobile Number must have 10 digits');
                    } else if (int.parse(emailController.text[0]) != 6 &&
                        int.parse(emailController.text[0]) != 7 &&
                        int.parse(emailController.text[0]) != 8 &&
                        int.parse(emailController.text[0]) != 9) {
                      WebResponseExtractor.showToast(
                          'Please Enter a Valid Mobile Number');
                    } else {
                      await loginFirebase(emailController.text);
                      await loginUser();
                      await addFirebaseId();
                      passwordController.clear();
                    }
                  } else if (emailVerified == false) {
                    WebResponseExtractor.showToast(
                        'Please Enter a Valid Email Id');
                  } else {
                    await loginFirebase(emailController.text);
                    await loginUser();
                    await addFirebaseId();
                    passwordController.clear();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isEnglish ? 'Proceed' : 'आगे बढ़ें',
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Icon(Icons.arrow_forward_ios_sharp)
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isEnglish ? "Create your " : 'अपना ',
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signUp');
                      },
                      child: Text(
                        "STARTiT",
                        textScaleFactor: 1,
                      )),
                  Text(
                    isEnglish ? "Account" : 'खाता बनाएं',
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    final pass = passwordController.text;
    Map mapdata = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    print(mapdata);
    final response = await http.post(
      Uri.parse(WebApis.USER_LOGIN),
      body: json.encode(mapdata),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    final jsonData = jsonDecode(response.body) as Map;

    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        if (isRememberMe) {
          final prefs = await SharedPreferences.getInstance();
          final userRemember = json.encode({
            "email": emailController.text,
            "password": pass,
          });
          print(userRemember);

          prefs.setString("userRemember", userRemember);
        }

        Map data = WebResponseExtractor.filterWebData(response,
            dataObject: "USER_DATA");
        var userData = data["data"];

        userIdMain = int.parse(userData["id"]);
        emailMain = userData["email"];
        mobile = userData["mobile"].toString();
        name = "${userData['first_name']} ${userData['last_name']}";
        print(userIdMain);
        print(mobile);
        print(name);

        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);

        if (userData["role_id"] == "1") {
          move = "/occupation";
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "BIP_DATA");
          var bipData = data["data"];

          if (bipData.toString() == "[]") {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/personal_details', (Route<dynamic> route) => false,
                arguments: move);
            // Navigator.of(context)
            //     .pushNamed('/personal_details', arguments: move);
          } else if (bipData["country"] == "0") {
            bipId = int.parse(bipData["id"]);
            // profileImageMain = bipData["profile_image"];
            // Navigator.of(context).pushNamed('/location', arguments: move);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/location', (Route<dynamic> route) => false,
                arguments: move);
          } else {
            bipId = int.parse(bipData["id"]);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Dashboard(move)),
                (Route<dynamic> route) => false);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard', (Route<dynamic> route) => false,
            //     arguments: move);
            // Navigator.of(context).pushNamed('/dashboard', arguments: move);
          }
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              "userId": userIdMain,
              "displayName": name,
              "email": emailMain,
              "mobile": mobile,
              "id": bipId,
              "move": move,
              "userFirebaseId": userFirebaseId
            },
          );
          prefs.setString("userData", userData);
          print(userData);
        }
        if (userData["role_id"] == "2") {
          move = "/capabilities";
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "INS_DATA");
          var investorData = data["data"];

          if (investorData.toString() == "[]") {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/personal_details', (Route<dynamic> route) => false,
                arguments: move);
            // Navigator.of(context)
            //     .pushNamed('/personal_details', arguments: move);
          } else if (investorData["country"] == null) {
            insId = int.parse(investorData["id"]);
            // Navigator.of(context).pushNamed('/location', arguments: move);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/location', (Route<dynamic> route) => false,
                arguments: move);
          } else {
            insId = int.parse(investorData["id"]);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard', (Route<dynamic> route) => false,
            //     arguments: move);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Dashboard(move)),
                (Route<dynamic> route) => false);
            // Navigator.of(context).pushNamed('/dashboard', arguments: move);
          }
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              "userId": userIdMain,
              "displayName": name,
              "email": emailMain,
              "mobile": mobile,
              "id": insId,
              "move": move,
              "userFirebaseId": userFirebaseId
            },
          );
          prefs.setString("userData", userData);
        }
        if (userData["role_id"] == "3") {
          move = "/product_provider";
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "PP_DATA");
          var ppData = data["data"];

          if (ppData.toString() == "[]") {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/personal_details', (Route<dynamic> route) => false,
                arguments: move);
            // Navigator.of(context)
            //     .pushNamed('/personal_details', arguments: move);
          } else if (ppData["country"] == "0") {
            ppId = int.parse(ppData["id"]);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/location', (Route<dynamic> route) => false,
                arguments: move);
            // Navigator.of(context).pushNamed('/location', arguments: move);
          } else {
            ppId = int.parse(ppData["id"]);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Dashboard(move)),
                (Route<dynamic> route) => false);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard', (Route<dynamic> route) => false,
            //     arguments: move);
            // Navigator.of(context).pushNamed('/dashboard', arguments: move);
          }
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              "userId": userIdMain,
              "displayName": name,
              "email": emailMain,
              "mobile": mobile,
              "id": ppId,
              "move": move,
              "userFirebaseId": userFirebaseId
            },
          );
          prefs.setString("userData", userData);
        }
        if (userData["role_id"] == "4") {
          move = "/domain";
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "SP_DATA");
          var spData = data["data"];

          if (spData.toString() == "[]") {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/personal_details', (Route<dynamic> route) => false,
                arguments: move);
            // Navigator.of(context)
            //     .pushNamed('/personal_details', arguments: move);
          } else if (spData["country"] == "0") {
            spId = int.parse(spData["id"]);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/location', (Route<dynamic> route) => false,
                arguments: move);
            // Navigator.of(context).pushNamed('/location', arguments: move);
          } else {
            spId = int.parse(spData["id"]);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Dashboard(move)),
                (Route<dynamic> route) => false);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/dashboard', (Route<dynamic> route) => false,
            //     arguments: move);
            // Navigator.of(context).pushNamed('/dashboard', arguments: move);
          }
          final prefs = await SharedPreferences.getInstance();
          final userData = json.encode(
            {
              "userId": userIdMain,
              "displayName": name,
              "email": emailMain,
              "mobile": mobile,
              "id": spId,
              "move": move,
              "userFirebaseId": userFirebaseId
            },
          );
          prefs.setString("userData", userData);
        }
      } else if (jsonData["RETURN_CODE"] == -1) {
        Map data = WebResponseExtractor.filterUserData(response,
            dataObject: "USER_ID");
        var userData = data["data"];

        userIdMain = int.parse(userData["id"]);
        mobile = userData["mobile"].toString();
        name = userData["first_name"];
        print(userIdMain);
        print(mobile);
        print(name);

        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
        // Navigator.of(context).pushNamed('/welcome');
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/welcome', (Route<dynamic> route) => false);
      }
    } else
      WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
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

      if (newUser.user.uid != null) {
        print("jasbdhbsdh");
        // print("firebase ID:" + newUser.user.uid);
        // print("Device Id ----: "+userDeviceToken);
        firebaseid = newUser.user.uid;
        if (userFirebaseId != firebaseid || userDeviceToken != fcmToken) {
          setState(() {
            userFirebaseId = firebaseid;
          });

          print(userFirebaseId);
          userDeviceToken = fcmToken;
        }
      } else {
        // registerFirebase(email);
      }
    } catch (e) {
      // await registerFirebase(email);
      print(e);
      if (e.code == "ERROR_USER_NOT_FOUND") {}
    }
    //return firebaseid;
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

  Future googleSignIn() async {
    final user = await GoogleSignInApi.login();
    String googleUserFullName = user.displayName;
    String googleUserFirstName = googleUserFullName.split(' ').first;
    String googleUserLastName =
        googleUserFullName.split(googleUserFirstName).last.trim();
    String googleUserEmail = user.email;
    String googleUserUniqueId = user.id;
    print(googleUserFullName);
    print(googleUserFirstName);
    print(googleUserLastName);
    print(googleUserEmail);
    print(googleUserUniqueId);

    GoogleSignInApi.googleLoginUser(
      context,
      move,
      googleUserFirstName,
      googleUserLastName,
      googleUserEmail,
      googleUserUniqueId,
    );
  }

  Future signInFB() async {
    AccessToken accessToken = await FacebookAuth.instance.login();

    final userData = await FacebookAuth.instance
        .getUserData(fields: "id,name,email,picture,first_name,last_name");
    print("USERDATA");
    print(userData);

    String facebookUserFirstName =
        userData["first_name"] != null ? userData["first_name"] : "";
    String facebookUserLastName =
        userData["last_name:"] != null ? userData["last_name:"] : "";
    String facebookUserEmail =
        userData["email"] != null ? userData["email"] : "";
    String facebookUserUniqueId =
        userData["id"] != null ? userData["id"] : userData["id"];

    FacebookSignInApi.facebookLoginUser(
      context,
      move,
      facebookUserFirstName,
      facebookUserLastName,
      facebookUserEmail,
      facebookUserUniqueId,
    );
  }
}
