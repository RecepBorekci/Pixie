import 'package:flutter/material.dart';
import 'package:photo_editor/screens/photo_selecting_screen.dart';
import 'package:photo_editor/screens/settings_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final List<Icon> recentImages = [Icon(Icons.add)];

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingsScreen();
                }));
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Recent photos: '),
              // ListView(
              //   scrollDirection: Axis.vertical,
              //   children: recentImages,
              // )
            ],
          ),
          TextButton(
            child: Text('Go to selecting screen.'),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PhotoSelectingScreen();
              }));
            },
          ),
          TextButton(
              onPressed: () {},
              child: Text('Go to edit video screen. (Does not exist yet)'))
        ],
      ),
    );
  }
}
