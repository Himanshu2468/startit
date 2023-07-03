import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startit/main.dart';

import '../widgets/intro_screen.dart';
import '../widgets/intro_screen_2.dart';
import '../widgets/intro_screen_3.dart';

class IntroPlaceholder extends StatefulWidget {
  @override
  _IntroPlaceholderState createState() => _IntroPlaceholderState();
}

class _IntroPlaceholderState extends State<IntroPlaceholder> {
  PageController pageController = PageController();
  int sliderIndex = 0;

  build(context) {
    List<Widget> introData = [
      IntroScreen(
        image: 'Intro.png',
        description: isEnglish
            ? 'Idea person is individual or group of people have a concept, thought and planning to start their own business for independence from financially and living the real passion of theirs..'
            : 'विचार व्यक्ति व्यक्ति है या लोगों के समूह के पास आर्थिक रूप से स्वतंत्रता और अपने वास्तविक जुनून को जीने के लिए अपना खुद का व्यवसाय शुरू करने की अवधारणा, विचार और योजना है।..',
        description2: isEnglish
            ? 'Think, Collaborate And Change Your Life'
            : 'सोचें, सहयोग करें और अपना जीवन बदलें',
      ),
      IntroScreen3(
        image: 'Finance.png',
        heading: isEnglish
            ? 'Your Investment can be Success story for other too...'
            : 'आपका निवेश दूसरों के लिए भी सफलता की कहानी हो सकता है ...',
        description: isEnglish
            ? "Individual or group of people who's real passion is to invest in the startups or businesses to uplift and make profit as they grow."
            : 'व्यक्ति या लोगों का समूह, जिनका वास्तविक जुनून स्टार्टअप्स या व्यवसायों में निवेश करना है ताकि वे बढ़ने के साथ-साथ लाभ कमा सकें।',
        description2: isEnglish
            ? 'Think, Collaborate And Change Your Life'
            : 'सोचें, सहयोग करें और अपना जीवन बदलें',
      ),
      IntroScreen2(
        image: 'Brainstorming.png',
        heading: isEnglish
            ? 'Your resource or service can be better utilized...'
            : 'आपके संसाधन या सेवा का बेहतर उपयोग किया जा सकता है ...',
        description: isEnglish
            ? 'Individual people who provide their professional and skilled services to others to complete their work or projects as a freelancers or part-time workers.'
            : 'व्यक्तिगत लोग जो अपने काम या परियोजनाओं को एक फ्रीलांसर या अंशकालिक कार्यकर्ता के रूप में पूरा करने के लिए दूसरों को अपनी पेशेवर और कुशल सेवाएं प्रदान करते हैं।',
        description2: isEnglish
            ? 'Think, Collaborate And Change Your Life'
            : 'सोचें, सहयोग करें और अपना जीवन बदलें',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width * 0.125,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            startItLogo(),
            introBuilder(introData),
            pageIndicator(),
            ElevatedButton(
              child: Text(
                isEnglish ? 'Next' : 'अगला',
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                if (sliderIndex == 2) {
                  Navigator.of(context).pushReplacementNamed('/login');
                } else
                  pageController.animateToPage(sliderIndex + 1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastLinearToSlowEaseIn);
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(12.0),
              child: Text.rich(
                TextSpan(
                  text: isEnglish
                      ? 'By Continuing you agree to our '
                      : 'जारी रखकर आप हमारी सहमति देते हैं ',
                  children: [
                    TextSpan(
                      text: isEnglish ? 'Terms' : 'नियम',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Terms');
                        },
                    ),
                    TextSpan(text: isEnglish ? ' and ' : ' और '),
                    TextSpan(
                      text: isEnglish ? 'Privacy Policy' : 'गोपनीयता नीति',
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('Privacy');
                        },
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void toggleSwitch(bool value) async {
    setState(() {
      isEnglish = value;
    });

    final prefs = await SharedPreferences.getInstance();
    final userRemember = json.encode({
      "languageCheck": isEnglish,
    });

    prefs.setString("language", userRemember);
  }

  Widget startItLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.07,
          child: Image(
            image: AssetImage('assets/images/StartItlogo2.PNG'),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language),
            SizedBox(width: 4),
            SizedBox(
              width: 50,
              child: DropdownButton(
                // hint: Text(
                //   isEnglish ? 'Language' : "भाषा",
                // ),
                style: TextStyle(color: Colors.black),
                iconSize: 0.0,
                underline: SizedBox(),
                value: isEnglish,
                onChanged: (_value) {
                  toggleSwitch(_value);
                },
                items: [
                  DropdownMenuItem(
                    value: true,
                    child: Text(
                      "English",
                      textScaleFactor: 1,
                    ),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text(
                      "Hindi",
                      textScaleFactor: 1,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget pageIndicator() {
    return Container(
        width: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < 3; i++)
              i == sliderIndex
                  ? pageIndicatorContainer(true)
                  : pageIndicatorContainer(false)
          ],
        ));
  }

  Widget pageIndicatorContainer(bool isCurrentPage) {
    return isCurrentPage
        ? Expanded(
            child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ))
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          );
  }

  Widget introBuilder(List<Widget> introData) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return introData[index];
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
}
