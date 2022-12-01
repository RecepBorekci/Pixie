import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor/screens/photo_editing_screen.dart';
import 'package:photo_editor/widgets/default_button.dart';
import 'package:screenshot/screenshot.dart';

import '../utils/utils.dart';

abstract class EditImageViewModel extends State<PhotoEditingScreen> {

  TextEditingController textEditingController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();

  saveToGallery(BuildContext context){
    screenshotController.capture().then((Uint8List? image) {
    saveImage(image!);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image Saved To Gallery!'),),);
    }).catchError((err) => print(err));
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  addNewText(BuildContext context) {
    setState(() {
    });
  }

  addNewDialog(context) {
    showDialog(context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Add New Text'),
          content: TextField(
            controller: textEditingController,
            maxLines: 5,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.edit),
              filled: true,
              hintText: 'Your Text Here.',
            ),
          ),
          actions: <Widget>[
            DefaultButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back'),
                color: Colors.red,
                textColor: Colors.white
            ),
            DefaultButton(
                onPressed: () {},
                child: const Text('Add Text'),
                color: Colors.red,
                textColor: Colors.white
            ),
          ]
        ),
    );
  }

  }