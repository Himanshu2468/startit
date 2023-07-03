import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BuildContext context;
  void initNotifications() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> pushNotification(
      Map<String, dynamic> result, BuildContext buildContext) async {
    context = buildContext;
    /* const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'push_messages: 0', 'push_messages: push_messages', 'push_messages: A new Flutter project',
      importance: Importance.High,
      priority: Priority.High,
      showWhen: false,
      enableVibration: true,
    );*/
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        Platform.isAndroid ? 'com.app.startit' : 'com.app.startit',
        'STARTiT Chat',
        'your channel description',
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        icon: '@mipmap/ic_launcher'
        //priority: Priority.High,
        );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0,
        '${result['notification']['title'].toString()}',
        '${result['notification']['body'].toString()}',
        platformChannelSpecifics,
        payload: result['data']['pagepath']);
  }

  Future selectNotification(String path) async {
    // some action...
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   Navigator.of(navigatorKey.currentContext)
    //       .pushNamed("$path");
    // });
    // navigatorKey.currentState.pushNamed("$path");
  }
}
