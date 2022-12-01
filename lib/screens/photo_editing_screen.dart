import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class PhotoEditingScreen extends StatefulWidget {
  final File? image;
  const PhotoEditingScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<PhotoEditingScreen> createState() => _PhotoEditingScreenState();
}

class _PhotoEditingScreenState extends State<PhotoEditingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(widget.image!),
    );
  }
}
