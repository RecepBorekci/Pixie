import 'package:flutter/material.dart';
import 'package:photo_editor/screens/photo_editing_screen.dart';
import 'package:photo_editor/widgets/default_button.dart';

abstract class EditImageViewModel extends State<PhotoEditingScreen> {

  TextEditingController textEditingController = TextEditingController();

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