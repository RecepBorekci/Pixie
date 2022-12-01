import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:photo_editor/widgets/edit_image_viewmodel.dart';

class PhotoEditingScreen extends StatefulWidget {
  final XFile image;
  const PhotoEditingScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<PhotoEditingScreen> createState() => _PhotoEditingScreenState();
}

class _PhotoEditingScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addnewTextFab,
      body: Image.file(File(widget.image.path)),
    );
  }

  Widget get _addnewTextFab => FloatingActionButton(
      onPressed: () => addNewDialog(context),
    backgroundColor: Colors.white60,
    tooltip: 'Add New Text',
    child: const Icon(
     Icons.edit,
      color: Colors.black,
    ),
  );
}
