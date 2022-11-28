import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_editor/screens/photo_editing_screen.dart';

class PhotoSelectingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PhotoEditingScreen();
                }));
              },
              child: Text('Go to editing screen.'))
        ],
      ),
    );
  }
}
