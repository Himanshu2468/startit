import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AccountSettings extends StatelessWidget {
  //const AccountSettings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    String move = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      drawer: AppDrawer(move),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Account Settings',
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
              children: [
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delete Account',
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.015),
                        Text(
                          'Before deleting your account you must cancel the subscription',
                          textScaleFactor: 1,
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: height * 0.015),
                        Container(
                          width: width * 0.3,
                          child: OutlinedButton(
                            child: Text(
                              'Delete',
                              textScaleFactor: 1,
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Password',
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              'Forget your password?',
                              textScaleFactor: 1,
                              style: TextStyle(fontSize: 12),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Reset Password',
                                textScaleFactor: 1,
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.015),
                        buildTextField(
                            context, width, height, 'Current Password'),
                        buildTextField(context, width, height, 'New Password'),
                        buildTextField(
                            context, width, height, 'Confirm Password'),
                        Container(
                          height: height * 0.05,
                          width: width * 0.3,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Update',
                              textScaleFactor: 1,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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

  Widget buildTextField(
      BuildContext context, double width, double height, String heading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: heading,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: height * 0.02),
        TextFormField(
          decoration: InputDecoration(
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
        SizedBox(height: height * 0.025),
      ],
    );
  }
}
