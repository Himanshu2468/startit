import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:startit/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startit/src/screens/dashboard.dart';
import 'package:startit/src/screens/success_path.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:startit/src/services/facebookSignInApi.dart';
import 'package:startit/src/services/googleSignInApi.dart';

class AppDrawer extends StatefulWidget {
  final String move;
  AppDrawer(this.move);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String image = "";

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  void toggleSwitch(bool value) async {
    if (isEnglish == false) {
      setState(() {
        isEnglish = true;
      });
    } else {
      setState(() {
        isEnglish = false;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    final userRemember = json.encode({
      "languageCheck": isEnglish,
    });

    prefs.setString("language", userRemember);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.move == "/occupation") {
      return bipDrawer(context);
    } else if (widget.move == "/capabilities") {
      return investorDrawer(context);
    } else if (widget.move == "/product_provider") {
      return ppDrawer(context);
    } else
      return spDrawer(context);
  }

  Drawer bipDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Profile',
              textScaleFactor: 1,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  children: [
                    Icon(Icons.language),
                    SizedBox(width: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                      child: DropdownButton(
                        // hint: Text(
                        //   isEnglish ? 'Language' : "भाषा",
                        // ),
                        style: TextStyle(color: Colors.black),
                        iconSize: 0.0,
                        underline: SizedBox(),
                        value: isEnglish,
                        onChanged: (_value) {
                          toggleSwitch(_value);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Dashboard("/occupation")),
                              (Route<dynamic> route) => false);
                        },
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text(
                              "English",
                              textScaleFactor: 1,
                            ),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text(
                              "Hindi",
                              textScaleFactor: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    final newRouteName = "/profile";
                    bool isNewRouteSameAsCurrent = false;

                    Navigator.popUntil(context, (route) {
                      if (route.settings.name == newRouteName) {
                        isNewRouteSameAsCurrent = true;
                      }
                      return true;
                    });

                    if (!isNewRouteSameAsCurrent) {
                      Navigator.pushNamed(context, newRouteName,
                          arguments: widget.move);
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image != ""
                            ? NetworkImage(
                                "http://164.52.192.76:8080/startit/$image",
                              )
                            : NetworkImage(
                                "https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png",
                              ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 16,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            name != null ? name : "",
            textScaleFactor: 1,
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          Text(
            emailMain != null ? emailMain : "",
            textScaleFactor: 1,
            style: TextStyle(fontSize: 9),
          ),
          ListTile(
            leading: Icon(Icons.speed_outlined),
            title: Text(
              'Dashboard',
              textScaleFactor: 1,
              style: TextStyle(fontSize: 13),
            ),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/dashboard";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                // Navigator.pushNamed(context, newRouteName,
                //     arguments: widget.move);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Dashboard(widget.move)),
                    (Route<dynamic> route) => false);
              }

              // Navigator.of(context)
              //     .pushNamed('/dashboard', arguments: widget.move);
            },
          ),
          ListTile(
            leading: Icon(Icons.all_out_rounded),
            title: Text(
              'My Ideas',
              textScaleFactor: 1,
              style: TextStyle(fontSize: 13),
            ),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/ideas";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName,
                    arguments: widget.move);
              }

              // Navigator.of(context).pushNamed("/ideas", arguments: widget.move);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.all_out_rounded),
          //   title: Text('Success path', style: TextStyle(fontSize: 13)),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     final newRouteName = "/ideas";
          //     bool isNewRouteSameAsCurrent = false;

          //     Navigator.popUntil(context, (route) {
          //       if (route.settings.name == newRouteName) {
          //         isNewRouteSameAsCurrent = true;
          //       }
          //       return true;
          //     });

          //     if (!isNewRouteSameAsCurrent) {
          //       Navigator.of(context).push(
          //           MaterialPageRoute(builder: (context) => SucessPath()));
          //     }

          //     // Navigator.of(context).pushNamed("/ideas", arguments: widget.move);
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.people_alt_outlined),
            title: Text('Manage Investors',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/manage-investors";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName,
                    arguments: widget.move);
              }

