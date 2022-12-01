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
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PhotoEditingScreen(
          image: image,
        );
      }));
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
                icon: Icon(
                  Icons.menu,
                  size: 30,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                color: Colors.grey,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                "Pixie",
                style: TextStyle(
                    fontFamily: "Courgette",
                    fontSize: 40,
                    color: Color.fromRGBO(54, 54, 54, 1),
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ],
          ),
        ),
      ),
    );
  }
}
