import 'dart:convert';

// import 'package:bia/Services/NotCommon.dart';
import 'package:startit/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class FirebaseMessage {
  static void sendMessageToUser(String receiverId, String receiverName,
      String receiverProfileImage, String message, String fileName) {
    DocumentReference documentReference1;
    DateTime nows = DateTime.now();

    String formattedDate = nows.microsecondsSinceEpoch.toString();
    if (message.contains('.png') ||
        message.contains('.jpg') ||
        message.contains('.jpeg') ||
        message.contains('.mp4') ||
        message.contains('.pdf') ||
        message.contains('.docx') ||
        message.contains('.xlsx') ||
        message.contains('.pptx')) {
      documentReference1 = FirebaseFirestore.instance
          .collection('message')
          .doc(userFirebaseId)
          .collection(receiverId)
          .doc();
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': receiverName,
        'ProfileImage': receiverProfileImage,
        'Id': receiverId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "",
        'url': message,
        'fileName': fileName,
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': message.contains('.png') ||
                message.contains('.jpg') ||
                message.contains('.jpeg')
            ? "image"
            : message.contains('.mp4')
                ? "video"
                : "file",
        'totalMessage': '',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "yes"
      });
      documentReference1 = FirebaseFirestore.instance
          .collection('message')
          .doc(receiverId)
          .collection(userFirebaseId)
          .doc();
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': name,
        'ProfileImage': profileImageMain,
        'Id': userFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "",
        'url': message,
        'fileName': fileName,
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': message.contains('.png') ||
                message.contains('.jpg') ||
                message.contains('.jpeg')
            ? "image"
            : message.contains('.mp4')
                ? "video"
                : "file",
        'totalMessage': '',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "yes"
      });
      documentReference1 = FirebaseFirestore.instance
          .collection('user/$userFirebaseId/recentMessage')
          .doc(receiverId);
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': receiverName,
        'ProfileImage': receiverProfileImage,
        'Id': receiverId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "",
        'url': message,
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': message.contains('.png') ||
                message.contains('.jpg') ||
                message.contains('.jpeg')
            ? "image"
            : message.contains('.mp4')
                ? "video"
                : "file",
        'totalMessage': '',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "yes"
      });
      documentReference1 = FirebaseFirestore.instance
          .collection('user/$receiverId/recentMessage')
          .doc(userFirebaseId);
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': name,
        'ProfileImage': profileImageMain,
        'Id': userFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "",
        'url': message,
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': message.contains('.png') ||
                message.contains('.jpg') ||
                message.contains('.jpeg')
            ? "image"
            : message.contains('.mp4')
                ? "video"
                : "file",
        'totalMessage': '',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "yes"
      });
    } else {
      documentReference1 = FirebaseFirestore.instance
          .collection('message')
          .doc(userFirebaseId)
          .collection(receiverId)
          .doc();
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': receiverName,
        'ProfileImage': receiverProfileImage,
        'Id': receiverId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': message,
        'url': "",
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': 'text',
        'totalMessage': '',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "yes"
      });
      documentReference1 = FirebaseFirestore.instance
          .collection('message')
          .doc(receiverId)
          .collection(userFirebaseId)
          .doc();
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': name,
        'ProfileImage': profileImageMain,
        'Id': userFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': message,
        'url': "",
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': 'text',
        'totalMessage': '',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "yes"
      });
      documentReference1 = FirebaseFirestore.instance
          .collection('user/$userFirebaseId/recentMessage')
          .doc(receiverId);
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': receiverName,
        'ProfileImage': receiverProfileImage,
        'Id': receiverId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': message,
        'url': "",
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': 'text',
        'totalMessage': '',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "yes"
      });
      documentReference1 = FirebaseFirestore.instance
          .collection('user/$receiverId/recentMessage')
          .doc(userFirebaseId);
      documentReference1.set({
        "documentId": documentReference1.id,
        'Name': name,
        'ProfileImage': profileImageMain,
        'Id': userFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': message,
        'url': "",
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': 'text',
        'totalMessage': '',
        'seenMessage': '',
        'messageTo': "user",
        'forwardMessage': "yes"
      });
    }
  }

  static void sendGroupMessage(String groupFirebaseId, String groupName,
      String groupId, String groupImage, List<String> userList) {
    DocumentReference documentReference1;
    DateTime nows = DateTime.now();

    String formattedDate = nows.microsecondsSinceEpoch.toString();
    for (int i = 0; i < userList.length; i++) {
      documentReference1 = FirebaseFirestore.instance
          .collection('user/${userList[i]}/recentMessage')
          .doc(groupFirebaseId);
      documentReference1.set({
        "documentId": groupFirebaseId,
        'Name': groupName,
        'ProfileImage': groupImage,
        'Id': groupFirebaseId,
        'SenderName': name,
        'SenderProfileImage': profileImageMain,
        'SenderId': userFirebaseId,
        'Message': "New Group",
        'url': "",
        'timestamp': formattedDate,
        'DateAndTime': DateTime.now().toString(),
        'messageType': 'text',
        'totalMessage': "",
        'seenMessage': '',
        "group_id": groupId,
        'messageTo': "group",
        'forwardMessage': "no"
      });
    }
  }

  static void sendNotification(
      String message, String deviceToken, String type) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    print(deviceToken);
    // print("rahul");
    /* final android = AndroidInitializationSettings('@mipmap/ic_launcher');
     final iOS = IOSInitializationSettings();
     final initSettings = InitializationSettings(android, iOS);
     final FirebaseMessaging  _fcm = FirebaseMessaging();
     flutterLocalNotificationsPlugin.initialize(initSettings,
         onSelectNotification: _onSelectNotification);
    String token = await _fcm.getToken();*/

    final data = {
      "notification": {
        "body": "$message",
        "title": "$name Send $type",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "priority": "high",
      "data": {
        "pagepath": "/recentChat",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$deviceToken"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA5Su3adU:APA91bFb0IbRjmGaxFD-FvFobWsI1BPalU7g82rLhP_WlV_WditCaY6EaC7cAh2NrcKZtnjOlOytgK8j_n6L5Dbvyj9lfeNQkLYtL5uIuoIfdIXJbrUf8Bl5dypzj8jALH0q2x9fiOCk'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options)
          .post('https://fcm.googleapis.com/fcm/send', data: data);

      if (response.statusCode == 200) {
        /*  final android = AndroidNotificationDetails(
             'channel id', 'channel name', 'channel description',
             priority: Priority.High, importance: Importance.Max);
         final iOS = IOSNotificationDetails();
         final platform = NotificationDetails(android, iOS);
         //final json = jsonEncode();
         final isSuccess = downloadStatus['isSuccess'];

         await flutterLocalNotificationsPlugin.show(
             0, // notification id
             isSuccess ? 'Success' : 'Failure',
             isSuccess
                 ? 'File has been downloaded successfully!'
                 : 'There was an error while downloading the file.',
             platform,
             payload: json);*/
        // Fluttertoast.showToast(msg: 'Request Sent To Driver');
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
    }

    /* http.Response response = await http.post(
       'https://fcm.googleapis.com/fcm/send',
       headers: <String, String>{
         'Content-Type': 'application/json',
         'Authorization': 'key=${NotCommon.SCREATE_KEY}',
       },
       body: jsonEncode(
         <String, dynamic>{
           'notification': <String, dynamic>{
             'body': 'Chat',
             'title': '$message'
           },
           'priority': 'high',
           'data': <String, dynamic>{
             'click_action':
             'FLUTTER_NOTIFICATION_CLICK',
             'id': '1',
             'status': 'done'
           },
           'to': fcmToken,
         },
       ),
     );*/
  }

  static void sendNotificationToGroup(String message, String deviceToken,
      String type, List<String> tokenIdList) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    print(deviceToken);
    print("object");
    /* final android = AndroidInitializationSettings('@mipmap/ic_launcher');
     final iOS = IOSInitializationSettings();
     final initSettings = InitializationSettings(android, iOS);
     final FirebaseMessaging  _fcm = FirebaseMessaging();
     flutterLocalNotificationsPlugin.initialize(initSettings,
         onSelectNotification: _onSelectNotification);
    String token = await _fcm.getToken();*/
    for (int i = 0; i < tokenIdList.length; i++) {
      final data = {
        "notification": {
          "body": "$message",
          "title": "$name Send $type",
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        },
        "priority": "high",
        "data": {
          "pagepath": "/recentChat",
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done"
        },
        "to": "${tokenIdList[i]}"
      };

      final headers = {
        'content-type': 'application/json',
        'Authorization':
            'key=AAAA5Su3adU:APA91bFb0IbRjmGaxFD-FvFobWsI1BPalU7g82rLhP_WlV_WditCaY6EaC7cAh2NrcKZtnjOlOytgK8j_n6L5Dbvyj9lfeNQkLYtL5uIuoIfdIXJbrUf8Bl5dypzj8jALH0q2x9fiOCk'
      };

      BaseOptions options = new BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 3000,
        headers: headers,
      );

      try {
        final response = await Dio(options)
            .post('https://fcm.googleapis.com/fcm/send', data: data);

        if (response.statusCode == 200) {
          /*  final android = AndroidNotificationDetails(
             'channel id', 'channel name', 'channel description',
             priority: Priority.High, importance: Importance.Max);
         final iOS = IOSNotificationDetails();
         final platform = NotificationDetails(android, iOS);
         //final json = jsonEncode();
         final isSuccess = downloadStatus['isSuccess'];

         await flutterLocalNotificationsPlugin.show(
             0, // notification id
             isSuccess ? 'Success' : 'Failure',
             isSuccess
                 ? 'File has been downloaded successfully!'
                 : 'There was an error while downloading the file.',
             platform,
             payload: json);*/
          // Fluttertoast.showToast(msg: 'Request Sent To Driver');
        } else {
          print('notification sending failed');
          // on failure do sth
        }
      } catch (e) {
        print('exception $e');
      }
    }
    /* http.Response response = await http.post(
       'https://fcm.googleapis.com/fcm/send',
       headers: <String, String>{
         'Content-Type': 'application/json',
         'Authorization': 'key=${NotCommon.SCREATE_KEY}',
       },
       body: jsonEncode(
         <String, dynamic>{
           'notification': <String, dynamic>{
             'body': 'Chat',
             'title': '$message'
           },
           'priority': 'high',
           'data': <String, dynamic>{
             'click_action':
             'FLUTTER_NOTIFICATION_CLICK',
             'id': '1',
             'status': 'done'
           },
           'to': fcmToken,
         },
       ),
     );*/
  }

  static Future _onSelectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
