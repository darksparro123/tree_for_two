import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:treeForTwo/screens/home.dart';
import 'package:treeForTwo/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: SplashScreen(),
    ),
  );
}
