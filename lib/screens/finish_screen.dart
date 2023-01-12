import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:photo_editor/screens/welcome_screen.dart';

import 'package:screenshot/screenshot.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen(this.finishedImage);
  final Image finishedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: new Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: Navigator.of(context).pop),
            MaterialButton(
              onPressed: () {},
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: finishedImage,
                  ),
                  Container(
                    color: Colors.grey.shade800.withOpacity(0.2),
                    child: Icon(
                      color: Colors.grey,
                      Icons.search_outlined,
                      size: 150,
                    ),
                  )
                ],
              ),
            ),

            IconButton(
              icon: new Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WelcomeScreen();
                }));
              },
            ),
            //  Navigator.of(context).popUntil((route) => route.isFirst);
          ],
        ),
      ),
    );
  }
}
