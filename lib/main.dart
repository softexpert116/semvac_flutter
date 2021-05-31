import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import './service/api.dart';
import './provider/badge_provider.dart';
import './provider/push_notification.dart';
import 'screens/home_screen.dart';
import 'service/pushnotification.dart';
import './provider/app_name_provider.dart';

void main() async {
  Service _service = new Service();
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Firebase.initializeApp(),
    _service.addAppOpens(),
  ]);
  PushNotificationService service = new PushNotificationService();
  service.requestNotifications();
  await FirebaseMessaging.instance.subscribeToTopic('SEMVAC_TOPIC');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => BadgeCounter(),
          ),
          ChangeNotifierProvider(
            create: (context) => PushNotification(),
          ),
          ChangeNotifierProvider(
            create: (context) => AppNameProvider(),
          )
        ],
        child: MaterialApp(
          title: 'SEMVAC Covid Viet App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
