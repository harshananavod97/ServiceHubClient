// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC6BfSu_1TxUy53-hNwkhQKApiuncvCas0',
    appId: '1:608157018159:web:68b791228330f4bb48beda',
    messagingSenderId: '608157018159',
    projectId: 'service-hub-client-a0f65',
    authDomain: 'service-hub-client-a0f65.firebaseapp.com',
    storageBucket: 'service-hub-client-a0f65.appspot.com',
    measurementId: 'G-SN0QG851T4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkHm61iiyY4i5svj19aCEz5mMLLBlFReU',
    appId: '1:608157018159:android:5a5aa308922a509448beda',
    messagingSenderId: '608157018159',
    projectId: 'service-hub-client-a0f65',
    storageBucket: 'service-hub-client-a0f65.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbxsvE7oLBg7GAZiLF8_30MKfMMe16FIk',
    appId: '1:608157018159:ios:56c7901d5d27974648beda',
    messagingSenderId: '608157018159',
    projectId: 'service-hub-client-a0f65',
    storageBucket: 'service-hub-client-a0f65.appspot.com',
    androidClientId: '608157018159-lp2m3p7vocttusbhc091fg26kri0gi54.apps.googleusercontent.com',
    iosClientId: '608157018159-l0n30k10bbt0qacbcmv2kst11vitdng0.apps.googleusercontent.com',
    iosBundleId: 'com.example.servicehubClient',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbxsvE7oLBg7GAZiLF8_30MKfMMe16FIk',
    appId: '1:608157018159:ios:56c7901d5d27974648beda',
    messagingSenderId: '608157018159',
    projectId: 'service-hub-client-a0f65',
    storageBucket: 'service-hub-client-a0f65.appspot.com',
    androidClientId: '608157018159-lp2m3p7vocttusbhc091fg26kri0gi54.apps.googleusercontent.com',
    iosClientId: '608157018159-l0n30k10bbt0qacbcmv2kst11vitdng0.apps.googleusercontent.com',
    iosBundleId: 'com.example.servicehubClient',
  );
}
