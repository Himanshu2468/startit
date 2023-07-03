import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:http/http.dart' as http;
import 'package:startit/main.dart';
import 'package:startit/src/screens/mng_invt_viewProfile.dart';
import 'package:startit/src/screens/view_service_list.dart';
import '../services/WebApis.dart';
import '../services/WebResponseExtractor.dart';

// ignore: must_be_immutable
class SucessPath extends StatefulWidget {
  String titleIdea;
  int id;
  SucessPath([this.id, this.titleIdea]);
  // const SucessPath({ Key? key }) : super(key: key);

  @override
  _SucessPathState createState() => _SucessPathState();
}

class _SucessPathState extends State<SucessPath> {
  List<SuccessDetail> l = [];
  List<SuccessPPSPDetail> insDetails = [];
  List<SuccessPPSPDetail> ppspList = [];

  bool isload = false;
  bool isloads = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSuccessData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            "Success Path",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        body: isload == false
            ? Container(
                height: height,
                width: width,
                color: Colors.blue,
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  padding: EdgeInsets.only(top: width * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          widget.titleIdea,
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: height * 0.008,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              maxRadius: height * 0.06,
                              backgroundImage: NetworkImage(profileImageMain ==
                                      null
                                  ? "http://164.52.192.76:8080/startit/frontassets/images/Logo_Tagline.png"
                                  : "http://164.52.192.76:8080/startit/$profileImageMain"),
                            ),
                            SizedBox(
                              height: height * 0.008,
                            ),
                            Text(
                              name,
                              textScaleFactor: 1,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: height * 0.008,
                            ),
                          ],
                        ),
                        Container(
                          height: height * 0.48,
                          child: ListView.builder(
                              // scrollDirection: Axis.horizontal,
                              itemCount: l.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SuccessTile(
                                  index,
                                  height,
                                  width,
                                  context,
                                  l[index].name,
                                  l[index].hindiName,
                                  l[index].id,
                                  l[index].role,
                                );
                              }),
                        ),
                        if (insDetails.length == 1)
                          Column(
                            children: [
                              CircleAvatar(
                                maxRadius: height * 0.06,
                                backgroundImage: NetworkImage(insDetails[0]
                                            .profileUrl ==
                                        null
                                    ? "http://164.52.192.76:8080/startit/frontassets/images/Logo_Tagline.png"
                                    : "http://164.52.192.76:8080/startit/${insDetails[0].profileUrl}"),
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                              Text(
                                insDetails[0].firstName +
                                    " " +
                                    insDetails[0].lastName,
                                textScaleFactor: 1,
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                            ],
                          ),
                        if (insDetails.length > 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.12,
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    maxRadius: height * 0.06,
                                    backgroundImage: NetworkImage(insDetails[0]
                                                .profileUrl ==
                                            null
                                        ? "http://164.52.192.76:8080/startit/frontassets/images/Logo_Tagline.png"
                                        : "http://164.52.192.76:8080/startit/${insDetails[0].profileUrl}"),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                  Text(
                                    insDetails[0].firstName +
                                        " " +
                                        insDetails[0].lastName,
                                    textScaleFactor: 1,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: height * 0.008,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                          child: Material(
                                        type: MaterialType.transparency,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.all(5),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.9,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: ListView.builder(
                                              // scrollDirection: Axis.horizontal,
                                              itemCount: insDetails.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    // );
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MIViewProfile(
                                                                int.parse(
                                                                    insDetails[
                                                                            index]
                                                                        .id),
                                                                insDetails[
                                                                        index]
                                                                    .email,
                                                                insDetails[
                                                                        index]
                                                                    .mobile,
                                                                insDetails[index]
                                                                        .firstName +
                                                                    " " +
                                                                    insDetails[
                                                                            index]
                                                                        .lastName,
                                                                ""),
                                                      ),
                                                    );
                                                  },
                                                  child: PPSPLIST(
                                                    height,
                                                    insDetails[index].firstName,
                                                    insDetails[index].lastName,
                                                    insDetails[index].mobile,
                                                    insDetails[index].email,
                                                    "",
                                                    insDetails[index]
                                                        .profileUrl,
                                                  ),
                                                );
                                              }),
                                        ),
                                      ));
                                    },
                                  );
                                },
                                child: Container(
                                  width: width * 0.1,
                                  height: width * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                  ),
                                  child: Center(
                                      child: Text(
                                    "+ " + (insDetails.length - 1).toString(),
                                    textScaleFactor: 1,
                                  )),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Container SuccessTile(
      int index,
      double height,
      double width,
      BuildContext context,
      String name,
      String hindiName,
      String id,
      String processFor) {
    return Container(
      // height: height * 0.8,
      // width: width * 0.5,
      child: Column(
        children: [
          if (index == 0)
            Dash(
                direction: Axis.vertical,
                length: height * 0.05,
                // dashLength: 15,
                dashColor: Colors.black),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (index % 2 == 0)
                SizedBox(
                  width: width * 0.25,
                ),
              if (index % 2 != 0)
                SizedBox(
                  width: width * 0.25,
                  height: height * 0.05,
                  child: Center(
                    child: Text(
                      isEnglish ? name : hindiName, textScaleFactor: 1,
                      // overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              // if (index % 2 != 0) Text("Developer"),
              SizedBox(
                  height: height * 0.05,
                  width: height * 0.1,
                  child: IconButton(
                    icon: Icon(
                      Icons.location_on_outlined,
                      size: height * 0.05,
                      color: Colors.orange,
                    ),
                    onPressed: () async {
                      setState(() {});
                      await getPPSPLIST(id, 0, 10);
                      return ppspList.isNotEmpty
                          ? isloads == false
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BipSpClass(ppspList, processFor, id);
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                )
                          : WebResponseExtractor.showToast("No Users");
                    },
                    // color: Colors.orange,
                  )),
              if (index % 2 == 0)
                SizedBox(
                  width: width * 0.25,
                  height: height * 0.05,
                  child: Center(
                    child: Text(
                      isEnglish ? name : hindiName, textScaleFactor: 1,
                      // overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              if (index % 2 != 0)
                SizedBox(
                  width: width * 0.25,
                ),

              // SizedBox(
              //   width: width * 0.2,
              // )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            (index + 1).toString(),
            textScaleFactor: 1,
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Dash(
              direction: Axis.vertical,
              length: height * 0.05,
              // dashLength: 15,
              dashColor: Colors.black),
          // SizedBox(
          //   height: height * 0.1,
          //   // height: 40,
          //   child: VerticalDivider(
          //     thickness: 2,
          //     color: Colors.black,
          //   ),
          // )
        ],
      ),
    );
  }

  Card PPSPLIST(double height, String first_name, String last_name,
      String mobile, String email, String roleNumber, String profileUrl) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          // Padding(
          //   padding:
          //       const EdgeInsets
          //               .only(
          //           top: 20.0),
          //   child: CircleAvatar(
          //     backgroundImage:
          //         NetworkImage(
          //       "http://164.52.192.76:8080/startit/$profile_image",
          //     ),
          //     backgroundColor:
          //         Colors
          //             .transparent,
          //     radius: width * 0.22,
          //   ),
          // ),
          //  /   height: MediaQuery.of(context).size.width * 0.5,
          //   child: Divider(
          //     thickness: 5,
          //     color: Colors.black,
          //   ),
          // )
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: height * 0.02),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  profileUrl == null
                      ? "http://164.52.192.76:8080/startit/frontassets/images/Logo_Tagline.png"
                      : "http://164.52.192.76:8080/startit/" + profileUrl,
                  // fit: BoxFit.,
                ),
              ),
              SizedBox(width: height * 0.02),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  first_name + " " + last_name,
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.19),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        email,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      mobile,
                      textScaleFactor: 1,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    if (roleNumber == "3")
                      Text(
                        "Product Provider",
                        textScaleFactor: 1,
                      ),
                    if (roleNumber == "4")
                      Text(
                        "Service Provider",
                        textScaleFactor: 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          // Padding(
          //   padding:
          //       const EdgeInsets.only(right: 10.0),
          //   child: Row(
          //     mainAxisAlignment:
          //         MainAxisAlignment.end,
          //     children: [
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         child: Text("Cancel"),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  void getSuccessData() async {
    setState(() {
      isload = true;
    });
    Map mapData = {"id": widget.id};

    final response = await http.post(
      Uri.parse(WebApis.GET_SUCCESS_PATH),
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
        Map data1 = WebResponseExtractor.filterWebData(response,
            dataObject: "SUCCESS_PATH_RR");
        // Map data = WebResponseExtractor.filterWebData(response,
        //     dataObject: "SUCCESS_PATH_IDEA");
        Map data2 = WebResponseExtractor.filterWebData(response,
            dataObject: "SUCCESS_PATH_INS");

        getIdeasFromWeb(data1["data"]);
        getIdeasFromWeb1(data2["data"]);
        setState(() {
          isload = false;
        });
        // getIdeasFromWeb2(data2["data"]);
      }
    } else {
      setState(() {
        isload = false;
      });
    }
  }

  Future<Null> getIdeasFromWeb(var jsonData) async {
    if (jsonData != null || jsonData != []) {
      setState(() {
        for (Map idea in jsonData) {
          l.add(SuccessDetail(
              id: idea["id"],
              hindiName: idea["hindi"],
              name: idea["name"],
              role: idea["processfor"]));
        }
      });
    }
  }

  Future<Null> getIdeasFromWeb1(var jsonData) async {
    if (jsonData != null || jsonData != []) {
      setState(() {
        for (Map idea in jsonData) {
          insDetails.add(SuccessPPSPDetail(
              id: idea["id"],
              email: idea["email"],
              firstName: idea["first_name"],
              lastName: idea["last_name"],
              mobile: idea["mobile"],
              roleNumber: idea["role_id"],
              profileUrl: idea["profile_image"]));
        }
      });
    }
  }

  // Future<Null> getIdeasFromWeb2(var jsonData) async {
  //   if (jsonData != null || jsonData != []) {
  //     setState(() {
  //       for (Map idea in jsonData) {
  //         l.add(SuccessDetail(
  //             id: idea["id"],
  //             hindiName: idea["hindi"],
  //             name: idea["name"],
  //             role: idea["processfor"]));
  //       }
  //     });
  //   }
  // }

  void getPPSPLIST(String ids, int offset, int limit) async {
    setState(() {
      isloads = true;
    });
    ppspList.clear();
    Map mapData = {"id": ids, "offset": offset, "limit": limit};

    final response = await http.post(
      Uri.parse(WebApis.GET_RESOURCE_PROVIDER_SKILL_ID),
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
        Map data1 =
            WebResponseExtractor.filterWebData(response, dataObject: "RP_LIST");

        getIdeasFromWebSPPP(data1["data"]);

        setState(() {
          isloads = false;
        });
      }

      setState(() {
        isload = false;
      });
    } else {
      setState(() {
        isloads = false;
      });
    }
  }

  Future<Null> getIdeasFromWebSPPP(var jsonData) async {
    if (jsonData != null || jsonData != []) {
      setState(() {
        for (Map idea in jsonData) {
          ppspList.add(SuccessPPSPDetail(
              id: idea["id"],
              email: idea["email"],
              firstName: idea["first_name"],
              lastName: idea["last_name"],
              mobile: idea["mobile"],
              roleNumber: idea["role_id"],
              profileUrl: idea["profile_image"]));
        }
      });
    }
  }
}

