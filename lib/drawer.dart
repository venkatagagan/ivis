import 'package:flutter/material.dart';
import 'package:ivis_security/contact.dart';
import 'package:ivis_security/reset.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
            children: [
              Container(
                color: const Color.fromARGB(
                    255, 120, 63, 59), // Background color for the custom header
                height: 230, // Height of the custom header
                child: const Stack(
                  children: [
                    // Positioned user avatar
                    Positioned(
                      top: 20,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                    ),
                    // Positioned account name
                    Positioned(
                      top: 44,
                      left: 100,
                      right: 73,
                      child: Text(
                        "NAME              +91XXXXXXXXXX name@email.com",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 108,
                      left: 100,
                      right: 86,
                      child: Text(
                        "Address Line 1 Address Line 2 District/City State, Country Pincode",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 207,
                      left: 100,
                      child: Text(
                        "+91 1234512345",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Positioned account email
                  ],
                ),
              ),
              //
              const SizedBox(
                height: 25,
              ),
              ListTile(
                title: const Text("RESET PASSWORD"),
                onTap: () {
                  // Handle home item tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResetScreen()),
                  ); // Close the drawer
                },
              ),
              const SizedBox(
                height: 25,
              ),
              ListTile(
                title: const Text("CONTACT"),
                onTap: () {
                  // Handle settings item tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactScreen()),
                  ); // Close the drawer
                },
              ),
              const SizedBox(
                height: 25,
              ),
              ListTile(
                minLeadingWidth: 25,
                title: const Text("TERMS & CONDITIONS"),
                onTap: () {
                  // Handle settings item tap
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
    );
  }
}
