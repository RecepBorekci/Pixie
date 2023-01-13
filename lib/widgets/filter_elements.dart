import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as imageLib;

class FilterElements extends StatefulWidget {
  // final Filter filter;
  final XFile image;
  const FilterElements({super.key, required this.image});

  @override
  State<FilterElements> createState() => _FilterElementsState();
}

class _FilterElementsState extends State<FilterElements> {
  String? fileName;
  List<Filter> filters = presetFiltersList;
  late File imageFile;

  void getImage(context) async {
    var imagee =
        imageLib.decodeImage(File(widget.image.path).readAsBytesSync());
    imagee = imageLib.copyResize(imagee!, width: 600);
    Map imagefile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          title: const Text("Photo Filter Example"),
          image: imagee!,
          filters: presetFiltersList,
          filename: fileName!,
          loader: const Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Filter Example'),
      ),
      body: Center(
        child: Container(
          child: imageFile == null
              ? const Center(
                  child: Text('No image selected.'),
                )
              : Image.file(imageFile),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImage(context),
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
