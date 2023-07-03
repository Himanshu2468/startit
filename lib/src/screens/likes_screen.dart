import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;

class LikesScreen extends StatefulWidget {
  final int ideaId;
  LikesScreen(this.ideaId);
  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  List<Liker> likers = [
    //   Liker("Vivek Bajoria", "Investor", "vivekdon@gmail.com", ""),
    //   Liker("Himanshu Singh", "Service Provider", "himanshudon@gmail.com", ""),
    //   Liker("Khushbu Pareek", "Product Provider", "khusbudon@gmail.com", ""),
  ];

  @override
  void initState() {
    getLikersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Likes",
          textScaleFactor: 1,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.1,
              width: width * 0.8,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.thumb_up_alt_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 4),
                    Text(
                      likers.length.toString() + " Likes",
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Divider(
                height: 2,
                thickness: 2,
              ),
              width: width * 0.8,
            ),
            SizedBox(
              height: height * 0.78,
              child: ListView.builder(
                itemBuilder: (_, i) => likerItem(
                  likers[i].name,
                  likers[i].role,
                  likers[i].emailId,
                  likers[i].imageUrl,
                  height,
                  width,
                ),
                itemCount: likers.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget likerItem(String name, String role, String emailId, String imageUrl,
      double height, double width) {
    if (role == "1") {
      role = "Idea Person";
    } else if (role == "2") {
      role = "Investor";
    } else if (role == "3") {
      role = "Product Provider";
    } else if (role == "4") {
      role = "Service Provider";
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          "http://164.52.192.76:8080/startit/$imageUrl",
        ),
        backgroundColor: imageUrl == "" ? Colors.grey[400] : Colors.transparent,
      ),
      title: Text(
        name,
        textScaleFactor: 1,
      ),
      subtitle: Text(
        role, textScaleFactor: 1,
        // style: TextStyle(fontSize: 12),
      ),
    );
  }

  void getLikersList() async {
    Map mapData = {"idea_id": widget.ideaId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_LIKERS_LIST),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "LIKE_USER_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getAllLikersFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getAllLikersFromWeb(var jsonData) async {
    setState(() {
      for (Map liker in jsonData) {
        likers.add(
          Liker(
            name: "${liker["first_name"]} ${liker["last_name"]}",
            role: liker["role_id"] != null ? liker["role_id"] : "",
            emailId: liker["email"] != null ? liker["email"] : "",
            imageUrl:
                liker["profile_image"] != null ? liker["profile_image"] : "",
          ),
        );
      }
    });
  }
}

class Liker {
  String name;
  String role;
  String emailId;
  String imageUrl;
  Liker({
    this.name,
    this.role,
    this.emailId,
    this.imageUrl,
  });
}
