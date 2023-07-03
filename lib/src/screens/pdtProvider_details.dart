import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:startit/main.dart';
import '../../main.dart';
import 'dart:convert';
import 'package:startit/src/services/WebApis.dart';
import 'package:startit/src/services/WebResponseExtractor.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart' as myIcons;

class ProductProviderDetails extends StatefulWidget {
  @override
  _ProductProviderDetailsState createState() => _ProductProviderDetailsState();
}

class _ProductProviderDetailsState extends State<ProductProviderDetails> {
  PageController pageController = PageController();
  bool imgcheck = false, vdcheck = false;
  bool imgcheck1 = false, vdcheck1 = false, doccehck1 = false;
  int sliderIndex = 0;
  String text = "";
  String head = "";
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

  Dio dio = Dio();
  TextEditingController detailsController = TextEditingController();
  TextEditingController brochureController = TextEditingController();

  ScrollController scrollController = ScrollController();
  ScrollController scrollController2 = ScrollController();

  List<TextEditingController> createUserController = [
    for (int i = 0; i < 7; i++) TextEditingController()
  ];

  // Dropdown skillsDropDown;
  // List<Dropdown> skillsList = [];
  // String skills = "";
  // String skillsID = "";
  // List skillsIdList = [];

  List<String> runningBusinessCatIDList = [];

  int count = 0;
  bool show = true;

  TextEditingController messageController = TextEditingController();
  TextEditingController differenceController = TextEditingController();

