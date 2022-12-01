import 'package:flutter/material.dart';

import './models/palette.dart';

import './screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Palette.purpleLight,
        fontFamily: "Montserrat",
      ),
      home: WelcomeScreen(),
    );
  }
}
