import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'chats.dart';
import 'custom_widget.dart';
import '../../main.dart';

class RecentChat extends StatefulWidget {
  @override
  _RecentChatState createState() => _RecentChatState();
}

class _RecentChatState extends State<RecentChat> {
  bool showEmojiKeyboard = false;
  DocumentReference documentReference1;
  bool showEmojiPicker = false;
  FocusNode textFieldFocus = FocusNode();

  List list = [];
  String id = '';
  String fileType = '';
  String imageId = "";
  String fileName = '';

  TextEditingController search = TextEditingController();
  // @override
  // void initState() {
  //   var Data = FirebaseFirestore.instance.collection('user').snapshots();
  //   print(Data);
  //   var document = FirebaseFirestore.instance.collection('user');
  //   print(document.toString());
  //   // FirebaseFirestore.instance.collection('user').snapshots().map(
  //   //     (QuerySnapshot list) => list.documents
  //   //         .map((DocumentSnapshot snap) => User.fromMap(snap.data))
  //   //         .toList());
  //   print("dcb");
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            'Recent Chat',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          elevation: 0.0,
        ),
        body: Stack(children: [
          Container(
            color: Colors.blue,
            child: Container(
              width: double.infinity,
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 15.0, bottom: 8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: chatScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget chatScreen() {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(userFirebaseId)
            .collection("recentMessage")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                child: Text(
              "Loading",
              textScaleFactor: 1,
            ));
            //CircularProgressIndicator()
            // );
          } else {
            list = snapshot.data.documents;
            print(list);
            print("object");
            return Container(
              height: mediaQueryHeight -
                  AppBar().preferredSize.height -
                  mediaQueryHeight * 0.15,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return list[index]['Name']
                            .toString()
                            .toLowerCase()
                            .trim()
                            .contains(search.text.toLowerCase().trim())
                        ? GestureDetector(
                            onTap: () {
                              // if (list[index]['messageTo'] == "user") {
                              // print("object");
                              // print(list[index]["Id"]);
                              if (list[index]["messageTo"] == "user") {
                                Map data = {
                                  "name": list[index]['Name'],
                                  "userProfileImage": list[index]
                                      ['ProfileImage'],
                                  "receiverId": list[index]['Id'],
                                  "chat": "user",
                                  'totalMessage': list[index]['totalMessage'],
                                  'deviceToken': CustomWidgets.CheckValidString(
                                          list[index]['deviceToken'])
                                      ? list[index]['deviceToken']
                                      : "",
                                };
                                print(data);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(data)),
                                );
                              } else if (list[index]["messageTo"] == "group") {
                                Map data = {
                                  "name": list[index]['Name'],
                                  "userProfileImage": list[index]
                                      ['ProfileImage'],
                                  "receiverId": list[index]['Id'],
                                  "idea_id": list[index]["group_id"],
                                  "chat": "group",
                                  'totalMessage': list[index]['totalMessage'],
                                  'deviceToken': "",
                                  "adminId": list[index]["adminId"]

                                  //  CustomWidgets.CheckValidString(
                                  //         list[index]['deviceToken'])
                                  //     ? list[index]['deviceToken']
                                  //     : "",
                                };
                                print(data);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(data)),
                                );
                              }
                              // }
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  width: mediaQueryWidth,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              // elevation: 50,
                                              child: Material(
                                                elevation: 5.0,
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  child: CustomWidgets
                                                          .CheckValidString(list[
                                                                  index]
                                                              ['ProfileImage'])
                                                      ? CachedNetworkImage(
                                                          imageUrl:
                                                              "http://164.52.192.76:8080/startit/" +
                                                                  list[index][
                                                                      'ProfileImage'],
                                                          fit: BoxFit.fill,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Image.network(
                                                            "http://164.52.192.76:8080/Tchrtalk/img/profile-image.jpg",
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      : Image.network(
                                                          "http://164.52.192.76:8080/Tchrtalk/img/profile-image.jpg",
                                                          fit: BoxFit.fill,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Text(
                                                    list[index]['Name'],
                                                    textScaleFactor: 1,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 1.0),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                CustomWidgets.sizedBox(
                                                    height: 5.0),
                                                list[index]['messageTo'] ==
                                                        "group"
                                                    ? list[index][
                                                                'messageType'] ==
                                                            "text"
                                                        ? SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            child: Text.rich(
                                                                TextSpan(
                                                                    text: list[index]['SenderId'] ==
                                                                            userFirebaseId
                                                                        ? "You : "
                                                                        : "${list[index]['SenderName']} : ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                    children: <
                                                                        InlineSpan>[
                                                                      TextSpan(
                                                                        text:
                                                                            '${list[index]['Message']}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                    ]),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1),
                                                          )
                                                        : list[index][
                                                                    'messageType'] ==
                                                                "image"
                                                            ? Container(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      list[index]['SenderId'] ==
                                                                              userFirebaseId
                                                                          ? "You : "
                                                                          : "${list[index]['SenderName']} ",
                                                                      textScaleFactor:
                                                                          1,
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(Icons
                                                                              .image_outlined),
                                                                          CustomWidgets.sizedBox(
                                                                              width: 5.0),
                                                                          Text(
                                                                            "Image",
                                                                            textScaleFactor:
                                                                                1,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : list[index][
                                                                        'messageType'] ==
                                                                    "video"
                                                                ? Container(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          list[index]['SenderId'] == userFirebaseId
                                                                              ? "You : "
                                                                              : "${list[index]['SenderName']} ",
                                                                          textScaleFactor:
                                                                              1,
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.video_collection_outlined),
                                                                              CustomWidgets.sizedBox(width: 5.0),
                                                                              Text(
                                                                                "Video",
                                                                                textScaleFactor: 1,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    child: Row(
                                                                    children: [
                                                                      Text(
                                                                        list[index]['SenderId'] ==
                                                                                userFirebaseId
                                                                            ? "You : "
                                                                            : "${list[index]['SenderName']} ",
                                                                        textScaleFactor:
                                                                            1,
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.file_copy_outlined),
                                                                            CustomWidgets.sizedBox(width: 5.0),
                                                                            Text(
                                                                              "File",
                                                                              textScaleFactor: 1,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ))
                                                    : Column(
                                                        children: [
                                                          list[index]['messageType'] ==
                                                                  "text"
                                                              ? list[index][
                                                                          'SenderId'] ==
                                                                      userFirebaseId
                                                                  ? SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.5,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.4,
                                                                        child:
                                                                            Text(
                                                                          "${list[index]['Message']}",
                                                                          textScaleFactor:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.5,
                                                                      child:
                                                                          SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.4,
                                                                        child:
                                                                            Text(
                                                                          list[index]
                                                                              [
                                                                              'Message'],
                                                                          textScaleFactor:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    )
                                                              : list[index][
                                                                          'messageType'] ==
                                                                      "image"
                                                                  ? Container(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(Icons
                                                                              .image_outlined),
                                                                          CustomWidgets.sizedBox(
                                                                              width: 5.0),
                                                                          Text(
                                                                            "Image",
                                                                            textScaleFactor:
                                                                                1,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : list[index][
                                                                              'messageType'] ==
                                                                          "video"
                                                                      ? Container(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.video_collection_outlined),
                                                                              CustomWidgets.sizedBox(width: 5.0),
                                                                              Text(
                                                                                "Video",
                                                                                textScaleFactor: 1,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Icon(Icons.file_copy_outlined),
                                                                              CustomWidgets.sizedBox(width: 5.0),
                                                                              Text(
                                                                                "File",
                                                                                textScaleFactor: 1,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                        ],
                                                      ),
                                                CustomWidgets.sizedBox(
                                                    height: 5.0),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                                      Column(
                                        children: [
                                          list[index]['SenderId'].toString() !=
                                                      userFirebaseId
                                                          .toString() &&
                                                  list[index]['totalMessage'] !=
                                                      "0" &&
                                                  list[index]['totalMessage'] !=
                                                      ""
                                              ? Container(
                                                  width: 18,
                                                  height: 18,
                                                  child: Card(
                                                    color: Colors.greenAccent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Center(
                                                        //     child: Text(
                                                        //   list[index]
                                                        //       ['totalMessage'],
                                                        //   style: TextStyle(
                                                        //       color:
                                                        //           Colors.white),
                                                        // )
                                                        ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.023,
                                                ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(list[index]['timestamp'].toString())), format: 'H:i')}",
                                            textScaleFactor: 1,
                                          ),
                                        ],
                                        // DateTime.f
                                        // DateTime.parse(list[index]['timestamp'].toString())
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1.0,
                                )
                              ],
                            ),
                          )
                        : Container();
                  }),
            );
          }
        });
  }
}
