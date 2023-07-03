import 'package:flutter/material.dart';
//import 'package:dropdown_date_picker/dropdown_date_picker.dart';
import 'package:startit/main.dart';
import '../services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import '../services/WebApis.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  String bulbColor = "";
  String gender = "";
  String dob = "";
  DateTime d;
  bool isGenderSelected = false;

  String image = "";
  String path = "";
  Uint8List imageBytes;
  Dio dio = Dio();

  static final now = DateTime.now();

  DateTime _selectedDate;
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 10, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 10, now.month, now.day),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else
        setState(() {
          dob = DateFormat('yyyy-MM-dd').format(pickedDate);
          _selectedDate = pickedDate;
        });
      print(dob);
    });
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget textBox;
    final move = ModalRoute.of(context).settings.arguments as String;
    if (move == "/occupation" || move == "/capabilities") {
      textBox = SizedBox(
        height: 50,
        width: 255,
        child: Text(
          isEnglish
              ? "Your Date Of Birth is also special for us, Please Enter"
              : 'आपकी जन्मतिथि भी हमारे लिए खास है, कृपया दर्ज करें',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      textBox = Text(
        isEnglish ? "Let's wish you on" : 'आइए आपको शुभकामनाएं देते हैं',
        textScaleFactor: 1,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
      );
    }

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          isEnglish ? 'Personal details' : 'व्यक्तिगत विवरण',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
              vertical: height * 0.05,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.cake,
                      color: Colors.blue,
                    ),
                    SizedBox(width: width * 0.023),
                    textBox,
                  ],
                ),
                SizedBox(height: height * 0.03),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                    width: width * 0.65,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        _selectedDate == null
                            ? isEnglish
                                ? 'Choose Date'
                                : "तारीख चुनें"
                            : DateFormat('dd MMM yyyy').format(_selectedDate),
                        textScaleFactor: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                Text(
                  isEnglish ? "Select your Gender" : 'अपना लिंग चुनें',
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.orange,
                          value: "M",
                          groupValue: bulbColor,
                          onChanged: (val) {
                            bulbColor = val;
                            isGenderSelected = true;
                            setState(() {
                              gender = val;
                            });
                          },
                        ),
                        Text(
                          isEnglish ? "Male" : 'पुरुष',
                          textScaleFactor: 1,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.orange,
                          value: "F",
                          groupValue: bulbColor,
                          onChanged: (val) {
                            bulbColor = val;
                            isGenderSelected = true;
                            setState(() {
                              gender = val;
                            });
                          },
                        ),
                        Text(
                          isEnglish ? "Female" : 'महिला',
                          textScaleFactor: 1,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.orange,
                          value: "O",
                          groupValue: bulbColor,
                          onChanged: (val) {
                            bulbColor = val;
                            isGenderSelected = true;
                            setState(() {
                              gender = val;
                            });
                          },
                        ),
                        Text(
                          isEnglish
                              ? "Prefer Not to say"
                              : 'चुप रहना पसंद करूंगा',
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  isEnglish
                      ? "Select Profile Image"
                      : 'प्रोफ़ाइल छवि का चयन करें',
                  textScaleFactor: 1,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.02),
                selectImage(width, height),
                SizedBox(height: height * 0.05),
                Center(
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.7,
                    child: ElevatedButton(
                      onPressed: () {
                        if (dob == "") {
                          WebResponseExtractor.showToast(isEnglish
                              ? 'Please select a valid DOB'
                              : 'कृपया एक मान्य जन्म तिथि चुनें');
                        }
                        if (_selectedDate == null) {
                          WebResponseExtractor.showToast(
                              'Please select a valid DOB');
                        } else if (isGenderSelected == false) {
                          WebResponseExtractor.showToast(
                              'Please select gender');
                        }
                        // else if (path == "") {
                        //   WebResponseExtractor.showToast(
                        //       'Please select a profile image');
                        // }
                        else {
                          addData(move);
                          Navigator.of(context)
                              .pushNamed('/location', arguments: move);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isEnglish
                                ? 'Save & Continue'
                                : 'सहेजें और जारी रखें',
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
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

  Widget selectImage(double width, double height) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          color: Colors.grey[300],
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: path == ""
                ? image != null && image != ""
                    ? NetworkImage("http://164.52.192.76:8080/startit/$image")
                    : NetworkImage(
                        "https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png",
                      )
                : FileImage(
                    File(path),
                  ),
          ),
        ),
      ),
      onTap: addImage,
    );
  }

  void addImage() async {
    bool checkSize = true;

    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'png', 'jpg'],
    );
    if (result != null) {
      result.files.forEach((element) {
        if (element.size > 2097152) {
          checkSize = false;
        }
      });
      if (checkSize == false) {
        WebResponseExtractor.showToast(
            "Please select each image of size less than 2MB");
        return;
      }
      setState(() {
        path = result.paths.first;
        imageBytes = result.files.first.bytes;
      });
    }
    print(path);
  }

  Future uploadMultipleImage() async {
    if (path.isNotEmpty) {
      try {
        FormData formData = FormData();

        MultipartFile imageFile = await MultipartFile.fromFile(path);

        formData = FormData.fromMap({
          "user_id": userIdMain,
          "profile_image": imageFile,
        });
        print(formData.fields);
        print(formData.files);
        final response = await dio.post(
          WebApis.PROFILE_IMAGE,
          data: formData,
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.data['RETUTN_MESSAGE']);
          WebResponseExtractor.showToast(response.data['RETUTN_MESSAGE']);
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void addData(String move) async {
    Map data = {
      "user_id": userIdMain,
      "dob": dob,
      "gender": gender,
    };
    print(data);
    if (move == "/occupation") {
      final response = await http.post(
        Uri.parse(WebApis.ADD_BIP),
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
          bipId = jsonData["BIP_ID"] is int
              ? jsonData["BIP_ID"]
              : int.parse(jsonData["BIP_ID"]);
          uploadMultipleImage();
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
      }

      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
    } else if (move == "/capabilities") {
      final response = await http.post(
        Uri.parse(WebApis.ADD_INVESTOR),
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
          insId = jsonData["INS_ID"] is int
              ? jsonData["INS_ID"]
              : int.parse(jsonData["INS_ID"]);
          uploadMultipleImage();
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
          print(userData);
        }
      }
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
    } else if (move == "/domain") {
      final response = await http.post(
        Uri.parse(WebApis.ADD_SP),
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
          spId = jsonData["SP_ID"] is int
              ? jsonData["SP_ID"]
              : int.parse(jsonData["SP_ID"]);
          uploadMultipleImage();
          print(spId);
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
          print(userData);
        }
      }
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
    } else {
      final response = await http.post(
        Uri.parse(WebApis.ADD_PRODUCT_PROVIDER),
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
          ppId = jsonData["PP_ID"] is int
              ? jsonData["PP_ID"]
              : int.parse(jsonData["PP_ID"]);

          uploadMultipleImage();
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
          print(userData);
        }
      }
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
    }
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

        setState(() {
          image = userData["profile_image"] != null
              ? userData["profile_image"]
              : "";
          dob = userData["dob"] != null ? userData["dob"] : "";
          gender = userData["gender"] != null ? userData["gender"] : "";
          bulbColor = gender;
          _selectedDate = (DateTime.parse(userData["dob"]));
          gender != "" ? isGenderSelected = true : isGenderSelected = false;
        });
      }
    }
  }
}
