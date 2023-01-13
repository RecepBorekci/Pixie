import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:painter/painter.dart';
import 'package:photo_editor/models/palette.dart';
import 'package:photo_editor/screens/color_picker.dart';
import 'package:screenshot/screenshot.dart';

import 'package:photo_editor/utils/chosen_color.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen(this.image, this.imageHeight, this.imageWidth,
      {super.key});

  final Image image;
  final int imageHeight;
  final int imageWidth;

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  late Image drawImage;
  ColorPicker colorPicker = const ColorPicker(300);
  final ScreenshotController _screenshotController = ScreenshotController();

  ui.Image? imageInfo;
  late double aspectRatio;

  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    controller.drawColor = Colors.black;
    return controller;
  }

  @override
  void initState() {
    super.initState();
    drawImage = widget.image;
    aspectRatio = widget.imageWidth / widget.imageHeight;
    ChosenColor.painterController = _newController();
  }

  Future<Image> convertToWidget(ui.Image uiimage) async {
    final pngBytes = await uiimage.toByteData(format: ui.ImageByteFormat.png);

    return Image.memory(Uint8List.view(pngBytes!.buffer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draw"),
        actions: [
          IconButton(
            onPressed: () {
              if (ChosenColor.painterController.isEmpty) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                        const Text('Nothing to undo'));
              } else {
                ChosenColor.painterController.undo();
              }
            },
            icon: const Icon(Icons.undo),
          ),
          IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Clear',
              onPressed: ChosenColor.painterController.clear),
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                final imageBytes = await _screenshotController.capture();
                // ignore: use_build_context_synchronously
                Navigator.pop(context, imageBytes);
              }),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Screenshot(
            controller: _screenshotController,
            child: ImageDrawing(
              drawImage: drawImage,
              controller: ChosenColor.painterController,
              colorPicker: colorPicker,
              aspectRatio: aspectRatio,
            ),
          ),
          const Spacer(),
          Container(color: Palette.purpleLight, child: colorPicker),
        ],
      ),
    );
  }
}

class ImageDrawing extends StatelessWidget {
  const ImageDrawing({
    Key? key,
    required this.drawImage,
    required PainterController controller,
    required this.colorPicker,
    required this.aspectRatio,
  })  : _controller = controller,
        super(key: key);

  final Image drawImage;
  final PainterController _controller;
  final ColorPicker colorPicker;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            drawImage,
            AspectRatio(aspectRatio: aspectRatio, child: Painter(_controller)),
          ],
        ),
      ],
    );
  }
}
