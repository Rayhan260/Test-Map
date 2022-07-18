import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:map_exam/edit_screen.dart';
import 'package:map_exam/home_screen.dart';
import 'package:map_exam/login_screen.dart';

// import 'login_screen.dart';

// import 'edit_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAP Exam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const LoginScreen(),
      //home: const HomeScreen(),
      home: const EditScreen(),
    );
  }
}

class NoteApp extends StatelessWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            }),
      );
}
