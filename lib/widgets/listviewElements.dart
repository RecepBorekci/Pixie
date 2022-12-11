import 'package:flutter/material.dart';

class ListviewElements extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  const ListviewElements(
      {Key? key,
      required this.icon,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: Colors.yellow,
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
            ),
            Text(
              text,
            ),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
