import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/screens/photo_editing_screen.dart';

import './settings_screen.dart';
import '../widgets/home_buttons.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<Icon> recentImages = [Icon(Icons.add)];

  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('Pixie'),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.photo_camera,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SettingsScreen();
                    }));
                  },
                  icon: Icon(Icons.settings)),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 0),
        child: Column(
          children: [
            if (image != null) Image.file(image!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HomeButton(
                  onPressed: pickImage,
                  source: ImageSource.gallery,
                  icon: Icons.photo,
                  text: "Gallery",
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pink,
                ),
                HomeButton(
                  onPressed: pickImage,
                  source: ImageSource.camera,
                  icon: Icons.photo_camera,
                  text: "Camera",
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.cyan,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotoEditingScreen();
                }));
              },
              child: Text('Go to editing screen.'),
            )
          ],
        ),
      ),
    );
  }
}
