import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:treeForTwo/screens/home.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Clean Code',
      home: AnimatedSplashScreen(
        duration: 4000,
        splash: Text(
          "Tree For Two",
          style: GoogleFonts.lobster(
            textStyle: TextStyle(
              color: Colors.pink[500],
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width / 10.0,
            ),
          ),
        ),
        nextScreen: Home(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.leftToRight,
        backgroundColor: Colors.white,
      ),
    );
  }
}
