import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'photo_editing_screen.dart';

class PhotoSelectingScreen extends StatefulWidget {
  @override
  State<PhotoSelectingScreen> createState() => _PhotoSelectingScreenState();
}

class _PhotoSelectingScreenState extends State<PhotoSelectingScreen> {
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
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
        title: Text("Select an Image"),
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text('Select Image From Gallery')),
            ElevatedButton(onPressed: () {}, child: Text('Open Camera')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PhotoEditingScreen();
                  }));
                },
                child: Text('Go to editing screen')),
          ],
        ),
      ),
    );
  }
}
