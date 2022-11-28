import 'package:flutter/material.dart';
import 'package:photo_editor/screens/photo_selecting_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            Icon(Icons.menu),
            Icon(Icons.camera),
          ],
        ),
        title: Text('Pixie'),
      ),
      body: Center(
        child: TextButton(
          child: Text('Go to selecting screen.'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PhotoSelectingScreen();
            }));
          },
        ),
      ),
    );
  }
}
