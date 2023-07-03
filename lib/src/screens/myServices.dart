import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';

import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../main.dart';

class MyServices extends StatefulWidget {
  @override
  _MyServicesState createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  List<ServiceData> serviceData = [
    // ServiceData(
    //     title: "Idea One",
    //     category: "Ideaone.com",
    //     date: "12.07.2000",
    //     imageUrl: "assets/images/ideaone.jpg",
    //     description:
    //         "Ideas can also be mental representational images of some object. Many philosophers have considered ideas to be a fundamental ontological.",
    //     status: "In Progress"),
  ];

  @override
  void initState() {
    getServices();
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
          "Services",
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
                    serviceId = 0;
                    loadService = false;
                    Navigator.of(context).pushNamed("/domain");
                  },
                  child: Text(
                    'Add Service +',
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
                  padding: EdgeInsets.all(5),
                  itemBuilder: (_, i) => ServiceItem(
                    serviceData[i].title,
                    serviceData[i].category,
                    serviceData[i].date,
                    serviceData[i].imageUrl,
                    serviceData[i].description,
                    serviceData[i].status,
                    height,
                    width,
                    context,
                    serviceData[i].newServiceId,
                  ),
                  itemCount: serviceData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 2,
                  ),
                ),
              ),
              // SizedBox(
              //   height: height * 0.05,
              // )
            ],
          ),
        ),
      ),
    );
  }

  void getServices() async {
    Map mapData = {"user_id": userIdMain};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.GET_MYSERVICES),
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
          dataObject: "SERVICE_LIST");
      if (data["code"] == 1) {
        print(data["data"]);
        getServicesFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getServicesFromWeb(var jsonData) async {
    setState(() {
      for (Map service in jsonData) {
        serviceData.add(
          ServiceData(
            title: service["categpry"] != null ? service["categpry"] : "",
            category:
                service["sub_category"] != null ? service["sub_category"] : "",
            date: service["createdAt"] != null
                ? DateFormat('dd MMM yyyy')
                    .format(DateTime.parse(service["createdAt"]))
                : "",
            imageUrl: service["service_media"] != null
                ? service["service_media"]
                : "",
            description: service["how_product_different"] != null
                ? service["how_product_different"]
                : "",
            status: service["active"] != null ? service["active"] : "",
            newServiceId: int.parse(service["id"]),
          ),
        );
      }
    });
  }
}

Widget ServiceItem(
  String title,
  String category,
  String date,
  String imageUrl,
  String description,
  String status,
  double height,
  double width,
  BuildContext context,
  int newServiceId,
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
                      child: Image.network(
                        "http://164.52.192.76:8080/startit/$imageUrl",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          title,
                          textScaleFactor: 1,
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
                  SizedBox(
                    width: width * 0.00,
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
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                height: height * 0.04,
                child: ElevatedButton(
                  onPressed: () {
                    serviceId = newServiceId;
                    loadService = true;
                    Navigator.of(context).pushNamed("/domain");
                  },
                  child: Text(
                    'View Service',
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

class ServiceData {
  String title;
  String category;

  String date;
  String imageUrl;
  String description;
  String status;
  int newServiceId;
  ServiceData(
      {this.title,
      this.category,
      this.date,
      this.imageUrl,
      this.description,
      this.status,
      this.newServiceId});
}
