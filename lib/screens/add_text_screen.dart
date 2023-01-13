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
import '../widgets/list_view_elements.dart';

class AddTextScreen extends StatefulWidget {
  final File fileToAddText;

  const AddTextScreen({super.key, required this.fileToAddText});

  @override
  State<AddTextScreen> createState() => _AddTextScreenState();
}

class _AddTextScreenState extends State<AddTextScreen> {
  TextEditingController textEditingController = TextEditingController();

  TextEditingController creatorText = TextEditingController();
  final ScreenshotController _ssController = ScreenshotController();
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
          'Text Deleted',
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
              color: Palette.purpleLight,
              textColor: Colors.black,
              child: const Text('Back'),
            ),
            DefaultButton(
                onPressed: () {
                  addNewText(context);
                },
                color: Palette.purpleLight,
                textColor: Colors.black,
                child: const Text('Add Text')),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    File newFileToWrite = widget.fileToAddText;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Text",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final imageBytes = await _ssController.capture();

              // ignore: use_build_context_synchronously
              Navigator.pop(context, imageBytes);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Screenshot(
            controller: _ssController,
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
                      onTap: () {
                        setCurrentIndex(context, i);
                      },
                      //onTap: () => setCurrentIndex(context, i),
                      child: Draggable(
                        feedback: ImageText(textInfo: texts[i]),
                        child: ImageText(textInfo: texts[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(() {
                            texts[i].top = off.dy - Utils.phoneHeight * 0.25;
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
          ),
          const Spacer(),
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ListViewElements(
                  icon: Icons.text_fields_outlined,
                  text: 'Add Text',
                  onPressed: () async {
                    addNewDialog(context);
                  },
                ),
                ListViewElements(
                  icon: Icons.add,
                  text: 'Font Size',
                  onPressed: () async {
                    increaseFontSize();
                  },
                ),
                ListViewElements(
                  icon: Icons.remove,
                  text: 'Font Size',
                  onPressed: () async {
                    decreaseFontSize();
                  },
                ),
                ListViewElements(
                  icon: Icons.format_align_left,
                  text: 'Align Left',
                  onPressed: () async {
                    alignLeft();
                  },
                ),
                ListViewElements(
                  icon: Icons.format_align_center,
                  text: 'Align Center',
                  onPressed: () async {
                    alignCenter();
                  },
                ),
                ListViewElements(
                  icon: Icons.format_align_right,
                  text: 'Align Right',
                  onPressed: () async {
                    alignRight();
                  },
                ),
                ListViewElements(
                  icon: Icons.format_bold,
                  text: 'Bold',
                  onPressed: () async {
                    boldText();
                  },
                ),
                ListViewElements(
                  icon: Icons.format_italic,
                  text: 'Italic',
                  onPressed: () async {
                    italicText();
                  },
                ),
                ListViewElements(
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
          )
        ],
      ),
    );
  }
}
