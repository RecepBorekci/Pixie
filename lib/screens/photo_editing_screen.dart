import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class PhotoEditingScreen extends StatefulWidget {
  const PhotoEditingScreen({Key? key, required this.image}) : super(key: key);
  final File? image;
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
