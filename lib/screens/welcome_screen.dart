import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final _firestore = FirebaseFirestore.instance;
  bool isThereEditedPhotos = false;

  List<String>? _photosURLs;

  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    if (loggedInUser != null) {
      getUserPhotosURL(loggedInUser!.uid);
    } else {
      print("no user :(");
    }
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

  Future<void> getUserPhotosURL(String userID) async {
    await for (var snapshot
        in _firestore.collection("edited_photos").snapshots()) {
      for (var document in snapshot.docs) {
        if (document.get("id") == userID) {
          document.get("photoURL");
          isThereEditedPhotos = true;
        }
      }
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
          ximage: image,
          imageFile: File(image.path),
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
            Text(
              "Welcome ${loggedInUser?.displayName ?? "No username"}",
              style: TextStyle(fontSize: 30),
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
              "Version: 0.2.0-beta",
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
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
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
                    Text(
                      "Recent",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: "Courgette",
                        fontSize: 20,
                        color: Palette.darkTextColor,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream:
                            _firestore.collection('edited_photos').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final photos = snapshot.data!.docs;
                          List<Widget> imageWidgets = [];

                          for (var photo in photos) {
                            final photoURL = photo.get('photoURL');
                            final createdAtTimestamp =
                                photo.get('createdAt') as Timestamp;

                            DateTime createdAtDate =
                                createdAtTimestamp.toDate();

                            final imageWidget = ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    photoURL,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  Text(createdAtDate.toString())
                                ],
                              ),
                            );

                            imageWidgets.add(imageWidget);
                          }

                          return SizedBox(
                            height: 370,
                            child: ListView(
                                itemExtent: 125.0,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20.0),
                                children: imageWidgets),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