              // Navigator.of(context)
              //     .pushNamed('/manage-investors', arguments: widget.move);
            },
          ),
          ListTile(
            leading: Icon(Icons.construction),
            title: Text('Manage Resource Providers',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/manage-resource-provider";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName,
                    arguments: widget.move);
              }

              // Navigator.of(context)
              //     .pushNamed('/manage-investors', arguments: widget.move);
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer_outlined),
            title: Text('Chat',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              if (userFirebaseId != null && userFirebaseId != "")
                Navigator.of(context).pushNamed('/recentChat');
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Account Settings', style: TextStyle(fontSize: 13)),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed('/account_setting', arguments: move);
          //   },
          // ),
          // Row(children: [
          //   Switch(
          //     onChanged: toggleSwitch,
          //     value: isEnglish,
          //     activeColor: Colors.blue,
          //   ),
          //   SizedBox(
          //     width: 20,
          //   ),
          //   Text(
          //     'English',
          //     textScaleFactor: 1,
          //     style: TextStyle(fontSize: 15),
          //   )
          // ]),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () async {
              // final googleSignIn = GoogleSignIn();
              // if(googleSignIn.currentUser!=null){
              //   print("asas");
              //    googleSignIn.disconnect();
              //   FirebaseAuth.instance.signOut();
              // }
              googleSignOut();

              final prefs = await SharedPreferences.getInstance();
              prefs.remove("userData");
              isRemember = true;
              isRemember1 = true;
              isRemember2 = true;
              isRemember3 = true;
              isRemember4 = true;
              isRemember5 = true;
              isRemember6 = true;
              isRemember7 = true;
              isRemember8 = true;
              isRememberMe = false;
              isRememberMe1 = false;
              isRememberMe2 = false;
              isRememberMe3 = false;
              isRememberMe4 = false;
              isRememberMe5 = false;
              isRememberMe6 = false;
              isRememberMe7 = false;
              isRememberMe8 = false;
              bipIdeaId = 0;
              userFirebaseId = null;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/user_login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  Drawer investorDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Profile',
              textScaleFactor: 1,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language),
                    SizedBox(width: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                      child: DropdownButton(
                        // hint: Text(
                        //   isEnglish ? 'Language' : "भाषा",
                        // ),
                        style: TextStyle(color: Colors.black),
                        iconSize: 0.0,
                        underline: SizedBox(),
                        value: isEnglish,
                        onChanged: (_value) {
                          toggleSwitch(_value);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Dashboard("/capabilities")),
                              (Route<dynamic> route) => false);
                        },
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text(
                              "English",
                              textScaleFactor: 1,
                            ),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text(
                              "Hindi",
                              textScaleFactor: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.018),

          // Row(
          //   children: [
          //     SizedBox(width: MediaQuery.of(context).size.width * 0.58),
          //     Icon(
          //       Icons.help_outline,
          //       size: 12,
          //     ),
          //     Text(' Help'),
          //   ],
          // ),
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    final newRouteName = "/profile";
                    bool isNewRouteSameAsCurrent = false;

                    Navigator.popUntil(context, (route) {
                      if (route.settings.name == newRouteName) {
                        isNewRouteSameAsCurrent = true;
                      }
                      return true;
                    });

                    if (!isNewRouteSameAsCurrent) {
                      Navigator.pushNamed(context, newRouteName,
                          arguments: widget.move);
                    }

                    // Navigator.of(context)
                    //     .pushNamed("/profile", arguments: widget.move);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image != ""
                            ? NetworkImage(
                                "http://164.52.192.76:8080/startit/$image",
                              )
                            : NetworkImage(
                                "https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png",
                              ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 16,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            name,
            textScaleFactor: 1,
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          Text(
            emailMain,
            textScaleFactor: 1,
            style: TextStyle(fontSize: 9),
          ),
          ListTile(
            leading: Icon(Icons.speed_outlined),
            title: Text(
              'Dashboard',
              textScaleFactor: 1,
              style: TextStyle(fontSize: 13),
            ),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/dashboard";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                // Navigator.pushNamed(context, newRouteName,
                //     arguments: widget.move);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Dashboard(widget.move)),
                    (Route<dynamic> route) => false);
              }
              // Navigator.of(context)
              //     .pushNamed('/dashboard', arguments: widget.move);
            },
          ),
          ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Suggested Idea',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              loadIns = true;
              Navigator.of(context).pop();
              final newRouteName = "/suggested_ideas";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(
                  context,
                  newRouteName,
                );
              }
              // Navigator.of(context).pushNamed('/suggested_ideas');
            },
          ),
          ListTile(
            leading: Icon(Icons.batch_prediction),
            title: Text('All Ideas',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/all_ideas";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName,
                    arguments: widget.move);
              }
              // Navigator.of(context)
              //     .pushNamed('/all_ideas', arguments: widget.move);
            },
          ),
          ListTile(
            leading: Icon(Icons.psychology),
            title: Text('Manage Idea Person',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/manage-idea-person";

              Navigator.pushNamed(context, newRouteName,
                  arguments: widget.move);

              // Navigator.of(context)
              //     .pushNamed('/manage-idea-person', arguments: widget.move);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border_outlined),
            title: Text('My Interests',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              loadIns = true;
              Navigator.of(context).pop();
              final newRouteName = "/investor_interest";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName);
              }
              // Navigator.of(context).pushNamed('/investor_interest');
            },
          ),

          ListTile(
            leading: Icon(Icons.sensors),
            title: Text('My Capabilities',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              loadIns = true;
              Navigator.of(context).pop();
              final newRouteName = "/capabilities";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(
                  context,
                  newRouteName,
                );
              }
              // Navigator.of(context).pushNamed('/capabilities');
            },
          ),

          // ListTile(
          //   leading: Icon(Icons.circle),
          //   title: Text('Manage Resourse Providers',
          //       style: TextStyle(fontSize: 13)),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed(
          //         '/manage-resource-provider',
          //         arguments: move);
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Account Settings', style: TextStyle(fontSize: 13)),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushNamed('/account_setting', arguments: move);
          //   },
          // ),

          ListTile(
            leading: Icon(Icons.question_answer_outlined),
            title: Text('Chat',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              if (userFirebaseId != null && userFirebaseId != "")
                Navigator.of(context).pushNamed('/recentChat');
            },
          ),
          // Row(children: [
          //   Switch(
          //     onChanged: toggleSwitch,
          //     value: isEnglish,
          //     activeColor: Colors.blue,
          //   ),
          //   SizedBox(
          //     width: 20,
          //   ),
          //   Text(
          //     'English',
          //     textScaleFactor: 1,
          //     style: TextStyle(fontSize: 15),
          //   )
          // ]),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () async {
              // final googleSignIn = GoogleSignIn();
              //  if(googleSignIn.currentUser!=null){
              //     print("asas");
              //     await googleSignIn.disconnect();
              //     FirebaseAuth.instance.signOut();
              //   }
              googleSignOut();
              final prefs = await SharedPreferences.getInstance();
              userFirebaseId = null;
              prefs.remove("userData");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/user_login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  Drawer ppDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Profile',
              textScaleFactor: 1,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                    Icon(Icons.language),
                    SizedBox(width: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                      child: DropdownButton(
                        // hint: Text(
                        //   isEnglish ? 'Language' : "भाषा",
                        // ),
                        style: TextStyle(color: Colors.black),
                        iconSize: 0.0,
                        underline: SizedBox(),
                        value: isEnglish,
                        onChanged: (_value) {
                          toggleSwitch(_value);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Dashboard("/product_provider")),
                              (Route<dynamic> route) => false);
                        },
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text(
                              "English",
                              textScaleFactor: 1,
                            ),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text(
                              "Hindi",
                              textScaleFactor: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // Row(
          //   children: [
          //     SizedBox(width: MediaQuery.of(context).size.width * 0.58),
          //     Icon(
          //       Icons.help_outline,
          //       size: 12,
          //     ),
          //     Text(' Help'),
          //   ],
          // ),
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    final newRouteName = "/profile";
                    bool isNewRouteSameAsCurrent = false;

                    Navigator.popUntil(context, (route) {
                      if (route.settings.name == newRouteName) {
                        isNewRouteSameAsCurrent = true;
                      }
                      return true;
                    });

                    if (!isNewRouteSameAsCurrent) {
                      Navigator.pushNamed(context, newRouteName,
                          arguments: widget.move);
                    }
                    // Navigator.of(context)
                    //     .pushNamed("/profile", arguments: widget.move);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image != ""
                            ? NetworkImage(
                                "http://164.52.192.76:8080/startit/$image",
                              )
                            : NetworkImage(
                                "https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png",
                              ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 16,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            name,
            textScaleFactor: 1,
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          Text(
            emailMain,
            textScaleFactor: 1,
            style: TextStyle(fontSize: 9),
          ),
          ListTile(
            leading: Icon(Icons.speed_outlined),
            title: Text(
              'Dashboard',
              textScaleFactor: 1,
              style: TextStyle(fontSize: 13),
            ),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/dashboard";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                // Navigator.pushNamed(context, newRouteName,
                //     arguments: widget.move);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Dashboard(widget.move)),
                    (Route<dynamic> route) => false);
              }
              // Navigator.of(context)
              //     .pushNamed('/dashboard', arguments: widget.move);
            },
          ),
          ListTile(
            leading: Icon(Icons.all_out_rounded),
            title: Text('My Products',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/my-product";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName,
                    arguments: widget.move);
              }
              // Navigator.of(context)
              //     .pushNamed("/my-product", arguments: widget.move);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Account Settings', style: TextStyle(fontSize: 13)),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed('/account_setting', arguments: move);
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.lightbulb_outline),
          //   title: Text('Suggested Idea', style: TextStyle(fontSize: 13)),
          //   onTap: () {
          //     loadIns = true;
          //     Navigator.of(context).pop();
          //     final newRouteName = "/suggested_ideas";
          //     bool isNewRouteSameAsCurrent = false;

          //     Navigator.popUntil(context, (route) {
          //       if (route.settings.name == newRouteName) {
          //         isNewRouteSameAsCurrent = true;
          //       }
          //       return true;
          //     });

          //     if (!isNewRouteSameAsCurrent) {
          //       Navigator.pushNamed(
          //         context,
          //         newRouteName,
          //       );
          //     }
          //     // Navigator.of(context).pushNamed('/suggested_ideas');
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.question_answer_outlined),
            title: Text('Chat',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              if (userFirebaseId != null && userFirebaseId != "")
                Navigator.of(context).pushNamed('/recentChat');
            },
          ),
          // Row(children: [
          //   Switch(
          //     onChanged: toggleSwitch,
          //     value: isEnglish,
          //     activeColor: Colors.blue,
          //   ),
          //   SizedBox(
          //     width: 20,
          //   ),
          //   Text(
          //     'English',
          //     textScaleFactor: 1,
          //     style: TextStyle(fontSize: 15),
          //   )
          // ]),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () async {
              // final googleSignIn = GoogleSignIn();
              //  if(googleSignIn.currentUser!=null){
              //     print("asas");
              //     await googleSignIn.disconnect();
              //     FirebaseAuth.instance.signOut();
              //   }
              googleSignOut();
              userFirebaseId = null;
              final prefs = await SharedPreferences.getInstance();
              prefs.remove("userData");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/user_login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  Drawer spDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Profile',
              textScaleFactor: 1,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language),
                    SizedBox(width: 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.12,
                      child: DropdownButton(
                        // hint: Text(
                        //   isEnglish ? 'Language' : "भाषा",
                        // ),
                        style: TextStyle(color: Colors.black),
                        iconSize: 0.0,
                        underline: SizedBox(),
                        value: isEnglish,
                        onChanged: (_value) {
                          toggleSwitch(_value);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Dashboard("/domain")),
                              (Route<dynamic> route) => false);
                        },
                        items: [
                          DropdownMenuItem(
                            value: true,
                            child: Text(
                              "English",
                              textScaleFactor: 1,
                            ),
                          ),
                          DropdownMenuItem(
                            value: false,
                            child: Text(
                              "Hindi",
                              textScaleFactor: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // Row(
          //   children: [
          //     SizedBox(width: MediaQuery.of(context).size.width * 0.58),
          //     Icon(
          //       Icons.help_outline,
          //       size: 12,
          //     ),
          //     Text(' Help'),
          //   ],
          // ),
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    final newRouteName = "/profile";
                    bool isNewRouteSameAsCurrent = false;

                    Navigator.popUntil(context, (route) {
                      if (route.settings.name == newRouteName) {
                        isNewRouteSameAsCurrent = true;
                      }
                      return true;
                    });

                    if (!isNewRouteSameAsCurrent) {
                      Navigator.pushNamed(context, newRouteName,
                          arguments: widget.move);
                    }
                    // Navigator.of(context)
                    //     .pushNamed("/profile", arguments: widget.move);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image != ""
                            ? NetworkImage(
                                "http://164.52.192.76:8080/startit/$image",
                              )
                            : NetworkImage(
                                "https://cdn3.iconfinder.com/data/icons/sympletts-part-10/128/user-man-plus-512.png",
                              ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 16,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Text(
            name,
            textScaleFactor: 1,
            style: TextStyle(fontSize: 18, color: Colors.blue),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          Text(
            emailMain,
            textScaleFactor: 1,
            style: TextStyle(fontSize: 9),
          ),
          ListTile(
            leading: Icon(Icons.speed_outlined),
            title: Text(
              'Dashboard',
              textScaleFactor: 1,
              style: TextStyle(fontSize: 13),
            ),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/dashboard";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                // Navigator.pushNamed(context, newRouteName,
                //     arguments: widget.move);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Dashboard(widget.move)),
                    (Route<dynamic> route) => false);
              }
              // Navigator.of(context)
              //     .pushNamed('/dashboard', arguments: widget.move);
            },
          ),
          ListTile(
            leading: Icon(Icons.all_out_rounded),
            title: Text('My Services',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              Navigator.of(context).pop();
              final newRouteName = "/myServices";
              bool isNewRouteSameAsCurrent = false;

              Navigator.popUntil(context, (route) {
                if (route.settings.name == newRouteName) {
                  isNewRouteSameAsCurrent = true;
                }
                return true;
              });

              if (!isNewRouteSameAsCurrent) {
                Navigator.pushNamed(context, newRouteName,
                    arguments: widget.move);
              }
              // Navigator.of(context)
              //     .pushNamed('/myServices', arguments: widget.move);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Account Settings', style: TextStyle(fontSize: 13)),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed('/account_setting', arguments: move);
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.lightbulb_outline),
          //   title: Text('Suggested Idea', style: TextStyle(fontSize: 13)),
          //   onTap: () {
          //     loadIns = true;
          //     Navigator.of(context).pop();
          //     final newRouteName = "/suggested_ideas";
          //     bool isNewRouteSameAsCurrent = false;

          //     Navigator.popUntil(context, (route) {
          //       if (route.settings.name == newRouteName) {
          //         isNewRouteSameAsCurrent = true;
          //       }
          //       return true;
          //     });

          //     if (!isNewRouteSameAsCurrent) {
          //       Navigator.pushNamed(
          //         context,
          //         newRouteName,
          //       );
          //     }
          //     // Navigator.of(context).pushNamed('/suggested_ideas');
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.question_answer_outlined),
            title: Text('Chat',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () {
              if (userFirebaseId != null && userFirebaseId != "")
                Navigator.of(context).pushNamed('/recentChat');
            },
          ),
          // Row(children: [
          //   Switch(
          //     onChanged: toggleSwitch,
          //     value: isEnglish,
          //     activeColor: Colors.blue,
          //   ),
          //   SizedBox(
          //     width: 20,
          //   ),
          //   Text(
          //     'English',
          //     textScaleFactor: 1,
          //     style: TextStyle(fontSize: 15),
          //   )
          // ]),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout',
                textScaleFactor: 1, style: TextStyle(fontSize: 13)),
            onTap: () async {
              // final googleSignIn = GoogleSignIn();
              //  if(googleSignIn.currentUser!=null){
              //   print("asas");
              //   await googleSignIn.disconnect();
              //   FirebaseAuth.instance.signOut();
              // // }
              googleSignOut();
              userFirebaseId = null;
              final prefs = await SharedPreferences.getInstance();
              prefs.remove("userData");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/user_login', (Route<dynamic> route) => false);
            },
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
        Map data12 = WebResponseExtractor.filterWebData(response,
            dataObject: "share_url");
        shareUserUrl = data12['data'];
        var userData = data["data"];

        setState(() {
          image = userData["profile_image"] != null
              ? userData["profile_image"]
              : "";
          profileImageMain = userData["profile_image"] != null
              ? userData["profile_image"]
              : "";
        });
      }
    }
  }

  Future googleSignOut() async {
    final user = await GoogleSignInApi.logOut();
  }
}
