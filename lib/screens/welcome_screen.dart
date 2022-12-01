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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 0, 0),
                child: Text(
                  "Pixie",
                  style: TextStyle(
                      fontFamily: "Courgette",
                      fontSize: 40,
                      color: Color.fromRGBO(54, 54, 54, 1),
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
