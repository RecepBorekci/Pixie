import 'package:flutter/material.dart';
import 'package:photo_editor/screens/welcome_screen.dart';

import 'login_screen.dart';
import 'registration_screen.dart';

class CompletelyUnnecessaryOpeningScreen extends StatelessWidget {
  const CompletelyUnnecessaryOpeningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
      ),
    );
  }
}
