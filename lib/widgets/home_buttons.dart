import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeButton extends StatelessWidget {
  Function onPressed;
  IconData icon;
  String text;
  Color foregroundColor, backgroundColor;
  ImageSource? source;
  HomeButton({
    required this.onPressed,
    this.source,
    required this.icon,
    required this.text,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: source == null ? () => onPressed() : () => onPressed(source),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
      child: MediaQuery.of(context).orientation == Orientation.portrait
          ? Container(
              height: MediaQuery.of(context).size.width * 0.30,
              width: MediaQuery.of(context).size.width * 0.32,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    icon,
                    size: MediaQuery.of(context).size.width * 0.14,
                  ),
                  Text(
                    "$text",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.photo,
                    size: 50,
                  ),
                  Text(
                    "$text",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
