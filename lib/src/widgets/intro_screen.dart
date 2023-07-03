import 'package:flutter/material.dart';
import 'package:startit/main.dart';

class IntroScreen extends StatelessWidget {
  final String image;

  final String description;
  final String description2;

  IntroScreen({
    this.image,
    this.description,
    this.description2,
  });

  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          Container(
            child: Image(
              height: MediaQuery.of(context).size.height * 0.35,
              image: AssetImage('assets/images/$image'),
            ),
          ),
          SizedBox(height: height * 0.03),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: SizedBox(
                width: 200,
                child: Text.rich(
                  TextSpan(
                      text: isEnglish ? 'Your Idea can' : 'आपका आइडिया आपका',
                      // style: TextStyle(
                      //   color: Colors.blue[900],
                      //   fontWeight: FontWeight.bold,
                      // ),
                      children: [
                        TextSpan(
                          text: isEnglish
                              ? ' be your Passion...'
                              : ' जुनून हो सकता है...',
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ]),
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              description,
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Spacer(),
          Text(
            description2,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
