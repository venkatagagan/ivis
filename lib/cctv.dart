import 'package:flutter/material.dart';
import 'package:ivis_security/apis/fetchdata.dart';
import 'package:ivis_security/cctv/camBigScreen.dart';
import 'package:ivis_security/cctv/camList.dart';
import 'package:ivis_security/cctv/screens.dart';
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/development.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/hdtv.dart';
import 'package:ivis_security/home.dart';

void main() {
  runApp(const CctvScreen());
}

bool shouldReloadContainers = false;

class CctvScreen extends StatefulWidget {
  const CctvScreen({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CctvScreen> {
  int startIndex = 0;
  int endIndex = 2;
  List<TdpCamera> listOfCamera = [];
  int sitID = 36301;

  @override
  void initState() {
    // TODO: implement initState
    retrieveTheCamerasData();
    super.initState();
  }

  void retrieveTheCamerasData() async {
    await getCameras(sitID).then((value) {
      setState(() {
        listOfCamera = value;
      });
    });
  }

  int selectedButtonIndex = 0;
  // Track the selected button

  void onButtonPressed(int index) {
    setState(() {
      selectedButtonIndex = index; // Update the selected button index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
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
                const SizedBox(
                  height: 50,
                ),
                const Divider(
                  height: 1, // Set the height of the line
                  thickness: 1, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  //49,24,34
                  children: [
                    const SizedBox(
                      width: 49,
                    ),
                    TextButton(
                      onPressed: () => onButtonPressed(0),
                      child: const Text(
                        'CAMERAS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11, // Set the text color to black
                          // Thickness of the underline
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    TextButton(
                      onPressed: () => onButtonPressed(1),
                      child: const Text(
                        'MONITORING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11, // Set the text color to black
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 34,
                    ),
                    TextButton(
                      onPressed: () => onButtonPressed(2),
                      child: const Text(
                        'STATUS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11, // Set the text color to black
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 30.5,
                    ),
                    Divider(
                      height: 1,
                      // Set the height of the line
                      thickness: 1, // Set the thickness of the line
                      color: Colors.white, // Set the color of the line
                    ),
                  ],
                ),
              ],
            ),
            if (selectedButtonIndex == 0) ...[
              // Display content for Button 1
              if (listOfCamera.isNotEmpty)
                const SizedBox(
                  height: 300,
                ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (startIndex >= 2) {
                              startIndex -= 2;
                              endIndex -= 2;
                            }
                            shouldReloadContainers = true;
                          });
                        },
                        child: Text('Back'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (endIndex < listOfCamera.length) {
                              startIndex += 2;
                              endIndex += 2;
                            }
                            shouldReloadContainers = true;
                          });
                        },
                        child: Text('Next'),
                      ),
                    ],
                  ),
                  ...listOfCamera.sublist(startIndex, endIndex).map(
                    (e) {
                      // GetData();
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => BigScreen(
                                  rtspLInk: e.rtspUrl,
                                  cameraId: e.status,
                                  cameraName: e.name)));
                        },
                        child: VideoPlayerScreen(
                            rtspLInk: e.rtspUrl,
                            status: e.status,
                            cameraName: e.name),
                      );
                    },
                  )
                ],
              ),

              if (listOfCamera.isEmpty) const CircularProgressIndicator()

              // Add rows and columns specific to Button 1
            ] else if (selectedButtonIndex == 1) ...[
              // Display content for Button 2
              const Positioned(
                top: 250, // Adjust the position from the bottom
                left: 130.5,
                right: 129.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              Positioned(
                top: 272, // Adjust the position from the bottom
                left: 30,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                                width:
                                    25), // Add spacing between text and image
                            const Text(
                              'Hours',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    176), // Add spacing between text and next image
                            ElevatedButton(
                              onPressed: () {
                                // Add your button functionality here
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors
                                    .transparent, // Remove the button color
                                side: BorderSide(
                                    color: Colors
                                        .black), // Add a border to the button
                              ),
                              child: Text('Button'),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            Image.asset(
                              'assets/logos/eye.jpg', // Replace with your image path
                              width: 19.7, // Adjust image width as needed
                              height: 13.13, // Adjust image height as needed
                            ),
                            const SizedBox(
                                width:
                                    10.3), // Add spacing between text and image
                            TextButton(
                              onPressed: () {
                                // Add your TextButton action here
                              },
                              child: const Text(
                                'One Stop Odessa',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    95), // Add spacing between text and next image
                            Image.asset(
                              'assets/logos/arrow.jpg', // Replace with your image path
                              width: 7.04, // Adjust image width as needed
                              height: 13, // Adjust image height as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ] else if (selectedButtonIndex == 2) ...[
              const Positioned(
                top: 230, // Adjust the position from the bottom
                left: 230.5,
                right: 29.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              Positioned(
                top: 255, // Adjust the position from the bottom
                left: 30,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    Container(
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            Image.asset(
                              'assets/logos/eye.jpg', // Replace with your image path
                              width: 19.7, // Adjust image width as needed
                              height: 13.13, // Adjust image height as needed
                            ),
                            const SizedBox(
                                width:
                                    10.3), // Add spacing between text and image
                            const Text(
                              'Alpha Omega Contract Sales ….',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    41), // Add spacing between text and next image
                            Image.asset(
                              'assets/logos/arrow.jpg', // Replace with your image path
                              width: 7.04, // Adjust image width as needed
                              height: 13, // Adjust image height as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            Image.asset(
                              'assets/logos/eye.jpg', // Replace with your image path
                              width: 19.7, // Adjust image width as needed
                              height: 13.13, // Adjust image height as needed
                            ),
                            const SizedBox(
                                width:
                                    10.3), // Add spacing between text and image
                            TextButton(
                              onPressed: () {
                                // Add your TextButton action here
                              },
                              child: const Text(
                                'One Stop Odessa',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    95), // Add spacing between text and next image
                            Image.asset(
                              'assets/logos/arrow.jpg', // Replace with your image path
                              width: 7.04, // Adjust image width as needed
                              height: 13, // Adjust image height as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            Image.asset(
                              'assets/logos/eye.jpg', // Replace with your image path
                              width: 19.7, // Adjust image width as needed
                              height: 13.13, // Adjust image height as needed
                            ),
                            const SizedBox(
                                width:
                                    10.3), // Add spacing between text and image
                            TextButton(
                              onPressed: () {
                                // Add your TextButton action here
                              },
                              child: const Text(
                                'One Stop Odessa',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    95), // Add spacing between text and next image
                            Image.asset(
                              'assets/logos/arrow.jpg', // Replace with your image path
                              width: 7.04, // Adjust image width as needed
                              height: 13, // Adjust image height as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 15),
                            Image.asset(
                              'assets/logos/eye.jpg', // Replace with your image path
                              width: 19.7, // Adjust image width as needed
                              height: 13.13, // Adjust image height as needed
                            ),
                            const SizedBox(
                                width:
                                    10.3), // Add spacing between text and image
                            TextButton(
                              onPressed: () {
                                // Add your TextButton action here
                              },
                              child: const Text(
                                'One Stop Odessa',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    95), // Add spacing between text and next image
                            Image.asset(
                              'assets/logos/arrow.jpg', // Replace with your image path
                              width: 7.04, // Adjust image width as needed
                              height: 13, // Adjust image height as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/logos/cctv.jpg',
                width: 19.93, // Adjust image width as needed
                height: 19.67,
              ),
              onPressed: () {
                // Handle home button press
              },
            ),
            IconButton(
              icon: Image.asset(
                'assets/logos/alarm.png', // Replace with your image path
                width: 19.93, // Adjust image width as needed
                height: 19.67, // Adjust image height as needed
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlarmScreen()),
                ); // Handle settings button press
              },
            ),
            IconButton(
              icon: Image.asset(
                'assets/logos/development.png', // Replace with your image path
                width: 19.93, // Adjust image width as needed
                height: 19.67, // Adjust image height as needed
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DevelopmentScreen()),
                ); // Handle settings button press
              },
            ),
            IconButton(
              icon: Image.asset(
                'assets/logos/center-circle.png', // Replace with your image path
                width: 19.93, // Adjust image width as needed
                height: 19.67, // Adjust image height as needed
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CenterScreen()),
                );
                // Handle search button press
              },
            ),
            IconButton(
              icon: Image.asset(
                'assets/logos/hdtv.png', // Replace with your image path
                width: 19.93, // Adjust image width as needed
                height: 19.67, // Adjust image height as needed
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HdtvScreen()),
                );
                // Handle search button press
              },
            ),
            IconButton(
              icon: Image.asset(
                'assets/logos/plus-square.png', // Replace with your image path
                width: 19.93, // Adjust image width as needed
                height: 19.67, // Adjust image height as needed
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CenterScreen()),
                );
                // Handle search button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
