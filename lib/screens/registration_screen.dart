import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:photo_editor/screens/welcome_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final tagForAnimation = 'logo in the opening';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Hero(
                tag: tagForAnimation,
                child: Image.asset(
                  'assets/logos/logo_on_the_login.png',
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            const Text(
              'Register',
              style: TextStyle(
                fontFamily: "Proxima Nova",
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            TextField(
              controller: usernameController,
              autocorrect: true,
              textAlign: TextAlign.left,
              decoration: const InputDecoration(
                hintText: 'Enter your username.',
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
              controller: emailController,
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
                  final result = await _auth.createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  if (result != null) {
                    print('success');
                    User? user = result.user;
                    await user!.updateDisplayName(usernameController.text);
                    // ignore: use_build_context_synchronously
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const WelcomeScreen();
                    }));
                  }
                } catch (e) {
                  print('error');
                }
              },
              child: const Text('Register'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontFamily: "Proxima Nova",
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Log in",
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
