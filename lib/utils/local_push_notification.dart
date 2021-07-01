import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalPushNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext mContext;

  void initLocalPushNotification(BuildContext context) {
    this.mContext = context;
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_noti_launcher');
    var iOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    ///For IOS
    getPermission();

    var initSettings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onTapNotification);
  }

  void getPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  ///For iOS
  // ignore: missing_return
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  ///Cancel Notification
  Future<dynamic> buildBackgroundNotification(
      Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
        '1104', 'the_voicee', 'Thhe Voicee App',
        priority: Priority.high, importance: Importance.max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);

    final dynamic notification = message['notification'];
    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(
          Random.secure().nextInt(500).toInt(),
          notification['title'],
          notification['body'],
          platform,
          payload: message['data'] != null
              ? jsonEncode(message['data']).toString()
              : null);
    }
  }

  // ignore: missing_return
  Future<dynamic> onTapNotification(data) {
    if (data is Map) {
      return null;
    } else if (data is String) {
      return null;
    }
  }

  void clearAll() {
    if (flutterLocalNotificationsPlugin != null) {
      flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}
