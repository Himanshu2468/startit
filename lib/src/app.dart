import 'dart:io';

import 'package:flutter/material.dart';
import 'package:startit/src/screens/all_ideas.dart';
import 'package:startit/src/screens/change_password.dart';
import 'package:startit/src/screens/in_app_notifications.dart';
import 'package:startit/src/screens/manage_idea_person.dart';
import 'package:startit/src/screens/manage_investors.dart';
import 'package:startit/src/screens/my_product.dart';
import 'package:startit/src/screens/product_provider_skills.dart';
import 'package:startit/src/screens/profile.dart';
import 'package:startit/src/screens/profile_accountSettings.dart';
import 'package:startit/src/screens/manage_resource_provider.dart';
import 'package:startit/src/screens/recent_chat.dart';
import 'package:startit/src/screens/sProvider_domain.dart';
import 'package:startit/src/screens/sProvider_productDetails.dart';
import 'package:startit/src/screens/sProvider_serviceDetails.dart';
import 'package:startit/src/screens/sProvider_skills.dart';
import 'package:startit/src/screens/usrLgn_password.dart';
import 'package:startit/src/screens/usrLgn_userId.dart';
import 'package:startit/src/services/notification.dart';
import './screens/add_resources.dart';
import 'package:startit/src/screens/capabilities.dart';
import 'package:startit/src/screens/pdtProvider_details.dart';
import 'package:startit/src/screens/pdtProvider_productDetails.dart';
import 'package:startit/src/screens/resource_requirements.dart';
import 'package:startit/src/screens/suggested_ideas.dart';
import 'screens/intro_placeholder.dart';
import 'screens/login_screen.dart';
import 'screens/user_login.dart';
import 'screens/signUp.dart';
import 'screens/otp_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/location.dart';
import 'screens/password_check.dart';
import 'screens/personal_details.dart';
import 'screens/occupation_screen.dart';
import 'screens/add_modify_data.dart';
import 'screens/investorInterest_screen.dart';
import 'screens/resource_parameters.dart';
import 'screens/dashboard.dart';
import './screens/ideas.dart';
import './screens/myServices.dart';
import 'package:startit/main.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool isStop = true;
  String move = "";
  bool cir = true;
  bool isLogin = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final Notifications _notifications = Notifications();

  @override
  void initState() {
    fcmFunction();
    checklanguage();
    super.initState();
  }

  void checklanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("language")) {
      final extractlanguage =
          json.decode(prefs.getString("language")) as Map<String, Object>;
      isEnglish = extractlanguage["languageCheck"];
    }
  }

  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STARTiT',
      home: isLogin
          ? Dashboard(move)
          : FutureBuilder(
              builder: (ctx, authresultSnapshot) => cir
                  ? Center(child: CircularProgressIndicator())
                  : IntroPlaceholder(),
              future: isStop ? tryAutoLogin() : null,
            ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue[300],
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
              bodyText1: TextStyle(
                fontSize: 10.0,
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
              button: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue[400],
            minimumSize: Size(double.maxFinite, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      routes: {
        '/login': (ctx) => LoginScreen(),
        '/user_login': (ctx) => UserLogin(),
        '/signUp': (ctx) => SignUp(),
        '/otp': (ctx) => Otp(),
        '/welcome': (ctx) => Welcome(),
        '/password-check': (ctx) => PasswordCheck(),
        '/personal_details': (ctx) => PersonalDetails(),
        '/location': (ctx) => Location(),
        '/occupation': (ctx) => OccupationScreen(),
        '/add_modify': (ctx) => AddModifyData(),
        '/investor_interest': (ctx) => InvestorInterest(),
        '/capabilities': (ctx) => Capabilities(),
        '/resource': (ctx) => ResourceRequirements(),
        '/suggested_ideas': (ctx) => SuggestedIdeas(),
        '/add_resources': (ctx) => AddResource(),
        "/resource_parameters": (ctx) => ResourceParameters(),
        "/product_provider": (ctx) => ProductProviderDetails(),
        '/domain': (ctx) => ServiceProviderDomain(),
        '/service_details': (ctx) => ServiceProviderServiceDetails(),
        '/skills': (ctx) => ServiceProviderSkills(),
        '/sproduct_detail': (ctx) => ServiceProviderProductDetails(),
        "/pproduct_detail": (ctx) => ProductProviderProductDetails(),
        "/dashboard": (ctx) => Dashboard(),
        "/ideas": (ctx) => Ideas(),
        "/manage-investors": (ctx) => ManageInvestors(),
        "/manage-resource-provider": (ctx) => ManageResourceProvider(),
        "/account_setting": (ctx) => AccountSettings(),
        '/profile': (ctx) => Profile(),
        '/all_ideas': (ctx) => AllIdeas(),
        '/manage-idea-person': (ctx) => ManageIdeaPerson(),
        "/my-product": (ctx) => MyProduct(),
        '/myServices': (ctx) => MyServices(),
        '/forgot_uderId': (ctx) => ForgotUderId(),
        '/forgot_password': (ctx) => ForgotPassword(),
        // '/chat_screen': (ctx) => ChatScreen(),
        // '/chat_screen': (ctx) => ChatScreen(),
        "/change_password": (ctx) => ChangePassword(),
        "/recentChat": (ctx) => RecentChat(),
        "/inAppNotification": (ctx) => InAppNotification(),
        "/product_provider_skills": (ctx) => ProductProviderSkills(),
      },
    );
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      setState(() {
        isLogin = false;
        cir = false;
        isStop = false;
        return false;
      });
    }
    final extractUserData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    print(extractUserData);
    userIdMain = extractUserData["userId"];
    name = extractUserData["displayName"];

    emailMain = extractUserData["email"];
    mobile = extractUserData["mobile"];
    userFirebaseId = extractUserData["userFirebaseId"];
    print(userFirebaseId);
    setState(() {
      move = extractUserData["move"];
    });
    if (extractUserData["move"] == "/occupation")
      bipId = extractUserData["id"];
    else if (extractUserData["move"] == "/capabilities")
      insId = extractUserData["id"];
    else if (extractUserData["move"] == "/product_provider")
      ppId = extractUserData["id"];
    else
      spId = extractUserData["id"];
    setState(() {
      isLogin = true;
      cir = false;
      return true;
      // Navigator.of(context).pushReplacementNamed("/dashboard", arguments: move);
    });
  }

  fcmFunction() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("Id:" + token);
    });

    _firebaseMessaging.getToken().then((token) {
      userDeviceToken = token;
      print(userDeviceToken);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> result) async {
        print('on message $result');
        this._notifications.pushNotification(result, context);
      },
      onResume: (Map<String, dynamic> result) async {
        print('on resume $result');
        //showNotification(result);
        this._notifications.pushNotification(result, context);
      },
      onLaunch: (Map<String, dynamic> result) async {
        print('on launch $result');

        this._notifications.pushNotification(result, context);
        //Navigator.of(context).pushNamed('${result['data']['pagepath']}');
      },
    );
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Hello');
    });
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    _firebaseMessaging.onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {
        print("Settings registered: $settings");
      },
    );
  }
}

// changes done in manifest:
//             android:showWhenLocked="true"
//             android:turnScreenOn="true"
