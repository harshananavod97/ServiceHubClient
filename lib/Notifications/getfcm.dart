


import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

//FireBase Fcm Token Get Method

Future<String?> getFcmToken() async {
  if (Platform.isAndroid) {
    String? fcmKey = await FirebaseMessaging.instance.getToken();
    return fcmKey;
  }
  String? fcmKey = await FirebaseMessaging.instance.getToken();
  return fcmKey;
}

