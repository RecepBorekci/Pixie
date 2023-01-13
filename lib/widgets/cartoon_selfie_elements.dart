import 'package:flutter/material.dart';

import '../models/palette.dart';

class CartoonSelfieElements extends StatefulWidget {
  final VoidCallback onPressed;
  final Image buttonImage;
  final String buttonName;

  const CartoonSelfieElements(
      {super.key,
      required this.buttonName,
      required this.buttonImage,
      required this.onPressed});

  @override
  State<CartoonSelfieElements> createState() => _CartoonSelfieElementsState();
}

class _CartoonSelfieElementsState extends State<CartoonSelfieElements> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.purpleLight,
        border: Border.all(),
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: const ButtonStyle(),
        child: Column(
          children: [
            CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: widget.buttonImage,
              ),
            ),
            Text(widget.buttonName),
          ],
        ),
      ),
    );
  }
}
