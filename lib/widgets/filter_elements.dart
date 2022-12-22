import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofilters/photofilters.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:image/image.dart' as imageLib;

class FilterElements extends StatefulWidget {
  // final Filter filter;
  final XFile image;
  const FilterElements({required this.image});

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
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Photo Filter Example"),
          image: imagee!,
          filters: presetFiltersList,
          filename: fileName!,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
      print(imageFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Photo Filter Example'),
      ),
      body: Center(
        child: new Container(
          child: imageFile == null
              ? Center(
                  child: new Text('No image selected.'),
                )
              : Image.file(imageFile),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => getImage(context),
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  void onTap() {
    print("hello");
  }

  /*@override
  Widget build(BuildContext context) {
    Image normalImage = Image.file(
      File(widget.image.path),
    );
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.black54, width: 5),
      ),
      child: InkWell(
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: */ /*Image.file(
              File(image.path),
              fit: BoxFit.cover,
            ),*/ /*
                  PhotoFilterSelector(
                image: normalImage,
              )),
        ),
      ),
    );
  }*/
}
