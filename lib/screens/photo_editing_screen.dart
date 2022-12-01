import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/screens/welcome_screen.dart';
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
      appBar: AppBar(
        title: Text('Editing Page'),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WelcomeScreen();
              }));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Image.file(File(widget.image.path)),
            const SizedBox(
              height: 150,
            ),
            const Text(
              'API Features Down Here',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.0),
                            margin: EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _addnewTextFab => FloatingActionButton(
        onPressed: () => addNewDialog(context),
        backgroundColor: Colors.white,
        tooltip: 'Add New Text',
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      );
}
