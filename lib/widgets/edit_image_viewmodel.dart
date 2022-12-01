import 'package:flutter/material.dart';
import 'package:photo_editor/screens/photo_editing_screen.dart';

abstract class EditImageViewModel extends State<PhotoEditingScreen> {

  TextEditingController textEditingController = TextEditingController();

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

          ]
        ),
    );
  }
  
}