class SuccessDetail {
  String name;
  String id;
  String hindiName;
  String role;
  SuccessDetail({this.name, this.id, this.hindiName, this.role});
}

class SuccessPPSPDetail {
  String firstName;
  String lastName;
  String id;
  String email;
  String mobile;
  String roleNumber;
  String profileUrl;
  SuccessPPSPDetail(
      {this.firstName,
      this.lastName,
      this.id,
      this.email,
      this.mobile,
      this.roleNumber,
      this.profileUrl});
}

class BipSpClass extends StatefulWidget {
  var ppspList, processFor, id;

  bool isload = false;
  bool isloads = true;
  BipSpClass(this.ppspList, this.processFor, this.id);
  @override
  _BipSpClassState createState() => _BipSpClassState();
}

class _BipSpClassState extends State<BipSpClass> {
  ScrollController _controller;

  int offset = 0;
  int limit = 10;
  @override
  void initState() {
    _controller = new ScrollController();
    _controller.addListener(_scrollListener);
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print('Page reached end of page');
        setState(() {
          //     LoadingProgress("Loading..");
          Text(
            'Loading',
            textScaleFactor: 1,
          );
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        offset += 10;
        limit += 10;

        widget.isload = false;
        widget.isloads = false;

        getPPSPLIST(widget.id, offset, limit);
        //  custData1 = customerSearchFetch(offsetData, 10);

        //message = "reach the bottom";
        // catalogueFetch(offsetData , 10, 1);
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        // message = "reach the top";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          widget.isload == false
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView.builder(
                      controller: _controller,
                      // scrollDirection: Axis.horizontal,
                      itemCount: widget.ppspList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (widget.ppspList[index].roleNumber == "4")
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewServiceList(
                                    int.parse(widget.ppspList[index].id),
                                    widget.ppspList[index].email,
                                    widget.ppspList[index].mobile,
                                    widget.ppspList[index].mobile,
                                    true,
                                    widget.ppspList[index].firstName +
                                        widget.ppspList[index].lastName,
                                  ),
                                ),
                              );
                            // );
                            else
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ViewServiceList(
                                        int.parse(widget.ppspList[index].id),
                                        widget.ppspList[index].email,
                                        widget.ppspList[index].mobile,
                                        widget.ppspList[index].mobile,
                                        false,
                                        widget.ppspList[index].firstName +
                                            widget.ppspList[index].lastName,
                                      )));
                            // );
                          },
                          child: PPSPLIST(
                            MediaQuery.of(context).size.height,
                            widget.ppspList[index].firstName,
                            widget.ppspList[index].lastName,
                            widget.ppspList[index].mobile,
                            widget.ppspList[index].email,
                            widget.ppspList[index].roleNumber,
                            widget.ppspList[index].profileUrl,
                          ),
                        );
                      }),
                )
              : Center(child: CircularProgressIndicator()),
          widget.isloads == true
              ? Container()
              : Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    )));
  }

  Card PPSPLIST(double height, String first_name, String last_name,
      String mobile, String email, String roleNumber, String profileUrl) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          // Padding(
          //   padding:
          //       const EdgeInsets
          //               .only(
          //           top: 20.0),
          //   child: CircleAvatar(
          //     backgroundImage:
          //         NetworkImage(
          //       "http://164.52.192.76:8080/startit/$profile_image",
          //     ),
          //     backgroundColor:
          //         Colors
          //             .transparent,
          //     radius: width * 0.22,
          //   ),
          // ),
          //  /   height: MediaQuery.of(context).size.width * 0.5,
          //   child: Divider(
          //     thickness: 5,
          //     color: Colors.black,
          //   ),
          // )
          SizedBox(
            height: height * 0.01,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: height * 0.02),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  profileUrl == null
                      ? "http://164.52.192.76:8080/startit/frontassets/images/Logo_Tagline.png"
                      : "http://164.52.192.76:8080/startit/" + profileUrl,
                  // fit: BoxFit.,
                ),
              ),
              SizedBox(width: height * 0.02),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  first_name + " " + last_name,
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.19),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        email,
                        textScaleFactor: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(
                      mobile,
                      textScaleFactor: 1,
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    if (roleNumber == "3")
                      Text(
                        "Product Provider",
                        textScaleFactor: 1,
                      ),
                    if (roleNumber == "4")
                      Text(
                        "Service Provider",
                        textScaleFactor: 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
    );
  }

  void getPPSPLIST(String ids, int offset, int limit) async {
    setState(() {
      if (widget.isloads == true) {
        widget.isload = true;
      } else {
        widget.isload = false;
      }
    });

    //  widget.ppspList.clear();
    Map mapData = {"id": ids, "offset": offset, "limit": limit};

    final response = await http.post(
      Uri.parse(WebApis.GET_RESOURCE_PROVIDER_SKILL_ID),
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
        Map data1 =
            WebResponseExtractor.filterWebData(response, dataObject: "RP_LIST");

        getIdeasFromWebSPPP(data1["data"]);

        setState(() {
          widget.isload = false;
          widget.isloads = true;
        });
      }
    }
  }

  Future<Null> getIdeasFromWebSPPP(var jsonData) async {
    if (jsonData != null || jsonData != []) {
      setState(() {
        for (Map idea in jsonData) {
          widget.ppspList.add(SuccessPPSPDetail(
              id: idea["id"],
              email: idea["email"],
              firstName: idea["first_name"],
              lastName: idea["last_name"],
              mobile: idea["mobile"],
              roleNumber: idea["role_id"],
              profileUrl: idea["profile_image"]));
        }
      });
    }
  }
}
