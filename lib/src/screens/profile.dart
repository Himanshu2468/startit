import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';

import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  String bulbColor = "";
  bool isGenderSelected = false;
  TabController _tabController;
  Color color;

  String gender = "";
  String dob = "2021-01-01";
  String location = "";
  String occupation = "";
  String image = "";

  String path = "";
  Uint8List imageBytes;
  Dio dio = Dio();
  String share_url;
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

  List<DropDown> countriesList = [];
  DropDown countryDropDown;
  String countryName = "";
  String countryID = "";

  List<DropDown> stateList = [];
  DropDown stateDropDown;
  String stateName = "";
  String stateID = "";

  List<DropDown> cityList = [];
  DropDown cityDropDown;
  String cityName = "";
  String cityID = "";

  double latitude = 0.0;
  double longitude = 0.0;
  String geoLocation = "";

  int screenNo = 0;

  DropDown employmentTypeDropDown;
  List<DropDown> employmentTypeList = [];
  String employmentTypeID = '';
  String employment = '';

  DropDown tradeDropDown;
  List<DropDown> tradeList = [];
  String tradeTypeID = '';
  String trade = '';

  DropDown businessDropDown;
  List<DropDown> businessList = [];
  String businessTypeID = '';
  String business1 = '';

  DropDown natureOfWork;
  List<DropDown> natureOfWorkList = [];
  String nOfWork = '';
  String nOfWorkID = '';

  @override
  void initState() {
    super.initState();
    createUserController4.text = mobile;
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    getCountries();
  }

  void _handleTabSelection() {
    setState(() {
      color = Colors.blue;
    });
  }

  TextEditingController createUserController1 = TextEditingController();
  TextEditingController createUserController2 = TextEditingController();
  TextEditingController createUserController3 = TextEditingController();
  TextEditingController createUserController4 = TextEditingController();

  TextEditingController pincodeController = TextEditingController();

  String jobRadio = "";
  String tradeRadio = "";
  String natureRadio = "";
  String businessRadio = "";

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    String move = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      drawer: AppDrawer(move),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Profile',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        actions: [
          if (move == "/domain" || move == "/product_provider")
            IconButton(
                onPressed: () {
                  // if (share_url != null) {
                  final RenderBox renderBox = context.findRenderObject();

                  Share.share(
                    shareUserUrl,
                    sharePositionOrigin:
                        renderBox.localToGlobal(Offset.zero) & renderBox.size,
                  );
                  // }
                },
                icon: Icon(Icons.share))
        ],
      ),
      body: Container(
        height: height,
        color: Colors.blue,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          padding: EdgeInsets.all(width * 0.1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_tabController.index == 0 &&
                                image != null &&
                                image != "") {
                              return showDialogFunc(context,
                                  "http://164.52.192.76:8080/startit/$image");
                            }
                          },
                          child: Container(
                            width: width * 0.3,
                            height: width * 0.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: image != ""
                                    ? (path == ""
                                        ? NetworkImage(
                                            "http://164.52.192.76:8080/startit/$image",
                                          )
                                        : FileImage(
                                            File(path),
                                          ))
                                    : NetworkImage(
                                        "http://164.52.192.76:8080/startit/frontassets/images/Logo_Tagline.png",
                                      ),
                              ),
                            ),
                          ),
                        ),
                        if (_tabController.index == 1)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              height: height * 0.06,
                              width: width * 0.08,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: GestureDetector(
                                onTap: addImage,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: width * 0.08,
                        ),
                        Text(
                          name,
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          emailMain,
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  height: height * 0.55,
                  child: nestedTabs(height, move),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nestedTabs(double height, String move1) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
            child: new SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Expanded(child: new Container()),
                  new TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    labelPadding: EdgeInsets.all(10.0),
                    indicatorColor: Colors.blue,
                    indicatorWeight: 3.0,
                    tabs: [
                      Text(
                        "About",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      Text(
                        "Edit Profile",
                        textScaleFactor: 1,
                        style: TextStyle(
                            color: _tabController.index == 1
                                ? Colors.blue
                                : Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            about(move1),
            edit(height, move1),
          ],
        ),
      ),
    );
  }

  Widget about(String move1) {
    if (gender == "M") {
      gender = "Male";
    }
    if (gender == "F") {
      gender = "Female";
    }
    if (gender == "O") {
      gender = "Others";
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PHONE",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    mobile,
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "EMAIL",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.047,
                    child: Text(
                      emailMain,
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "GENDER",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    gender,
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DATE  OF  BIRTH",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(DateTime.parse(dob)),
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "LOCATION",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.047,
                    child: Text(
                      location,
                      textScaleFactor: 1,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  if (move1 == "/occupation" || move1 == "/domain")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OCCUPATION",
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          occupation,
                          textScaleFactor: 1,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/change_password');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Change Password',
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
    );
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

        countryID = userData["country"];
        //countryName = userData["country_name"];
        print(countryID);
        countryDropDown =
            countriesList.firstWhere((element) => element.ID == countryID);
        countryName = countryDropDown.NAME;

        await getState();

        stateID = userData["state"];
        //stateName = userData["state_name"];
        print(stateID);
        stateDropDown =
            stateList.firstWhere((element) => element.ID == stateID);
        stateName = stateDropDown.NAME;

        await getCity();

        cityID = userData["city"];
        //cityName = userData["city_name"];
        print(cityID);
        cityDropDown = cityList.firstWhere((element) => element.ID == cityID);
        cityName = cityDropDown.NAME;

        setState(() {
          image = userData["profile_image"] != null
              ? userData["profile_image"]
              : "";
          profileImageMain = userData["profile_image"] != null
              ? userData["profile_image"]
              : "";
          location = "${userData["city_name"]}, ${userData["state_name"]}";
          dob = userData["dob"];
          gender = userData["gender"] != null ? userData["gender"] : "";
          bulbColor = gender;

          _selectedDate = (DateTime.parse(userData["dob"]));

          pincodeController.text = userData["pincode"];

          occupation = userData["what_do_you_do"] != null
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
            businessDropDown = businessList
                .firstWhere((element) => element.ID == businessTypeID);
            business1 = businessDropDown.NAME;
          }
        });
      }
    }
  }

  Widget edit(double height, String move1) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PHONE",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: TextFormField(
                      controller: createUserController4,
                      style: TextStyle(fontSize: 14),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
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
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DATE  OF  BIRTH",
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    // padding: EdgeInsets.only(
                    //   left: 5,
                    //   right: 5,
                    // ),
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                    child: TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        _selectedDate == null
                            ? 'Choose Date'
                            : DateFormat('dd MMM yyyy').format(_selectedDate),
                        textScaleFactor: 1,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "GENDER",
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    "Male",
                    textScaleFactor: 1,
                  )
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.2),
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
                    "Female",
                    textScaleFactor: 1,
                  )
                ],
              ),
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
                "Prefer Not to say",
                textScaleFactor: 1,
              ),
            ],
          ),
          Text(
            "LOCATION",
            textScaleFactor: 1,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            'Country',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.05,
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
              child: DropdownButton(
                hint: Text(
                  'Enter your country',
                  textScaleFactor: 1,
                ),
                iconSize: 30.0,
                isExpanded: true,
                underline: SizedBox(),
                value: countryDropDown,
                onChanged: (DropDown _value) {
                  stateDropDown = null;
                  countryName = _value.NAME;
                  countryID = _value.ID;
                  setState(() {
                    countryDropDown = _value;
                  });
                  getState();
                },
                items: countriesList.map((DropDown country) {
                  return DropdownMenuItem<DropDown>(
                    value: country,
                    child: Text(
                      country.NAME,
                      textScaleFactor: 1,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            'State',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.05,
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
              child: DropdownButton(
                hint: Text(
                  'Enter your state',
                  textScaleFactor: 1,
                ),
                iconSize: 30.0,
                isExpanded: true,
                underline: SizedBox(),
                value: stateDropDown,
                onChanged: (DropDown _value) {
                  cityDropDown = null;
                  stateName = _value.NAME;
                  stateID = _value.ID;
                  setState(() {
                    stateDropDown = _value;
                  });
                  getCity();
                },
                items: stateList.map((DropDown state) {
                  return DropdownMenuItem<DropDown>(
                    value: state,
                    child: Text(
                      state.NAME,
                      textScaleFactor: 1,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            'City',
            textScaleFactor: 1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.05,
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
              child: DropdownButton(
                hint: Text(
                  'Enter your city',
                  textScaleFactor: 1,
                ),
                iconSize: 30.0,
                isExpanded: true,
                underline: SizedBox(),
                value: cityDropDown,
                onChanged: (DropDown _value) {
                  cityName = _value.NAME;
                  cityID = _value.ID;
                  setState(() {
                    cityDropDown = _value;
                  });
                },
                items: cityList.map((DropDown city) {
                  return DropdownMenuItem<DropDown>(
                    value: city,
                    child: Text(
                      city.NAME,
                      textScaleFactor: 1,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          // if (move1 != "/occupation" && move1 != "/domain")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pin Code',
                textScaleFactor: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.06,
                child: TextFormField(
                  style: TextStyle(fontSize: 14),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  controller: pincodeController,
                  decoration: InputDecoration(
                    counter: SizedBox(),
                    contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                    filled: true,
                    fillColor: Colors.grey[50],
                    focusColor: Colors.white70,
                    hintText: 'Enter 6-digit pin code',
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          if (move1 == "/occupation" || move1 == "/domain")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "OCCUPATION",
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(
                  height: 5,
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
                          "Job",
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
                          "Student",
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
                          "Self Employed",
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
                          "Business",
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                if (screenNo == 1) job(height, move1),
                if (screenNo == 2) student(height, move1),
                if (screenNo == 3) selfEmployed(height, move1),
                if (screenNo == 4) business(height, move1),
              ],
            ),
          Center(
            child: Container(
              height: height * 0.05,
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                onPressed: () {
                  if (screenNo == 1) {
                    if (employment == "") {
                      WebResponseExtractor.showToast(
                          'Please Select Employment Type');
                    } else if (createUserController1.text.trim().isEmpty) {
                      WebResponseExtractor.showToast(
                          'Please Enter Your Job Title');
                    } else
                      jobApi(move1);
                  } else if (screenNo == 2) {
                    if (trade == "") {
                      WebResponseExtractor.showToast('Please Select Trade');
                    } else if (createUserController2.text.trim().isEmpty) {
                      WebResponseExtractor.showToast(
                          'Please Enter your School or University');
                    } else
                      tradeApi(move1);
                  } else if (screenNo == 3) {
                    if (nOfWork == "") {
                      WebResponseExtractor.showToast(
                          'Please Select Nature of Work');
                    } else if (createUserController3.text.trim().isEmpty) {
                      WebResponseExtractor.showToast(
                          'Please Enter Your Work Title');
                    } else
                      natureApi(move1);
                  } else if (screenNo == 4) {
                    if (business1 == "") {
                      WebResponseExtractor.showToast(
                          'Please Select Business Occupation');
                    } else
                      businessApi(move1);
                  }
                  if (createUserController4.text.length != 10) {
                    WebResponseExtractor.showToast(
                        'Please Enter a Valid Mobile Number');
                  } else if (int.parse(createUserController4.text[0]) != 6 &&
                      int.parse(createUserController4.text[0]) != 7 &&
                      int.parse(createUserController4.text[0]) != 8 &&
                      int.parse(createUserController4.text[0]) != 9) {
                    WebResponseExtractor.showToast(
                        'Please Enter a Valid Mobile Number');
                  } else if (countryID == "") {
                    WebResponseExtractor.showToast(
                        "Please Select Your Country");
                  } else if (stateID == "") {
                    WebResponseExtractor.showToast("Please Select Your State");
                  } else if (cityID == "") {
                    WebResponseExtractor.showToast("Please Select Your City");
                  } else {
                    addData(move1);
                    updateLocation(move1);
                    _tabController.animateTo(0);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Save',
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
    );
  }

  Widget job(double height, String move1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Title',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextFormField(
            style: TextStyle(fontSize: 14),
            controller: createUserController1,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              counter: SizedBox(),
              contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
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
        ),
        SizedBox(height: 20),
        Text(
          'Employment Type',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.05,
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
              onChanged: (DropDown newValue) {
                setState(() {
                  employmentTypeDropDown = newValue;
                  employment = employmentTypeDropDown.NAME;
                  employmentTypeID = employmentTypeDropDown.ID;
                });
              },
              items: employmentTypeList.map((DropDown valueItem) {
                return DropdownMenuItem<DropDown>(
                  value: valueItem,
                  child: Text(
                    valueItem.NAME,
                    textScaleFactor: 1,
                  ),
                );
              }).toList()),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget student(double height, String move1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trade',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.05,
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
            onChanged: (DropDown _value) {
              setState(() {
                tradeDropDown = _value;
                trade = tradeDropDown.NAME;
                tradeTypeID = tradeDropDown.ID;
              });
            },
            items: tradeList.map((DropDown valueItem) {
              return DropdownMenuItem<DropDown>(
                value: valueItem,
                child: Text(
                  valueItem.NAME,
                  textScaleFactor: 1,
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "University or School",
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextFormField(
            style: TextStyle(fontSize: 14),
            controller: createUserController2,
            decoration: InputDecoration(
              counter: SizedBox(),
              contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
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
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget selfEmployed(double height, String move1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Title',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.06,
          child: TextFormField(
            style: TextStyle(fontSize: 14),
            controller: createUserController3,
            decoration: InputDecoration(
              counter: SizedBox(),
              contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
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
        ),
        SizedBox(height: 20),
        Text(
          'Nature of Work',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.05,
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
              onChanged: (DropDown newValue) {
                setState(() {
                  natureOfWork = newValue;
                  nOfWork = natureOfWork.NAME;
                  nOfWorkID = natureOfWork.ID;
                });
              },
              items: natureOfWorkList.map(
                (DropDown valueItem) {
                  return DropdownMenuItem<DropDown>(
                    value: valueItem,
                    child: Text(
                      valueItem.NAME,
                      textScaleFactor: 1,
                    ),
                  );
                },
              ).toList()),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget business(double height, String move1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Occupation',
          textScaleFactor: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: height * 0.02),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.05,
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
            onChanged: (DropDown _value) {
              setState(() {
                businessDropDown = _value;
                business1 = businessDropDown.NAME;
                businessTypeID = businessDropDown.ID;
              });
            },
            items: businessList.map((DropDown valueItem) {
              return DropdownMenuItem<DropDown>(
                value: valueItem,
                child: Text(
                  valueItem.NAME,
                  textScaleFactor: 1,
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          height: 20,
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
          setState(() {
            occupation = "Job";
          });
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
          setState(() {
            occupation = "Job";
          });
          WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        }
      }
    }
  }

  void tradeApi(String move) async {
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
          setState(() {
            occupation = "Student";
          });
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
          setState(() {
            occupation = "Student";
          });
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
          setState(() {
            occupation = "Business";
          });
          print(jsonData);
        }
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
        setState(() {
          occupation = "Self Employed";
        });
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
        setState(() {
          occupation = "Self Employed";
        });
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
        employmentTypeList.add(new DropDown(category["id"], category["name"]));
      }
    });
    getTrade();
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
        tradeList.add(new DropDown(category["id"], category["name"]));
      }
    });
    getNatureOfWork();
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
        getBusinessFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getBusinessFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        businessList.add(new DropDown(category["id"], category["name"]));
      }
    });
    getProfileData();
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
        natureOfWorkList.add(new DropDown(category["id"], category["name"]));
      }
    });
    getBusiness();
  }

  void getCountries() async {
    final response = await http.post(
      Uri.parse(WebApis.COUNTRY),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "COUNTRY_MASTER");

      if (data["code"] == 1) {
        getCountriesFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getCountriesFromWeb(var jsonData) async {
    setState(() {
      for (Map country in jsonData) {
        countriesList.add(new DropDown(country["id"], country["name"]));
      }
    });
    getEmploymentType();
  }

  void getState() async {
    Map mapData = {"country_id": int.parse(countryID)};

    final response = await http.post(
      Uri.parse(WebApis.STATE),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "STATE_MASTER");

      if (data["code"] == 1) {
        getStatesFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getStatesFromWeb(var jsonData) async {
    setState(() {
      stateList.clear();

      for (Map state in jsonData) {
        stateList.add(new DropDown(state["id"], state["name"]));
      }
    });
  }

  void getCity() async {
    Map mapData = {"state_id": int.parse(stateID)};

    final response = await http.post(
      Uri.parse(WebApis.CITY),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "CITY_MASTER");

      if (data["code"] == 1) {
        getCityFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getCityFromWeb(var jsonData) async {
    setState(() {
      cityList.clear();

      for (Map city in jsonData) {
        cityList.add(new DropDown(city["id"], city["name"]));
      }
    });
  }

  void addData(String move) async {
    Map data = {
      "user_id": userIdMain,
      "dob": dob,
      "gender": gender,
      "mobile": createUserController4.text,
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
        // if (jsonData["RETURN_CODE"] == 1) {
        //   bipId = jsonData["BIP_ID"];
        mobile = createUserController4.text;
        // }
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
        // if (jsonData["RETURN_CODE"] == 1) {
        //   // insId = jsonData["INS_ID"];
        // }
        mobile = createUserController4.text;
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
        // if (jsonData["RETURN_CODE"] == 1) {
        //   spId = jsonData["SP_ID"];
        //   print(spId);
        // }
        mobile = createUserController4.text;
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
        // if (jsonData["RETURN_CODE"] == 1) {
        //   ppId = jsonData["PP_ID"];
        // }
        mobile = createUserController4.text;
      }
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
    }
  }

  void updateLocation(String move) async {
    print("Updating Location");
    if (move == "/occupation") {
      loadedBip = false;
      Map data = {
        "user_id": userIdMain,
        "bip_id": bipId,
        "location_latitude": latitude,
        "location_longitude": longitude,
        "location_geo": geoLocation,
        "country": int.parse(countryID),
        "state": int.parse(stateID),
        "city": int.parse(cityID),
        "pincode": int.parse(pincodeController.text),
      };
      print(data);
      final response = await http.post(
        Uri.parse(WebApis.EDIT_BIP),
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
          WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        }
      }
    } else if (move == "/capabilities") {
      loadIns = false;
      Map data = {
        "user_id": userIdMain,
        "ins_id": insId,
        "location_latitude": latitude,
        "location_longitude": longitude,
        "location_geo": geoLocation,
        "country": int.parse(countryID),
        "state": int.parse(stateID),
        "city": int.parse(cityID),
        "pincode": int.parse(pincodeController.text),
      };
      print(data);
      final response = await http.post(
        Uri.parse(WebApis.INVESTOR_LOCATION),
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
          WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        }
      }
    } else if (move == "/domain") {
      loadService = false;
      Map data = {
        "user_id": userIdMain,
        "sp_id": spId,
        "location_latitude": latitude,
        "location_longitude": longitude,
        "location_geo": geoLocation,
        "country": int.parse(countryID),
        "state": int.parse(stateID),
        "city": int.parse(cityID),
        "pincode": int.parse(pincodeController.text),
      };
      print(data);
      final response = await http.post(
        Uri.parse(WebApis.EDIT_SP),
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
          WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        }
      }
    } else {
      loadedProduct = false;
      Map data = {
        "user_id": userIdMain,
        "pp_id": ppId,
        "location_latitude": latitude,
        "location_longitude": longitude,
        "location_geo": geoLocation,
        "country": int.parse(countryID),
        "state": int.parse(stateID),
        "city": int.parse(cityID),
        "pincode": int.parse(pincodeController.text),
      };
      print(data);
      final response = await http.post(
        Uri.parse(WebApis.PRODUCT_PROVIDER_LOCATION),
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
          WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
        }
      }
    }
    getProfileData();
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
    uploadMultipleImage();
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
          setState(() {
            image = "knjc";
          });
          print(response.data['RETUTN_MESSAGE']);
          WebResponseExtractor.showToast(response.data['RETUTN_MESSAGE']);
        }
      } catch (e) {
        print(e.toString());
      }
    }
    getProfileData();
  }
}

showDialogFunc(context, img) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.width * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                img,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class DropDown {
  String ID;
  String NAME;
  DropDown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
