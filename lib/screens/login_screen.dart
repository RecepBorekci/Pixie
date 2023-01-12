import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_editor/screens/registration_screen.dart';
import 'package:photo_editor/screens/welcome_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: tagForAnimation,
              child: Flexible(
                  child: Image.asset(
                'assets/logos/logo_on_the_login.png',
                height: 200,
                width: 200,
              )),
            ),
            Text(
              "Welcome to Pixie!",
              style: TextStyle(
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Text(
              "Talk your imagination!",
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
              decoration: InputDecoration(
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
              decoration: InputDecoration(
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
                  final user = await _auth.signInWithEmailAndPassword(
                    email: emailOrUsernameController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  if (user != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return WelcomeScreen();
                    }));
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Log in'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
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
                        builder: (context) => RegistrationScreen()));
                  },
                  child: Text(
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
      ),
    );
  }
}
