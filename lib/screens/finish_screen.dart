// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:photo_editor/screens/welcome_screen.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen(this.finishedImage, {super.key});
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
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: Navigator.of(context).pop),
            MaterialButton(
              onPressed: () {},
              child: Stack(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: finishedImage,
                  ),
                  Container(
                    color: Colors.grey.shade800.withOpacity(0.2),
                    child: const Icon(
                      color: Colors.grey,
                      Icons.search_outlined,
                      size: 150,
                    ),
                  )
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WelcomeScreen();
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
