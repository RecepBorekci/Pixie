import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../services/cut_out_pro_features.dart';
import '../widgets/cartoon_selfie_elements.dart';
import '../widgets/list_view_elements.dart';
import 'package:path_provider/path_provider.dart';

class SpecialsScreen extends StatefulWidget {

  final File fileToAddFeature;

  SpecialsScreen({required this.fileToAddFeature});

  @override
  State<SpecialsScreen> createState() => _SpecialsScreenState();
}

class _SpecialsScreenState extends State<SpecialsScreen> {

  CutOutProFeatures featuresHelper = CutOutProFeatures();
  late String path;
  late File addFeatureFile;

  bool isLoading = false;

  @override
  void initState() {
    path = widget.fileToAddFeature.path;
    addFeatureFile = widget.fileToAddFeature;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cutout Pro'), actions: [
        IconButton(
          onPressed: () async {
            Navigator.pop(context, addFeatureFile);
          },
          icon: const Icon(Icons.check),
        ),
      ],),
      body: Column(
        children: [
          Spacer(),
          Image.file(addFeatureFile),
          Spacer(),
          SizedBox(
            height: 70.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ListViewElements(
                  icon: Icons.remove,
                  text: 'Remove BG',
                  onPressed: () async {
                    startLoading();

                    Uint8List bytes = await featuresHelper.removeBackground(path);

                    String newPath = await _createFileFromString(bytes);

                    loadingFinished();

                    setState(() {
                      addFeatureFile = File(newPath);
                    });
                  },
                ),
                ListViewElements(
                  icon: Icons.face_outlined,
                  text: 'Face Cutout',
                  onPressed: () async {
                    startLoading();

                    Uint8List bytes = await featuresHelper.cutoutFace(path);

                    String newPath = await _createFileFromString(bytes);

                    loadingFinished();

                    setState(() {
                      addFeatureFile = File(newPath);
                    });
                  },
                ),
                ListViewElements(
                  icon: Icons.color_lens_outlined,
                  text: 'Correct Color',
                  onPressed: () async {
                    startLoading();

                    Uint8List bytes = await featuresHelper.correctColor(path);

                    String newPath = await _createFileFromString(bytes);

                    loadingFinished();

                    setState(() {
                      addFeatureFile = File(newPath);
                    });
                  },
                ),
                ListViewElements(
                  icon: Icons.photo_camera_front_outlined,
                  text: 'Make Passport',
                  onPressed: () async {
                    startLoading();

                    Uint8List bytes = await featuresHelper.passportPhotoMethod(path);

                    String newPath = await _createFileFromString(bytes);

                    loadingFinished();

                    setState(() {
                      addFeatureFile = File(newPath);
                    });
                  },
                ),
                ListViewElements(
                  icon: Icons.image_outlined,
                  text: 'Image Retouch',
                  onPressed: () async {
                    startLoading();

                    Uint8List bytes = await featuresHelper.retouchImage(path);

                    String newPath = await _createFileFromString(bytes);

                    loadingFinished();

                    setState(() {
                      addFeatureFile = File(newPath);
                    });
                  },
                ),
                ListViewElements(
                  icon: Icons.perm_identity_outlined,
                  text: 'Cartoon Selfie',
                  onPressed: () async {
                    await createCartoonSelfieElements(context, featuresHelper, path);
                  },
                ),
                ListViewElements(
                  icon: Icons.enhance_photo_translate,
                  text: 'Enhance Photo',
                  onPressed: () async {
                    startLoading();

                    Uint8List bytes = await featuresHelper.photoEnhancerMethod(path);

                    String newPath = await _createFileFromString(bytes);

                    loadingFinished();

                    setState(() {
                      addFeatureFile = File(newPath);
                    });
                  },
                ),
                ListViewElements(
                  icon: Icons.color_lens_outlined,
                  text: 'Colorize Photo',
                  onPressed: () async {
                    startLoading();

                    Uint8List bytes = await featuresHelper.photoColorizerMethod(path);

                    String newPath = await _createFileFromString(bytes);

                    loadingFinished();

                    setState(() {
                      addFeatureFile = File(newPath);
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void loadingFinished() {
    setState(() {
      isLoading = false;
    });
  }

  Future<String> _createFileFromString(Uint8List bytes) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.png");
    await file.writeAsBytes(bytes);
    return file.path;
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
                    addFeatureFile = File(newPath);
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
