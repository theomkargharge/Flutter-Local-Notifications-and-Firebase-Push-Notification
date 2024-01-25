import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(

      );

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {});
  }

  void requestNoiticationPremission() async {
    NotificationSettings notificationSettings =
        await messaging.requestPermission(
      carPlay: true,
      sound: true,
      badge: true,
      alert: true,
      announcement: true,
      criticalAlert: true,
      provisional: true,
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('User gives the permission');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User gives the permission');
    } else {
      print('User denied the permission');
    }
  }

  //get device token
  Future<String> getToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  // get refresh token

  void refreshToken() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print(event);
    });
  }

  //get the notification
  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
      showNotification(message);
    });
  }

  // show message
  Future<void> showNotification(RemoteMessage message) async {
    // AndroidNotificationChannel channel = AndroidNotificationChannel(
    //     Random.secure().nextInt(10000).toString(),
    //     'Blood donation Notification',
    //     importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            Random.secure().nextInt(10000).toString(),
            'Blood donation Notification',
            channelDescription: 'you channel description',
            importance: Importance.max,
            // priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            ticker: 'ticker');

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

   await  _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails);
  }
}
