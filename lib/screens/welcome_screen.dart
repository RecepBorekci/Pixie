import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/palette.dart';
import '../screens/photo_editing_screen.dart';
import '../widgets/home_buttons.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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

  final List<Icon> recentImages = [Icon(Icons.add)];

  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;
      setState(() => this.image = imageTemporary);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PhotoEditingScreen(
          image: image,
        );
      }));
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Palette.appBackgroundDark,
                gradient: LinearGradient(
                    colors: [Palette.appBackgroundDark, Palette.appBackground]),
              ),
              child: Text(
                'Pixie',
                style: TextStyle(
                    fontFamily: "Courgette",
                    fontSize: 40,
                    color: Palette.darkTextColor,
                    fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border(
                      bottom: new BorderSide(),
                      left: new BorderSide(),
                      right: new BorderSide(),
                      top: new BorderSide(),
                    )),
                child: ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Palette.darkTextColor,
                  ),
                  title: Text(
                    "Language",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border(
                      bottom: new BorderSide(),
                      left: new BorderSide(),
                      right: new BorderSide(),
                      top: new BorderSide(),
                    )),
                child: ListTile(
                  onTap: () {
                    _auth.signOut();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  leading: Icon(
                    Icons.logout_outlined,
                    color: Palette.darkTextColor,
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            Center(
                child: Text(
              "Version: 0.5.0-alpha",
              style: TextStyle(color: Colors.grey),
            )),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Palette.appBackground,
        foregroundColor: Palette.darkTextColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Palette.appBackground,
        ),
        elevation: 0,
      ),
      backgroundColor: Palette.appBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pixie",
                style: TextStyle(
                    fontFamily: "Courgette",
                    fontSize: 40,
                    color: Palette.darkTextColor,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeButton(
                    onPressed: pickImage,
                    source: ImageSource.gallery,
                    icon: Icons.photo,
                    text: "Gallery",
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink,
                  ),
                  HomeButton(
                    onPressed: pickImage,
                    source: ImageSource.camera,
                    icon: Icons.photo_camera,
                    text: "Camera",
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.cyan,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
