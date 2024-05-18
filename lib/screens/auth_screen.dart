import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = false;
  String displayName = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Login Screen"),
        ),
        body: Center(
          child: getAuthForm(context),
        ));
  }

  Widget getAuthForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      width: 700,
      child: Column(
        children: [
          Text(
            isSignUp ? "Sign Up" : "Login",
            style: TextStyle(fontSize: 20),
          ),
          isSignUp
              ? TextField(
                  decoration: InputDecoration(hintText: "Display Name"),
                  onChanged: (value) => setState(() {
                    displayName = value;
                  }),
                )
              : Container(),
          TextField(
            decoration: InputDecoration(hintText: "Email"),
            onChanged: (value) => setState(() {
              email = value;
            }),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: "Password"),
            onChanged: (value) => setState(() {
              password = value;
            }),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                isSignUp ? createUser(context) : loginUser(context);
              },
              child: Text("Continue")),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  isSignUp = !isSignUp;
                });
              },
              child: Text(isSignUp ? "Login instead" : "Sign up instead"))
        ],
      ),
    );
  }

  void createUser(BuildContext context) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      goBackToHomeScreen(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void loginUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      goBackToHomeScreen(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.toString());
      }
    }
  }
}
