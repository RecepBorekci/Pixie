import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/screens/completely_unnecessary_login_screen.dart';
import 'package:photo_editor/screens/completely_unnecessary_opening_screen.dart';
import 'package:photo_editor/screens/completely_unnecessary_registration_screen.dart';
import 'package:photo_editor/screens/photo_editing_screen.dart';
import 'package:photo_editor/screens/settings_screen.dart';

import './models/palette.dart';

import './screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Palette.purpleLight,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurpleAccent,
        ),
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
