import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mtnno1/admin/add_food.dart';
import 'package:mtnno1/admin/admin_home.dart';
import 'package:mtnno1/admin/admin_login.dart';
import 'package:mtnno1/pages/bottomnav.dart';
import 'package:mtnno1/pages/home.dart';
import 'package:mtnno1/pages/login.dart';
import 'package:mtnno1/pages/onboard.dart';
import 'package:mtnno1/service/app_constrant.dart';
import 'package:mtnno1/service/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mtn.no1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Onboard(),
    );
  }
}
