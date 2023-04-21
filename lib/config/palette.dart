import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xffb5662f, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xffbc7544), //10%
      100: const Color(0xffc48559), //20%
      200: const Color(0xffcb946d), //30%
      300: const Color(0xffd3a382), //40%
      400: const Color(0xffdab397), //50%
      500: const Color(0xffe1c2ac), //60%
      600: const Color(0xffe9d1c1), //70%
      700: const Color(0xfff0e0d5), //80%
      800: const Color(0xfff8f0ea), //90%
      900: const Color(0xffffffff), //100%
    },
  );

  static const Color background = Color.fromRGBO(244, 246, 198, 1);
  static const Color brown = Color.fromRGBO(181, 102, 47, 1);
} // you can define define int 500 as the default shade and add your lighter tints above and darker tints below.
