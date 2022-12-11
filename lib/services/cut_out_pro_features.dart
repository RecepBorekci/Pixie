import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

const cutOutProUrl = 'https://www.cutout.pro/api/v1/';
const backgroundRemoval = 'matting?mattingType=6';
const faceCutout = 'matting?mattingType=3';
const apiKey = '2327f560a4be4ce7a439dd770bab6128';

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

    // Networking networkHelper = Networking(url);

    // var removerData = await networkHelper.getData();
    //
    // return removerData;
  }

  Future<dynamic> cutoutFace(String path) async {
    try {
      Uint8List rawImageBytes = (await uploadImage(path, faceCutout)).bodyBytes;

      return rawImageBytes;
    } catch (e) {
      return Future.error(e);
    }
  }
}
