import 'package:flutter/material.dart';

void main() {
  runApp(const ResetScreen());
}

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key});

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
                'RESET PASSWORD',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 200, // Adjust the top position as needed
              left: 30,
              // Adjust the left position as needed
              child: Container(
                width: 300,
                height: 250, // Set the width of the form container
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
                      const SizedBox(height: 40),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: 'Username or e-mail',
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 69),
                      ElevatedButton(
                        onPressed: () {
                          // Handle form submission
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                                content: Container(
                                  height: 140,
                                  width: 340,
                                  padding: const EdgeInsets.all(16),
                                  child: const Text(
                                    "Reset password link has been sent to your registered e-mail id",
                                    style: TextStyle(
                                      fontSize: 16, // Set the text size
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
                              borderRadius: BorderRadius.circular(25.0),
                              // Adjust the radius as needed
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(
                              const Size(125, 50)), // Set the size here
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

class ResetForm extends StatelessWidget {
  const ResetForm({super.key});

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
