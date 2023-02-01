// ignore_for_file: use_build_context_synchronously, unnecessary_new

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/screens/add_text_screen.dart';
import 'package:photo_editor/screens/drawing_screen.dart';
import 'package:photo_editor/screens/welcome_screen.dart';
import 'package:photo_editor/services/cut_out_pro_features.dart';
import 'dart:io';
import 'package:photo_editor/widgets/list_view_elements.dart';
import 'package:screenshot/screenshot.dart';
import 'package:photo_editor/widgets/edit_image_viewmodel.dart';
import 'package:photofilters/photofilters.dart';
import '../widgets/cartoon_selfie_elements.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:async';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as imageLib;
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_editor/models/palette.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'finish_screen.dart';

// ignore: must_be_immutable
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

  bool isLoading = false;

  List<Filter> filters = presetFiltersList;
  Future<void> getImage(context) async {
    fileName = basename(widget.imageFile.path);
    var image = imageLib.decodeImage(editedImageFile.readAsBytesSync());
    image = imageLib.copyResize(image!, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          appBarColor: Palette.purpleLight.shade900,
          title: const Text("Select Filter"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName,
          loader: const Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null) {
      setState(() {
        widget.imageFile = imagefile['image_filtered'];
      });
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
              statusBarColor: Colors.transparent,
              toolbarColor: Palette.purpleLight.shade900,
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
    return null;
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
        title: const Text('Editing Page'),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const WelcomeScreen();
              }));
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () async {
              try {
                final ref = _storage
                                  .ref()
                                  .child("user_images")
                                  .child("${DateTime.now()}jpg");
                await ref.putFile(editedImageFile);
                imageURL = await ref.getDownloadURL();
                _firestore.collection("edited_photos").add({
                                "id": _auth.currentUser!.uid,
                                "email": _auth.currentUser!.email,
                                "username": _auth.currentUser!.displayName,
                                "photoURL": imageURL,
                                "createdAt": FieldValue.serverTimestamp(),
                              });
              } catch (e) {
                print(e);
              } finally {
                await GallerySaver.saveImage(editedImageFile.path);
              }
              const snackBar = SnackBar(
                content: Text('Image Saved to Gallery'),
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
      body: isLoading
          ? Container(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(editedImageFile),
                  Center(
                    child: CircularProgressIndicator(
                      color: Palette.purpleLight.shade900,
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  )
                ],
              ),
            )
          : Screenshot(
              controller: screenshotController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Image.file(editedImageFile),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    color: Colors.orange,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        ListViewElements(
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
                        ListViewElements(
                          icon: Icons.filter,
                          text: 'Filter',
                          onPressed: () async {
                            await getImage(context);
                          },
                        ),
                        ListViewElements(
                          icon: Icons.text_fields_outlined,
                          text: 'Text',
                          onPressed: () async {
                            Uint8List writtenImageBytes =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddTextScreen(
                                    fileToAddText: editedImageFile),
                              ),
                            );

                            startLoading();

                            String newPath =
                                await _createFileFromString(writtenImageBytes);

                            loadingFinished();

                            setState(() {
                              editedImageFile = File(newPath);
                            });
                          },
                        ),
                        ListViewElements(
                          icon: Icons.color_lens_outlined,
                          text: 'Color',
                          onPressed: () async {
                            Uint8List drawnImageBytes;

                            ui.Image imageInfo = await _getImageInfo();

                            drawnImageBytes = await Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DrawingScreen(Image.file(editedImageFile),
                                  imageInfo.height, imageInfo.width);
                            }));

                            startLoading();

                            String newPath =
                                await _createFileFromString(drawnImageBytes);

                            loadingFinished();

                            setState(() {
                              editedImageFile = File(newPath);
                            });
                          },
                        ),
                        ListViewElements(
                          icon: Icons.star_border_purple500_outlined,
                          text: 'Cutout Pro',
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

  void loadingFinished() {
    setState(() {
      isLoading = false;
    });
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  Future<String> _createFileFromString(Uint8List bytes) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.png");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<ui.Image> _getImageInfo() async {
    Completer<ui.Image> completer = Completer<ui.Image>();

    Image editedImage = Image.file(editedImageFile);

    editedImage.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo image, bool _) {
      completer.complete(image.image);
    }));
    ui.Image info = await completer.future;

    return info;
  }

  createSpecialsElements(
      BuildContext context, CutOutProFeatures helper, String path) async {
    showModalBottomSheet(
        barrierColor: Colors.white.withOpacity(0),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(35))),
        context: context,
        builder: (context) => SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ListViewElements(
                    icon: Icons.remove,
                    text: 'Remove BG',
                    onPressed: () async {
                      startLoading();

                      Uint8List bytes = await helper.removeBackground(path);

                      String newPath = await _createFileFromString(bytes);

                      loadingFinished();

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListViewElements(
                    icon: Icons.face_outlined,
                    text: 'Face Cutout',
                    onPressed: () async {
                      startLoading();

                      Uint8List bytes = await helper.cutoutFace(path);

                      String newPath = await _createFileFromString(bytes);

                      loadingFinished();

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListViewElements(
                    icon: Icons.color_lens_outlined,
                    text: 'Correct Color',
                    onPressed: () async {
                      startLoading();

                      Uint8List bytes = await helper.correctColor(path);

                      String newPath = await _createFileFromString(bytes);

                      loadingFinished();

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListViewElements(
                    icon: Icons.photo_camera_front_outlined,
                    text: 'Make Passport',
                    onPressed: () async {
                      startLoading();

                      Uint8List bytes = await helper.passportPhotoMethod(path);

                      String newPath = await _createFileFromString(bytes);

                      loadingFinished();

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListViewElements(
                    icon: Icons.image_outlined,
                    text: 'Image Retouch',
                    onPressed: () async {
                      startLoading();

                      Uint8List bytes = await helper.retouchImage(path);

                      String newPath = await _createFileFromString(bytes);

                      loadingFinished();

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListViewElements(
                    icon: Icons.perm_identity_outlined,
                    text: 'Cartoon Selfie',
                    onPressed: () async {
                      await createCartoonSelfieElements(context, helper, path);
                    },
                  ),
                  ListViewElements(
                    icon: Icons.enhance_photo_translate,
                    text: 'Enhance Photo',
                    onPressed: () async {
                      startLoading();

                      Uint8List bytes = await helper.photoEnhancerMethod(path);

                      String newPath = await _createFileFromString(bytes);

                      loadingFinished();

                      setState(() {
                        editedImageFile = File(newPath);
                      });
                    },
                  ),
                  ListViewElements(
                    icon: Icons.color_lens_outlined,
                    text: 'Colorize Photo',
                    onPressed: () async {
                      startLoading();

                      Uint8List bytes = await helper.photoColorizerMethod(path);

                      String newPath = await _createFileFromString(bytes);

                      loadingFinished();

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
      shape: const RoundedRectangleBorder(),
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
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 0);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '1',
                buttonImage: Image.asset('assets/images/image1.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 1);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '2',
                buttonImage: Image.asset('assets/images/image2.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 2);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '3',
                buttonImage: Image.asset('assets/images/image3.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 3);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '4',
                buttonImage: Image.asset('assets/images/image4.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 4);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '5',
                buttonImage: Image.asset('assets/images/image5.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 5);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '6',
                buttonImage: Image.asset('assets/images/image6.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 6);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '7',
                buttonImage: Image.asset('assets/images/image7.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 7);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '8',
                buttonImage: Image.asset('assets/images/image8.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 8);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '9',
                buttonImage: Image.asset('assets/images/image9.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 9);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

                  setState(() {
                    editedImageFile = File(newPath);
                  });
                }),
            CartoonSelfieElements(
                buttonName: '10',
                buttonImage: Image.asset('assets/images/image10.jpg'),
                onPressed: () async {
                  startLoading();

                  Uint8List bytes = await helper.cartoonSelfieMethod(path, 10);

                  String newPath = await _createFileFromString(bytes);

                  loadingFinished();

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
