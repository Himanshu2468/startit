import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
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

  TextEditingController locationController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  bool useLocation = false;

  static const kGoogleApiKey = "AIzaSyAGXDKWsGDky-Rpuq-JLofG7nuYludpq1U";

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  void initState() {
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    String move = ModalRoute.of(context).settings.arguments as String;
    String move1 = move;
    String locationText = "";
    if (move == "/occupation") {
      locationText = isEnglish
          ? "GPS location will help us to match your requirements"
          : 'GPS स्थान आपकी आवश्यकताओं को पूरा करने में हमारी सहायता करेगा';
    } else if (move == "/capabilities") {
      locationText = isEnglish
          ? "We need your location to serve you better"
          : 'आपको बेहतर सेवा देने के लिए हमें आपके स्थान की आवश्यकता है';
    } else {
      locationText = isEnglish
          ? "We need your location to show nearby customers for you"
          : 'आपके लिए आस-पास के ग्राहकों को दिखाने के लिए हमें आपके स्थान की आवश्यकता है';
    }

    if (move == "/domain") {
      move = "/occupation";
    }
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          isEnglish ? 'Location' : 'स्थान',
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
            //height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.1,
              vertical: height * 0.1,
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
                Text(
                  locationText,
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  height: height * 0.05,
                  child: TextFormField(
                      style: TextStyle(fontSize: 12),
                      controller: locationController,
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        prefixIcon: Icon(Icons.search),
                        hintText: isEnglish
                            ? 'Search your location'
                            : 'अपना स्थान खोजें',
                        filled: true,
                        fillColor: Colors.grey[100],
                        focusColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Colors.grey[300],
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onTap: () async {
                        Prediction result = await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          // language: "en",
                          // types: ["(regions)"],
                          // components: [new Component(Component.country, "in")],
                          // region: "in",
                          // strictbounds: false,
                        );

                        if (result != null) {
                          setState(() {
                            locationController.text = result.description;
                          });
                          geoLocation = result.description;
                        }
                        displayPrediction(result);
                      }),
                ),
                SizedBox(height: height * 0.01),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.my_location_rounded,
                        color: useLocation ? Colors.blue : Colors.grey[500],
                      ),
                      onTap: () {
                        setState(() {
                          useLocation = !useLocation;
                        });
                        if (useLocation == true) {
                          getCurrentLocation();
                        }
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    GestureDetector(
                      child: Text(
                        isEnglish
                            ? 'Use Your Location'
                            : 'अपने स्थान का प्रयोग करें',
                        textScaleFactor: 1,
                        style: TextStyle(
                            color:
                                useLocation ? Colors.blue : Colors.grey[500]),
                      ),
                      onTap: () {
                        setState(() {
                          useLocation = !useLocation;
                        });
                        if (useLocation == true) {
                          getCurrentLocation();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                text(isEnglish ? 'Country' : 'देश'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                buildDropDown(DropdownButton(
                  hint: Text(
                    isEnglish ? 'Enter your country' : 'अपना देश दर्ज करें',
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
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                text(isEnglish ? 'State' : 'राज्य'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                buildDropDown(DropdownButton(
                  hint: Text(
                    isEnglish ? 'Enter your state' : 'अपना राज्य दर्ज करें',
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
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                text(
                  isEnglish ? 'City' : 'शहर',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                buildDropDown(DropdownButton(
                  hint: Text(
                    isEnglish ? 'Enter your city' : 'अपना शहर दर्ज करें',
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
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                text(isEnglish ? 'Pin Code' : 'पिन कोड'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                buildDropDown(
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    maxLength: 6,
                    controller: pincodeController,
                    cursorColor: Colors.grey[700],
                    decoration: InputDecoration(
                        counter: SizedBox(),
                        hintText: isEnglish
                            ? 'Enter 6-digit pin code'
                            : '6 अंकों का पिन कोड दर्ज करें',
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.045,
                ),
                Center(
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.7,
                    child: ElevatedButton(
                      onPressed: () {
                        if (countryID == "") {
                          WebResponseExtractor.showToast(
                              "Please Select Your Country");
                        } else if (stateID == "") {
                          WebResponseExtractor.showToast(
                              "Please Select Your State");
                        } else if (cityID == "") {
                          WebResponseExtractor.showToast(
                              "Please Select Your City");
                        } else if (pincodeController.text.isEmpty) {
                          WebResponseExtractor.showToast(
                              "Please Enter your Pincode");
                        } else {
                          updateLocation(move1);
                          if (move == "/capabilities")
                            Navigator.of(context)
                                .pushNamed("/investor_interest");
                          else if (move == "/product_provider")
                            Navigator.of(context)
                                .pushNamed('/product_provider');
                          else
                            Navigator.of(context)
                                .pushNamed(move, arguments: move1);
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

  Widget text(String txt) {
    return Text.rich(
      TextSpan(
        text: txt,
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
    );
  }

  Widget buildDropDown(Widget child) {
    return InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
      child: child,
    );
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      latitude = detail.result.geometry.location.lat;
      longitude = detail.result.geometry.location.lng;

      print(latitude);
      print(longitude);
      getAddressFromCoordinates();
    }
    FocusScope.of(context).unfocus();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
    print(latitude);
    print(longitude);

    getAddressFromCoordinates();
  }

  void getAddressFromCoordinates() async {
    Coordinates coordinates = Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    countryName = first.countryName;
    stateName = first.adminArea;
    cityName = first.locality;
    geoLocation = first.addressLine;
    countryDropDown =
        countriesList.firstWhere((country) => country.NAME == countryName);
    countryID = countryDropDown.ID;
    await getState();
    stateDropDown = stateList.firstWhere((state) => state.NAME == stateName);
    stateID = stateDropDown.ID;
    await getCity();
    cityDropDown = cityList.firstWhere((city) => city.NAME == cityName);
    cityID = cityDropDown.ID;
    pincodeController.text = first.postalCode;
    setState(() {});

    print(first.countryName);
    print(first.adminArea);
    print(first.locality);
    print(first.subAdminArea);
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

    getProfileData();
  }

  Future<Null> getCountriesFromWeb(var jsonData) async {
    setState(() {
      for (Map country in jsonData) {
        countriesList.add(new DropDown(country["id"], country["name"]));
      }
    });
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

  void updateLocation(String move) async {
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

        countryID = userData["country"] != null ? userData["country"] : "";
        //countryName = userData["country_name"];
        print(countryID);
        if (userData["country"] != null) {
          countryDropDown =
              countriesList.firstWhere((element) => element.ID == countryID);
          countryName = countryDropDown.NAME;
          await getState();
        }

        stateID = userData["state"] != null ? userData["state"] : "";
        //stateName = userData["state_name"];
        print(stateID);
        if (userData["state"] != null) {
          stateDropDown =
              stateList.firstWhere((element) => element.ID == stateID);
          stateName = stateDropDown.NAME;
          await getCity();
        }

        cityID = userData["city"] != null ? userData["city"] : "";
        //cityName = userData["city_name"];
        print(cityID);
        if (userData["city"] != null) {
          cityDropDown = cityList.firstWhere((element) => element.ID == cityID);
          cityName = cityDropDown.NAME;
        }

        setState(() {
          pincodeController.text = userData["pincode"];
        });
      }
    }
  }
}

class DropDown {
  String ID;
  String NAME;
  DropDown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
