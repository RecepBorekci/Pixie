import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:photo_editor/utils/secrets.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

const cutOutProUrl = 'https://www.cutout.pro/api/v1/';
const backgroundRemoval = 'matting?mattingType=6';
const faceCutout = 'matting?mattingType=3';
const colorCorrection = 'matting?mattingType=4';
const passportPhoto = 'idphoto/printLayout';
const imageRetouch = 'imageFix';
const photoEnhancer = 'matting?mattingType=18';
const photoColorizer = 'matting?mattingType=19';

const cartoonSelfie = 'cartoonSelfie?cartoonType=';

// Class for using CutOutPro API. This class will have the methods for the features in this API.
class CutOutProFeatures {
  Future<http.Response> uploadImage(path, featureURL) async {
    http.MultipartRequest imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse('$cutOutProUrl$featureURL'));

    imageUploadRequest.headers.addAll({
      'APIKEY': apiKey,
    });

    final file = await http.MultipartFile.fromPath(
      'file',
      path,
    );

    imageUploadRequest.files.add(file);

    try {
      var streamedResponse = await imageUploadRequest.send();
      var response = http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> uploadImagePassportPhoto(path) async {
    final bytes = await io.File(path).readAsBytes();

    String img64 = base64Encode(bytes);

    final body = jsonEncode({
      'base64': img64,
      'bgColor': 'FFFFFF',
      'dpi': 300,
      'mmHeight': 40,
      'mmWidth': 20,
      'printBgColor': 'FFFFFF',
      'printMmHeigh': 210,
      'printMmWidth': 150
    });

    http.Response response =
        await http.post(Uri.parse('$cutOutProUrl$passportPhoto'),
            headers: {
              'APIKEY': apiKey,
              'Content-Type': 'application/json',
            },
            body: body);

    return response;
  }

  Future<http.Response> uploadImageForImageRetouch(path) async {
    final bytes = await io.File(path).readAsBytes();

    String img64 = base64Encode(bytes);

    final body = jsonEncode({
      'base64': img64,
      'rectangles': [
        {
          "height": 200,
          "width": 200,
          "x": 160,
          "y": 280,
        },
        {"height": 200, "width": 200, "x": 560, "y": 680},
      ]
    });

    http.Response response =
        await http.post(Uri.parse('$cutOutProUrl$imageRetouch'),
            headers: {
              'APIKEY': apiKey,
              'Content-Type': 'application/json',
            },
            body: body);

    return response;
  }

  Future<dynamic> removeBackground(String path) async {
    try {
      // POST METHOD FOR APIs.
      // http.Response response = await http.post(
      //   Uri.parse(cutOutProUrl),
      //   headers: {
      //     'APIKEY': apiKey,
      //   },
      // );
      //
      // final responseJSON = response.body;
      // print(responseJSON);

      // ATTEMPT TO GET IMAGE FROM THE API.
      // dynamic imageJSON;
      // imageJSON = jsonDecode((await uploadImage(path)).body);

      // Use 'bodyBytes' instead of 'body'!!!!! It solved the problem.
      Uint8List rawImageBytes =
          (await uploadImage(path, backgroundRemoval)).bodyBytes;

      return rawImageBytes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> cutoutFace(String path) async {
    try {
      Uint8List rawImageBytes = (await uploadImage(path, faceCutout)).bodyBytes;

      return rawImageBytes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> correctColor(String path) async {
    try {
      Uint8List rawImageBytes =
          (await uploadImage(path, colorCorrection)).bodyBytes;

      return rawImageBytes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Uint8List> passportPhotoMethod(String path) async {
    try {
      String data = (await uploadImagePassportPhoto(path)).body;

      String imageURL = jsonDecode(data)['data']['idPhotoImage'];

      http.Response response = await http.get(Uri.parse(imageURL));

      return response.bodyBytes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Uint8List> retouchImage(String path) async {
    try {
      String data = (await uploadImageForImageRetouch(path)).body;

      String imageURL = jsonDecode(data)['data']['imageUrl'];

      http.Response response = await http.get(Uri.parse(imageURL));

      return response.bodyBytes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> cartoonSelfieMethod(
      String path, int cartoonSelfieType) async {
    try {
      String cartoonSelfieUri = "$cartoonSelfie${cartoonSelfieType.toString()}";

      Uint8List rawImageBytes =
          (await uploadImage(path, cartoonSelfieUri)).bodyBytes;

      return rawImageBytes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> photoEnhancerMethod(String path) async {
    try {
      Uint8List rawImageBytes =
          (await uploadImage(path, photoEnhancer)).bodyBytes;

      return rawImageBytes;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> photoColorizerMethod(String path) async {
    try {
      Uint8List rawImageBytes =
          (await uploadImage(path, photoColorizer)).bodyBytes;

      return rawImageBytes;
    } catch (e) {
      return Future.error(e);
    }
  }
}
