import 'package:http/http.dart';
import 'networking.dart';
import 'package:flutter/material.dart';

const cutOutProUrl = 'https://www.cutout.pro/api/v1/matting?mattingType=6';
const apiKey = '2327f560a4be4ce7a439dd770bab6128';

// Class for using CutOutPro API. This class will have the methods for the features in this API.
class CutOutProFeatures {
  Future<dynamic> removeBackground(Image image) async {
    Uri url = Uri.parse(
        '$cutOutProUrl?APIKEY=$apiKey&file=/temporary_image/flower.jpeg');

    Networking networkHelper = Networking(url);

    var removerData = await networkHelper.getData();

    return removerData;
  }
}
