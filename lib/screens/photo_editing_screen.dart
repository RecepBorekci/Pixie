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

import '../widgets/cartoon_selfie_elements.dart';

class PhotoEditingScreen extends StatefulWidget {
  final XFile image;
  const PhotoEditingScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<PhotoEditingScreen> createState() => _PhotoEditingScreenState();
}

class _PhotoEditingScreenState extends EditImageViewModel {
  // Variable for choosing cartoon selfie type;
  late int cartoonSelfieType;
  late CutOutProFeatures featuresHelper;
  void onPressedFilter() {
    print("object");
  }

  @override
  void initState() {
    super.initState();
    featuresHelper = CutOutProFeatures();
  }

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
                File(widget.image.path),
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
                    onPressed: onPressedFilter,
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
                    onPressed: () async {
                      await createSpecialsElements(
                          context, featuresHelper, widget.image.path);
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

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ApiTestScreen(
                          originalImage: Image.file(File(path)),
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
                          Uint8List bytes = await helper.cutoutFace(path);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ApiTestScreen(
                              originalImage: Image.file(File(path)),
                              testImage: Image.memory(
                                bytes,
                                fit: BoxFit.cover,
                              ),
                            );
                          }));
                        },
                        child: Text('DO NOT Press Me!!! I am face cutout'),
                      );
                    },
                  ),
                  ListviewElements(
                    icon: Icons.color_lens_outlined,
                    text: 'Correct Color',
                    onPressed: () {
                      ElevatedButton(
                        onPressed: () async {
                          Uint8List bytes = await helper.correctColor(path);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ApiTestScreen(
                              originalImage: Image.file(File(path)),
                              testImage: Image.memory(
                                bytes,
                                fit: BoxFit.cover,
                              ),
                            );
                          }));
                        },
                        child:
                            Text('DO NOT Press Me!!! I am color correction.'),
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
                              await helper.passportPhotoMethod(path);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ApiTestScreen(
                              originalImage: Image.file(File(path)),
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
                          Image passportImage = await helper.retouchImage(path);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ApiTestScreen(
                              originalImage: Image.file(File(path)),
                              testImage: passportImage,
                            );
                          }));
                        },
                        child: Text('DO NOT Press Me!!! I am image retouch.'),
                      );
                    },
                  ),
                  ListviewElements(
                    icon: Icons.perm_identity_outlined,
                    text: 'Cartoon Selfie',
                    onPressed: () {
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
                                  buttonImage:
                                      Image.asset('assets/images/image0.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 0);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '1',
                                  buttonImage:
                                      Image.asset('assets/images/image1.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 1);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '2',
                                  buttonImage:
                                      Image.asset('assets/images/image2.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 2);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '3',
                                  buttonImage:
                                      Image.asset('assets/images/image3.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 3);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '4',
                                  buttonImage:
                                      Image.asset('assets/images/image4.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 4);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '5',
                                  buttonImage:
                                      Image.asset('assets/images/image5.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 5);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '6',
                                  buttonImage:
                                      Image.asset('assets/images/image6.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 6);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '7',
                                  buttonImage:
                                      Image.asset('assets/images/image7.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 7);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '8',
                                  buttonImage:
                                      Image.asset('assets/images/image8.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 8);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '9',
                                  buttonImage:
                                      Image.asset('assets/images/image9.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 9);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                              CartoonSelfieElements(
                                  buttonName: '10',
                                  buttonImage:
                                      Image.asset('assets/images/image10.jpg'),
                                  onPressed: () async {
                                    Uint8List bytes = await helper
                                        .cartoonSelfieMethod(path, 10);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ApiTestScreen(
                                        originalImage: Image.file(File(path)),
                                        testImage: Image.memory(
                                          bytes,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }));
                                  }),
                            ],
                          ),
                        ),
                      );
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     Uint8List bytes = await helper.cartoonSelfieMethod(
                      //         path, cartoonSelfieType);
                      //
                      //     Navigator.push(context,
                      //         MaterialPageRoute(builder: (context) {
                      //       return ApiTestScreen(
                      //         originalImage: Image.file(File(path)),
                      //         testImage: Image.memory(
                      //           bytes,
                      //           fit: BoxFit.cover,
                      //         ),
                      //       );
                      //     }));
                      //   },
                      //   child: Text(
                      //       'DO NOT Press Me!!! I am cartoon selfie. (2 Credits)'),
                      // );
                    },
                  ),
                  ListviewElements(
                    icon: Icons.perm_identity_outlined,
                    text: 'Enhance Photo',
                    onPressed: () {
                      ElevatedButton(
                        onPressed: () async {
                          Uint8List bytes =
                              await helper.photoEnhancerMethod(path);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ApiTestScreen(
                              originalImage: Image.file(File(path)),
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
                    text: 'Colorize Photo',
                    onPressed: () {
                      ElevatedButton(
                        onPressed: () async {
                          Uint8List bytes =
                              await helper.photoColorizerMethod(path);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ApiTestScreen(
                              originalImage: Image.file(File(path)),
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
