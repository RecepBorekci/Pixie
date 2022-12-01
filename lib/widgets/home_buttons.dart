import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  Function onPressed;
  IconData icon;
  String text;
  Color foregroundColor, backgroundColor;
  HomeButton({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
      child: MediaQuery.of(context).orientation == Orientation.portrait
          ? Container(
              height: MediaQuery.of(context).size.width * 0.27,
              width: MediaQuery.of(context).size.width * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    icon,
                    size: 50,
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