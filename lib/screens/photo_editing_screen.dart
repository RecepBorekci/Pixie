// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/screens/add_text_screen.dart';
import 'package:photo_editor/screens/color_picker.dart';
import 'package:photo_editor/screens/drawing_screen.dart';
import 'package:photo_editor/screens/welcome_screen.dart';
import 'package:photo_editor/services/cut_out_pro_features.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor/widgets/listviewElements.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_editor/widgets/edit_image_viewmodel.dart';
import 'package:photofilters/photofilters.dart';
import '../widgets/cartoon_selfie_elements.dart';
import "../widgets/filter_elements.dart";
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_editor/models/palette.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:painter/painter.dart';

import '../widgets/image_text.dart';
import 'finish_screen.dart';

class PhotoEditingScreen extends StatefulWidget {
  XFile ximage;
  File imageFile;
  PhotoEditingScreen({Key? key, required this.ximage, required this.imageFile})
      : super(key: key);

  @override
  State<PhotoEditingScreen> createState() => _PhotoEditingScreenState();
}

bool isFilterSelected = false;

class _PhotoEditingScreenState extends EditImageViewModel {
  late String fileName;
  late int cartoonSelfieType;
  late File editedImageFile;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  late String imageURL;

  ScreenshotController _ssController = ScreenshotController();

