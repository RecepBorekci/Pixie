import 'package:flutter/material.dart';

class CartoonSelfieElements extends StatefulWidget {
  final VoidCallback onPressed;
  final Image buttonImage;
  final String buttonName;

  CartoonSelfieElements(
      {required this.buttonName,
      required this.buttonImage,
      required this.onPressed});

  @override
  State<CartoonSelfieElements> createState() => _CartoonSelfieElementsState();
}

class _CartoonSelfieElementsState extends State<CartoonSelfieElements> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
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
      style: ButtonStyle(),
    );
  }
}
