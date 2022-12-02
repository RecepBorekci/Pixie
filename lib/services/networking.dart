import 'package:http/http.dart';
import 'dart:convert';

// This class holds the getData() method. It will be used to make API calls using custom urls.
class Networking {
  final Uri url;

  Networking(this.url);

  Future<dynamic> getData() async {
    Response response = await get(url);

    if (response.statusCode == 200) {
      String data = response.body;

      var decodedData = jsonDecode(data);

      return decodedData;
    } else {
      print(response.statusCode);
    }
  }
}
