import 'package:flutter/material.dart';
import '../widgets/add_modify_1.dart';
import '../widgets/add_modify_2.dart';
import '../widgets/add_modify_4.dart';
import '../widgets/add_modify_3.dart';
import '../widgets/add_modify_5.dart';
import 'package:startit/main.dart';

class AddModifyData extends StatefulWidget {
  @override
  _AddModifyDataState createState() => _AddModifyDataState();
}

class _AddModifyDataState extends State<AddModifyData> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  int sliderIndex = 0;
  String text = isEnglish
      ? "Tell us About Your Idea"
      : 'हमें अपने आइडिया के बारे में बताएं';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    switch (sliderIndex) {
      case 0:
        setState(() {
          text = isEnglish
              ? "Tell us About Your Idea"
              : 'हमें अपने आइडिया के बारे में बताएं';
        });
        break;
      case 1:
        setState(() {
          text = isEnglish ? "Let's Add Your Idea" : 'आइए अपना आइडिया जोड़ें';
        });
        break;
      case 2:
        setState(() {
          text = isEnglish
              ? "Invite your friends to be a part of your idea.."
              : 'अपने दोस्तों को अपने आइडिया का हिस्सा बनने के लिए आमंत्रित करें..';
        });
        break;
      case 3:
        setState(() {
          text = isEnglish ? "Idea Privacy" : 'आइडिया गोपनीयता';
        });
        break;
      case 4:
        setState(() {
          text = isEnglish ? "Media Files" : 'मीडिया फ़ाइलें';
        });
        break;
      case 5:
        setState(() {
          text = isEnglish ? "Media Privacy" : 'मीडिया गोपनीयता';
        });
        break;
      default:
        setState(() {
          text = isEnglish
              ? "Tell us About Your Idea"
              : 'हमें अपने आइडिया के बारे में बताएं';
        });
    }

    return WillPopScope(
      onWillPop: () => Future.sync(onWillPop),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            isEnglish ? "Add or modify Idea" : 'आइडिया जोड़ें या संशोधित करें',
            textScaleFactor: 1,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
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
                  )),
              padding: EdgeInsets.only(top: width * 0.05),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (sliderIndex == 1)
                    Container(
                        width: width * 0.45,
                        // height: height*0.3,
                        child: Image.asset("assets/images/cloud.png")),
                  if (sliderIndex != 1)
                    SizedBox(
                      height: height * 0.05,
                    ),
                  SizedBox(height: height * 0.01),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                    child: Text(
                      text,
                      textScaleFactor: 1,
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  pageIndicator(width, height),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  introBuilder(),
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
            for (int i = 0; i < 6; i++)
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Widget> introData = [
      firstModify(),
      //2
      secondModify(width),
      thirdModify(width, height),
      fourthModify(
          width,
          height,
          isEnglish ? "Idea Summary" : 'आइडिया सारांश',
          isEnglish ? "Idea Uniqueness" : 'आइडिया की विशिष्टता',
          isEnglish ? "Your Case Study" : 'आपका केस स्टडी',
          isEnglish ? "Investor" : 'इन्वेस्टर',
          isEnglish ? "Product\nProvider" : 'उत्पाद\nप्रदाता',
          isEnglish ? "Service\nProvider" : 'सेवा\nप्रदाता',
          isEnglish
              ? "We know your idea is unique, so we recommend to show it to Investors."
              : 'हम जानते हैं कि आपका विचार अद्वितीय है, इसलिए हम इसे निवेशकों को दिखाने की सलाह देते हैं।',
          true,
          isEnglish ? 'Read' : 'पढ़',
          isEnglish ? 'Idea' : 'आइडिया'),
      fifthModify(height, width),
      fourthModify(
          width,
          height,
          isEnglish ? "Pictures" : 'चित्रों',
          isEnglish ? "Videos" : 'वीडियो',
          isEnglish ? "Documents" : 'दस्तावेज़',
          isEnglish ? "Investor" : 'इन्वेस्टर',
          isEnglish ? "Product\nProvider" : 'उत्पाद\nप्रदाता',
          isEnglish ? "Service\nProvider" : 'सेवा\nप्रदाता',
          isEnglish
              ? "We recommend to shoot your video and allow Investors to see it."
              : 'हम आपके वीडियो को शूट करने और निवेशकों को इसे देखने की अनुमति देने की सलाह देते हैं।',
          false,
          isEnglish ? 'See' : 'देख',
          isEnglish ? 'Media' : 'मीडिया'),
    ];

    return Container(
      height: height * 0.9,
      child: PageView(
        physics: loadedBip
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        children: introData,
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            sliderIndex = index;
          });
        },
      ),
    );
  }

  Container fifthModify(double height, double width) {
    return Container(
        padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
        child: AddModify5(pageController, sliderIndex, width, height));
  }

  Container fourthModify(
    double width,
    double height,
    String colText1,
    String colText2,
    String colText3,
    String rowText1,
    String rowText2,
    String rowText3,
    String lastText,
    bool fourth,
    String str,
    String str2,
  ) {
    return Container(
      padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
      width: width,
      child: AddModify4(
        pageController,
        sliderIndex,
        width,
        height,
        rowText1,
        rowText2,
        rowText3,
        colText1,
        colText2,
        colText3,
        fourth,
        lastText,
        str,
        str2,
      ),
    );
  }

  SingleChildScrollView thirdModify(double width, double height) {
    return SingleChildScrollView(
        child: AddModify3(pageController, sliderIndex, width, height));
  }

  SingleChildScrollView firstModify() {
    return SingleChildScrollView(
      // child: AddModify1(pageController, sliderIndex, categoryList),
      child: AddModify1(pageController, sliderIndex),
    );
  }

  Widget secondModify(double width) {
    return RawScrollbar(
      controller: scrollController,
      thumbColor: Colors.black26,
      isAlwaysShown: true,
      thickness: 8,
      child: SingleChildScrollView(
          child: AddModify2(width, pageController, sliderIndex)),
    );
  }
}
