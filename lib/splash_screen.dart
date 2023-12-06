import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ivis_security/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  body: Stack(
    children: <Widget>[
      // Background image
      Image.asset(
        'assets/images/bg.png',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
      // Centered logo at the top
      Positioned(
        top: 0, // Adjust position as needed
        left: 0, // Adjust position as needed
        right: 0, // Adjust position as needed
        child: Center(
          child: Image.asset(
            'assets/logos/logo.png',
            height: 200.0,
            width: 300.0,
          ),
        ),
      ),
      // Centered logo in the middle
      Center(
        child: Image.asset(
          'assets/logos/logo_centre.png',
          height: 144.0,
          width: 168.0,
        ),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(bottom: 40),
        child: const Text(
          'Version 1.2.0',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    ],
  ),
);

  }
}
