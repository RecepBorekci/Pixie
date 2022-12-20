import 'dart:io';

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
        child: ListView(
          children: [widget.originalImage, widget.testImage],
        ),
      ),
    );
  }
}
