import 'package:flutter/material.dart';
import 'package:startit/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/WebApis.dart';
import '../services/WebResponseExtractor.dart';

class AddModify4 extends StatefulWidget {
  PageController pageController = PageController();

  int sliderIndex;

  double width;

  double height;

  String rowText1;

  String rowText2;

  String rowText3;
  String colText1;

  String colText2;

  String colText3;

  bool fourth;

  String lastText;
  String str;
  String str2;
  AddModify4(
      this.pageController,
      this.sliderIndex,
      this.width,
      this.height,
      this.rowText1,
      this.rowText2,
      this.rowText3,
      this.colText1,
      this.colText2,
      this.colText3,
      this.fourth,
      this.lastText,
      this.str,
      this.str2);

  @override
  _AddModify4State createState() => _AddModify4State();
}

class _AddModify4State extends State<AddModify4>
    with AutomaticKeepAliveClientMixin<AddModify4> {
  @override
  void initState() {
    // if (loadedBip == true) {
    //   getData();
    // } else
    //   checkBools();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish
              ? "Manage Who Can ${widget.str} Your ${widget.str2}"
              : "प्रबंधित करें कि आपका ${widget.str2} कौन ${widget.str} सकता है",
          textScaleFactor: 1,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: widget.height * 0.04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: widget.width * 0.3,
            ),
            Text(
              widget.rowText1,
              textScaleFactor: 1,
            ),
            Text(
              widget.rowText2,
              textScaleFactor: 1,
            ),
            Text(
              widget.rowText3,
              textScaleFactor: 1,
            ),
          ],
        ),
        SizedBox(
            width: widget.width,
            child: Divider(
              color: Colors.red,
              thickness: widget.width * 0.005,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // width: width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.colText1,
                    textScaleFactor: 1,
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: widget.height * 0.06,
                  ),
                  Text(
                    widget.colText2,
                    textScaleFactor: 1,
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: widget.height * 0.06,
                  ),
                  Text(
                    widget.colText3,
                    textScaleFactor: 1,
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: widget.height * 0.3,
              // width: width * 0.2,
              child: VerticalDivider(
                color: Colors.red,
                thickness: widget.width * 0.005,
              ),
            ),
            AbsorbPointer(
              absorbing: widget.fourth
                  ? false
                  : (noInvestorSelected == true ? true : false),
              child: Opacity(
                opacity:
                    widget.fourth ? 1 : (noInvestorSelected == true ? 0.35 : 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                        value: widget.fourth ? isRemember : isRememberMe,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember = !isRemember
                                : isRememberMe = !isRememberMe;
                          });
                        }),
                    SizedBox(
                      height: widget.height * 0.02,
                    ),
                    Checkbox(
                        value: widget.fourth ? isRemember1 : isRememberMe1,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember1 = !isRemember1
                                : isRememberMe1 = !isRememberMe1;
                          });
                        }),
                    SizedBox(
                      height: widget.height * 0.02,
                    ),
                    Checkbox(
                        value: widget.fourth ? isRemember2 : isRememberMe2,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember2 = !isRemember2
                                : isRememberMe2 = !isRememberMe2;
                          });
                        }),
                  ],
                ),
              ),
            ),
            AbsorbPointer(
              absorbing:
                  widget.fourth ? false : (noPPSelected == true ? true : false),
              child: Opacity(
                opacity: widget.fourth ? 1 : (noPPSelected == true ? 0.35 : 1),
                child: Column(
                  children: [
                    Checkbox(
                        value: widget.fourth ? isRemember3 : isRememberMe3,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember3 = !isRemember3
                                : isRememberMe3 = !isRememberMe3;
                          });
                        }),
                    SizedBox(
                      height: widget.height * 0.02,
                    ),
                    Checkbox(
                        value: widget.fourth ? isRemember4 : isRememberMe4,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember4 = !isRemember4
                                : isRememberMe4 = !isRememberMe4;
                          });
                        }),
                    SizedBox(
                      height: widget.height * 0.02,
                    ),
                    Checkbox(
                        value: widget.fourth ? isRemember5 : isRememberMe5,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember5 = !isRemember5
                                : isRememberMe5 = !isRememberMe5;
                          });
                        }),
                  ],
                ),
              ),
            ),
            AbsorbPointer(
              absorbing:
                  widget.fourth ? false : (noSPSelected == true ? true : false),
              child: Opacity(
                opacity: widget.fourth ? 1 : (noSPSelected == true ? 0.35 : 1),
                child: Column(
                  children: [
                    Checkbox(
                        value: widget.fourth ? isRemember6 : isRememberMe6,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember6 = !isRemember6
                                : isRememberMe6 = !isRememberMe6;
                          });
                        }),
                    SizedBox(
                      height: widget.height * 0.02,
                    ),
                    Checkbox(
                        value: widget.fourth ? isRemember7 : isRememberMe7,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember7 = !isRemember7
                                : isRememberMe7 = !isRememberMe7;
                          });
                        }),
                    SizedBox(
                      height: widget.height * 0.02,
                    ),
                    Checkbox(
                        value: widget.fourth ? isRemember8 : isRememberMe8,
                        onChanged: (value) {
                          setState(() {
                            widget.fourth
                                ? isRemember8 = !isRemember8
                                : isRememberMe8 = !isRememberMe8;
                          });
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(widget.width * 0.06),
          child: Text(
            widget.lastText,
            textScaleFactor: 1,
            style: TextStyle(fontSize: 15),
          ),
        ),
        SizedBox(
          height: widget.height * 0.05,
        ),
        ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEnglish ? 'Save & Continue' : 'सहेजें और जारी रखें',
                textScaleFactor: 1,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Icon(Icons.chevron_right)
            ],
          ),
          onPressed: () {
            if (widget.sliderIndex == 5) {
              addSixthBip();
              Navigator.of(context).pushNamed('/add_resources');
            } else {
              addFourthBip();
              checkBools();
              widget.pageController.animateToPage(widget.sliderIndex + 1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn);
            }
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
  String check(bool c) {
    if (c == true) {
      return "Y";
    } else {
      return "N";
    }
  }

  void addFourthBip() async {
    Map data = {
      "user_id": userIdMain,
      "bip_idea_id": bipIdeaId,
      "idea_uniqueness_ins_can_read": check(isRemember1),
      "idea_uniqueness_rp_can_read": check(isRemember4),
      "idea_uniqueness_sp_can_read": check(isRemember7),
      "idea_summary_ins_can_read": check(isRemember),
      "idea_summary_rp_can_read": check(isRemember3),
      "idea_summary_sp_can_read": check(isRemember6),
      "idea_case_study_ins_can_read": check(isRemember2),
      "idea_case_study_rp_can_read": check(isRemember5),
      "idea_case_study_sp_can_read": check(isRemember8),
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.ADD_BIP_IDEA_THIRD),
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

  void addSixthBip() async {
    Map data = {
      "user_id": userIdMain,
      "bip_idea_id": bipIdeaId,
      "video_path_ins_can_see": check(isRememberMe1),
      "video_path_rp_can_see": check(isRememberMe4),
      "video_path_sp_can_see": check(isRememberMe7),
      "picture_path_ins_can_see": check(isRememberMe),
      "picture_path_rp_can_see": check(isRememberMe3),
      "picture_path_sp_can_see": check(isRememberMe6),
      "doc_path_ins_can_see": check(isRememberMe2),
      "doc_path_sp_can_see": check(isRememberMe5),
      "doc_path_rp_can_see": check(isRememberMe8),
    };
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.ADD_BIP_IDEA_MEDIA_PRIVACY),
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

  void getData() async {
    Map mapData = {"idea_id": bipIdeaId};
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.VIEW_IDEA),
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
        if (widget.fourth) {
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "IDEA_DETAILS");
          var userData = data["data"];
          setState(() {
            if (userData["idea_uniqueness_ins_can_read"] == "N")
              isRemember1 = false;

            if (userData["idea_uniqueness_rp_can_read"] == "N")
              isRemember4 = false;

            if (userData["idea_uniqueness_sp_can_read"] == "N")
              isRemember7 = false;

            if (userData["idea_summary_ins_can_read"] == "N")
              isRemember = false;

            if (userData["idea_summary_rp_can_read"] == "N")
              isRemember3 = false;

            if (userData["idea_summary_sp_can_read"] == "N")
              isRemember6 = false;

            if (userData["idea_case_study_ins_can_read"] == "N")
              isRemember2 = false;

            if (userData["idea_case_study_rp_can_read"] == "N")
              isRemember5 = false;

            if (userData["idea_case_study_sp_can_read"] == "N")
              isRemember8 = false;
          });
        } else {
          Map data = WebResponseExtractor.filterWebData(response,
              dataObject: "MEDIA_PRIVACY");
          var userData = data["data"];

          setState(() {
            if (userData["video_path_ins_can_see"] == "Y") isRememberMe1 = true;

            if (userData["video_path_rp_can_see"] == "Y") isRememberMe4 = true;

            if (userData["video_path_sp_can_see"] == "Y") isRememberMe7 = true;

            if (userData["picture_path_ins_can_see"] == "Y")
              isRememberMe = true;

            if (userData["picture_path_rp_can_see"] == "Y")
              isRememberMe3 = true;

            if (userData["picture_path_sp_can_see"] == "Y")
              isRememberMe6 = true;

            if (userData["doc_path_ins_can_see"] == "Y") isRememberMe2 = true;

            if (userData["doc_path_sp_can_see"] == "Y") isRememberMe5 = true;

            if (userData["doc_path_rp_can_see"] == "Y") isRememberMe8 = true;
          });
        }
      }
    }
    checkBools();
  }

  void checkBools() {
    if (isRemember == false && isRemember1 == false && isRemember2 == false) {
      setState(() {
        isRememberMe = false;
        isRememberMe1 = false;
        isRememberMe2 = false;
        noInvestorSelected = true;
      });
    } else {
      setState(() {
        noInvestorSelected = false;
      });
    }
    if (isRemember3 == false && isRemember4 == false && isRemember5 == false) {
      setState(() {
        isRememberMe3 = false;
        isRememberMe4 = false;
        isRememberMe5 = false;
        noPPSelected = true;
      });
    } else {
      setState(() {
        noPPSelected = false;
      });
    }
    if (isRemember6 == false && isRemember7 == false && isRemember8 == false) {
      setState(() {
        isRememberMe6 = false;
        isRememberMe7 = false;
        isRememberMe8 = false;
        noSPSelected = true;
      });
    } else {
      setState(() {
        noSPSelected = false;
      });
    }
  }
}
