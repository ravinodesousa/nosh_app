import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';
import 'package:nosh_app/screens/auth.dart';
import 'package:nosh_app/screens/canteen_list.dart';
import 'package:nosh_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(Duration(seconds: 3), () => {checkAuthStatus()});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void checkAuthStatus() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.containsKey("userId") &&
        prefs.containsKey("userType") &&
        prefs.containsKey("userName") &&
        prefs.containsKey("canteenName") &&
        prefs.containsKey("email") &&
        prefs.containsKey("mobileNo")) {
      if (prefs.getString("userType") == "USER") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CanteenList()));
      } else if (prefs.getString("userType") == "CANTEEN") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/img_splash.png",
                width: 220,
                height: 220,
              )
            ]),
      ),
    );
  }
}