  @override
  void initState() {
    getPpDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    switch (sliderIndex) {
      case 0:
        setState(() {
          text = isEnglish
              ? "We are happy to know you.."
              : "हमें आपको जानकर खुशी हुई..";
          head = isEnglish ? "Business Details" : "व्यापार विवरण";
        });
        break;
      case 1:
        setState(() {
          text = isEnglish
              ? "Very important to attract customers"
              : "ग्राहकों को आकर्षित करने के लिए बहुत महत्वपूर्ण";
          head = isEnglish ? "Product Details" : "उत्पाद विवरण";
        });
        break;
      default:
        setState(() {
          text = isEnglish
              ? "Tell us About Your Idea"
              : "हमें अपने विचार के बारे में बताएं";
        });
    }

    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            head,
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
              width: width,
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
                      text,
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (sliderIndex == 2)
                    Center(
                      child: SizedBox(
                        width: width * 0.7,
                        child: Text(
                          isEnglish
                              ? 'This section will show your uniqueness over competitors'
                              : "यह खंड प्रतिस्पर्धियों पर आपकी विशिष्टता दिखाएगा",
                          textScaleFactor: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  if (sliderIndex != 2)
                    SizedBox(
                      height: height * 0.008,
                    ),
                  SizedBox(height: height * 0.03),
                  pageIndicator(width, height),
                  SizedBox(height: height * 0.045),
                  introBuilder(),
                  SizedBox(height: height * 0.045),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool onWillPop() {
    if (sliderIndex == 0) {
      Navigator.pop(context);
    } else {
      pageController.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
    return false;
  }

  Widget pageIndicator(double width, double height) {
    return Container(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 2; i++)
              i == sliderIndex
                  ? pageIndicatorContainer(true, width, height)
                  : pageIndicatorContainer(false, width, height)
          ],
        ));
  }

  Widget pageIndicatorContainer(
      bool isCurrentPage, double width, double height) {
    return isCurrentPage
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            height: height * 0.006,
            width: width * 0.12,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            height: height * 0.006,
            width: width * 0.12,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          );
  }

  Widget introBuilder() {
    List<Widget> innerData = [
      //InnerData1(),
      first(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width),
      //InnerData2(),
      second(MediaQuery.of(context).size.height,
          MediaQuery.of(context).size.width),
      //InnerData3(),
      // third(MediaQuery.of(context).size.height,
      //     MediaQuery.of(context).size.width),
    ];
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: PageView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return innerData[index];
        },
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            sliderIndex = index;
          });
        },
      ),
    );
  }

  Container first(double height, double width) {
    return Container(
      // height: height * 0.7,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: RawScrollbar(
        controller: scrollController,
        thumbColor: Colors.black26,
        isAlwaysShown: true,
        thickness: 5,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                  context,
                  width,
                  height,
                  isEnglish ? 'Brand Name' : "ब्रांड का नाम",
                  isEnglish
                      ? 'Enter Your brand name'
                      : "अपना ब्रांड का नाम लिखें",
                  4,
                  true,
                ),
                SizedBox(height: height * 0.04),
                buildTextField(
                  context,
                  width,
                  height,
                  isEnglish ? 'CIN' : "सीआईएन",
                  isEnglish ? 'Enter GST number' : "अपना सीआईएन लिखें",
                  5,
                  false,
                ),
                SizedBox(height: height * 0.04),
                buildTextField(
                  context,
                  width,
                  height,
                  isEnglish ? 'Your Team Size' : "आपकी टीम का आकार",
                  isEnglish
                      ? 'Enter number of employees'
                      : "आपकी टीम का आकार लिखें",
                  6,
                  false,
                ),
                SizedBox(height: height * 0.04),
                buildTextFieldYear(
                  context,
                  width,
                  height,
                  isEnglish ? 'Year of establishment' : "स्थापना वर्ष",
                  isEnglish
                      ? 'Enter year of establishment'
                      : "स्थापना वर्ष लिखें",
                  0,
                  true,
                ),
                SizedBox(height: height * 0.04),
                buildTextField(
                  context,
                  width,
                  height,
                  isEnglish ? 'Legal status of firm' : "फर्म की कानूनी स्थिति",
                  isEnglish
                      ? 'i.e. Registered or Non-Registered'
                      : "फर्म की कानूनी स्थिति लिखें",
                  1,
                  false,
                ),
                SizedBox(height: height * 0.04),
                buildTextField(
                  context,
                  width,
                  height,
                  isEnglish ? 'Annual Turnover' : "वार्षिक कारोबार",
                  isEnglish ? 'Enter annual turnover' : "वार्षिक कारोबार लिखें",
                  2,
                  false,
                ),
                SizedBox(height: height * 0.04),
                Text.rich(
                  TextSpan(
                    text: isEnglish ? 'Address' : "पता",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  maxLines: 3,
                  controller: createUserController.elementAt(3),
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.symmetric(
                    //     vertical: width * 0.1, horizontal: width * 0.022),
                    hintText: isEnglish ? 'Input Address' : "अपना पता लिखें",
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
                SizedBox(height: height * 0.065),
                Container(
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      if (sliderIndex == 1) {
                        Navigator.of(context).pushNamed('/pproduct_detail',
                            arguments: "/product_provider");
                      }
                      if (createUserController[4].text.trim().isEmpty) {
                        WebResponseExtractor.showToast(
                            'Please Enter Brand Name');
                      } else if (createUserController[0].text.trim().isEmpty) {
                        WebResponseExtractor.showToast(
                            'Please Enter Year of establishment');
                      } else if (createUserController[0].text.length < 4) {
                        WebResponseExtractor.showToast(
                            'Please Enter Valid Year of establishment');
                      } else {
                        createUser();
                        pageController.animateToPage(sliderIndex + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context, double width, double height,
      String heading, String hint, int i, bool yes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: heading,
            style: TextStyle(fontWeight: FontWeight.w500),
            children: [
              if (yes == true)
                TextSpan(text: ' *', style: TextStyle(color: Colors.red[700])),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: createUserController.elementAt(i),
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
      ],
    );
  }

  Widget buildTextFieldYear(BuildContext context, double width, double height,
      String heading, String hint, int i, bool yes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: heading,
            style: TextStyle(fontWeight: FontWeight.w500),
            children: [
              if (yes == true)
                TextSpan(text: ' *', style: TextStyle(color: Colors.red[700])),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: createUserController.elementAt(i),
          maxLength: 4,
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
      ],
    );
  }

  Container second(double height, double width) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      // height: height * 0.7,
      child: RawScrollbar(
        controller: scrollController2,
        thumbColor: Colors.black26,
        isAlwaysShown: true,
        thickness: 5,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField2(
                    context,
                    width,
                    height,
                    isEnglish ? 'Add Product Details' : "उत्पाद विवरण जोड़ें",
                    detailsController,
                    " *"),
                SizedBox(height: height * 0.02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (images.isEmpty && imageUrlPic.length == 0)
                        ? addPictures2(
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
                            child: addPictures2(
                              context,
                              addImage,
                              'Add Pictures',
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
                    uint8list == null
                        ? addPictures2(
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
                        : addPictures2(
                            context,
                            addVideo,
                            'Add Video',
                            'mp4',
                            isEnglish
                                ? '200 MB each, 2 Videos'
                                : "200 एमबी प्रत्येक, 2 वीडियो",
                            GestureDetector(
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
                              child: Container(
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
                                                  ),
                                          ),
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
                SizedBox(height: height * 0.03),
                // Row(
                //   children: [
                //     Container(
                //       width: width * 0.35,
                //       height: height * 0.05,
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(primary: Colors.amber[600]),
                //         child: Text(
                //           'Add',
                //           style: TextStyle(color: Colors.white, fontSize: 15),
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: width * 0.03),
                // Row(
                //   children: [
                //     Container(
                //       width: width * 0.05,
                //       height: height * 0.03,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(5),
                //         color: Colors.grey[300],
                //       ),
                //       child: Icon(
                //         Icons.add,
                //         size: 12,
                //       ),
                //     ),
                //     SizedBox(width: width * 0.015),
                //     SizedBox(
                //       width: width * 0.18,
                //       child: Text(
                //         'Add more',
                //         style: TextStyle(
                //           color: Colors.grey[500],
                //           fontSize: 12,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                //   ],
                // ),
                SizedBox(height: height * 0.04),
                buildTextField2(
                    context,
                    width,
                    height,
                    isEnglish ? 'Upload Brochure' : "ब्रोशर अपलोड करें",
                    brochureController,
                    ""),
                SizedBox(height: height * 0.02),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (images1.isEmpty && imageUrlPic1.length == 0)
                        ? addPictures2(
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
                                ),
                                onPressed: addImage1),
                          )
                        : addPictures2(
                            context,
                            addImage1,
                            'Idea Pictures',
                            'jpeg/png',
                            isEnglish
                                ? '2 MB each, 6 images'
                                : "2 एमबी प्रत्येक, 6 चित्र",
                            GestureDetector(
                              onTap: () {
                                if (!imgcheck1)
                                  return showDialogFunc(context, imageUrlPic1,
                                          imageIds1, false)
                                      .then((val) {
                                    setState(() {
                                      onlyImage1 = imageUrlPic1.first;
                                    });
                                  });
                              },
                              child: Container(
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
                        ? addPictures2(
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
                        : addPictures2(
                            context,
                            addVideo1,
                            'Add Video',
                            'mp4',
                            isEnglish
                                ? '200 MB each, 2 Videos'
                                : "200 एमबी प्रत्येक, 2 वीडियो",
                            GestureDetector(
                              onTap: () {
                                if (!vdcheck1)
                                  return showDialogFuncVideo(context,
                                          _controller1, videoIds1, false)
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
                              child: Container(
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
                        ? addPictures2(
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
                        : addPictures2(
                            context,
                            addDocument,
                            'Add Documents',
                            'pdf/dox/pptx',
                            isEnglish
                                ? '2MB each, 4 Docs'
                                : "2 एमबी प्रत्येक, 4 डॉक्स",
                            GestureDetector(
                              onTap: () {
                                if (!doccehck1)
                                  return showDialogFuncDocument(
                                      context, documentUrl1, documentIds1);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: width * 0.06,
                                    child: Icon(
                                      Icons.note_add,
                                      size: width * 0.04,
                                      //color: Colors.white,
                                    ),
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
                SizedBox(height: height * 0.06),
                Container(
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (detailsController.text.isEmpty) {
                        WebResponseExtractor.showToast(
                            "Please fill Product Details");
                      } else if (sliderIndex == 1) {
                        await uploadMultipleImage();
                        Navigator.of(context).pushNamed('/pproduct_detail',
                            arguments: "/product_provider");
                      }
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
                    width: width * 0.42,
                    child: Text(
                      isEnglish
                          ? 'Violent/abuse contents will lead to violation of uses. Read more...Terms'
                          : "हिंसक/दुरुपयोग सामग्री से उपयोग की शर्तों का उल्लंघन होगा। और पढ़ें… शर्तें (शर्तों के लिए हाइपरलिंक)",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
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

  Future uploadMultipleImage() async {
    loadingIndicator();
    {
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
          "product_id": productId,
          "product_service_details": detailsController.text,
          "brochure_details": brochureController.text,
          "serviceMedia": imageFiles,
          "serviceMediaVideo": videoFiles,
          "brochurePicture": imageFiles1,
          "brochuredDoc": documentFiles,
          "brochureVideo": videoFiles1
        });
        final response = await dio.post(
          WebApis.ADD_PRODUCT_MEDIA,
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

  void getPpDetails() async {
    Map mapData = {"product_id": productId};

    final response = await http.post(
      Uri.parse(WebApis.VIEW_SINGLE_PRODUCT),
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
            dataObject: "SERVICE_DETAILS");
        Map data1 = WebResponseExtractor.filterWebData(response,
            dataObject: "BROCHURE_MEDIA");
        Map data2 = WebResponseExtractor.filterWebData(response,
            dataObject: "SERVICE_MEDIA");

        var userData = data["data"];

        setState(
          () {
            if (userData["brand_name"] != null)
              createUserController.elementAt(4).text = userData["brand_name"];
            if (userData["gst_no"] != null)
              createUserController.elementAt(5).text = userData["gst_no"];
            if (userData["team_size"] != null)
              createUserController.elementAt(6).text = userData["team_size"];
            if (userData["year_of_establishment"] != null)
              createUserController.elementAt(0).text =
                  userData["year_of_establishment"];
            if (userData["legal_status_firm"] != null)
              createUserController.elementAt(1).text =
                  userData["legal_status_firm"];
            if (userData["annual_turnover"] != null)
              createUserController.elementAt(2).text =
                  userData["annual_turnover"];
            if (userData["address"] != null)
              createUserController.elementAt(3).text = userData["address"];
            if (userData["product_service_details"] != null)
              detailsController.text = userData["product_service_details"];
            if (userData["brochure_details"] != null)
              brochureController.text = userData["brochure_details"];
            if (userData["message_for_idea_person"] != null)
              messageController.text = userData["message_for_idea_person"];
            if (userData["how_product_different"] != null)
              differenceController.text = userData["how_product_different"];
            // if (userData["skills"] != null) {
            //   String newSkillsIds = userData["skills"];

            //   List<int> newSkillsIdsList = [];

            //   if (newSkillsIds != "") {
            //     newSkillsIdsList =
            //         newSkillsIds.split(",").map(int.parse).toList();

            //     for (int newSkillID in newSkillsIdsList) {
            //       skillsDropDown = skillsList
            //           .firstWhere((s) => s.id == newSkillID.toString());
            //       skills = skillsDropDown.NAME;
            //       skillsID = skillsDropDown.ID;
            //       if (!skillsIdList.contains(newSkillID)) {
            //         skillsIdList.add(newSkillID);
            //       }
            //       if (!runningBusinessCatIDList.contains(skills)) {
            //         runningBusinessCatIDList.add(skills);
            //       }
            //     }
            //   }
            // }
          },
        );
        getIdeasFromWeb(data2["data"]);
        getIdeasFromWeb1(data1["data"]);
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
                                                      ? deletePP1MediaData(
                                                          ids[index])
                                                      : deletePP2MediaData(
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
                                            deletePP2MediaData(ids[index]);
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
                                                ? deletePP1MediaData(ids[index])
                                                : deletePP2MediaData(
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

  Widget buildTextField2(BuildContext context, double width, double height,
      String heading, TextEditingController t1, String mandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
              text: heading,
              style: TextStyle(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: mandatory,
                  style: TextStyle(color: Colors.red[700]),
                ),
              ]),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          controller: t1,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: isEnglish
                ? 'Write about your product/service'
                : "अपने उत्पादों/सेवाओं के बारे में लिखें",
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
      ],
    );
  }

  Widget addPictures2(BuildContext context, Function onPressed, String txt,
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
        Padding(
          padding: EdgeInsets.only(left: width * 0.02),
          child: addButton(onPressed),
        ),
        // SizedBox(height: height * 0.005),
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

  // Container third(double height, double width) {
  //   return Container(
  //     padding: EdgeInsets.only(left: 10, right: 10),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           SizedBox(
  //             height: height * 0.05,
  //             child: InputDecorator(
  //               decoration: InputDecoration(
  //                 filled: true,
  //                 fillColor: Colors.grey[50],
  //                 contentPadding:
  //                     EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
  //                 isCollapsed: true,
  //                 prefixIcon: Icon(Icons.search),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(50),
  //                   borderSide: BorderSide(
  //                     color: Colors.grey[300],
  //                     width: 1.5,
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(50),
  //                   borderSide: BorderSide(
  //                     color: Colors.blue,
  //                     width: 1.5,
  //                   ),
  //                 ),
  //               ),
  //               child: DropdownButton(
  //                 hint: Text(
  //                   isEnglish
  //                       ? 'Search For Your Skills'
  //                       : "अपने कौशल की खोज करें",
  //                 ),
  //                 style: TextStyle(color: Colors.black),
  //                 iconSize: 0.0,
  //                 isExpanded: true,
  //                 underline: SizedBox(),
  //                 value: skillsDropDown,
  //                 onChanged: (_value) {
  //                   setState(() {
  //                     skillsDropDown = _value;
  //                     skills = skillsDropDown.NAME;
  //                     skillsID = skillsDropDown.ID;
  //                     count = 1;
  //                   });
  //                   if (!skillsIdList.contains(skillsID)) {
  //                     skillsIdList.add(skillsID);
  //                   }
  //                   if (!runningBusinessCatIDList.contains(skills)) {
  //                     runningBusinessCatIDList.add(skills);
  //                   }
  //                 },
  //                 items: skillsList.map((Dropdown skills) {
  //                   return DropdownMenuItem<Dropdown>(
  //                     value: skills,
  //                     child: Text(
  //                       skills.NAME,
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: height * 0.018),
  //           Container(
  //             child: Wrap(
  //               children: [
  //                 ...List.generate(
  //                   runningBusinessCatIDList.length,
  //                   (index) => list3(
  //                     index,
  //                     context,
  //                     runningBusinessCatIDList[index],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: height * 0.018),
  //           //list3(context, 'User Interface', Colors.blue, 0.45),
  //           SizedBox(height: height * 0.04),
  //           buildTextField3(
  //               context,
  //               width,
  //               height,
  //               messageController,
  //               isEnglish
  //                   ? 'Message For Idea person/Customers'
  //                   : "आइडिया व्यक्ति/ग्राहकों के लिए संदेश",
  //               isEnglish ? 'Write your message' : "अपना संदेश लिखें",
  //               true,
  //               ""),
  //           SizedBox(height: height * 0.03),
  //           buildTextField3(
  //               context,
  //               width,
  //               height,
  //               differenceController,
  //               isEnglish
  //                   ? 'How are your product/service different?'
  //                   : "आपके उत्पाद/सेवाएं किस प्रकार भिन्न हैं?",
  //               isEnglish ? 'Write your answer' : "अपना जबाब लिखें",
  //               false,
  //               " *"),
  //           SizedBox(height: height * 0.05),
  //           Container(
  //             height: height * 0.05,
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 if (sliderIndex == 1) {
  //                   if (differenceController.text.isEmpty) {
  //                     WebResponseExtractor.showToast(
  //                         "Please write how are your product/service is different");
  //                   } else {
  //                     Navigator.of(context).pushNamed('/pproduct_detail',
  //                         arguments: "/product_provider");
  //                     addSkills();
  //                   }
  //                 } else {
  //                   pageController.animateToPage(sliderIndex + 1,
  //                       duration: Duration(milliseconds: 500),
  //                       curve: Curves.fastLinearToSlowEaseIn);
  //                 }
  //               },
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     isEnglish ? 'Save & Continue' : "सहेजें और जारी रखें",
  //                     style: TextStyle(color: Colors.white, fontSize: 15),
  //                   ),
  //                   Icon(Icons.chevron_right)
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget buildTextField3(
      BuildContext context,
      double width,
      double height,
      TextEditingController controller,
      String heading,
      String hint,
      bool first,
      String mandatory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
              text: heading,
              style: TextStyle(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: mandatory,
                  style: TextStyle(color: Colors.red[700]),
                ),
              ]),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          maxLines: 3,
          controller: controller,
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
      ],
    );
  }

  Color selectedColour(int position) {
    Color c;
    if (position % 3 == 0) c = Colors.amber[700];
    if (position % 3 == 1) c = Colors.red[600];
    if (position % 3 == 2) c = Colors.blue[600];
    return c;
  }

  // Widget list3(int item, BuildContext context, String txt) {
  //   Color tileColor = selectedColour(item);

  //   final double width = MediaQuery.of(context).size.width;
  //   final double height = MediaQuery.of(context).size.height;
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(4),
  //         color: tileColor,
  //       ),
  //       padding: EdgeInsets.all(8),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             txt,
  //             style: TextStyle(color: Colors.white, fontSize: 16),
  //           ),
  //           SizedBox(width: 4.0),
  //           GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 runningBusinessCatIDList
  //                     .remove(runningBusinessCatIDList[item]);
  //                 skillsIdList.remove(skillsIdList[item]);
  //               });
  //             },
  //             child: Icon(
  //               Icons.clear,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void addSkills() async {
  //   Map data = {
  //     "user_id": userIdMain,
  //     "product_id": productId,
  //     "skills": skillsIdList.join(","),
  //     "message_for_idea_person": messageController.text,
  //     "how_product_different": differenceController.text,
  //   };
  //   print(data);
  //   final response = await http.post(Uri.parse(WebApis.ADD_PRODUCT_SKILLS),
  //       body: json.encode(data),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json'
  //       });
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body) as Map;
  //     if (jsonData["RETURN_CODE"] == 1) {
  //       WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
  //     }
  //   }
  // }

  // // void getSkills() async {
  // //   Map mapData = {
  // //     "category_id": ppCategoryIdsMain,
  // //   };
  // //   print(mapData);
  // //   final response = await http.post(
  // //     Uri.parse(WebApis.SKILLS),
  // //     body: json.encode(mapData),
  //     headers: {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json'
  //     },
  //   );
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     Map data = WebResponseExtractor.filterWebData(response,
  //         dataObject: "RESOUCE_REQUIREMEN");

  //     if (data["code"] == 1) {
  //       getskillsFromWeb(data["data"]);
  //     }
  //   }
  // }

  // Future<Null> getskillsFromWeb(var jsonData) async {
  //   setState(() {
  //     for (Map skill in jsonData) {
  //       skillsList.add(
  //         new Dropdown(
  //           skill["id"],
  //           isEnglish ? skill["name"] : skill["hindi"],
  //         ),
  //       );
  //     }
  //   });

  //   if (loadedProduct == true) {
  //     getPpDetails();
  //   }
  // }

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
    // print(images[0].path);
  }

  void addVideo() async {
    double sized = 0;
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );
    if (result != null) {
      setState(() {
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

  void deletePP1MediaData(String id) async {
    Map data = {"media_id": id};
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.DELETE_PP_UPPER_MEDIA),
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

  void deletePP2MediaData(String id) async {
    Map data = {"media_id": id};
    print(data);
    final response = await http.post(
      Uri.parse(WebApis.DELETE_PP_LOWER_MEDIA),
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

  void createUser() async {
    Map data = {
      "user_id": userIdMain,
      "product_id": productId,
      "pp_id": ppId,
      "year_of_establishment":
          createUserController.elementAt(0).text.toString(),
      "legal_status_firm": createUserController.elementAt(1).text,
      "annual_turnover": createUserController.elementAt(2).text,
      "address": createUserController.elementAt(3).text,
      "brand_name": createUserController.elementAt(4).text,
      "gst_no": createUserController.elementAt(5).text,
      "team_size": createUserController.elementAt(6).text,
    };
    print(data);

    final response = await http.post(
      Uri.parse(WebApis.BUSINESS_DETAILS),
      body: json.encode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    print(response.body);
    final jsonData = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      if (jsonData["RETURN_CODE"] == 1) {
        productId = jsonData["PRODUCT_ID"];
        print(productId);
        WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
      }
    } else
      WebResponseExtractor.showToast(jsonData["RETURN_MESSAGE"]);
  }
}

class Dropdown {
  String ID;
  String NAME;
  Dropdown(this.ID, this.NAME);
  String get name => NAME;
  String get id => ID;
}
