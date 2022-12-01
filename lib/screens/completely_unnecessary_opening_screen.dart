import 'package:flutter/material.dart';

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
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CompletelyUnnecessaryRegistrationScreen();
              }));
            },
            child: Text('Register'),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
