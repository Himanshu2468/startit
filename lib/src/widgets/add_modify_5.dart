import 'package:flutter/material.dart';
import 'package:startit/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/WebApis.dart';
import '../services/WebResponseExtractor.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;

class AddModify5 extends StatefulWidget {
  PageController pageController = PageController();
  int sliderIndex;
  double width;
  double height;

  AddModify5(this.pageController, this.sliderIndex, this.width, this.height);

  @override
  _AddModify5State createState() => _AddModify5State();
}

class _AddModify5State extends State<AddModify5>
    with AutomaticKeepAliveClientMixin<AddModify5> {
  bool get wantKeepAlive => true;
  bool imgcheck = false, vdcheck = false, doccehck = false;
  List<File> images = [];
  List<File> videos = [];
  List<File> documents = [];
  Uint8List imageBytes;
  Uint8List videoBytes;
  Uint8List documentBytes;
  var uint8list = null;
  List<String> imageUrlPic = [];
  List<String> imageIds = [];
  List<String> videoIds = [];
  List<String> documentIds = [];
  String onlyImage = "";
  List<String> documentUrl = [];
  String videoUrlPic = "";
  List<VideoPlayerController> _controller = [];
  Dio dio = Dio();
  int i = 0, j = 0, k = 0;

  bool mediaUploaded = true;

  @override
  void initState() {
    super.initState();
    // if (loadedBip == true) {
    getBipMediaData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    Widget addPictures(
        String txt, String txt1, String txt2, Widget icon, double width1) {
      final double height = MediaQuery.of(context).size.height;
      // final double width = MediaQuery.of(context).size.width;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txt,
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          SizedBox(height: height * 0.005),
          Container(
            width: width1,
            height: height * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey[300],
            ),
            child: icon,
          ),
          Text(
            txt1,
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 10,
            ),
          ),
          Text(
            txt2,
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 10,
            ),
          ),
          SizedBox(height: height * 0.01),
        ],
      );
    }

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: widget.height * 0.02),
        Row(
          children: [
            (images.isEmpty && imageUrlPic.length == 0)
                ? addPictures(
                    isEnglish ? 'Idea Pictures' : 'आइडिया पिक्चर्स',
                    'jpeg/png',
                    isEnglish
                        ? 'Each files size limit 2MB'
                        : '2एमबी प्रत्येक, 6 चित्र',
                    IconButton(
                        icon: Icon(
                          Icons.image,
                          //color: Colors.white,
                        ),
                        onPressed: addImage),
                    widget.width * 0.32,
                  )
                : addPictures(
                    isEnglish ? 'Idea Pictures' : 'आइडिया पिक्चर्स',
                    'jpeg/png',
                    isEnglish
                        ? 'Each files size limit 2MB'
                        : '2एमबी प्रत्येक, 6 चित्र',
                    GestureDetector(
                      onTap: () {
                        if (!imgcheck)
                          return showDialogFunc(context, imageUrlPic, imageIds)
                              .then((val) {
                            print("hello");
                            setState(() {
                              onlyImage = imageUrlPic.first;
                            });
                          });
                      },
                      child: Container(
                        width: width * 0.18,
                        height: height * 0.08,
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
                                      height: height * 0.08,
                                      width: width * 0.16,
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
                                    width: width * 0.16,
                                    child: Center(
                                      child: onlyImage != ""
                                          ? Text(
                                              "+" +
                                                  (imageUrlPic.length - 1)
                                                      .toString(),
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "+" +
                                                  (images.length - 1 + i)
                                                      .toString(),
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                    widget.width * 0.32,
                  ),
            SizedBox(width: 12),
            addButton(addImage)
          ],
        ),
        Row(
          children: [
            uint8list == null
                ? addPictures(
                    isEnglish ? 'Add Videos' : 'वीडियो',
                    'mp4',
                    isEnglish
                        ? 'Total files size limit 200MB'
                        : '200एमबी प्रत्येक, 2 वीडियो',
                    IconButton(
                        icon: Icon(Icons.video_call_outlined
                            //color: Colors.white,
                            ),
                        onPressed: addVideo),
                    widget.width * 0.32,
                  )
                : addPictures(
                    isEnglish ? 'Add Videos' : 'वीडियो',
                    'mp4',
                    isEnglish
                        ? 'Total files size limit 200MB'
                        : '200एमबी प्रत्येक, 2 वीडियो',
                    GestureDetector(
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
                      child: Container(
                        width: width * 0.32,
                        height: height * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ),
                        child: (videos.length + j == 1 ||
                                _controller.length == 1)
                            ? videoUrlPic != ""
                                ? _controller[0].value.initialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            _controller[0].value.aspectRatio,
                                        child: VideoPlayer(_controller[0]),
                                      )
                                    : Container()
                                : Image.memory(
                                    uint8list,
                                    fit: BoxFit.cover,
                                  )
                            : Row(
                                children: [
                                  Container(
                                    height: height * 0.075,
                                    width: width * 0.16,
                                    child: videoUrlPic != ""
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
                                          ),
                                  ),
                                  Container(
                                    width: width * 0.16,
                                    child: Center(
                                      child: videoUrlPic != ""
                                          ? Text(
                                              "+" +
                                                  (_controller.length - 1)
                                                      .toString(),
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "+" +
                                                  (videos.length - 1 + j)
                                                      .toString(),
                                              textScaleFactor: 1,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                    widget.width * 0.32,
                  ),
            SizedBox(width: 12),
            addButton(addVideo)
          ],
        ),
        Row(
          children: [
            (documents.isEmpty && documentUrl.length == 0)
                ? addPictures(
                    isEnglish ? 'Add Documents' : 'दस्तावेज़',
                    'pdf/dox/pptx',
                    isEnglish
                        ? 'Each files size limit 2MB'
                        : '2एमबी प्रत्येक, 4 डॉक्स',
                    IconButton(
                        icon: Icon(
                          Icons.note_add_outlined,
                          size: 32,
                          //color: Colors.white,
                        ),
                        onPressed: addDocument),
                    widget.width * 0.32,
                  )
                : GestureDetector(
                    onTap: () {
                      if (!doccehck)
                        return showDialogFuncDocument(
                            context, documentUrl, documentIds);
                    },
                    child: addPictures(
                      isEnglish ? 'Add Documents' : 'दस्तावेज़',
                      'pdf/dox/pptx',
                      isEnglish
                          ? 'Each files size limit 2MB'
                          : '2एमबी प्रत्येक, 4 डॉक्स',
                      Row(
                        children: [
                          Container(
                            width: width * 0.16,
                            child: Icon(
                              Icons.file_copy,
                              size: 32,
                              //color: Colors.white,
                            ),
                          ),
                          Center(
                            child: documents.isEmpty
                                ? Text(
                                    documentUrl.length.toString(),
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    (documents.length + k).toString(),
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                      widget.width * 0.32,
                    ),
                  ),
            SizedBox(width: 12),
            addButton(addDocument)
          ],
        ),
        SizedBox(height: widget.height * 0.02),
        ElevatedButton(
          onPressed: () {
            uploadMultipleImage();
          },
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
        ),
        SizedBox(
          height: widget.height * 0.03,
        ),
        Text(
          isEnglish
              ? "Violent/abuse contents will lead to violation of terms of uses."
              : 'हिंसक/दुरुपयोग वाली सामग्री से उपयोग की शर्तों का उल्लंघन होगा।',
          textScaleFactor: 1,
          style: TextStyle(color: Colors.grey[700], fontSize: 11),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEnglish ? "Read more..." : 'और पढ़ें…',
              textScaleFactor: 1,
              style: TextStyle(color: Colors.grey[700], fontSize: 11),
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  isEnglish ? "Terms" : 'नियम',
                  textScaleFactor: 1,
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        )
      ],
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
        formData = FormData.fromMap({
          "user_id": userIdMain,
          "bip_idea_id": bipIdeaId,
          "fileToUploadPicture": imageFiles,
          "fileToUploadVideo": videoFiles,
          "fileToUploadDoc": documentFiles
        });
        // Map<String, String> head = {
        //   'Accept': 'application/json',
        //   'Content-type': 'application/json',
        // };
        print(formData.fields.toString());
        final response = await dio.post(
          WebApis.ADD_BIP_IDEA_MEDIA,
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
    widget.pageController.animateToPage(widget.sliderIndex + 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn);
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
        // _controller.forEach((element) {
        //   element.dispose();
        // });
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
      });
      documentUrl.clear();
    }
  }

  void getBipMediaData() async {
    Map mapData = {"idea_id": bipIdeaId};

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
        Map data1 = WebResponseExtractor.filterWebData(response,
            dataObject: "IDEA_MEDIA");

        getIdeasFromWeb(data1["data"]);
      }
    }
  }

  void deleteBipMediaData(String id) async {
    Map data = {"media_id": id};
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.DELETE_BIP_MEDIA),
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

  Future<Null> getIdeasFromWeb(var jsonData) async {
    if (jsonData != null || jsonData != []) {
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
          } else if (idea["file_type_head"] == "documents") {
            documentIds.add(idea["id"]);
            documentUrl.add(
                "http://164.52.192.76:8080/startit/" + idea["picture_path"]);
          }
        }
        if (imageUrlPic.isNotEmpty) onlyImage = imageUrlPic[0];
        i = imageUrlPic.length;
        j = _controller.length;
        k = documentUrl.length;
      });
    }
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
}
