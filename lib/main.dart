import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(App());
  });
}

String mobile = "";
String name = "";
String emailMain = "";
String profileImageMain = "";
int userIdMain;
int otp;
bool isEnglish = true;
String userFirebaseId;
String userDeviceToken;

int bipId;
int bipIdeaId;
bool loadedBip = false;
String categoryIDMain = "";

int insId;
int insIdeaId;
bool loadIns = false;

int ppId;
int productId = 0;
bool loadedProduct = false;
String ppCategoryIdsMain = "";

int spId;
int serviceId = 0;
bool loadService = false;
String spCategoryIdsMain = "";

bool noInvestorSelected = false;
bool noPPSelected = false;
bool noSPSelected = false;

bool isRemember = true;
bool isRemember1 = true;
bool isRemember2 = true;
bool isRemember3 = true;
bool isRemember4 = true;
bool isRemember5 = true;
bool isRemember6 = true;
bool isRemember7 = true;
bool isRemember8 = true;
bool isRememberMe = false;
bool isRememberMe1 = false;
bool isRememberMe2 = false;
bool isRememberMe3 = false;
bool isRememberMe4 = false;
bool isRememberMe5 = false;
bool isRememberMe6 = false;
bool isRememberMe7 = false;
bool isRememberMe8 = false;

String recentIdeaTitle = "";
String recentIdeaGroupId = "";
List<String> recentFriendListIds = [];
String recentUserLink = "";
String groupLink = "";
String shareUserUrl = "";
