import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../main.dart';
import 'dart:convert';
import '../services/WebApis.dart';
import '../services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;
import 'package:url_launcher/url_launcher.dart';

class Capabilities extends StatefulWidget {
  @override
  _CapabilitiesState createState() => _CapabilitiesState();
}

class _CapabilitiesState extends State<Capabilities> {
  List<File> images = [];
  List<File> videos = [];
  List<File> documents = [];
  Uint8List imageBytes;
  Uint8List videoBytes;
  Uint8List documentBytes;
  var uint8list = null;
  Dropdown runningBusinessCat;
  List<Dropdown> runningBusinessCatList = [];
  String runningBusiness = "";
  String runningBusinessCatID = "";
  Dio dio = Dio();
  List runningBusinessCatIDList = [];
  List<String> pickItemsCatIDList = [];
  String rci;
  List<String> imageUrlPic = [];
  List<String> documentUrl = [];
  List<String> imageIds = [];
  List<String> videoIds = [];
  List<String> documentIds = [];
  bool imgcheck = false, vdcheck = false, doccehck = false;
  String onlyImage = "";
  String videoUrlPic = "";
  List<VideoPlayerController> _controller = [];
  int i = 0, j = 0, k = 0;

  TextEditingController projectsController = TextEditingController();
  TextEditingController projectsController1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRunningBusinessCategory();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      //backgroundColor: Colors.blue,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          isEnglish ? 'Capabilities' : "क्षमताओं",
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            padding: EdgeInsets.all(width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    isEnglish
                        ? 'We are happy to know you..'
                        : 'हमें आपको जानकर खुशी हुई…',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
                Container(
                  height: height * 0.68,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(isEnglish
                            ? 'Running business Category'
                            : "व्यवसाय श्रेणी"),
                        SizedBox(height: height * 0.016),
                        buildDropDownButton(
                          isEnglish ? 'Select Category' : "श्रेणी चुनें",
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        // list('Business A', Colors.amber[600]),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // list('Business B', Colors.blue),
                        Container(
                          child: Wrap(
                            children: [
                              ...List.generate(
                                pickItemsCatIDList.length,
                                (index) => list(
                                    index,
                                    pickItemsCatIDList[index],
                                    Colors.amber[600]),
                              )
                            ],
                          ),
                        ),
                        //SizedBox(height: height * 0.05),
                        Text(
                          isEnglish
                              ? 'Invested Projects'
                              : "निवेशित परियोजनाएं",
                          textScaleFactor: 1,
                        ),
                        SizedBox(height: height * 0.016),
                        Container(
                          width: width * 0.7,
                          child: TextFormField(
                            // initialValue: investedProject,
                            controller: projectsController,
                            decoration: InputDecoration(
                              hintText: 'Enter Projects',
                              filled: true,
                              fillColor: Colors.grey[50],
                              focusColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          isEnglish
                              ? 'Personal message for Idea Person'
                              : "आइडिया पर्सन के लिए व्यक्तिगत संदेश",
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Container(
                          width: width * 0.7,
                          child: TextFormField(
                            // initialValue: messageInit,
                            controller: projectsController1,
                            decoration: InputDecoration(
                              hintText: isEnglish
                                  ? 'Enter Your Message'
                                  : "अपना संदेश दर्ज करें",
                              filled: true,
                              fillColor: Colors.grey[50],
                              focusColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          isEnglish
                              ? 'Attach Media Files'
                              : "मीडिया फ़ाइलें संलग्न करें",
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            (images.isEmpty && imageUrlPic.length == 0)
                                ? addPictures(
                                    isEnglish ? 'Add Pictures' : "चित्र जोड़ें",
                                    'jpeg/png',
                                    isEnglish
                                        ? '2 MB each, 6 images'
                                        : "2 एमबी प्रत्येक, 6 चित्र",
                                    IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          //color: Colors.white,
                                        ),
                                        onPressed: addImage),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (!imgcheck)
                                        return showDialogFunc(
                                                context, imageUrlPic, imageIds)
                                            .then((val) {
                                          setState(() {
                                            onlyImage = imageUrlPic.first;
                                          });
                                        });
                                    },
                                    child: addPictures(
                                      isEnglish
                                          ? 'Add Pictures'
                                          : "चित्र जोड़ें",
                                      'jpeg/png',
                                      isEnglish
                                          ? '2 MB each, 6 images'
                                          : "2 एमबी प्रत्येक, 6 चित्र",
                                      Container(
                                        width: width * 0.15,
                                        height: height * 0.07,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey[300],
                                        ),
                                        child: (images.length + i == 1 ||
                                                imageUrlPic.length == 1)
                                            ? onlyImage != ""
                                                ? Image.network(
                                                    "http://164.52.192.76:8080/startit/" +
                                                        onlyImage,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(images[0].path),
                                                    fit: BoxFit.cover,
                                                  )
                                            : Row(
                                                children: [
                                                  Container(
                                                      height: height * 0.07,
                                                      width: width * 0.15,
                                                      child: onlyImage != ""
                                                          ? Image.network(
                                                              "http://164.52.192.76:8080/startit/" +
                                                                  onlyImage,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              File(images[0]
                                                                  .path),
                                                              fit: BoxFit.cover,
                                                            )),
                                                  Container(
                                                    width: width * 0.15,
                                                    child: Center(
                                                      child: onlyImage != ""
                                                          ? Text(
                                                              "+" +
                                                                  (imageUrlPic.length -
                                                                          1)
                                                                      .toString(),
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              "+" +
                                                                  (images.length -
                                                                          1 +
                                                                          i)
                                                                      .toString(),
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                            SizedBox(width: 16),
                            Padding(
                              padding: EdgeInsets.only(bottom: height * 0.02),
                              child: addButton(addImage),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            uint8list == null
                                ? addPictures(
                                    isEnglish ? 'Add Video' : "वीडियो जोड़ें",
                                    'mp4',
                                    isEnglish
                                        ? '200 MB each, 2 Videos'
                                        : "200 एमबी प्रत्येक, 2 वीडियो",
                                    IconButton(
                                        icon: Icon(Icons.video_call_outlined
                                            //color: Colors.white,
                                            ),
                                        onPressed: addVideo),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (!vdcheck)
                                        return showDialogFuncVideo(
                                                context, _controller, videoIds)
                                            .then((val) {
                                          _controller.forEach((element) {
                                            element.pause();
                                          });
                                          setState(() {
                                            if (j == 0) {
                                              videoUrlPic = "";
                                              _controller.clear();
                                              videos.clear();
                                              uint8list = null;
                                            }
                                          });
                                        });
                                    },
                                    child: addPictures(
                                      isEnglish ? 'Add Video' : "वीडियो जोड़ें",
                                      'mp4',
                                      isEnglish
                                          ? '200 MB each, 2 Videos'
                                          : "200 एमबी प्रत्येक, 2 वीडियो",
                                      Container(
                                        width: width * 0.15,
                                        height: height * 0.07,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.grey[300],
                                        ),
                                        child:
                                            (videos.length + j == 1 ||
                                                    _controller.length == 1)
                                                ? videoUrlPic != ""
                                                    ? _controller[0]
                                                            .value
                                                            .initialized
                                                        ? AspectRatio(
                                                            aspectRatio:
                                                                _controller[0]
                                                                    .value
                                                                    .aspectRatio,
                                                            child: VideoPlayer(
                                                                _controller[0]),
                                                          )
                                                        : Container()
                                                    : Image.memory(
                                                        uint8list,
                                                        fit: BoxFit.cover,
                                                      )
                                                : Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        height: height * 0.07,
                                                        width: width * 0.15,
                                                        child: videoUrlPic != ""
                                                            ? _controller[0]
                                                                    .value
                                                                    .initialized
                                                                ? AspectRatio(
                                                                    aspectRatio:
                                                                        _controller[0]
                                                                            .value
                                                                            .aspectRatio,
                                                                    child: VideoPlayer(
                                                                        _controller[
                                                                            0]),
                                                                  )
                                                                : Container()
                                                            : Image.memory(
                                                                uint8list,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                      Container(
                                                        width: width * 0.15,
                                                        child: Center(
                                                          child:
                                                              videoUrlPic != ""
                                                                  ? Text(
                                                                      "+" +
                                                                          (_controller.length - 1)
                                                                              .toString(),
                                                                      textScaleFactor:
                                                                          1,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )
                                                                  : Text(
                                                                      "+" +
                                                                          (videos.length - 1 + j)
                                                                              .toString(),
                                                                      textScaleFactor:
                                                                          1,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                      ),
                                    ),
                                  ),
                            SizedBox(width: 16),
                            Padding(
                              padding: EdgeInsets.only(bottom: height * 0.02),
                              child: addButton(addVideo),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            (documents.isEmpty && documentUrl.length == 0)
                                ? addPictures(
                                    'Add Documents',
                                    'pdf/dox/pptx',
                                    isEnglish
                                        ? '2MB each, 4 Docs'
                                        : "2 एमबी प्रत्येक, 4 डॉक्स",
                                    Center(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.note_add_outlined,
                                            //color: Colors.white,
                                          ),
                                          onPressed: addDocument),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (!doccehck)
                                        return showDialogFuncDocument(
                                            context, documentUrl, documentIds);
                                    },
                                    child: addPictures(
                                      'Add Documents',
                                      'pdf/dox/pptx',
                                      isEnglish
                                          ? '2MB each, 4 Docs'
                                          : "2 एमबी प्रत्येक, 4 डॉक्स",
                                      Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: width * 0.15,
                                              child: Icon(
                                                Icons.insert_drive_file,
                                                size: width * 0.08,
                                                //color: Colors.white,
                                              ),
                                            ),
                                            Center(
                                              child: documents.isEmpty
                                                  ? Text(
                                                      "+" +
                                                          documentUrl.length
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      "+" +
                                                          (documents.length + k)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(width: 16),
                            Padding(
                              padding: EdgeInsets.only(bottom: height * 0.02),
                              child: addButton(addDocument),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Center(
                          child: Container(
                            height: height * 0.05,
                            width: width * 0.7,
                            child: ElevatedButton(
                              onPressed: () {
                                if (runningBusinessCatIDList.isEmpty) {
                                  WebResponseExtractor.showToast(
                                      "Select Atleast One Running Business Category");
                                  // } else if (projectsController.text.isEmpty) {
                                  //   WebResponseExtractor.showToast(
                                  //       "Invested Projects cannot be empty");
                                } else {
                                  addInvestorCapabilities();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isEnglish
                                        ? 'Save & Continue'
                                        : "सहेजें और जारी रखें",
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Icon(Icons.chevron_right)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addButton(Function onPressed) {
    return SizedBox(
      width: 40,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: CircleBorder(),
            padding: EdgeInsets.all(4)),
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future uploadMultipleImage() async {
    loadingIndicator();
    if (images.isNotEmpty || videos.isNotEmpty || documents.isNotEmpty) {
      try {
        FormData formData = FormData();

        List<MultipartFile> imageFiles = [];
        List<MultipartFile> videoFiles = [];
        List<MultipartFile> documentFiles = [];

        for (var file in images) {
          imageFiles.add(
            await MultipartFile.fromFile(file.path),
          );
        }
        for (var file in videos) {
          videoFiles.add(
            await MultipartFile.fromFile(file.path),
          );
        }
        for (var file in documents) {
          documentFiles.add(
            await MultipartFile.fromFile(file.path),
          );
        }
        print(userIdMain);
        print(insIdeaId);
        formData = FormData.fromMap({
          "user_id": userIdMain,
          "fileToUploadPicture": imageFiles,
          "fileToUploadVideo": videoFiles,
          "fileToUploadDoc": documentFiles
        });
        final response = await dio.post(
          WebApis.ADD_INS_CAPABILITIES_MEDIA,
          data: formData,
        );
        if (response.statusCode == 200) {
          print(response.data['RETURN_MESSAGE']);
          WebResponseExtractor.showToast(response.data['RETURN_MESSAGE']);
        }
      } catch (e) {
        print(e.toString());
      }
    }
    Navigator.pop(context);
    if (loadIns == true) {
      Navigator.pop(context);
    } else
      Navigator.of(context).pushNamed('/resource');
  }

  loadingIndicator() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        });
  }

  Widget text(String txt) {
    final double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Text(
          txt,
          textScaleFactor: 1,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ),
        SizedBox(width: width * 0.012),
        Text(
          '*',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget buildDropDownButton(String hint) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      width: width * 0.7,
      child: DropdownButton<Dropdown>(
          icon: Icon(Icons.arrow_drop_down),
          hint: Text(
            hint,
            textScaleFactor: 1,
          ),
          value: runningBusinessCat,
          isDense: true,
          iconSize: 35,
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (Dropdown _value) {
            setState(() {
              runningBusinessCat = _value;
              runningBusiness = runningBusinessCat.NAME;
              runningBusinessCatID = runningBusinessCat.ID;
            });
            if (!runningBusinessCatIDList.contains(runningBusinessCatID)) {
              runningBusinessCatIDList.add(runningBusinessCatID);
            }
            if (!pickItemsCatIDList.contains(runningBusiness)) {
              pickItemsCatIDList.add(runningBusiness);
            }
          },
          items: runningBusinessCatList.map((Dropdown category) {
            return DropdownMenuItem<Dropdown>(
              value: category,
              child: Text(
                category.NAME,
                textScaleFactor: 1,
              ),
            );
          }).toList()),
    );
  }

  Widget list(int item, String txt, Color clr) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: height * 0.04,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: clr,
          ),
          padding: EdgeInsets.only(left: width * 0.04),
          width: width * 0.7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.58,
                child: Text(
                  txt,
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pickItemsCatIDList.remove(pickItemsCatIDList[item]);
                    runningBusinessCatIDList
                        .remove(runningBusinessCatIDList[item]);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }

  Widget addPictures(String txt, String txt1, String txt2, Widget icon) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          txt,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
        SizedBox(height: height * 0.005),
        Container(
          width: width * 0.30,
          height: height * 0.07,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          child: icon,
        ),
        SizedBox(height: height * 0.005),
        Text(
          txt1,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 9,
          ),
        ),
        Text(
          txt2,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 9,
          ),
        ),
        SizedBox(height: height * 0.01),
      ],
    );
  }

  void getRunningBusinessCategory() async {
    final response = await http.post(
      Uri.parse(WebApis.CATEGORY),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map data = WebResponseExtractor.filterWebData(response,
          dataObject: "CATEGORY_MASTER");

      if (data["code"] == 1) {
        getRunningBusinessCategoryFromWeb(data["data"]);
      }
    }
  }

  Future<Null> getRunningBusinessCategoryFromWeb(var jsonData) async {
    setState(() {
      for (Map category in jsonData) {
        runningBusinessCatList.add(new Dropdown(category["id"],
            isEnglish ? category["name"] : category["name_hindi"]));
      }
    });
    // if (loadIns == true) {
    getCapabilitiesData();
    // }
  }

  void addInvestorCapabilities() async {
    Map mapData = {
      "user_id": userIdMain,
      "mst_run_category_id": runningBusinessCatIDList.join(","),
      "mst_ins_project_id": projectsController.text,
      "message": projectsController1.text
    };
    print(mapData);
    final response = await http.post(
      Uri.parse(WebApis.ADD_EDIT_INVESTOR_CAPABILITIES),
      body: json.encode(mapData),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      if (jsonData["RETURN_CODE"] == 1) {
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
    uploadMultipleImage();
  }

  void getCapabilitiesData() async {
    Map mapData = {"user_id": userIdMain};

    final response = await http.post(
      Uri.parse(WebApis.MY_CAPABILITIES),
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
        Map data = WebResponseExtractor.filterWebData(response,
            dataObject: "INS_CAPABILITIES");
        Map data1 = WebResponseExtractor.filterWebData(response,
            dataObject: "CAPABILITIES_MEDIA");

        var userData = data["data"];

        rci = userData["mst_running_category_id"];
        List<int> newRunningIdsList = [];

        if (rci != "") {
          newRunningIdsList = rci.split(",").map(int.parse).toList();
          for (int runningId in newRunningIdsList) {
            runningBusinessCat = runningBusinessCatList
                .firstWhere((cat) => cat.id == runningId.toString());
            runningBusiness = runningBusinessCat.NAME;
            runningBusinessCatID = runningBusinessCat.ID;
            if (!runningBusinessCatIDList.contains(runningId)) {
              runningBusinessCatIDList.add(runningId);
            }
            if (!pickItemsCatIDList.contains(runningBusiness)) {
              pickItemsCatIDList.add(runningBusiness);
            }
          }
        }

        setState(() {
          projectsController.text = userData["mst_ins_projects_id"];
          projectsController1.text = userData["message"];
        });
        getIdeasFromWeb(data1["data"]);
      }
    }
  }

  Future<Null> getIdeasFromWeb(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        if (idea["file_type_head"] == "picture") {
          imageIds.add(idea["id"]);
          imageUrlPic.add(idea["picture_path"]);
        }
        // File.writeAsBytes(response.bodyBytes);
        else if (idea["file_type_head"] == "video") {
          if (idea["picture_path"] != null && idea["picture_path"] != "") {
            videoIds.add(idea["id"]);
            VideoPlayerController vdioe;
            vdioe = VideoPlayerController.network(
                "http://164.52.192.76:8080/startit/" + idea["picture_path"])
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {
                  // vdioe.play();
                });
              });
            _controller.add(vdioe);
            uint8list = "as";
            videoUrlPic =
                "http://164.52.192.76:8080/startit/" + idea["picture_path"];
          }
        } else if (idea["file_type_head"] == "document") {
          documentIds.add(idea["id"]);
          documentUrl
              .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
        }
      }
      if (imageUrlPic.isNotEmpty) onlyImage = imageUrlPic[0];
      i = imageUrlPic.length;
      j = _controller.length;
      k = documentUrl.length;
    });
  }

  void addImage() async {
    bool checkSize = true;
    print("object");
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'png', 'jpg'],
    );
    if (result != null) {
      result.files.forEach((element) {
        if (element.size > 2097152) {
          checkSize = false;
        }
      });
      if (checkSize == false) {
        WebResponseExtractor.showToast(
            "Please select each image of size less than 2MB");
        return;
      }
      if (result.count + i > 6) {
        WebResponseExtractor.showToast(
            "Please select 6 images or less than 6.");
        return;
      }
      setState(() {
        imgcheck = true;
        images.clear();
        onlyImage = "";
        // imageUrlPic.clear();
        images.addAll(result.paths.map((path) => File(path)).toList());
        imageBytes = result.files.first.bytes;
        imageUrlPic.clear();
      });
    }
    print(images[0].path);
  }

  void addVideo() async {
    double sized = 0;
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );
    if (result != null) {
      result.files.forEach((element) {
        sized += element.size;
      });
      if (sized > 209715200) {
        WebResponseExtractor.showToast(
            "Please select total videos of size less than 200MB");
        return;
      }
      if (result.count + j > 2) {
        WebResponseExtractor.showToast(
            "Please select 2 videos or less than 2.");
        return;
      }
      // setState(() {

      // });
      // CircularProgressIndicator();

      setState(() {
        videos.clear();

        videos = result.paths.map((path) => File(path)).toList();
        videoBytes = result.files.first.bytes;
        // CircularProgressIndicator();
      });
      final uint8lis = await VideoThumbnail.thumbnailData(
        video: videos[0].path,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      setState(() {
        uint8list = uint8lis;
      });
      setState(() {
        vdcheck = true;
        videoUrlPic = "";
        _controller.clear();
      });
      // CircularProgressIndicator();
      // print("HIMASNHU" + uint8list);
    }
  }

  void addDocument() async {
    bool checkSize = true;
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'pptx'],
    );
    if (result != null) {
      result.files.forEach((element) {
        if (element.size > 2097152) {
          checkSize = false;
        }
      });
      if (checkSize == false) {
        WebResponseExtractor.showToast(
            "Please select each image of size less than 2MB");
        return;
      }
      if (result.count + k > 4) {
        WebResponseExtractor.showToast(
            "Please select 4 documents or less than 4.");
        return;
      }
      doccehck = true;
      documents.clear();
      // documentUrl.clear();
      documents = result.paths.map((path) => File(path)).toList();
      setState(() {
        documentBytes = result.files.first.bytes;
        documentUrl.clear();
      });
    }
  }

  void deleteBipMediaData(String id) async {
    Map data = {"media_id": id};
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.DELETE_INS_CAP_MEDIA),
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
        WebResponseExtractor.showToast(jsonData["RETUTN_MESSAGE"]);
      }
    }
  }

  showDialogFunc(context, List<String> img, List<String> ids) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: img.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(
                              "http://164.52.192.76:8080/startit/" + img[index],
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            iconSize: 30,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Are you sure want to delete ?",
                                      textScaleFactor: 1,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Close",
                                            textScaleFactor: 1,
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            // deleteBipMediaData(ids[index]);
                                            deleteBipMediaData(ids[index]);
                                            setState(() {});
                                            img.removeAt(index);
                                            ids.removeAt(index);
                                            i--;
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Confirm",
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ))
                                    ],
                                  );
                                },
                              );
                            },
                            color: Colors.red)
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.width * 0.5,
                        //   child: Divider(
                        //     thickness: 5,
                        //     color: Colors.black,
                        //   ),
                        // )
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }

  showDialogFuncDocument(context, List<String> img, List<String> ids) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: img.length,
                  itemBuilder: (BuildContext context, int index) {
                    String docType = img[index].split(".").last;
                    IconData customIcon;
                    Color clr;
                    if (docType == "pdf") {
                      customIcon = myIcons.MaterialCommunityIcons.pdf_box;
                      clr = Colors.red;
                    }
                    if (docType == "xlsx") {
                      customIcon =
                          myIcons.MaterialCommunityIcons.file_excel_box;
                      clr = Colors.green[700];
                    }
                    if (docType == "docx" || docType == "doc") {
                      customIcon = myIcons.MaterialCommunityIcons.file_word_box;
                      clr = Colors.blue[700];
                    }
                    if (docType == "pptx") {
                      customIcon =
                          myIcons.MaterialCommunityIcons.file_powerpoint_box;
                      clr = Colors.orange[700];
                    }
                    print(docType);
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () async {
                                await launch(img[index]);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Icon(
                                  customIcon,
                                  color: clr,
                                  size: 50,
                                ),
                              )),
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      "Are you sure want to delete ?",
                                      textScaleFactor: 1,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Close",
                                            textScaleFactor: 1,
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            deleteBipMediaData(ids[index]);
                                            setState(() {});
                                            img.removeAt(index);
                                            ids.removeAt(index);
                                            k--;
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            "Confirm",
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ))
                                    ],
                                  );
                                },
                              );
                            },
                            color: Colors.red)
                      ],
                    );
                  }),
            ),
          ),
        );
      },
    );
  }

  showDialogFuncVideo(
      context, List<VideoPlayerController> vc, List<String> ids) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vc.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              width: vc.length == 1
                                  ? MediaQuery.of(context).size.width * 0.95
                                  : MediaQuery.of(context).size.width * 0.8,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: vc[index].value.initialized
                                      ? AspectRatio(
                                          aspectRatio:
                                              vc[index].value.aspectRatio,
                                          child: VideoPlayer(vc[index]),
                                        )
                                      : Container()),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              IconButton(
                                iconSize: 30,
                                icon: Icon(!vc[index].value.isPlaying
                                    ? Icons.play_arrow
                                    : Icons.pause),
                                onPressed: () {
                                  !vc[index].value.isPlaying
                                      ? vc[index].play()
                                      : vc[index].pause();
                                  setState(() {});
                                  vc[index].setLooping(true);
                                },
                              ),
                              IconButton(
                                  iconSize: 30,
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Are you sure want to delete ?",
                                            textScaleFactor: 1,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Close",
                                                  textScaleFactor: 1,
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  deleteBipMediaData(
                                                      ids[index]);
                                                  setState(() {});
                                                  vc.removeAt(index);
                                                  ids.removeAt(index);
                                                  j--;
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Confirm",
                                                  textScaleFactor: 1,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ))
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  color: Colors.red),
                            ],
                          )
                        ],
                      );
                    }),
              ),
            ),
          );
        });
      },
    );
  }
}

class Dropdown {
  String ID;
  String NAME;
  Dropdown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
