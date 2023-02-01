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
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? loggedInUser;

  bool isLoading = false;

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

  final List<Icon> recentImages = [const Icon(Icons.add)];

  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      this.image = imageTemporary;
      setState(() => this.image = imageTemporary);
      // ignore: use_build_context_synchronously
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                      right: BorderSide(),
                      top: BorderSide(),
                    )),
                child: ListTile(
                  leading: const Icon(
                    Icons.language,
                    color: Palette.darkTextColor,
                  ),
                  title: const Text(
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
                    border: const Border(
                      bottom: BorderSide(),
                      left: BorderSide(),
                      right: BorderSide(),
                      top: BorderSide(),
                    )),
                child: isLoading
                    ? CircularProgressIndicator()
                    : ListTile(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          await _auth.signOut();

                          setState(() {
                            isLoading = false;
                          });

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        leading: const Icon(
                          Icons.logout_outlined,
                          color: Palette.darkTextColor,
                        ),
                        title: const Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
              ),
            ),
            const Center(
                child: Text(
              "Version: 1.5.8-beta",
              style: TextStyle(color: Colors.grey),
            )),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Palette.appBackground,
        foregroundColor: Palette.darkTextColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
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
              const Text(
                "Pixie",
                style: TextStyle(
                    fontFamily: "Courgette",
                    fontSize: 40,
                    color: Palette.darkTextColor,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(
                "Welcome ${loggedInUser?.displayName ?? "No username"}",
                style: const TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                padding: const EdgeInsets.all(15),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    const Text(
                      "Recent",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: "Courgette",
                        fontSize: 25.0,
                        color: Palette.darkTextColor,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('edited_photos')
                            .orderBy("createdAt", descending: true)
                            .where('id', isEqualTo: loggedInUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final photos = snapshot.data!.docs;
                          List<Widget> imageWidgets = [];

                          for (var photo in photos) {
                            final photoURL = photo.get('photoURL');
                            final createdAtTimestamp = photo.get('createdAt');

                            DateTime createdAtDate = createdAtTimestamp == null
                                ? DateTime.now()
                                : createdAtTimestamp.toDate();

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
                            height: 280,
                            child: ListView(
                                itemExtent: 125.0,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
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
