import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Language')),
            Column(
              children: [
                Text(
                  'Version',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('0.1')
              ],
            )
          ],
        ),
      ),
    );
  }
}
