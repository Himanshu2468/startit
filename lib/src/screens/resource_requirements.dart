import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:startit/src/screens/dashboard.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../services/WebResponseExtractor.dart';
import 'package:dio/dio.dart';
import '../services/WebApis.dart';
import 'package:startit/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;

class ResourceRequirements extends StatefulWidget {
  @override
  _ResourceRequirementsState createState() => _ResourceRequirementsState();
}

class _ResourceRequirementsState extends State<ResourceRequirements> {
  bool imgcheck = false, vdcheck = false, doccehck = false;
  String bulbColor = "N";
  bool isAgreed = false;
  int i = 0, j = 0, k = 0;
  List<File> images = [];
  List<File> videos = [];
  List<File> documents = [];
  Uint8List imageBytes;
  Uint8List videoBytes;
  Uint8List documentBytes;
  var uint8list = null;
  Dio dio = Dio();
  List<String> imageUrlPic = [];
  String onlyImage = "";
  List<String> documentUrl = [];
  String videoUrlPic = "";
  List<VideoPlayerController> _controller = [];
  List<String> imageIds = [];
  List<String> videoIds = [];
  List<String> documentIds = [];

  TextEditingController answerController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // if (loadIns == true) {
    getQuestionaireData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          isEnglish ? 'Add Resource Requirements' : "संसाधन आवश्यकताएँ जोड़ें",
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
                Text(
                  isEnglish
                      ? 'Add Questionnaires to check idea person\'s pitch'
                      : "आइडिया व्यक्ति की पिच की जांच करने के लिए प्रश्नावली जोड़ें",
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.lightBlue, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: height * 0.05),
                Text(
                  isEnglish
                      ? "Do you have a questionnaire?"
                      : "क्या आपके पास प्रश्न है?",
                  textScaleFactor: 1,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.orange,
                          value: "Y",
                          groupValue: bulbColor,
                          onChanged: (val) {
                            setState(() {
                              isAgreed = true;
                              bulbColor = val;
                            });
                          },
                        ),
                        Text(
                          isEnglish ? "Yes" : "हाँ",
                          textScaleFactor: 1,
                        )
                      ],
                    ),
                    SizedBox(width: width * 0.12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          activeColor: Colors.orange,
                          value: "N",
                          groupValue: bulbColor,
                          onChanged: (val) {
                            setState(() {
                              bulbColor = val;
                              isAgreed = false;
                            });
                          },
                        ),
                        Text(
                          isEnglish ? "No" : "नहीं",
                          textScaleFactor: 1,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                AbsorbPointer(
                  absorbing: isAgreed ? false : true,
                  child: Opacity(
                    opacity: isAgreed ? 1.0 : 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(isEnglish ? 'Add Question' : "प्रश्न जोड़ें"),
                        SizedBox(height: height * 0.02),
                        Form(
                            key: _form,
                            child: buildTextField(isEnglish
                                ? 'Enter your question'
                                : "अपना प्रश्न दर्ज करें")),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.03),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (images.isEmpty && imageUrlPic.length == 0)
                                      ? addPictures(
                                          addImage,
                                          'jpeg/png',
                                          isEnglish
                                              ? '2 MB each, 6 images'
                                              : "2 एमबी प्रत्येक, 6 चित्र",
                                          IconButton(
                                              icon: Icon(
                                                Icons.add,
                                              ),
                                              onPressed: addImage),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (!imgcheck)
                                              return showDialogFunc(context,
                                                      imageUrlPic, imageIds)
                                                  .then((val) {
                                                setState(() {
                                                  onlyImage = imageUrlPic.first;
                                                });
                                              });
                                          },
                                          child: addPictures(
                                            addImage,
                                            'jpeg/png',
                                            isEnglish
                                                ? '2 MB each, 6 images'
                                                : "2 एमबी प्रत्येक, 6 चित्र",
                                            Container(
                                              width: width * 0.16,
                                              height: height * 0.08,
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
                                                            height:
                                                                height * 0.08,
                                                            width: width * 0.08,
                                                            child: onlyImage !=
                                                                    ""
                                                                ? Image.network(
                                                                    "http://164.52.192.76:8080/startit/" +
                                                                        onlyImage,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : Image.file(
                                                                    File(images[
                                                                            0]
                                                                        .path),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )),
                                                        Container(
                                                          width: width * 0.08,
                                                          child: Center(
                                                            child:
                                                                onlyImage != ""
                                                                    ? Text(
                                                                        "+" +
                                                                            (imageUrlPic.length - 1).toString(),
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
                                                                            (images.length - 1 + i).toString(),
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
                                  uint8list == null
                                      ? addPictures(
                                          addVideo,
                                          'mp4',
                                          isEnglish
                                              ? '200 MB each, 2 Videos'
                                              : "200 एमबी प्रत्येक, 2 वीडियो",
                                          IconButton(
                                              icon: Icon(
                                                  Icons.video_call_outlined),
                                              onPressed: addVideo),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (!vdcheck)
                                              return showDialogFuncVideo(
                                                      context,
                                                      _controller,
                                                      videoIds)
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
                                            addVideo,
                                            'mp4',
                                            isEnglish
                                                ? '200 MB each, 2 Videos'
                                                : "200 एमबी प्रत्येक, 2 वीडियो",
                                            Container(
                                              width: width * 0.16,
                                              height: height * 0.08,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey[300],
                                              ),
                                              child:
                                                  (videos.length + j == 1 ||
                                                          _controller.length ==
                                                              1)
                                                      ? videoUrlPic != ""
                                                          ? _controller[0]
                                                                  .value
                                                                  .initialized
                                                              ? AspectRatio(
                                                                  aspectRatio:
                                                                      _controller[
                                                                              0]
                                                                          .value
                                                                          .aspectRatio,
                                                                  child: VideoPlayer(
                                                                      _controller[
                                                                          0]),
                                                                )
                                                              : Container()
                                                          : Image.memory(
                                                              uint8list,
                                                              fit: BoxFit.cover,
                                                            )
                                                      : Row(
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.075,
                                                              width:
                                                                  width * 0.08,
                                                              child: videoUrlPic !=
                                                                      ""
                                                                  ? _controller[
                                                                              0]
                                                                          .value
                                                                          .initialized
                                                                      ? AspectRatio(
                                                                          aspectRatio: _controller[0]
                                                                              .value
                                                                              .aspectRatio,
                                                                          child:
                                                                              VideoPlayer(_controller[0]),
                                                                        )
                                                                      : Container()
                                                                  : Image
                                                                      .memory(
                                                                      uint8list,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                            ),
                                                            Container(
                                                              width:
                                                                  width * 0.08,
                                                              child: Center(
                                                                child:
                                                                    videoUrlPic !=
                                                                            ""
                                                                        ? Text(
                                                                            "+" +
                                                                                (_controller.length - 1).toString(),
                                                                            textScaleFactor:
                                                                                1,
                                                                            style:
                                                                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                          )
                                                                        : Text(
                                                                            "+" +
                                                                                (videos.length - 1 + j).toString(),
                                                                            textScaleFactor:
                                                                                1,
                                                                            style:
                                                                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                          ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                            ),
                                          ),
                                        ),
                                  (documents.isEmpty && documentUrl.length == 0)
                                      ? addPictures(
                                          addDocument,
                                          'pdf/dox/pptx',
                                          isEnglish
                                              ? '2MB each, 4 Docs'
                                              : "2 एमबी प्रत्येक, 4 डॉक्स",
                                          IconButton(
                                              icon: Icon(
                                                Icons.note_add_outlined,
                                              ),
                                              onPressed: addDocument),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (!doccehck)
                                              return showDialogFuncDocument(
                                                  context,
                                                  documentUrl,
                                                  documentIds);
                                          },
                                          child: addPictures(
                                            addDocument,
                                            'pdf/dox/pptx',
                                            isEnglish
                                                ? '2MB each, 4 Docs'
                                                : "2 एमबी प्रत्येक, 4 डॉक्स",
                                            Row(
                                              children: [
                                                Container(
                                                  width: width * 0.08,
                                                  child: Icon(
                                                    Icons.note_add,
                                                  ),
                                                ),
                                                Center(
                                                  child: documents.isEmpty
                                                      ? Text(
                                                          documentUrl.length
                                                              .toString(),
                                                          textScaleFactor: 1,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : Text(
                                                          (documents.length + k)
                                                              .toString(),
                                                          textScaleFactor: 1,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.08),
                Container(
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      uploadMultipleImage(context);
                      // Navigator.of(context).pushReplacementNamed('/dashboard',
                      //     arguments: "/capabilities");
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

  void getQuestionaireData() async {
    Map mapData = {"user_id": userIdMain};

    final response = await http.post(
      Uri.parse(WebApis.MY_INTERESTS),
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
            dataObject: "INS_IDEA");
        var userData = data["data"];
        String knowQuestion = userData["know_question"];

        if (knowQuestion == "Y") {
          setState(() {
            answerController.text = userData["question"];
            bulbColor = "Y";
            isAgreed = true;
          });
          Map data1 = WebResponseExtractor.filterWebData(response,
              dataObject: "IDEA_MEDIA");

          getIdeasFromWeb(data1["data"]);
        }
      }
    }
  }

  Future<Null> getIdeasFromWeb(var jsonData) async {
    setState(() {
      for (Map idea in jsonData) {
        if (idea["file_type_head"] == "picture") {
          imageIds.add(idea["id"]);
          imageUrlPic.add(idea["picture_path"]);
        } else if (idea["file_type_head"] == "video") {
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

  Future uploadMultipleImage(BuildContext ctx) async {
    loadingIndicator();
    _form.currentState.save();
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
          "ins_idea_id": bipIdeaId,
          "know_question": bulbColor,
          "question": answerController.text,
          "fileToUploadPicture": imageFiles,
          "fileToUploadVideo": videoFiles,
          "fileToUploadDoc": documentFiles
        });
        final response = await dio.post(
          WebApis.ADD_EDIT_INVESTOR_IDEA_MEDIA,
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
    Navigator.pop(ctx);
    // Navigator.of(ctx)
    //     .pushReplacementNamed('/dashboard', arguments: "/capabilities");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard("/capabilities")),
        (Route<dynamic> route) => false);
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     '/dashboard', (Route<dynamic> route) => false,
    //     arguments: "/capabilities");
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
                // color: Colors.white,
              ),
            ),
          );
        });
  }

  Widget text(String txt) {
    return Text(
      txt,
      textScaleFactor: 1,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }

  Widget buildTextField(String hint) {
    return Container(
      child: TextFormField(
        controller: answerController,
        decoration: InputDecoration(
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
      ),
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

  Widget addPictures(
      Function onPressed, String txt1, String txt2, Widget icon) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: width * 0.16,
          height: height * 0.07,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          child: icon,
        ),
        SizedBox(height: height * 0.007),
        Padding(
          padding: EdgeInsets.only(left: width * 0.04),
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
          width: width * 0.25,
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
      documents = result.paths.map((path) => File(path)).toList();
      setState(() {
        documentBytes = result.files.first.bytes;
      });
      documentUrl.clear();
    }
  }

  void deleteBipMediaData(String id) async {
    Map data = {"media_id": id};
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.DELETE_QUESTIONAIR_INS),
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
