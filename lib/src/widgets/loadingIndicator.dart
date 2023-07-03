import 'package:flutter/material.dart';

class LoadingIndicator {
  static loadingIndicator(BuildContext ctx) {
    return showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          return Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            ),
          );
        });
  }
}
