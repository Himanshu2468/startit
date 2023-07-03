import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;

class VisitorsScreen extends StatefulWidget {
  final int ideaId;
  VisitorsScreen(this.ideaId);
  @override
  _VisitorsScreenState createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  List<Visitor> visitors = [
    //   visitor("Vivek Bajoria", "Investor", "vivekdon@gmail.com", ""),
    //   visitor("Himanshu Singh", "Service Provider", "himanshudon@gmail.com", ""),
    //   visitor("Khushbu Pareek", "Product Provider", "khusbudon@gmail.com", ""),
  ];

  @override
  void initState() {
    getVisitorsList();
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
          "Visitors",
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
                      Icons.travel_explore_rounded,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 4),
                    Text(
                      visitors.length.toString() + " Visitors",
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
                itemBuilder: (_, i) => visitorItem(
                  visitors[i].name,
                  visitors[i].role,
                  visitors[i].emailId,
                  visitors[i].imageUrl,
                  height,
                  width,
                ),
                itemCount: visitors.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget visitorItem(String name, String role, String emailId, String imageUrl,
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

  void getVisitorsList() async {
    Map mapData = {"idea_id": widget.ideaId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_VISITORS_LIST),
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
          dataObject: "VISITOR_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getAllVisitorsFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getAllVisitorsFromWeb(var jsonData) async {
    setState(() {
      for (Map visitor in jsonData) {
        visitors.add(
          Visitor(
            name: "${visitor["first_name"]} ${visitor["last_name"]}",
            role: visitor["role_id"] != null ? visitor["role_id"] : "",
            emailId: visitor["email"] != null ? visitor["email"] : "",
            imageUrl: visitor["profile_image"] != null
                ? visitor["profile_image"]
                : "",
          ),
        );
      }
    });
  }
}

class Visitor {
  String name;
  String role;
  String emailId;
  String imageUrl;
  Visitor({
    this.name,
    this.role,
    this.emailId,
    this.imageUrl,
  });
}
