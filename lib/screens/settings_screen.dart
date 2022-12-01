import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_editor/screens/completely_unnecessary_opening_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = FirebaseAuth.instance;

  late User loggedInUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(onPressed: () {}, child: Text('Language')),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _auth.signOut();
                    // Log out button doesn't work yet. Don't press it.
                    Navigator.popUntil(
                        context, ModalRoute.withName('/welcome'));
                  },
                  child: Text('Log Out'),
                ),
                Text(
                  'Version',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('0.2.0-alpha')
              ],
            )
          ],
        ),
      ),
    );
  }
}
