import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../services/WebResponseExtractor.dart';
import 'package:dio/dio.dart';
import 'package:video_player/video_player.dart';
import '../services/WebApis.dart';
import 'package:startit/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;

class ServiceProviderServiceDetails extends StatefulWidget {
  @override
  _ServiceProviderServiceDetailsState createState() =>
      _ServiceProviderServiceDetailsState();
}

class _ServiceProviderServiceDetailsState
    extends State<ServiceProviderServiceDetails> {
  bool imgcheck = false, vdcheck = false;
  bool imgcheck1 = false, vdcheck1 = false, doccehck1 = false;
  List<File> images = [];
  List<File> videos = [];
  List<File> images1 = [];
  List<File> videos1 = [];
  List<File> documents1 = [];
  Uint8List imageBytes;
  Uint8List videoBytes;
  Uint8List documentBytes;
  var uint8list = null;
  var uint8list1 = null;
  TextEditingController serviceDetailsController = TextEditingController();
  TextEditingController brochureController = TextEditingController();
  Dio dio = Dio();
  List<String> imageUrlPic = [];
  List<String> imageIds = [];
  List<String> videoIds = [];
  String onlyImage = "";
  String videoUrlPic = "";
  List<VideoPlayerController> _controller = [];
  List<VideoPlayerController> _controller1 = [];
  List<String> imageUrlPic1 = [];
  List<String> imageIds1 = [];
  List<String> videoIds1 = [];
  List<String> documentIds1 = [];
  String onlyImage1 = "";
  List<String> documentUrl1 = [];
  String videoUrlPic1 = "";
  int i = 0, j = 0;
  int i1 = 0, j1 = 0, k1 = 0;

  @override
  void initState() {
    super.initState();
    // if (loadService == true) {
    getServiceDetail();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      //drawer: Drawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          isEnglish ? 'Service details' : "सेवा विवरण",
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.blue,
        child: SingleChildScrollView(
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
                Center(
                  child: Text(
                    isEnglish
                        ? 'Showcase your skills in a better way to get opportunity easily'
                        : "आसानी से अवसर प्राप्त करने के लिए अपने कौशल को बेहतर तरीके से प्रदर्शित करें",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.04),
                Text.rich(
                  TextSpan(
                      text: isEnglish
                          ? 'Add service Details'
                          : "सेवा विवरण जोड़ें",
                      style: TextStyle(fontWeight: FontWeight.w500),
                      children: [
                        TextSpan(
                          text: " *",
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ]),
                ),
                buildTextField(
                    context,
                    width,
                    height,
                    isEnglish
                        ? 'Write about your product/service'
                        : "अपने उत्पादों/सेवाओं के बारे में लिखें",
                    serviceDetailsController),
                SizedBox(height: height * 0.02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (images.isEmpty && imageUrlPic.length == 0)
                        ? addPictures(
                            context,
                            addImage,
                            'Add Image',
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
                                        context, imageUrlPic, imageIds, true)
                                    .then((val) {
                                  setState(() {
                                    onlyImage = imageUrlPic.first;
                                  });
                                });
                            },
                            child: addPictures(
                              context,
                              addImage,
                              'Idea Pictures',
                              'jpeg/png',
                              isEnglish
                                  ? '2 MB each, 6 images'
                                  : "2 एमबी प्रत्येक, 6 चित्र",
                              Container(
                                width: width * 0.12,
                                height: height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
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
                                              width: width * 0.06,
                                              child: onlyImage != ""
                                                  ? Image.network(
                                                      "http://164.52.192.76:8080/startit/" +
                                                          onlyImage,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(images[0].path),
                                                      fit: BoxFit.cover,
                                                    )),
                                          Container(
                                            width: width * 0.06,
                                            child: Center(
                                              child: onlyImage != ""
                                                  ? Text(
                                                      "+" +
                                                          (imageUrlPic.length -
                                                                  1)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      "+" +
                                                          (images.length -
                                                                  1 +
                                                                  i)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
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
                    SizedBox(width: width * 0.02),
                    uint8list == null
                        ? addPictures(
                            context,
                            addVideo,
                            'Add Video',
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
                                        context, _controller, videoIds, true)
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
                              context,
                              addVideo,
                              'Add Video',
                              'mp4',
                              isEnglish
                                  ? '200 MB each, 2 Videos'
                                  : "200 एमबी प्रत्येक, 2 वीडियो",
                              Container(
                                width: width * 0.12,
                                height: height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[300],
                                ),
                                child: (videos.length + j == 1 ||
                                        _controller.length == 1)
                                    ? videoUrlPic != ""
                                        ? _controller[0].value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _controller[0]
                                                    .value
                                                    .aspectRatio,
                                                child:
                                                    VideoPlayer(_controller[0]),
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
                                              width: width * 0.06,
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
                                                              _controller[0]),
                                                        )
                                                      : Container()
                                                  : Image.memory(
                                                      uint8list,
                                                      fit: BoxFit.cover,
                                                    )),
                                          Container(
                                            width: width * 0.06,
                                            child: Center(
                                              child: videoUrlPic != ""
                                                  ? Text(
                                                      "+" +
                                                          (_controller.length -
                                                                  1)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      "+" +
                                                          (videos.length -
                                                                  1 +
                                                                  j)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
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
                  ],
                ),
                // SizedBox(height: height * 0.03),
                // Row(
                //   children: [
                //     Container(
                //       width: width * 0.35,
                //       height: height * 0.05,
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(
                //             primary: Colors.amber[600]),
                //         child: Text(
                //           'Add',
                //           style: TextStyle(color: Colors.white, fontSize: 15),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: width * 0.03),
                //     Row(
                //       children: [
                //         Container(
                //           width: width * 0.05,
                //           height: height * 0.03,
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(5),
                //             color: Colors.grey[300],
                //           ),
                //           child: Icon(
                //             Icons.add,
                //             size: 12,
                //           ),
                //         ),
                //         SizedBox(width: width * 0.015),
                //         SizedBox(
                //           width: width * 0.18,
                //           child: Text(
                //             'Add more',
                //             style: TextStyle(
                //               color: Colors.grey[500],
                //               fontSize: 12,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                SizedBox(height: height * 0.04),
                Text.rich(
                  TextSpan(
                    text: isEnglish ? 'Upload Brochure' : "ब्रोशर अपलोड करें",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                buildTextField(
                  context,
                  width,
                  height,
                  isEnglish
                      ? 'Write about your product/service'
                      : "अपने उत्पादों/सेवाओं के बारे में लिखें",
                  brochureController,
                ),
                SizedBox(height: height * 0.02),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (images1.isEmpty && imageUrlPic1.length == 0)
                        ? addPictures(
                            context,
                            addImage1,
                            'Add Image',
                            'jpeg/png',
                            isEnglish
                                ? '2 MB each, 6 images'
                                : "2 एमबी प्रत्येक, 6 चित्र",
                            IconButton(
                                icon: Icon(
                                  Icons.add,
                                  //color: Colors.white,
                                ),
                                onPressed: addImage1),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (!imgcheck1)
                                return showDialogFunc(
                                        context, imageUrlPic1, imageIds1, false)
                                    .then((val) {
                                  print("hello");
                                  setState(() {
                                    onlyImage1 = imageUrlPic1.first;
                                  });
                                });
                            },
                            child: addPictures(
                              context,
                              addImage1,
                              'Idea Pictures',
                              'jpeg/png',
                              isEnglish
                                  ? '2 MB each, 6 images'
                                  : "2 एमबी प्रत्येक, 6 चित्र",
                              Container(
                                width: width * 0.12,
                                height: height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[300],
                                ),
                                child: (images1.length + i1 == 1 ||
                                        imageUrlPic1.length == 1)
                                    ? onlyImage1 != ""
                                        ? Image.network(
                                            "http://164.52.192.76:8080/startit/" +
                                                onlyImage1,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(images1[0].path),
                                            fit: BoxFit.cover,
                                          )
                                    : Row(
                                        children: [
                                          Container(
                                              height: height * 0.07,
                                              width: width * 0.06,
                                              child: onlyImage1 != ""
                                                  ? Image.network(
                                                      "http://164.52.192.76:8080/startit/" +
                                                          onlyImage1,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      File(images1[0].path),
                                                      fit: BoxFit.cover,
                                                    )),
                                          Container(
                                            width: width * 0.06,
                                            child: Center(
                                              child: onlyImage1 != ""
                                                  ? Text(
                                                      "+" +
                                                          (imageUrlPic1.length -
                                                                  1)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      "+" +
                                                          (images1.length -
                                                                  1 +
                                                                  i1)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
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
                    SizedBox(width: width * 0.02),
                    uint8list1 == null
                        ? addPictures(
                            context,
                            addVideo1,
                            'Add Video',
                            'mp4',
                            isEnglish
                                ? '200 MB each, 2 Videos'
                                : "200 एमबी प्रत्येक, 2 वीडियो",
                            IconButton(
                                icon: Icon(Icons.video_call_outlined
                                    //color: Colors.white,
                                    ),
                                onPressed: addVideo1),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (!vdcheck1)
                                return showDialogFuncVideo(
                                        context, _controller1, videoIds1, false)
                                    .then((val) {
                                  _controller1.forEach((element) {
                                    element.pause();
                                  });
                                  setState(() {
                                    if (j1 == 0) {
                                      videoUrlPic1 = "";
                                      _controller1.clear();
                                      videos1.clear();
                                      uint8list1 = null;
                                    }
                                  });
                                });
                            },
                            child: addPictures(
                              context,
                              addVideo1,
                              'Add Video',
                              'mp4',
                              isEnglish
                                  ? '200 MB each, 2 Videos'
                                  : "200 एमबी प्रत्येक, 2 वीडियो",
                              Container(
                                width: width * 0.12,
                                height: height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[300],
                                ),
                                child: (videos1.length + j1 == 1 ||
                                        _controller1.length == 1)
                                    ? videoUrlPic1 != ""
                                        ? _controller1[0].value.initialized
                                            ? AspectRatio(
                                                aspectRatio: _controller1[0]
                                                    .value
                                                    .aspectRatio,
                                                child: VideoPlayer(
                                                    _controller1[0]),
                                              )
                                            : Container()
                                        : Image.memory(
                                            uint8list1,
                                            fit: BoxFit.cover,
                                          )
                                    : Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: height * 0.07,
                                            width: width * 0.06,
                                            child: videoUrlPic1 != ""
                                                ? _controller1[0]
                                                        .value
                                                        .initialized
                                                    ? AspectRatio(
                                                        aspectRatio:
                                                            _controller1[0]
                                                                .value
                                                                .aspectRatio,
                                                        child: VideoPlayer(
                                                            _controller1[0]),
                                                      )
                                                    : Container()
                                                : Image.memory(
                                                    uint8list1,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          Container(
                                            width: width * 0.06,
                                            child: Center(
                                              child: videoUrlPic1 != ""
                                                  ? Text(
                                                      "+" +
                                                          (_controller1.length -
                                                                  1)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      "+" +
                                                          (videos1.length -
                                                                  1 +
                                                                  j1)
                                                              .toString(),
                                                      textScaleFactor: 1,
                                                      style: TextStyle(
                                                          fontSize: 20,
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
                    SizedBox(width: width * 0.02),
                    (documents1.isEmpty && documentUrl1.length == 0)
                        ? addPictures(
                            context,
                            addDocument,
                            'Add Documents',
                            'pdf/dox/pptx',
                            isEnglish
                                ? '2MB each, 4 Docs'
                                : "2 एमबी प्रत्येक, 4 डॉक्स",
                            IconButton(
                                icon: Icon(
                                  Icons.note_add_outlined,
                                  //color: Colors.white,
                                ),
                                onPressed: addDocument),
                          )
                        : GestureDetector(
                            onTap: () {
                              if (!doccehck1)
                                return showDialogFuncDocument(
                                    context, documentUrl1, documentIds1);
                            },
                            child: addPictures(
                              context,
                              addDocument,
                              'Add Documents',
                              'pdf/dox/pptx',
                              isEnglish
                                  ? '2MB each, 4 Docs'
                                  : "2 एमबी प्रत्येक, 4 डॉक्स",
                              Row(
                                children: [
                                  Container(
                                    width: width * 0.06,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.note_add,
                                          size: width * 0.04,
                                          //color: Colors.white,
                                        ),
                                        onPressed: () {}),
                                  ),
                                  Center(
                                    child: documents1.isEmpty
                                        ? Text(
                                            "+" +
                                                documentUrl1.length.toString(),
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            "+" +
                                                (documents1.length + k1)
                                                    .toString(),
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Container(
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      if (serviceDetailsController.text.trim().isEmpty) {
                        WebResponseExtractor.showToast(
                            "Please add Service Details");
                      } else
                        uploadMultipleImage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isEnglish ? 'Save & Continue' : "सहेजें और जारी रखें",
                          textScaleFactor: 1,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Center(
                  child: SizedBox(
                    width: width * 0.5,
                    child: Text(
                      isEnglish
                          ? 'Violent/abuse contents will lead to violation of uses. Read more...Terms'
                          : "हिंसक/दुरुपयोग सामग्री से उपयोग की शर्तों का उल्लंघन होगा। और पढ़ें… शर्तें (शर्तों के लिए हाइपरलिंक)",
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 12,
                      ),
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

  Future uploadMultipleImage() async {
    loadingIndicator();

    try {
      FormData formData = FormData();

      List<MultipartFile> imageFiles = [];
      List<MultipartFile> videoFiles = [];
      List<MultipartFile> documentFiles = [];
      List<MultipartFile> imageFiles1 = [];
      List<MultipartFile> videoFiles1 = [];

      for (var file in images) {
        imageFiles.add(
          await MultipartFile.fromFile(file.path),
        );
      }
      for (var file in images1) {
        imageFiles1.add(
          await MultipartFile.fromFile(file.path),
        );
      }
      for (var file in videos1) {
        videoFiles1.add(
          await MultipartFile.fromFile(file.path),
        );
      }
      for (var file in videos) {
        videoFiles.add(
          await MultipartFile.fromFile(file.path),
        );
      }
      for (var file in documents1) {
        documentFiles.add(
          await MultipartFile.fromFile(file.path),
        );
      }
      formData = FormData.fromMap({
        "user_id": userIdMain,
        "service_id": serviceId,
        "service_details": serviceDetailsController.text,
        "brochure_details": brochureController.text,
        "serviceMedia": imageFiles,
        "serviceMediaVideo": videoFiles,
        "brochurePicture": imageFiles1,
        "brochureVideo": videoFiles1,
        "brochuredDoc": documentFiles
      });
      final response = await dio.post(
        WebApis.SERVICE_MEDIA,
        data: formData,
      );
      if (response.statusCode == 200) {
        print(response.data['RETUTN_MESSAGE']);
        WebResponseExtractor.showToast(response.data['RETUTN_MESSAGE']);
      }
    } catch (e) {
      print(e.toString());
    }

    Navigator.pop(context);
    // Navigator.of(context).pushNamed('/skills');
    Navigator.of(context).pushNamed('/sproduct_detail');
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

  Widget buildTextField(BuildContext context, double width, double height,
      String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.symmetric(
            //     vertical: width * 0.1, horizontal: width * 0.022),
            //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 70.0),
            hintText: hint,
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
          maxLines: 5,
        ),
      ],
    );
  }

  Widget addPictures(BuildContext context, Function onPressed, String txt,
      String txt1, String txt2, Widget icon) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width * 0.12,
          height: height * 0.07,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          child: icon,
        ),
        SizedBox(height: height * 0.007),
        // SizedBox(
        //   width: width * 0.18,
        //   height: height * 0.04,
        //   child: Text(
        //     txt,
        //     style: TextStyle(
        //       color: Colors.grey[500],
        //       fontSize: 12,
        //     ),
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.only(left: width * 0.02),
          child: addButton(onPressed),
        ),
        SizedBox(height: height * 0.007),
        Text(
          txt1,
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 9,
          ),
        ),
        SizedBox(
          width: width * 0.22,
          child: Text(
            txt2,
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }

  Widget addButton(Function onPressed) {
    return SizedBox(
      width: 30,
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: CircleBorder(),
            padding: EdgeInsets.all(4)),
        child: Icon(
          Icons.add,
          size: 20,
        ),
      ),
    );
  }

  void addImage() async {
    bool checkSize = true;
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
        // imageUrlPic.clear();
        images.addAll(result.paths.map((path) => File(path)).toList());
        imageBytes = result.files.first.bytes;
        imageUrlPic.clear();
      });
    }
    print(images[0].path);
  }

  void addImage1() async {
    bool checkSize = true;
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
      if (result.count + i1 > 6) {
        WebResponseExtractor.showToast(
            "Please select 6 images or less than 6.");
        return;
      }
      setState(() {
        imgcheck1 = true;
        images1.clear();
        onlyImage1 = "";
        // imageUrlPic.clear();
        // imageUrlPic.clear();
        images1.addAll(result.paths.map((path) => File(path)).toList());
        imageBytes = result.files.first.bytes;
        imageUrlPic1.clear();
      });
    }
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

      setState(() {
        videos.clear();

        videos = result.paths.map((path) => File(path)).toList();
        videoBytes = result.files.first.bytes;
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

        // _controller.clear();
      });
      // CircularProgressIndicator();
      // print("HIMASNHU" + uint8list);
    }
  }

  void addVideo1() async {
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
      if (result.count + j1 > 2) {
        WebResponseExtractor.showToast(
            "Please select 2 videos or less than 2.");
        return;
      }

      setState(() {
        videos1.clear();

        videos1 = result.paths.map((path) => File(path)).toList();
        videoBytes = result.files.first.bytes;
        // CircularProgressIndicator();
      });
      final uint8lis1 = await VideoThumbnail.thumbnailData(
        video: videos1[0].path,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      setState(() {
        uint8list1 = uint8lis1;
      });
      setState(() {
        vdcheck1 = true;
        videoUrlPic1 = "";
        _controller1.clear();

        // _controller.clear();
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
      if (result.count + k1 > 4) {
        WebResponseExtractor.showToast(
            "Please select 4 documents or less than 4.");
        return;
      }
      doccehck1 = true;
      documents1.clear();
      // documentUrl.clear();
      documents1 = result.paths.map((path) => File(path)).toList();
      setState(() {
        documentBytes = result.files.first.bytes;
      });
      documentUrl1.clear();
    }
  }

  void deleteSP1MediaData(String id) async {
    Map data = {"media_id": id};
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.DELETE_SP_UPPER_MEDIA),
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

  void deleteSP2MediaData(String id) async {
    Map data = {"media_id": id};
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.DELETE_SP_LOWER_MEDIA),
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

  void getServiceDetail() async {
    Map mapData = {"service_id": serviceId};
    print(mapData);

    final response = await http.post(
      Uri.parse(WebApis.VIEW_SERVICE),
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
          dataObject: "SERVICE_DETAILS");
      Map data1 = WebResponseExtractor.filterWebData(response,
          dataObject: "BROCHURE_MEDIA");
      Map data2 = WebResponseExtractor.filterWebData(response,
          dataObject: "SERVICE_MEDIA");
      if (data["code"] == 1) {
        print(data["data"]);
        getServiceDetailFromWeb(data["data"]);
        getIdeasFromWeb(data2["data"]);
        getIdeasFromWeb1(data1["data"]);
      }
    }
  }

  showDialogFuncVideo(
      context, List<VideoPlayerController> vc, List<String> ids, bool isUpper) {
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
                                                  isUpper == true
                                                      ? deleteSP1MediaData(
                                                          ids[index])
                                                      : deleteSP2MediaData(
                                                          ids[index]);
                                                  setState(() {});
                                                  vc.removeAt(index);
                                                  ids.removeAt(index);
                                                  isUpper == true ? j-- : j1--;
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
                                            deleteSP2MediaData(ids[index]);
                                            setState(() {});
                                            img.removeAt(index);
                                            ids.removeAt(index);
                                            k1--;
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

  showDialogFunc(context, List<String> img, List<String> ids, bool isUpper) {
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
                                            isUpper == true
                                                ? deleteSP1MediaData(ids[index])
                                                : deleteSP2MediaData(
                                                    ids[index]);
                                            setState(() {});
                                            img.removeAt(index);
                                            ids.removeAt(index);
                                            isUpper == true ? i-- : i1--;
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
        }
      }
      if (imageUrlPic.isNotEmpty) onlyImage = imageUrlPic[0];
      i = imageUrlPic.length;
      j = _controller.length;
    });
  }

  Future<Null> getIdeasFromWeb1(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        if (idea["file_type_head"] == "picture") {
          imageIds1.add(idea["id"]);
          imageUrlPic1.add(idea["picture_path"]);
        }
        // File.writeAsBytes(response.bodyBytes);
        else if (idea["file_type_head"] == "video") {
          if (idea["picture_path"] != null && idea["picture_path"] != "") {
            videoIds1.add(idea["id"]);
            VideoPlayerController vdioe;
            vdioe = VideoPlayerController.network(
                "http://164.52.192.76:8080/startit/" + idea["picture_path"])
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                setState(() {
                  // vdioe.play();
                });
              });
            _controller1.add(vdioe);
            uint8list1 = "as";
            videoUrlPic1 =
                "http://164.52.192.76:8080/startit/" + idea["picture_path"];
          }
        } else if (idea["file_type_head"] == "document") {
          documentIds1.add(idea["id"]);
          documentUrl1
              .add("http://164.52.192.76:8080/startit/" + idea["picture_path"]);
        }
      }
      if (imageUrlPic1.isNotEmpty) onlyImage1 = imageUrlPic1[0];
      i1 = imageUrlPic1.length;
      j1 = _controller1.length;
      k1 = documentUrl1.length;
    });
  }

  Future<Null> getServiceDetailFromWeb(var jsonData) async {
    setState(() {
      serviceDetailsController.text = jsonData["product_service_details"];
      brochureController.text = jsonData["brochure_details"];
    });
  }
}
