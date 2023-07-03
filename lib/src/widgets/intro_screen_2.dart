import 'package:flutter/material.dart';

class IntroScreen2 extends StatelessWidget {
  final String image;
  final String heading;
  final String description;
  final String description2;

  IntroScreen2({
    this.image,
    this.heading,
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
              height: MediaQuery.of(context).size.height * 0.38,
              image: AssetImage('assets/images/$image'),
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              heading,
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
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
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
