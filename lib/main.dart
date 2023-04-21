import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/data/item.dart';
import 'package:nosh_app/screens/add_menu.dart';
import 'package:nosh_app/screens/canteen_list.dart';
import 'package:nosh_app/screens/cart.dart';
import 'package:nosh_app/screens/forgot_password.dart';
import 'package:nosh_app/screens/item_list.dart';
import 'package:nosh_app/screens/login.dart';
import 'package:nosh_app/screens/menu_list.dart';
import 'package:nosh_app/screens/notification_list.dart';
import 'package:nosh_app/screens/order_list_common.dart';
import 'package:nosh_app/screens/order_list_customer.dart';
import 'package:nosh_app/screens/payments.dart';
import 'package:nosh_app/screens/profile.dart';
import 'package:nosh_app/screens/qr.dart';
import 'package:nosh_app/screens/signup.dart';
import 'package:nosh_app/screens/splash.dart';
import 'package:nosh_app/screens/token_history.dart';
import 'package:nosh_app/screens/users_list.dart';

void main() {
  runApp(const MyApp());
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
      home: const Payments(),
    );
  }
}
