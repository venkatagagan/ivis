// ignore: file_names
import 'package:flutter/material.dart';

void main() {
  runApp(const ForgotScreen());
}

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

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
            Positioned(
              top: 50, // Adjust the position from the bottom
              left: 71,
              child: Image.asset(
                'assets/logos/logo.png',
                height: 26.87,
                width: 218.25,
              ),
            ),
            Positioned(
              top: 152, // Adjust the position from the bottom
              left: (MediaQuery.of(context).size.width - 100) / 2 - 20,
              child: const Text(
                'FORGOT PASSWORD',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              top: 308, // Adjust the position from the bottom
              left: 313,
              child: Text(
                'x',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 200, // Adjust the top position as needed
              left: 30,
              bottom: 360, // Adjust the left position as needed
              child: Container(
                width: 300, // Set the width of the form container
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  // Your form fields and controls go here
                  child: Column(
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Username or e-mail',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          // Handle form submission
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const SizedBox(
                                  height: 140,
                                  width: 300,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 0,
                                        left: 0), // Adjust the left padding
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 14),
                                        Text(
                                          'New password link has been sent to your registered e-mail id',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                10), // Add spacing between text and next image
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: '      name@email.com',
                                            filled: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 16), // Adjust top margin as needed
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25.0), // Adjust the radius as needed
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(
                              const Size(150, 50)), // Set the size here
                        ),
                        child: const Text('SUBMIT'),
                      ),
                    ],
                  ),
                ),
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
      ),
    );
  }
}

class ForgotForm extends StatelessWidget {
  const ForgotForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username or e-mail',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
