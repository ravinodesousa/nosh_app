import 'package:flutter/material.dart';
import 'package:nosh_app/config/palette.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Palette.background,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/img_logo.png',
                  width: MediaQuery.of(context).size.width / 1.15,
                  height: MediaQuery.of(context).size.height / 1.15,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                )
              ],
            )));
  }
}
