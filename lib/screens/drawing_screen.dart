import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:painter/painter.dart';
import 'package:photo_editor/models/palette.dart';
import 'package:photo_editor/screens/color_picker.dart';
import 'package:screenshot/screenshot.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen(this.image);

  final Image image;

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  late Image drawImage;
  ColorPicker colorPicker = ColorPicker(300);
  GlobalKey _globalKey = new GlobalKey();
  ScreenshotController _screenshotController = ScreenshotController();

  PainterController _controller = _newController();

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  @override
  void initState() {
    super.initState();
    drawImage = widget.image;
  }

  Future<Image> convertToWidget(ui.Image uiimage) async {
    final pngBytes = await uiimage.toByteData(format: ui.ImageByteFormat.png);

    return Image.memory(Uint8List.view(pngBytes!.buffer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draw"),
        actions: [
          IconButton(
            onPressed: () {
              if (_controller.isEmpty) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                        new Text('Nothing to undo'));
              } else {
                _controller.undo();
              }
            },
            icon: Icon(Icons.undo),
          ),
          IconButton(
              icon: new Icon(Icons.delete),
              tooltip: 'Clear',
              onPressed: _controller.clear),
          IconButton(
              icon: new Icon(Icons.check),
              onPressed: () async {
                final imageBytes = await _screenshotController.capture();
                Navigator.pop(context, imageBytes);
              }),
        ],
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: Stack(
          alignment: Alignment.center,
          children: [
            drawImage,
            LayoutBuilder(
              builder: (_, constraints) {
                return Column(
                  children: [
                    Screenshot(
                      controller: _screenshotController,
                      child: SizedBox(
                        height: constraints.maxHeight - 140,
                        width: constraints.maxWidth - 140,
                        child: Painter(_controller),
                      ),
                    ),
                    Container(color: Palette.purpleLight, child: colorPicker),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class Painter extends CustomPainter {
//   Painter({
//     required this.drawImage,
//   });
//
//   ui.Image drawImage;
//
//   List<Offset> points = [];
//
//   final Paint painter = new Paint()
//     ..color = Colors.blue[400]!
//     ..style = PaintingStyle.fill;
//
//   @override
//   void update(Offset offset) {
//     points.add(offset);
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawImage(drawImage, Offset(0.0, 0.0), Paint());
//     for (Offset offset in points) {
//       canvas.drawCircle(offset, 10, painter);
//     }
//   }
//
//   @override
//   bool shouldRepaint(Painter oldDelegate) => false;
// }
