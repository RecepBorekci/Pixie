import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor/screens/api_test_screen.dart';
import 'package:photo_editor/screens/welcome_screen.dart';
import 'package:photo_editor/services/cut_out_pro_features.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_editor/widgets/edit_image_viewmodel.dart';

class PhotoEditingScreen extends StatefulWidget {
  final XFile image;
  const PhotoEditingScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<PhotoEditingScreen> createState() => _PhotoEditingScreenState();
}

class _PhotoEditingScreenState extends EditImageViewModel {
  CutOutProFeatures featuresHelper = CutOutProFeatures();

  // @override
  // void initState() {
  //   super.initState();
  //   getBackgroundRemover();
  // }

  String imageData = '';

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
          ), onPressed: () => saveToGallery(context),
          tooltip: 'Save Image',
        )
      ],
    ),

      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,

        child: Column(
          children: [

            SafeArea(
              child:
              SizedBox(
                height: MediaQuery.of(context).size.height*0.35,
                child: Stack(
                  children: [
                    Image.file(File(widget.image.path)),
                  ],
                ),
              ),
            ),


            // TODO: DO NOT uncomment lines below until these are added to the buttons. This is backgroundRemoval.
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
            // TODO: Do not uncomment this button. This is face cutout.
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
            // TODO: Do not uncomment this button. This is color correction.
            ElevatedButton(
              onPressed: () async {
                Uint8List bytes =
                    await featuresHelper.correctColor(widget.image.path);

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ApiTestScreen(
                    originalImage: Image.file(File(widget.image.path)),
                    testImage: Image.memory(
                      bytes,
                      fit: BoxFit.cover,
                    ),
                  );
                }));
              },
              child: Text('DO NOT Press Me!!! I am color correction.'),
            ),
            Container(
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.0),
                            margin: EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],








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

          ],
        ),
      ),


        ),
  );

  }



}
