import 'package:flutter/material.dart';
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/development.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/cctv.dart';
import 'package:ivis_security/request.dart';
import 'package:ivis_security/contact.dart';
import 'package:ivis_security/reset.dart';
import 'package:ivis_security/home.dart';

void main() {
  runApp(const HdtvScreen());
}

class HdtvScreen extends StatefulWidget {
  const HdtvScreen({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HdtvScreen> {
  int selectedButtonIndex = 0; // Track the selected button

  void onButtonPressed(int index) {
    setState(() {
      selectedButtonIndex = index; // Update the selected button index
    });
  }

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
              alignment: Alignment.center,
            ),
            Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.menu,
                              size: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Your action when the image is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                        // Add your logic here, such as navigating to a new screen or performing some action.
                      },
                      child: Image.asset(
                        'assets/logos/logo.png',
                        height: 26.87,
                        width: 218.25,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 43.13,
                ),
                const Divider(
                  height: 1, // Set the height of the line
                  thickness: 1, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ],
            ),
            const Positioned(
              top: 170, // Adjust the top position as needed
              left: 0.5, // Adjust the left position as needed
              right: 0.5, // Adjust the right position as needed
              child: Divider(
                height: 1, // Set the height of the line
                thickness: 1, // Set the thickness of the line
                color: Colors.white, // Set the color of the line
              ),
            ),
            const Positioned(
              top: 250, // Adjust the top position as needed
              left: 30.5, // Adjust the left position as needed
              right: 30.5, // Adjust the right position as needed
              child: Divider(
                height: 1, // Set the height of the line
                thickness: 1, // Set the thickness of the line
                color: Colors.white, // Set the color of the line
              ),
            ),
            Positioned(
              right: 30, // Adjust the position from the right
              top: 125, // Center vertically
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  // Handle right arrow button press
                },
                iconSize: 40, // Adjust the size of the button
                color: Colors.white, // Adjust the color of the button
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 -
                  75, // Adjust the position from the left
              top: 135, // Center vertically
              child: const Text(
                'ONE STOP ODESSA',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 202, // Adjust the position from the bottom
              left: 51, // Adjust the position from the left
              child: TextButton(
                onPressed: () => onButtonPressed(0),
                child: const Text(
                  'SCREENS',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to black
                  ),
                ),
              ),
            ),
            Positioned(
              top: 202, // Adjust the position from the bottom
              left: 151, // Adjust the position from the left
              child: TextButton(
                onPressed: () => onButtonPressed(1),
                child: const Text(
                  'PLAYLIST',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to black
                  ),
                ),
              ),
            ),
            Positioned(
              top: 202, // Adjust the position from the bottom
              left: 256, // Adjust the position from the left
              child: TextButton(
                onPressed: () => onButtonPressed(2),
                child: const Text(
                  'AD LIST',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to black
                  ),
                ),
              ),
            ),
            if (selectedButtonIndex == 0) ...[
              // Display content for Button 1
              const Positioned(
                top: 253, // Adjust the position from the bottom
                left: 30.5,
                right: 229.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 285,
                      ),
                      Container(
                        width: 300,
                        height: 510,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              top: 0, left: 0), // Adjust the left padding
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Add rows and columns specific to Button 1
            ] else if (selectedButtonIndex == 1) ...[
              // Display content for Button 2
              const Positioned(
                top: 253, // Adjust the position from the bottom
                left: 130.5,
                right: 129.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 285,
                      ),
                      Container(
                        width: 300,
                        height: 300,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ] else if (selectedButtonIndex == 2) ...[
              // Display content for Button 2
              const Positioned(
                top: 253, // Adjust the position from the bottom
                left: 230.5,
                right: 29.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 285,
                      ),
                      Container(
                        width: 300,
                        height: 300,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ],
            Positioned(
              bottom: 0, // Adjust the position from the bottom
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0), // Adjust the left padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CctvScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/bx-cctv.png', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AlarmScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/alarm.png', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DevelopmentScreen()),
                              );
                              // Handle the button press event here
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/development.png', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CenterScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/center-circle.jpg', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/hdtv.jpg', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RequestScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/plus-square.png', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ), // Positioned widget at the top-left corner
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
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
        ),
      ),
    );
    //return Scaffold(

    //);
  }
}