  PainterController _controller = _newController();

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.green;
    return controller;
  }

  List<Filter> filters = presetFiltersList;
  Future getImage(context) async {
    fileName = basename(widget.imageFile.path);
    var image = imageLib.decodeImage(editedImageFile.readAsBytesSync());
    image = imageLib.copyResize(image!, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Select Filter"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null) {
      setState(() {
        widget.imageFile = imagefile['image_filtered'];
      });
      print(widget.imageFile.path);
    }
    setState(() {
      editedImageFile = File(widget.imageFile.path);
    });
  }

  Future<CroppedFile?> cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
          sourcePath: imageFile.path,
          aspectRatioPresets: const [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          compressFormat: ImageCompressFormat.png,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              lockAspectRatio: false,
              statusBarColor: Palette.purpleLight.shade400,
              toolbarColor: Palette.purpleLight.shade600,
              toolbarWidgetColor: Colors.white,
              backgroundColor: Palette.appBackground,
              cropFrameColor: Palette.purpleLight.shade900,
              cropGridColor: Colors.white,
              activeControlsWidgetColor: Palette.purpleLight,
              cropFrameStrokeWidth: 10,
            )
          ]);

      return croppedFile;
    } catch (e) {
      print(e);
    }
  }

  CutOutProFeatures featuresHelper = CutOutProFeatures();

  String imageData = '';

  @override
  void initState() {
    super.initState();

    editedImageFile = File(widget.ximage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editing Page'),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WelcomeScreen();
              }));
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () async {
              await GallerySaver.saveImage(editedImageFile.path);
              final _ref = _storage
                  .ref()
                  .child("user_images")
                  .child(DateTime.now().toString() + "jpg");
              await _ref.putFile(editedImageFile);
              imageURL = await _ref.getDownloadURL();
              _firestore.collection("edited_photos").add({
                "id": _auth.currentUser!.uid,
                "email": _auth.currentUser!.email,
                "username": _auth.currentUser!.displayName,
                "photoURL": imageURL,
                "createdAt": FieldValue.serverTimestamp(),
              });
              final snackBar = SnackBar(
                content: Text('Image Saved'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.black38,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return FinishScreen(Image.file(editedImageFile));
              }));
            },
            tooltip: 'Save Image',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Screenshot(
        controller: _ssController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(fit: FlexFit.tight, child: Container()),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              color: Colors.orange,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // ListviewElements(
                  //   icon: Icons.remove,
                  //   text: 'Background Remove',
                  //   onPressed: () async {
                  //     Uint8List bytes = await featuresHelper
                  //         .removeBackground(widget.image.path);
                  //
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) {
                  //       return ApiTestScreen(
                  //         originalImage: Image.file(File(widget.image.path)),
                  //         testImage: Image.memory(
                  //           bytes,
                  //         ),
                  //       );
                  //     }));
                  //   },
                  // ),
                  ListviewElements(
                    icon: Icons.crop,
                    text: 'Crop',
                    onPressed: () async {
                      try {
                        CroppedFile? croppedImage =
                            await cropImage(editedImageFile);

                        setState(() {
                          editedImageFile = File(croppedImage!.path);
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  ListviewElements(
                    icon: Icons.filter,
                    text: 'Filter',
                    onPressed: () {
                      getImage(context);
                    },
                  ),
                  ListviewElements(
                    icon: Icons.text_fields_outlined,
                    text: 'Text',
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              AddTextScreen(fileToAddText: editedImageFile),
                        ),
                      );

                      // setState(() {
                      //   editedImageFile = editedImageFile;
                      // });
                      // await createTextElements(context, editedImageFile.path);
                    },
                  ),
                  ListviewElements(
                    icon: Icons.color_lens_outlined,
                    text: 'Color',
                    onPressed: () async {
                      Uint8List drawnImageBytes;
                      drawnImageBytes = await Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return DrawingScreen(Image.file(editedImageFile));
                      }));
                      String newPath =
                          await _createFileFromString(drawnImageBytes);
                      setState(() {
                        editedImageFile = File(newPath);
                      });

                      // showModalBottomSheet(
                      //     context: context,
                      //     builder: (context) {
                      //       // return ColorPicker(300);
                      //       return SizedBox(
                      //         height: 70,
                      //         child: ListView(
                      //           children: [
                      //             ListviewElements(
                      //                 icon: Icons.brush,
                      //                 text: 'Draw',
                      //                 onPressed: () {}),
                      //             ListviewElements(
                      //                 icon: Icons.brush,
                      //                 text: 'Draw',
                      //                 onPressed: () {}),
                      //           ],
                      //         ),
                      //       );
                      //     });
                    },
                  ),
                  ListviewElements(
                    icon: Icons.star_border_purple500_outlined,
                    text: 'Special',
                    onPressed: () async {
                      await createSpecialsElements(
                          context, featuresHelper, editedImageFile.path);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _createFileFromString(Uint8List bytes) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    return file.path;
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

  createSpecialsElements(
      BuildContext context, CutOutProFeatures helper, String path) async {
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
                    icon: Icons.remove,
                    text: 'Remove BG',
                    onPressed: () async {
                      Uint8List bytes = await helper.removeBackground(path);

                      String newPath = await _createFileFromString(bytes);

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListviewElements(
                    icon: Icons.face_outlined,
                    text: 'Face Cutout',
                    onPressed: () async {
                      Uint8List bytes = await helper.cutoutFace(path);

                      String newPath = await _createFileFromString(bytes);

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListviewElements(
                    icon: Icons.color_lens_outlined,
                    text: 'Correct Color',
                    onPressed: () async {
                      Uint8List bytes = await helper.correctColor(path);

                      String newPath = await _createFileFromString(bytes);

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListviewElements(
                    icon: Icons.photo_camera_front_outlined,
                    text: 'Make Passport',
                    onPressed: () async {
                      Uint8List bytes = await helper.passportPhotoMethod(path);

                      String newPath = await _createFileFromString(bytes);

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListviewElements(
                    icon: Icons.image_outlined,
                    text: 'Image Retouch',
                    onPressed: () async {
                      Uint8List bytes = await helper.retouchImage(path);

                      String newPath = await _createFileFromString(bytes);

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListviewElements(
                    icon: Icons.perm_identity_outlined,
                    text: 'Cartoon Selfie',
                    onPressed: () async {
                      await createCartoonSelfieElements(context, helper, path);
                    },
                  ),
                  ListviewElements(
                    icon: Icons.perm_identity_outlined,
                    text: 'Enhance Photo',
                    onPressed: () async {
                      Uint8List bytes = await helper.photoEnhancerMethod(path);

                      String newPath = await _createFileFromString(bytes);

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListviewElements(
                    icon: Icons.perm_identity_outlined,
                    text: 'Colorize Photo',
                    onPressed: () async {
                      Uint8List bytes = await helper.photoColorizerMethod(path);

                      String newPath = await _createFileFromString(bytes);

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                ],
              ),
            ));
  }

  createCartoonSelfieElements(
      BuildContext context, CutOutProFeatures helper, String path) async {
    showModalBottomSheet(
      barrierColor: Colors.white.withOpacity(0),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(),
      context: context,
      builder: (context) => SizedBox(
        height: 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CartoonSelfieElements(
                buttonName: '0',
                buttonImage: Image.asset('assets/images/image0.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 0);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '1',
                buttonImage: Image.asset('assets/images/image1.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 1);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '2',
                buttonImage: Image.asset('assets/images/image2.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 2);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '3',
                buttonImage: Image.asset('assets/images/image3.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 3);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '4',
                buttonImage: Image.asset('assets/images/image4.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 4);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '5',
                buttonImage: Image.asset('assets/images/image5.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 5);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '6',
                buttonImage: Image.asset('assets/images/image6.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 6);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '7',
                buttonImage: Image.asset('assets/images/image7.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 7);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '8',
                buttonImage: Image.asset('assets/images/image8.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 8);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '9',
                buttonImage: Image.asset('assets/images/image9.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 9);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '10',
                buttonImage: Image.asset('assets/images/image10.jpg'),
                onPressed: () async {
                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 10);

                  String newPath = await _createFileFromString(bytes);

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
          ],
        ),
      ),
    );
  }
}

// background removal (1 Credits)

// face cutout (1 Credits)

// color correction (1 Credits)

// passport photo (1 Credits)

// image retouch. (1 Credits)

// cartoon selfie (2 CREDITS)

// photo enhancer (2 CREDITS)

// photo colorizer (2 CREDITS)
