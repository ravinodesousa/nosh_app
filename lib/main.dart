import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/screens/add_menu_item.dart';
import 'package:nosh_app/screens/canteen_list.dart';
import 'package:nosh_app/screens/cart.dart';
import 'package:nosh_app/screens/category_item.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:nosh_app/screens/item_detail.dart';
import 'package:nosh_app/screens/menu_list.dart';
import 'package:nosh_app/screens/notification_list.dart';
import 'package:nosh_app/screens/order_list.dart';
import 'package:nosh_app/screens/order_status.dart';
import 'package:nosh_app/screens/order_summary.dart';
import 'package:nosh_app/screens/qr_scan.dart';
import 'package:nosh_app/screens/splash.dart';
import 'package:nosh_app/screens/verify_otp.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NOSH',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Palette.kToDark,
        // primaryColor: Color.fromRGBO(94, 165, 152, 0),
      ),
      home: Splash(),
    );
  }
}
