import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor/models/text_info.dart';
import 'package:screenshot/screenshot.dart';
import 'package:photo_editor/widgets/image_text.dart';

import '../models/palette.dart';
import '../utils/utils.dart';
import '../widgets/default_button.dart';
import '../widgets/listviewElements.dart';

class AddTextScreen extends StatefulWidget {
  final File fileToAddText;

  AddTextScreen({required this.fileToAddText});

  @override
  State<AddTextScreen> createState() => _AddTextScreenState();
}

class _AddTextScreenState extends State<AddTextScreen> {
  TextEditingController textEditingController = TextEditingController();

  TextEditingController creatorText = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  int currentIndex = 0;

  List<TextInfo> texts = [];

  addNewText(BuildContext context) {
    setState(() {
      texts.add(TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left));
    });
    Navigator.of(context).pop();
  }

  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
  }

  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Image Deleted',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black38,
      ),
    );
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts[currentIndex].text.contains('\n')) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('\n', ' ');
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Text('Add New Text'),
          content: TextField(
            controller: textEditingController,
            maxLines: 5,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.edit),
              filled: true,
              hintText: 'Your Text Here.',
            ),
          ),
          actions: <Widget>[
            DefaultButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back'),
              color: Palette.purpleLight,
              textColor: Colors.black,
            ),
            DefaultButton(
                onPressed: () {
                  addNewText(context);
                },
                child: const Text('Add Text'),
                color: Palette.purpleLight,
                textColor: Colors.black),
          ]),
    );
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  saveToGallery(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) {
      saveImage(image!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image Saved To Gallery!'),
        ),
      );
    }).catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    File newFileToWrite = widget.fileToAddText;

    return Flexible(
      fit: FlexFit.tight,
      child: Stack(
        children: [
          Image.file(newFileToWrite),
          for (int i = 0; i < texts.length; i++)
            Positioned(
              left: texts[i].left,
              top: texts[i].top,
              child: GestureDetector(
                onLongPress: () {
                  setState(() {
                    currentIndex = i;
                    removeText(context);
                  });
                },
                onTap: () async {
                  setCurrentIndex(context, i);
                  await createTextElements(context, newFileToWrite.path);
                },
                //onTap: () => setCurrentIndex(context, i),
                child: Draggable(
                  feedback: ImageText(textInfo: texts[i]),
                  child: ImageText(textInfo: texts[i]),
                  onDragEnd: (drag) {
                    final renderBox = context.findRenderObject() as RenderBox;
                    Offset off = renderBox.globalToLocal(drag.offset);
                    setState(() {
                      texts[i].top = off.dy - 88;
                      texts[i].left = off.dx;
                    });
                  },
                ),
              ),
            ),
          creatorText.text.isNotEmpty
              ? Positioned(
                  left: 0,
                  bottom: 0,
                  child: Text(
                    creatorText.text,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(
                          0.3,
                        )),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  createTextElements(BuildContext context, String path) async {
    showModalBottomSheet(
        barrierColor: Colors.white.withOpacity(0),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
        context: context,
        builder: (context) => SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ListviewElements(
                    icon: Icons.text_fields_outlined,
                    text: 'Add Text',
                    onPressed: () async {
                      addNewDialog(context);
                    },
                  ),
                  ListviewElements(
                    icon: Icons.add,
                    text: 'Font Size',
                    onPressed: () async {
                      increaseFontSize();
                    },
                  ),
                  ListviewElements(
                    icon: Icons.remove,
                    text: 'Font Size',
                    onPressed: () async {
                      decreaseFontSize();
                    },
                  ),
                  ListviewElements(
                    icon: Icons.format_align_left,
                    text: 'Align Left',
                    onPressed: () async {
                      alignLeft();
                    },
                  ),
                  ListviewElements(
                    icon: Icons.format_align_center,
                    text: 'Align Center',
                    onPressed: () async {
                      alignCenter();
                    },
                  ),
                  ListviewElements(
                    icon: Icons.format_align_right,
                    text: 'Align Right',
                    onPressed: () async {
                      alignRight();
                    },
                  ),
                  ListviewElements(
                    icon: Icons.format_bold,
                    text: 'Bold',
                    onPressed: () async {
                      boldText();
                    },
                  ),
                  ListviewElements(
                    icon: Icons.format_italic,
                    text: 'Italic',
                    onPressed: () async {
                      italicText();
                    },
                  ),
                  ListviewElements(
                    icon: Icons.space_bar,
                    text: 'Add New Line',
                    onPressed: () async {
                      addLinesToText();
                    },
                  ),
                  Tooltip(
                    message: 'Red',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.purpleLight,
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 80,
                      height: 50,
                      child: GestureDetector(
                          onTap: () => changeTextColor(Colors.red),
                          child: const CircleAvatar(
                            backgroundColor: Colors.red,
                          )),
                    ),
                  ),
                  Tooltip(
                    message: 'White',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.purpleLight,
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 80,
                      height: 50,
                      child: GestureDetector(
                          onTap: () => changeTextColor(Colors.white),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                          )),
                    ),
                  ),
                  Tooltip(
                    message: 'Black',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.purpleLight,
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 80,
                      height: 50,
                      child: GestureDetector(
                          onTap: () => changeTextColor(Colors.black),
                          child: const CircleAvatar(
                            backgroundColor: Colors.black,
                          )),
                    ),
                  ),
                  Tooltip(
                    message: 'Blue',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.purpleLight,
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 80,
                      height: 50,
                      child: GestureDetector(
                          onTap: () => changeTextColor(Colors.blue),
                          child: const CircleAvatar(
                            backgroundColor: Colors.blue,
                          )),
                    ),
                  ),
                  Tooltip(
                    message: 'Yellow',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.purpleLight,
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 80,
                      height: 50,
                      child: GestureDetector(
                          onTap: () => changeTextColor(Colors.yellow),
                          child: const CircleAvatar(
                            backgroundColor: Colors.yellow,
                          )),
                    ),
                  ),
                  Tooltip(
                    message: 'Green',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.purpleLight,
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 80,
                      height: 50,
                      child: GestureDetector(
                          onTap: () => changeTextColor(Colors.green),
                          child: const CircleAvatar(
                            backgroundColor: Colors.green,
                          )),
                    ),
                  ),
                  Tooltip(
                    message: 'Orange',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.purpleLight,
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 80,
                      height: 50,
                      child: GestureDetector(
                          onTap: () => changeTextColor(Colors.orange),
                          child: const CircleAvatar(
                            backgroundColor: Colors.orange,
                          )),
                    ),
                  ),
                  Tooltip(
                    message: 'Pink',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.purpleLight,
                        border: Border.all(),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      width: 80,
                      height: 50,
                      child: GestureDetector(
                          onTap: () => changeTextColor(Colors.pink),
                          child: const CircleAvatar(
                            backgroundColor: Colors.pink,
                          )),
                    ),
                  ),
                ],
              ),
            ));
  }
}
