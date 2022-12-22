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
    return Card(
      child: InkWell(
        splashColor: Colors.red,
        child: Material(
          child: GestureDetector(
            child: Container(
              color: Colors.cyan,
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
          ),
        ),
      ),
    );
  }
}
