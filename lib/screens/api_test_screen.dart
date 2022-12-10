import 'package:flutter/material.dart';

class ApiTestScreen extends StatefulWidget {
  Image testImage;

  ApiTestScreen(this.testImage);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.testImage,
    );
  }
}
