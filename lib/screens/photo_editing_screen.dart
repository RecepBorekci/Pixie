import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/screens/api_test_screen.dart';
import 'package:photo_editor/screens/welcome_screen.dart';
import 'package:photo_editor/services/cut_out_pro_features.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_editor/widgets/listviewElements.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_editor/widgets/edit_image_viewmodel.dart';
import 'package:photofilters/photofilters.dart';
import "../widgets/filter_elements.dart";
import 'dart:async';
import 'package:path/path.dart';
import 'package:image/image.dart' as imageLib;

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
  List<Filter> filters = presetFiltersList;
  Future getImage(context) async {
    fileName = basename(widget.imageFile.path);
    var image = imageLib.decodeImage(widget.imageFile.readAsBytesSync());
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
    XFile newImage = new XFile(imagefile['image_filtered'].toString());
    if (imagefile != null) {
      setState(() {
        widget.imageFile = imagefile['image_filtered'];
      });
      print(widget.imageFile.path);
    }
    setState(() {
      widget.ximage = XFile(widget.imageFile.path);
    });
  }

  CutOutProFeatures featuresHelper = CutOutProFeatures();

  // @override
  // void initState() {
  //   super.initState();
  //   getBackgroundRemover();
  // }

  String imageData = '';

  // Future cropImage(File imageFile) async {
  //   await ImageCropper.platform.cropImage(
  //     sourcePath: imageFile.path,
  //   );
  // }

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
            onPressed: () => saveToGallery(context),
            tooltip: 'Save Image',
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Screenshot(
        controller: screenshotController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Image.file(
                File(widget.ximage.path),
              ),
              fit: FlexFit.tight,
            ),
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
                    onPressed: () {
                      // await cropImage(File(widget.image.path));
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
                    onPressed: () {},
                  ),
                  ListviewElements(
                    icon: Icons.color_lens_outlined,
                    text: 'Color',
                    onPressed: () {},
                  ),
                  ListviewElements(
                    icon: Icons.star_border_purple500_outlined,
                    text: 'Special',
                    onPressed: () {
                      showModalBottomSheet(
                          barrierColor: Colors.white.withOpacity(0),
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(35))),
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
                                        Uint8List bytes = await featuresHelper
                                            .removeBackground(
                                                widget.ximage.path);

                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ApiTestScreen(
                                            originalImage: Image.file(
                                                File(widget.ximage.path)),
                                            testImage: Image.memory(
                                              bytes,
                                            ),
                                          );
                                        }));
                                      },
                                    ),
                                    ListviewElements(
                                      icon: Icons.face_outlined,
                                      text: 'Face Cutout',
                                      onPressed: () {
                                        ElevatedButton(
                                          onPressed: () async {
                                            Uint8List bytes =
                                                await featuresHelper.cutoutFace(
                                                    widget.ximage.path);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ApiTestScreen(
                                                originalImage: Image.file(
                                                    File(widget.ximage.path)),
                                                testImage: Image.memory(
                                                  bytes,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }));
                                          },
                                          child: Text(
                                              'DO NOT Press Me!!! I am face cutout'),
                                        );
                                      },
                                    ),
                                    ListviewElements(
                                      icon: Icons.color_lens_outlined,
                                      text: 'Correct Color',
                                      onPressed: () {
                                        ElevatedButton(
                                          onPressed: () async {
                                            Uint8List bytes =
                                                await featuresHelper
                                                    .correctColor(
                                                        widget.ximage.path);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ApiTestScreen(
                                                originalImage: Image.file(
                                                    File(widget.ximage.path)),
                                                testImage: Image.memory(
                                                  bytes,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }));
                                          },
                                          child: Text(
                                              'DO NOT Press Me!!! I am color correction.'),
                                        );
                                      },
                                    ),
                                    ListviewElements(
                                      icon: Icons.photo_camera_front_outlined,
                                      text: 'Make Passport',
                                      onPressed: () {
                                        ElevatedButton(
                                          onPressed: () async {
                                            Image passportImage =
                                                await featuresHelper
                                                    .passportPhotoMethod(
                                                        widget.ximage.path);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ApiTestScreen(
                                                originalImage: Image.file(
                                                    File(widget.ximage.path)),
                                                testImage: passportImage,
                                              );
                                            }));
                                          },
                                          child: Text(
                                              'DO NOT Press Me!!! I am passport photo maker.'),
                                        );
                                      },
                                    ),
                                    ListviewElements(
                                      icon: Icons.image_outlined,
                                      text: 'Image Retouch',
                                      onPressed: () {
                                        ElevatedButton(
                                          onPressed: () async {
                                            Image passportImage =
                                                await featuresHelper
                                                    .retouchImage(
                                                        widget.ximage.path);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ApiTestScreen(
                                                originalImage: Image.file(
                                                    File(widget.ximage.path)),
                                                testImage: passportImage,
                                              );
                                            }));
                                          },
                                          child: Text(
                                              'DO NOT Press Me!!! I am image retouch.'),
                                        );
                                      },
                                    ),
                                    ListviewElements(
                                      icon: Icons.perm_identity_outlined,
                                      text: 'Cartoon Selfie',
                                      onPressed: () {
                                        ElevatedButton(
                                          onPressed: () async {
                                            Uint8List bytes =
                                                await featuresHelper
                                                    .cartoonSelfieMethod(
                                                        widget.ximage.path);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ApiTestScreen(
                                                originalImage: Image.file(
                                                    File(widget.ximage.path)),
                                                testImage: Image.memory(
                                                  bytes,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }));
                                          },
                                          child: Text(
                                              'DO NOT Press Me!!! I am cartoon selfie. (2 Credits)'),
                                        );
                                      },
                                    ),
                                    ListviewElements(
                                      icon: Icons.perm_identity_outlined,
                                      text: 'Enhance Photo',
                                      onPressed: () {
                                        ElevatedButton(
                                          onPressed: () async {
                                            Uint8List bytes =
                                                await featuresHelper
                                                    .photoEnhancerMethod(
                                                        widget.ximage.path);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ApiTestScreen(
                                                originalImage: Image.file(
                                                    File(widget.ximage.path)),
                                                testImage: Image.memory(
                                                  bytes,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }));
                                          },
                                          child: Text(
                                              'DO NOT Press Me!!! I am photo enhancer. (2 Credits)'),
                                        );
                                      },
                                    ),
                                    ListviewElements(
                                      icon: Icons.perm_identity_outlined,
                                      text: 'Enhance Photo',
                                      onPressed: () {
                                        ElevatedButton(
                                          onPressed: () async {
                                            Uint8List bytes =
                                                await featuresHelper
                                                    .photoColorizerMethod(
                                                        widget.ximage.path);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ApiTestScreen(
                                                originalImage: Image.file(
                                                    File(widget.ximage.path)),
                                                testImage: Image.memory(
                                                  bytes,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }));
                                          },
                                          child: Text(
                                              'DO NOT Press Me!!! I am photo colorizer. (2 Credits)'),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ));
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
}

