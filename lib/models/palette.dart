import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor purpleLight = MaterialColor(
    0xff747dfc, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffffffff), //10%
      100: Color(0xfff1f2ff), //20%
      200: Color(0xffe3e5fe), //30%
      300: Color(0xffd5d8fe), //40%
      400: Color(0xffc7cbfe), //50%
      500: Color(0xffbabefe), //60%
      600: Color(0xffacb1fd), //70%
      700: Color(0xff9ea4fd), //80%
      800: Color(0xff9097fd), //90%
      900: Color(0xff828afc), //100%
    },
  );
  static const Color appBackground = Color.fromRGBO(242, 242, 242, 1);
  static const Color appBackgroundDark = Color.fromRGBO(232, 232, 232, 1);
  static const Color darkTextColor = Color.fromRGBO(54, 54, 54, 1);
}
