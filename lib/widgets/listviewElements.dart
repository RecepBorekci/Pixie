import 'package:flutter/material.dart';
import 'package:photo_editor/models/palette.dart';

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
        decoration: BoxDecoration(
          color: Palette.purpleLight,
          border: Border.all(),
        ),
        padding: const EdgeInsets.all(0.0),
        width: 100,
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
            SizedBox(
              height: 3,
              width: 3,
            )
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
