import 'package:flutter/material.dart';


class PhotoEditingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editing Page'),
          centerTitle: true,
        ),
        body: GestureDetector(

          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Selected photos come here"
                  "crop widget eklenecek"
                  "contrast widget etc etc"), Icon(Icons.edit)],
            ),
          ),
        ),
      ),
    );
  }
  }