// TODO: NEVER EVER DELETE THE CODES BELOW!!! THEY ARE BUTTONS FOR USING CUTOUT PRO API.

// TODO: DO NOT uncomment lines below until these are added to the buttons. This is for backgroundRemoval.

// ElevatedButton(
//   onPressed: () async {
//     Uint8List bytes =
//         await featuresHelper.removeBackground(widget.image.path);
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ApiTestScreen(
//         originalImage: Image.file(File(widget.image.path)),
//         testImage: Image.memory(
//           bytes,
//           fit: BoxFit.cover,
//         ),
//       );
//     }));
//   },
//   child: Text('DO NOT Press Me!!! I am background remover'),
// ),

// TODO: Do not uncomment this button. This is for face cutout.
// ElevatedButton(
//   onPressed: () async {
//     Uint8List bytes =
//         await featuresHelper.cutoutFace(widget.image.path);
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ApiTestScreen(
//         originalImage: Image.file(File(widget.image.path)),
//         testImage: Image.memory(
//           bytes,
//           fit: BoxFit.cover,
//         ),
//       );
//     }));
//   },
//   child: Text('DO NOT Press Me!!! I am face cutout'),
// ),

// TODO: Do not uncomment this button. This is for color correction.
// ElevatedButton(
//   onPressed: () async {
//     Uint8List bytes =
//         await featuresHelper.correctColor(widget.image.path);
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ApiTestScreen(
//         originalImage: Image.file(File(widget.image.path)),
//         testImage: Image.memory(
//           bytes,
//           fit: BoxFit.cover,
//         ),
//       );
//     }));
//   },
//   child: Text('DO NOT Press Me!!! I am color correction.'),
// ),

// TODO: Do not uncomment this button. This is for passport photo.
// ElevatedButton(
//   onPressed: () async {
//     Image passportImage =
//         await featuresHelper.passportPhotoMethod(widget.image.path);
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ApiTestScreen(
//         originalImage: Image.file(File(widget.image.path)),
//         testImage: passportImage,
//       );
//     }));
//   },
//   child: Text('DO NOT Press Me!!! I am passport photo maker.'),
// )

// TODO: Do not uncomment this button. This is for image retouch.
// ElevatedButton(
//   onPressed: () async {
//     Image passportImage =
//         await featuresHelper.retouchImage(widget.image.path);
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ApiTestScreen(
//         originalImage: Image.file(File(widget.image.path)),
//         testImage: passportImage,
//       );
//     }));
//   },
//   child: Text('DO NOT Press Me!!! I am image retouch.'),
// ),

// TODO: Do not uncomment this button. This is for cartoon selfie. (2 CREDITS)
// ElevatedButton(
//   onPressed: () async {
//     Uint8List bytes =
//         await featuresHelper.cartoonSelfieMethod(widget.image.path);
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ApiTestScreen(
//         originalImage: Image.file(File(widget.image.path)),
//         testImage: Image.memory(
//           bytes,
//           fit: BoxFit.cover,
//         ),
//       );
//     }));
//   },
//   child:
//       Text('DO NOT Press Me!!! I am cartoon selfie. (2 Credits)'),
// ),

// TODO: Do not uncomment this button. This is for photo enhancer. (2 CREDITS)
// ElevatedButton(
//   onPressed: () async {
//     Uint8List bytes =
//         await featuresHelper.photoEnhancerMethod(widget.image.path);
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ApiTestScreen(
//         originalImage: Image.file(File(widget.image.path)),
//         testImage: Image.memory(
//           bytes,
//           fit: BoxFit.cover,
//         ),
//       );
//     }));
//   },
//   child:
//       Text('DO NOT Press Me!!! I am photo enhancer. (2 Credits)'),
// ),

// TODO: Do not uncomment this button. This is for photo colorizer. (2 CREDITS)
// ElevatedButton(
//   onPressed: () async {
//     Uint8List bytes = await featuresHelper
//         .photoColorizerMethod(widget.image.path);
//
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ApiTestScreen(
//         originalImage: Image.file(File(widget.image.path)),
//         testImage: Image.memory(
//           bytes,
//           fit: BoxFit.cover,
//         ),
//       );
//     }));
//   },
//   child:
//       Text('DO NOT Press Me!!! I am photo colorizer. (2 Credits)'),
// ),

// SizedBox(
//   height: 150,
//   child: ListView.builder(
//     scrollDirection: Axis.horizontal,
//     itemBuilder: (context,index){
//       return Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(20.0),
//             margin: EdgeInsets.only(left:30),
//             decoration: BoxDecoration(
//               color: Colors.deepOrangeAccent,
//               borderRadius: BorderRadius.circular(15),
//             ),
//           )
//         ],
//       );
//     }),
// ),

//         )],
//         ),
//       ),
//
//
//         ),
//   );
//
//   }
//
//
//
// }
