import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';
//import 'package:ivis_security/apis/Monitoring.dart';
import 'package:ivis_security/apis/fetchdata.dart';
import 'package:ivis_security/cctv/camBigScreen.dart';
import 'package:ivis_security/cctv/camList.dart';
import 'package:ivis_security/cctv/screens.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/development.dart';
import 'package:ivis_security/hdtv.dart';
import 'package:ivis_security/home.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';

bool shouldReloadContainers = false;

class CctvScreen extends StatefulWidget {
  String siteId;
  String Sitename;
  int i;

  CctvScreen({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CctvScreen> {
  int startIndex = 0;
  int endIndex = 1;
  String sitename = "";
  String siteId = "";
  int currentIndex = 0;
  List<TdpCamera> listOfCamera = [];
  int sitID = 36323;
  bool _isVisible = false;
  String visibilityScreenName = "";
  Set<String> monitoringNames = Set();
  List<dynamic> siteNames = [];

  @override
  void initState() {
    super.initState();
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;

    sitID = int.parse(widget.siteId);
    fetchMonitoringNames(sitID);
    fetchSiteNames();
  }

  Future<void> fetchMonitoringNames(int accountId) async {
    final response = await http.get(Uri.parse(
        "http://usmgmt.iviscloud.net:777/cpus/Monitoring/monitoringHours?accountId=$accountId"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> monitoringHours = data['monitoringHours'];

      setState(() {
        monitoringNames = monitoringHours
            .map(
                (monitoringHour) => monitoringHour['monitoringname'].toString())
            .toSet();
      });
    } else {
      throw Exception('Failed to load monitoring names');
    }
  }

  Future<void> fetchSiteNames() async {
    try {
      List<dynamic> sites = await BussinessInterface.fetchSiteNames();
      setState(() {
        siteNames = sites;
        retrieveTheCamerasData();
      });
    } catch (e) {
      print('Error fetching site names: $e');
    }
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
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 15,
                        child: Center(
                          child: Text(
                            sitename,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
            Positioned(
              left: 29.87, // Adjust the position from the right
              top: 125, // Center vertically
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: currentIndex > 0
                    ? () {
                        String siteId =
                            siteNames[currentIndex - 1]['siteId'].toString();
                        String sitename =
                            siteNames[currentIndex - 1]['siteName'].toString();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CctvScreen(
                              i: currentIndex - 1,
                              siteId: siteId,
                              Sitename: sitename,
                            ),
                          ),
                        );
                      }
                    : null,
                iconSize: 21.13,
                color: Colors.white,
              ),
            ),
            Positioned(
              right: 29.87, // Adjust the position from the right
              top: 125, // Center vertically
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: currentIndex < siteNames.length - 1
                    ? () {
                        String siteId =
                            siteNames[currentIndex + 1]['siteId'].toString();
                        String sitename =
                            siteNames[currentIndex + 1]['siteName'].toString();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CctvScreen(
                              i: currentIndex + 1,
                              siteId: siteId,
                              Sitename: sitename,
                            ),
                          ),
                        );
                      }
                    : null,
                iconSize: 21.13,
                color: Colors.white,
              ),
            ),
            if (selectedButtonIndex == 0) ...[
              // Display content for Button 1
              const Positioned(
                top: 250, // Adjust the position from the bottom
                right: 230.5,
                left: 29.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 300,
                  ),
                  if (listOfCamera.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...listOfCamera.map(
                              (e) {
                                // GetData();
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) => BigScreen(
                                                httpUrl: e.httpUrl,
                                                cameraId: e.status,
                                                cameraName: e.name)));
                                  },
                                  // child: VideoPlayerScreen(
                                  //     rtspLInk: e.rtspUrl,
                                  //     status: e.status,
                                  //     cameraName: e.name),
                                  child: Expanded(
                                      child: VisibilityDetector(
                                    key: Key(e.name.toString()),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 260,
                                        width: 300,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                            child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (visibilityScreenName == e.name)
                                              VideoPlayerScreen(
                                                  httpUrl: e.httpUrl,
                                                  status: e.status,
                                                  cameraName: e.name)
                                            else
                                              Text(e.name),
                                          ],
                                        )),
                                      ),
                                    ),
                                    onVisibilityChanged: (visibilityInfo) {
                                      setState(() {
                                        // Change the flag value of _isVisible
                                        // If it is greater than 0 means it is visible
                                        _isVisible =
                                            visibilityInfo.visibleFraction > 0;

                                        // It will show how much percentage the widget is visible
                                        var visiblePercentage =
                                            visibilityInfo.visibleFraction *
                                                100;
                                        if (visibilityScreenName != e.name &&
                                            visiblePercentage == 100) {
                                          visibilityScreenName = e.name;

                                          print(visibilityScreenName);
                                        } else {
                                          print("Hello");
                                        }
                                        print(
                                            '${e.name} is ${visiblePercentage}% visible');
                                      });
                                    },
                                  )),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  if (listOfCamera.isEmpty) const CircularProgressIndicator()
                ],
              ),
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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CenterScreen()),
                                );

                                // Add your desired action here
                              },
                              child: Image.asset(
                                'assets/logos/Rectangle.png',
                                height: 25,
                                width: 45,
                              ),
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
                            Column(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 23,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 266,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CenterScreen()),
                                            );
                                            // Add your desired action here
                                          },
                                          child: Image.asset(
                                            'assets/logos/plus-square.jpg',
                                            height: 13,
                                            width: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 22,
                                    ),
                                    // ignore: unused_local_variable
                                    for (String site in monitoringNames)
                                      SingleChildScrollView(
                                          child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                site,

                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      11, // Set the text color to black
                                                ), //#ABABAB
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            height: 1,
                                            thickness: 1,

                                            // Thickness of the divider
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                        ],
                                      )),
                                  ],
                                ),
                              ],
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
                top: 250, // Adjust the position from the bottom
                left: 230.5,
                right: 29.5,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              Center(
                child: Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
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
