import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = '2327f560a4be4ce7a439dd770bab6128';

const cutOutProUrl = 'https://www.cutout.pro/api/v1/';
const backgroundRemoval = 'matting?mattingType=6';
const faceCutout = 'matting?mattingType=3';
const colorCorrection = 'matting?mattingType=4';
const passportPhoto = 'idphoto/printLayout';
const imageRetouch = 'imageFix';

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
    final bytes = await Io.File(path).readAsBytes();

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
    final bytes = await Io.File(path).readAsBytes();

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

  Future<Image> passportPhotoMethod(String path) async {
    try {
      String data = (await uploadImagePassportPhoto(path)).body;

      print(data);

      String imageURL = jsonDecode(data)['data']['idPhotoImage'];

      print(imageURL);

      Image image = Image.network(imageURL);

      return image;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Image> retouchImage(String path) async {
    try {
      String data = (await uploadImageForImageRetouch(path)).body;

      print(data);

      String imageURL = jsonDecode(data)['data']['imageUrl'];

      print(imageURL);

      Image image = Image.network(imageURL);

      return image;
    } catch (e) {
      return Future.error(e);
    }
  }
}
