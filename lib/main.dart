import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor/screens/login_screen.dart';
import 'package:photo_editor/screens/opening_screen.dart';
import 'package:photo_editor/screens/registration_screen.dart';
import 'package:photo_editor/screens/photo_editing_screen.dart';

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
        fontFamily: "Nunito",
      ),
      home: OpeningScreen(),
      routes: {
        '/opening': (context) => OpeningScreen(),
        '/login': (context) => LoginScreen(),
        '/registration': (context) => RegistrationScreen(),
        '/welcome': (context) => WelcomeScreen(),
        // '/editing': (context) => PhotoEditingScreen(),
      },
    );
  }
}
