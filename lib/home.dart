import 'package:flutter/material.dart';
import 'package:ivis_security/OneStop.dart';
import 'package:ivis_security/drawer.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int selectedButtonIndex = 0; // Track the selected button
  int i = 0;
  List<dynamic> siteNames = [];

  @override
  void initState() {
    super.initState();
    fetchSiteNames();
  }

  Future<void> fetchSiteNames() async {
    try {
      List<dynamic> sites = await BussinessInterface.fetchSiteNames();
      setState(() {
        siteNames = sites;
      });
    } catch (e) {
      print('Error fetching site names: $e');
    }
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedButtonIndex = index; // Update the selected button index
    });
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: DrawerWidget(),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/bg.png',
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Column(
              children: [
                SizedBox(height: Height * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: Width * 0.1),
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.menu,
                              size: Height * 0.045,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: Width * 0.05),
                    Image.asset(
                      'assets/logos/logo.png',
                      height: Height * 0.05,
                      width: Width * 0.61,
                    ),
                  ],
                ),
                SizedBox(
                  height: Height * 0.05,
                ),
                Divider(
                  height: Height * 0.001, // Set the height of the line
                  thickness: 1, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
                SizedBox(
                  height: Height * 0.065,
                ),
                Divider(
                  height: Height * 0.001, // Set the height of the line
                  thickness: 1, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
                SizedBox(
                  height: Height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => onButtonPressed(0),
                      child: const Text(
                        'S I T E S',
                        style: TextStyle(
                          color: Colors.white, // Set the text color to black
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Width * 0.25,
                    ),
                    TextButton(
                      onPressed: () => onButtonPressed(1),
                      child: const Text(
                        'M A P',
                        style: TextStyle(
                          color: Colors.white, // Set the text color to black
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: Height * 0.333, // Adjust the top position as needed
              left: Width * 0.08, // Adjust the left position as needed
              right: Width * 0.08, // Adjust the right position as needed
              child: Divider(
                height: 1, // Set the height of the line
                thickness: 1, // Set the thickness of the line
                color: Colors.white, // Set the color of the line
              ),
            ),
            if (selectedButtonIndex == 0) ...[
              // Display content for Button 1

              Positioned(
                top: Height * 0.335, // Adjust the position from the bottom
                left: Width * 0.08,
                right: Width * 0.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: Height * 0.4),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (Map<String, dynamic> site in siteNames)
                              GestureDetector(
                                onTap: () {
                                  // Navigate to another Dart file
                                  String siteId = site['siteId'].toString();
                                  String SiteName = site['siteName'].toString();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OneStopScreen(
                                        i: siteNames.indexOf(site),
                                        siteId: siteId,
                                        Sitename: SiteName,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: Width * 0.85,
                                  height: Height * 0.08,
                                  margin: EdgeInsets.only(
                                      bottom: 16), // Add margin for space
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      left: 0,
                                    ), // Adjust the left padding
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: Width * 0.05),
                                        Image.asset(
                                          'assets/logos/eye.jpg', // Replace with your image path
                                          width: Width *
                                              0.07, // Adjust image width as needed
                                          height: Height *
                                              0.02, // Adjust image height as needed
                                        ),
                                        SizedBox(
                                            width: Width *
                                                0.05), // Add spacing between text and image
                                        SizedBox(
                                          height: Height * 0.02,
                                          width: Width * 0.55,
                                          child: Text(
                                            site['siteName']
                                                .toString(), // Access the 'siteName' field
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: Width * 0.02),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                        // Add spacing between text and next image
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )

              // Add rows and columns specific to Button 1
            ] else if (selectedButtonIndex == 1) ...[
              // Display content for Button 2
              Positioned(
                top: Height * 0.335, // Adjust the position from the bottom
                right: Width * 0.08,
                left: Width * 0.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: Height * 0.4, // Adjusted height
                  ),
                  Center(
                    child: Container(
                      width: Width * 0.75, // Adjusted width
                      height: Height * 0.56, // Adjusted height
                      color: Colors.white,
                      child: Center(
                        child: Text("coming soon..."),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
    );
    //return Scaffold(

    //);
  }
}
