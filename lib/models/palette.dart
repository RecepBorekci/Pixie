import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor purpleLight = const MaterialColor(
    0xff747dfc, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff828afc), //10%
      100: const Color(0xff9097fd), //20%
      200: const Color(0xff9ea4fd), //30%
      300: const Color(0xffacb1fd), //40%
      400: const Color(0xffbabefe), //50%
      500: const Color(0xffc7cbfe), //60%
      600: const Color(0xffd5d8fe), //70%
      700: const Color(0xffe3e5fe), //80%
      800: const Color(0xfff1f2ff), //90%
      900: const Color(0xffffffff), //100%
    },
  );
  static const Color appBackground = Color.fromRGBO(242, 242, 242, 1);
  static const Color appBackgroundDark = Color.fromRGBO(232, 232, 232, 1);
  static const Color darkTextColor = Color.fromRGBO(54, 54, 54, 1);
}
