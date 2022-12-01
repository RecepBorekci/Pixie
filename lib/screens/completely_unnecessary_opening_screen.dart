import 'package:flutter/material.dart';
import 'package:photo_editor/screens/welcome_screen.dart';

import 'completely_unnecessary_login_screen.dart';
import 'completely_unnecessary_registration_screen.dart';

class CompletelyUnnecessaryOpeningScreen extends StatelessWidget {
  const CompletelyUnnecessaryOpeningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CompletelyUnnecessaryLoginScreen();
              }));
            },
            child: Text('Log In'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CompletelyUnnecessaryRegistrationScreen();
              }));
            },
            child: Text('Register'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WelcomeScreen();
              }));
            },
            child: Text('Go to Welcome Screen'),
          ),
        ],
      ),
    );
  }
}
