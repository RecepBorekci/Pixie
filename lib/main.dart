import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/screens/completely_unnecessary_login_screen.dart';
import 'package:photo_editor/screens/completely_unnecessary_opening_screen.dart';
import 'package:photo_editor/screens/completely_unnecessary_registration_screen.dart';
import 'package:photo_editor/screens/photo_editing_screen.dart';
import 'package:photo_editor/screens/settings_screen.dart';

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
      home: CompletelyUnnecessaryOpeningScreen(),
      routes: {
        '/opening': (context) => CompletelyUnnecessaryOpeningScreen(),
        '/login': (context) => CompletelyUnnecessaryLoginScreen(),
        '/registration': (context) => CompletelyUnnecessaryRegistrationScreen(),
        '/welcome': (context) => WelcomeScreen(),
        // '/editing': (context) => PhotoEditingScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
