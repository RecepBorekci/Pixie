import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:math';

import 'list_view_elements.dart';

class AdjustImage extends StatefulWidget {
  File editedImageFile;
  File imageFile;
  Image image;
  AdjustImage(
      {required this.editedImageFile,
      required this.imageFile,
      required this.image});

  @override
  State<AdjustImage> createState() => _AdjustImageState();
}

class _AdjustImageState extends State<AdjustImage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      decodeImage();
    });
    super.initState();
  }

  Future decodeImage() async {
    decodedImage =
        await decodeImageFromList(widget.imageFile.readAsBytesSync());
    imgImage = img.Image(decodedImage.width, decodedImage.height);
  }

  Future getImage(img.Image data) async {
    var image = img.decodeImage(widget.editedImageFile.readAsBytesSync());
    data = image!;
    return image;
  }

  late var decodedImage;
  late File newEditedImageFile;
  var contrastSliderValue = 20.0;
  bool newEditedImageFileCheck = false;
  img.Image imgImage = new img.Image(100, 100);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        ListViewElements(
            icon: Icons.contrast,
            text: 'Contrast',
            onPressed: () {
              showModalBottomSheet(
                  barrierColor: Colors.white.withOpacity(0),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setSheetState) {
                      return SizedBox(
                        height: 71,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.contrast),
                              Expanded(
                                child: Slider(
                                    max: 100,
                                    value: contrastSliderValue,
                                    onChanged: (double value) {
                                      setSheetState(() {
                                        contrastSliderValue = value;
                                        ImageFilter(
                                            brightness: contrastSliderValue,
                                            hue: 0.8,
                                            saturation: 0.3,
                                            child: Container(
                                                decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(
                                                    widget.editedImageFile),
                                              ),
                                            )));
                                        widget.image =
                                            Image.file(widget.editedImageFile);
                                      });
                                      setState(() {
                                        widget.image =
                                            Image.file(widget.editedImageFile);
                                      });
                                    }),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                icon: Icon(Icons.done),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  });
            })
      ]),
    );
  }
}

Widget ImageFilter({brightness, saturation, hue, child}) {
  return ColorFiltered(
      colorFilter:
          ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
        value: brightness,
      )),
      child: ColorFiltered(
          colorFilter:
              ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
            value: saturation,
          )),
          child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
              value: hue,
            )),
            child: child,
          )));
}

class ColorFilterGenerator {
  static List<double> hueAdjustMatrix({required double value}) {
    value = value * pi;

    if (value == 0)
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];

    double cosVal = cos(value);
    double sinVal = sin(value);
    double lumR = 0.213;
    double lumG = 0.715;
    double lumB = 0.072;

    return List<double>.from(<double>[
      (lumR + (cosVal * (1 - lumR))) + (sinVal * (-lumR)),
      (lumG + (cosVal * (-lumG))) + (sinVal * (-lumG)),
      (lumB + (cosVal * (-lumB))) + (sinVal * (1 - lumB)),
      0,
      0,
      (lumR + (cosVal * (-lumR))) + (sinVal * 0.143),
      (lumG + (cosVal * (1 - lumG))) + (sinVal * 0.14),
      (lumB + (cosVal * (-lumB))) + (sinVal * (-0.283)),
      0,
      0,
      (lumR + (cosVal * (-lumR))) + (sinVal * (-(1 - lumR))),
      (lumG + (cosVal * (-lumG))) + (sinVal * lumG),
      (lumB + (cosVal * (1 - lumB))) + (sinVal * lumB),
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]).map((i) => i.toDouble()).toList();
  }

  static List<double> brightnessAdjustMatrix({required double value}) {
    if (value <= 0)
      value = value * 255;
    else
      value = value * 100;

    if (value == 0)
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];

    return List<double>.from(<double>[
      1,
      0,
      0,
      0,
      value,
      0,
      1,
      0,
      0,
      value,
      0,
      0,
      1,
      0,
      value,
      0,
      0,
      0,
      1,
      0
    ]).map((i) => i.toDouble()).toList();
  }

  static List<double> saturationAdjustMatrix({required double value}) {
    value = value * 100;

    if (value == 0)
      return [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];

    double x =
        ((1 + ((value > 0) ? ((3 * value) / 100) : (value / 100)))).toDouble();
    double lumR = 0.3086;
    double lumG = 0.6094;
    double lumB = 0.082;

    return List<double>.from(<double>[
      (lumR * (1 - x)) + x,
      lumG * (1 - x),
      lumB * (1 - x),
      0,
      0,
      lumR * (1 - x),
      (lumG * (1 - x)) + x,
      lumB * (1 - x),
      0,
      0,
      lumR * (1 - x),
      lumG * (1 - x),
      (lumB * (1 - x)) + x,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]).map((i) => i.toDouble()).toList();
  }
}
