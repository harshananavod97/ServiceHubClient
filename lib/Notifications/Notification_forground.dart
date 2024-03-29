import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:servicehub_client/screen/Appoiment/appontment_screen.dart';

import '../main.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    final RemoteMessage? _message =
        await FirebaseMessaging.instance.getInitialMessage();
    final InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
    );
    _notiPlugin.initialize(initialSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
      print('onDidReceiveNotificationResponse Function');
      print(details.payload);
      print(details.payload != null);

  
    });
  }


//Notification Show for used

  static void showNotification(RemoteMessage message) {
    final NotificationDetails notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'com.example.push_notification',
        'push_notification',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    _notiPlugin.show(
      DateTime.now().microsecond,
      message.notification?.title,
      message.notification?.body,
      notiDetails,
      payload: message.data.toString(),
    );
  }
}
