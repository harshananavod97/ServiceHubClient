import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:servicehub_client/Notifications/Notification_forground.dart';
import 'package:servicehub_client/Notifications/getfcm.dart';
import 'package:servicehub_client/api/api_controller.dart';
import 'package:servicehub_client/firebase_options.dart';
import 'package:servicehub_client/provider/auth_provider.dart';
import 'package:servicehub_client/provider/map_provider.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:servicehub_client/screen/Appoiment/appontment_screen.dart';

import 'package:servicehub_client/screen/On%20Bording%20Screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Fire Base Push Noti
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  Future.delayed(Duration(seconds: 1)).then((value) {
    if (message.notification?.title == "New Request For Job") {
      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => AppointmentScreen(on: true, size: 40),
        ),
      );
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //-------------------------------------------------------------------------------
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    final fcmToken = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onMessage.listen((event) {
      print("onMessage fORGROUND ${event.data}");

      if (event.notification?.title == "New Request For Job") {
        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => AppointmentScreen(on: true, size: 40),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp ${message.data}");

      print("open it");
      if (message.notification?.title == "New Request For Job") {
        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => AppointmentScreen(on: true, size: 40),
          ),
        );
      }
    });

    final RemoteMessage? _message =
        await FirebaseMessaging.instance.getInitialMessage();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Apicontroller(),
        ),
        ChangeNotifierProvider(
          create: (context) => MapProvider(),
        ),
      ],
      child: MyApp(message: _message),
    ));
  });
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatefulWidget {
  final RemoteMessage? message;
  MyApp({super.key, this.message});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Apicontroller apicontroller = Apicontroller();
  String customerid = "";

  //get Use Customer Id

  getUserData() async {
    String? fcmKey = await getFcmToken();
    final ids = await SharedPreferences.getInstance();
    final idss = await SharedPreferences.getInstance();

    setState(() {
      ids.getString("id").toString().isNotEmpty
          ? customerid = ids.getString("id").toString()
          : customerid = idss.getString("id").toString();
      apicontroller.getcustomerdetails(customerid, context);
    });

    //Used To Update Fcm Key
    apicontroller.CustomerFcmKeyUpdat(customerid, fcmKey.toString());
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    LocalNotification.initialize();
    // For Forground State
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotification.showNotification(message);
    });
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Service Hub Customer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
