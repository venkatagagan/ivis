import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/cctv.dart';
import 'package:ivis_security/development.dart';
import 'package:ivis_security/hdtv.dart';
import 'package:ivis_security/request.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/contact.dart';
import 'package:ivis_security/reset.dart';
import 'package:ivis_security/apis/Services.dart';
//import 'package:ivis_security/apis/Bussiness_int_api.dart';

// ignore: must_be_immutable
class OneStopScreen extends StatefulWidget {
  String siteId;
  String Sitename;
  int i;

  OneStopScreen({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  _OneStopScreenState createState() => _OneStopScreenState();
}

class Site {
  final int siteId;
  final String siteName;

  Site(this.siteId, this.siteName);
}

class _OneStopScreenState extends State<OneStopScreen> {
// ignore: must_be_immutable
  String liveview = "F";
  String alaram = "F";
  String bi = "F";
  String se = "F";
  String ad = "F";
  late String sitename;
  late String siteId;
  late String I;
  late int i;
  late String Id;
  late String Name;
  List<Site> sites = [];
  int currentIndex = 1;

  late Map<String, dynamic> services;
  int accountId = 1004;
  int currentSiteIndex = 0; // Counter for site IDs
  @override
  void initState() {
    super.initState();
    // Initialize sitename and siteid here
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;
    fetchSites();
    fetchData(int.parse(siteId)); // Pass siteid to fetchData
  }

  Future<void> fetchData(int accountId) async {
    try {
      final Map<String, dynamic> response =
          await ApiService.fetchClientServices(accountId);

      setState(() {
        services = response;

        liveview = services['Services']['LiveView'] ?? 'F';
        alaram = services['Services']['alarms'] ?? 'F';
        bi = services['Services']['business_intelligence'] ?? 'F';
        se = services['Services']['safety_escort'] ?? 'F';
        ad = services['Services']['advertising'] ?? 'F';
      });
    } catch (e) {
      print('Error fetching client services: $e');
      // Handle errors...
    }
  }

  Future<void> fetchSites() async {
    final response = await http.get(Uri.parse(
        'http://54.92.215.87:943/getSitesListForUserName_1_0/?userName=ivisusnew'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> siteList = data['sites'];

      setState(() {
        sites = siteList
            .map((site) => Site(site['siteId'], site['siteName']))
            .toList();
      });
    } else {
      throw Exception('Failed to load sites');
    }
  }

  void goToNextSite() {
    if (currentIndex < sites.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void goToPreviousSite() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
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
                    Image.asset(
                      'assets/logos/logo.png',
                      height: 26.87,
                      width: 218.25,
                    ),
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
            Positioned(
              left: 116, // Adjust the position from the left
              top: 137, // Center vertically
              child: Text(
                sitename,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
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
            Positioned(
              right: 29.87, // Adjust the position from the right
              top: 125, // Center vertically
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  currentIndex < sites.length - 1 ? goToNextSite : null;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OneStopScreen(
                        i: currentIndex,
                        siteId: '${sites[currentIndex].siteId}', //siteId
                        Sitename: "${sites[currentIndex].siteName}",
                      ),
                    ),
                  );
                  // Handle right arrow button press
                },

                iconSize: 21.13, // Adjust the size of the button
                color: Colors.white, // Adjust the color of the button
              ),
            ),
            const SizedBox(height: 45),
            const Positioned(
              left: 30, // Adjust the position from the right
              top: 215, // Center vertically
              child: Text(
                'GUARD',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Positioned(
              top: 234, // Adjust the position from the bottom
              left: 30,
              child: Row(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      // Handle the button press event here
                      if (liveview == "T") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CctvScreen()),
                        );
                      } else {
                        showMyDialog(context);
                      }
                    },
                    child: Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        color: liveview == "T"
                            ? Colors.white.withOpacity(1)
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              width: 33,
                            ),
                            Image.asset(
                              'assets/logos/Acc.png', // Replace with your image path
                              width: 30.4, // Adjust image width as needed
                              height: 30, // Adjust image height as needed
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'LIVE View',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            // Add spacing between text and image
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      color: alaram == "T"
                          ? Colors.white.withOpacity(1)
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0), // Adjust the left padding
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                            width: 33,
                          ),
                          Image.asset(
                            'assets/logos/Aalarm.png', // Replace with your image path
                            width: 29.5, // Adjust image width as needed
                            height: 27, // Adjust image height as needed
                          ),

                          TextButton(
                            onPressed: () {
                              // Add your TextButton action here
                              ElevatedButton(
                                onPressed: () {
                                  if (liveview == "T") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AlarmScreen()),
                                    );
                                  } else {
                                    showMyDialog(context);
                                  }
                                },
                                child: const Text('Show Dialog'),
                              );
                            },
                            child: const Text(
                              'Alarms',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ), // Add spacing between text and image
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      // Handle the button press event here
                      if (se == "T") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CenterScreen()),
                        );
                      } else {
                        showMyDialog(context);
                      }
                    },
                    child: Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        color: se == "T"
                            ? Colors.white.withOpacity(1)
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              width: 33,
                            ),
                            Image.asset(
                              'assets/logos/Acenter-circle.png', // Replace with your image path
                              width: 29.5, // Adjust image width as needed
                              height: 27, // Adjust image height as needed
                            ),
                            const Text(
                              'Safety',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const Text(
                              'Escort',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Positioned(
              left: 30, // Adjust the position from the right
              top: 364, // Center vertically
              child: Text(
                'INSIGHT',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Positioned(
              top: 383, // Adjust the position from the bottom
              left: 30,
              child: Row(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      // Handle the button press event here
                      if (bi == "T") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DevelopmentScreen()),
                        );
                      } else {
                        showMyDialog(context);
                      }
                    },
                    child: Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        color: bi == "T"
                            ? Colors.white.withOpacity(1)
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 22, width: 38),
                            Image.asset(
                              'assets/logos/Adevelopment.png', // Replace with your image path
                              width: 29.9, // Adjust image width as needed
                              height: 29.9, // Adjust image height as needed
                            ),
                            const SizedBox(height: 8.1),

                            const Text(
                              'Business',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const Text(
                              'Intelligence',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ), // Add spacing between text and image
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      // Handle the button press event here
                      if (liveview == "T") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HdtvScreen()),
                        );
                      } else {
                        showMyDialog(context);
                      }
                    },
                    child: Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        color: ad == "T"
                            ? Colors.white.withOpacity(1)
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 23, width: 30),
                            Image.asset(
                              'assets/logos/Ahdtv.png', // Replace with your image path
                              width: 35.96, // Adjust image width as needed
                              height: 29.22, // Adjust image height as needed
                            ),
                            const SizedBox(height: 7.78),
                            // Add spacing between text and image
                            const Text(
                              'Ads',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Positioned(
              left: 30, // Adjust the position from the right
              top: 518, // Center vertically
              child: Text(
                'HELPDESK',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Positioned(
              top: 547, // Adjust the position from the bottom
              left: 30,
              child: Row(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      // Handle the button press event here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RequestScreen()),
                      );
                    },
                    child: Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0), // Adjust the left padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 23, width: 30),
                            Image.asset(
                              'assets/logos/Aplus-square.png', // Replace with your image path
                              width: 30.4, // Adjust image width as needed
                              height: 30, // Adjust image height as needed
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Service',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const Text(
                              'Request',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            // Service Request
                          ],
                        ),
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
  }

  void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              "You have not availed this service. To subscribe please CONTACT",
              style: TextStyle(
                fontSize: 16, // Set the text size
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(
                top: 16,
              ), // Adjust top margin as needed
            ),
          ],
        );
      },
    );
  }
}
