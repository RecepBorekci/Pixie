import 'package:flutter/material.dart';

class ApiTestScreen extends StatefulWidget {
  Image originalImage;
  Image testImage;

  ApiTestScreen({required this.originalImage, required this.testImage});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: widget.testImage,
        ),
      ),
    );
  }
}
