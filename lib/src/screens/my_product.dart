import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';

class MyProduct extends StatefulWidget {
  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  List<IdeaData> ideaData = [
    // IdeaData(
    //     "Idea One",
    //     "Ideaone.com",
    //     "12.07.2000",
    //     "assets/images/ideaone.jpg",
    //     "Ideas can also be mental representational images of some object. Many philosophers have considered ideas to be a fundamental ontological.",
    //     "In Progress"),
  ];

  @override
  void initState() {
    getIdeas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    String move = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      drawer: AppDrawer(move),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "My Product",
          textScaleFactor: 1,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
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
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04),
                width: width * 0.35,
                height: height * 0.05,
                child: ElevatedButton(
                  onPressed: () {
                    productId = 0;
                    loadedProduct = false;
                    Navigator.of(context).pushNamed('/product_provider');
                  },
                  child: Text(
                    'Add Product +',
                    textScaleFactor: 1,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                height: height - AppBar().preferredSize.height - height * 0.2,
                child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  itemBuilder: (_, i) => IdeaItem(
                    ideaData[i].title,
                    ideaData[i].category,
                    ideaData[i].date,
                    ideaData[i].imageUrl,
                    ideaData[i].description,
                    ideaData[i].status,
                    height,
                    width,
                    context,
                    ideaData[i].ideaId,
                  ),
                  itemCount: ideaData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getIdeas() async {
    Map mapData = {"user_id": userIdMain};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.MY_PRODUCT),
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
          dataObject: "PRODUCT_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getIdeasFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getIdeasFromWeb(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        ideaData.add(
          IdeaData(
            title: idea["categpry"] != null ? idea["categpry"] : "",
            category: idea["sub_category"] != null ? idea["sub_category"] : "",
            // web: idea["service_media"] != null ? idea["service_media"] : "",
            date: idea["createdAt"] != null
                ? DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(idea["createdAt"]))
                : "",
            imageUrl:
                idea["service_media"] != null ? idea["service_media"] : "",
            description: idea["product_service_details"] != null
                ? idea["product_service_details"]
                : "",
            status: idea["active"] != null ? idea["active"] : "",
            ideaId: int.parse(idea["id"]),
          ),
        );
      }
    });
  }
}

Widget IdeaItem(
  String title,
  String category,
  String date,
  String imageUrl,
  String description,
  String status,
  double height,
  double width,
  BuildContext context,
  int ideaId,
) {
  String statusDescription = "";

  if (status == "0") {
    statusDescription = "In Progress";
  }

  return Padding(
    padding: EdgeInsets.all(width * 0.025),
    child: Card(
      elevation: 5,
      child: GridTile(
        child: Container(
          padding: EdgeInsets.all(width * 0.016),
          margin: EdgeInsets.only(left: width * 0.045, right: width * 0.045),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: height * 0.001,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.12,
                    height: height * 0.08,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageUrl != ""
                          ? Image.network(
                              "http://164.52.192.76:8080/startit/$imageUrl",
                              fit: BoxFit.cover,
                            )
                          : SizedBox(
                              child: Icon(Icons.image),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          title,
                          textScaleFactor: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          category,
                          textScaleFactor: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: width * 0.22,
                        height: height * 0.026,
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            date,
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: width * 0.2,
                          height: height * 0.026,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[100],
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              statusDescription,
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                          )),
                      SizedBox(
                        height: height * 0.06,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    description,
                    textScaleFactor: 1,
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey, height: 1.5),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: width * 0.13),
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                height: height * 0.04,
                child: ElevatedButton(
                  onPressed: () {
                    productId = ideaId;
                    loadedProduct = true;
                    Navigator.of(context).pushNamed('/product_provider');
                  },
                  child: Text(
                    'View Product',
                    textScaleFactor: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class IdeaData {
  String title;
  String category;
  String date;
  String imageUrl;
  String description;
  String status;
  int ideaId;
  IdeaData(
      {this.title,
      this.category,
      this.date,
      this.imageUrl,
      this.description,
      this.status,
      this.ideaId});
}
