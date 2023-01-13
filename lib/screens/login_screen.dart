import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_editor/screens/registration_screen.dart';
import 'package:photo_editor/screens/welcome_screen.dart';

import '../models/palette.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailOrUsernameController = TextEditingController();
  final passwordController = TextEditingController();

  final tagForAnimation = 'logo in the opening';

  final _auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Utils.phoneHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Hero(
                    tag: tagForAnimation,
                    child: Image.asset(
                      'assets/logos/logo_on_the_login.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                const Text(
                  "Welcome to Pixie!",
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                const Text(
                  "Let your imagination talk!",
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontSize: 20.0,
                  ),
                ),
                TextField(
                  controller: emailOrUsernameController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    hintText: 'Enter your e-mail.',
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2.5,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2.5,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        isLoading = true;
                      });

                      final user = await _auth.signInWithEmailAndPassword(
                        email: emailOrUsernameController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (user != null) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const WelcomeScreen();
                        }));
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('Log in'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not a member yet?",
                      style: TextStyle(
                        fontFamily: "Proxima Nova",
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()));
                      },
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          fontFamily: "Proxima Nova",
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Center(
                child: CircularProgressIndicator(
                  color: Palette.purpleLight.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
