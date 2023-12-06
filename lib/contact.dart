import 'package:flutter/material.dart';

void main() {
  runApp(const ContactScreen());
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Column(
              children: [
                const SizedBox(height: 53),
                Image.asset(
                  'assets/logos/logo.png',
                  height: 26.87,
                  width: 218.25,
                ),
                const SizedBox(height: 72.13),
                const Text(
                  'CONTACT',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 29,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const ContactPage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 40,
        ),
        const Padding(
          padding: EdgeInsets.only(
              left: 35.0, right: 120.0), // Add left padding of 40 pixels
          child: Text(
            'IVIS Security, Inc.© 620 N. Grant Avenue Ste. 1010 Odessa, TX 79761',
            style: TextStyle(
              color: Colors.grey, // Set the color to gray
            ),
          ),
        ),
        const SizedBox(
          height: 23,
        ),
        const Padding(
          padding: EdgeInsets.only(
              left: 35.0, right: 120.0), // Add left padding of 40 pixels
          child: Text('Call : (844) GET-IVIS'),
        ),
        const SizedBox(
          width: 300,
        ),
        const SizedBox(
          height: 31,
        ),
        Image.asset(
          'assets/logos/phone.jpg', // Replace with the path to your image asset
          width: 50, // Adjust the width as needed
          height: 50, // Adjust the height as needed
        ),
      ],
    );
  }
}
