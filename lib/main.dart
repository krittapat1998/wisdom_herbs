import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wisdom_herbs/contact/firebase_options.dart';
import 'package:wisdom_herbs/screen/my_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseOptions,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(
        title: 'Wisdom of Herbs',
        style: TextStyle(
          fontSize: 24, // Increase font size for better visibility
          fontWeight: FontWeight.bold,
          color: Colors.white, // Set the color to white
        ),
      ),
    );
  }
}
