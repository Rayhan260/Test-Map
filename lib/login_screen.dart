import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_exam/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (_) => const LoginScreen());
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

    final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();




    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Please sign in', style: TextStyle(fontSize: 35.0)),
                const SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                   keyboardType: TextInputType.emailAddress,
                  
                  decoration:
                      const InputDecoration(hintText: 'Type your email here'),
                  onTap: (value) {
                        _usernameController.text = value!;
                  },
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Type your password',
                  ),
                  onTap: (value) {
                    _passwordController.text = value!;
                  },
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(child: const Text('Sign in'), onPressed: () {
                   logIn(_usernameController.text, _passwordController.text)
                }),
              ],
            ),
          ),
        ),
      );
    }

    void logIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (FirebaseAuth.instance.currentUser?.uid ==
                  "RtBlDF29exaGf5mdI2Z20g76zoX2") {
                return LoginScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}

  

