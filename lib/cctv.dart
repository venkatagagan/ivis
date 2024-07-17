import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:ivis_security/apis/fetchdata.dart';
import 'package:ivis_security/cctv/camBigScreen.dart';
import 'package:ivis_security/cctv/camList.dart';
import 'package:ivis_security/cctv/screens.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/home.dart';
import 'package:ivis_security/navigation.dart';
import 'package:visibility_detector/visibility_detector.dart';

bool shouldReloadContainers = false;

// ignore: must_be_immutable
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
  int currentIndex = 1;
  List<TdpCamera> listOfCamera = [];
  int sitID = 36323;
  // ignore: unused_field
  bool _isVisible = false;
  String visibilityScreenName = "";
  Set<String> monitoringNames = Set();
  List<dynamic> siteNames = [];
  String S = "n";

  late Map<String, dynamic> services;
  String liveview = "F";

  @override
  void initState() {
    super.initState();
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;

    sitID = int.parse(widget.siteId);
    fetchMonitoringNames(sitID);
    fetchSiteNames();
    fetchData(sitID);
  }

  Future<void> fetchData(int accountId) async {
    try {
      final Map<String, dynamic> response =
          await ApiService.fetchClientServices(accountId);

      setState(() {
        services = response;

        liveview = services['siteServicesList']['live'] ?? 'F';
      });
    } catch (e) {
      print('Error fetching client services: $e');
      // Handle errors...
    }
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
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
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
                SizedBox(height: Height * 0.08),
                Row(
                  children: [
                    SizedBox(width: Width * 0.1),
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
                    SizedBox(
                      width: Width * 0.05,
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
                        height: Height * 0.04,
                        width: Width * 0.6,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Height * 0.04,
                ),
                const Divider(
                  height: 1, // Set the height of the line
                  thickness: 1, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
                SizedBox(
                  height: Height * 0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Width * 0.05,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: currentIndex > 0
                            ? () {
                                String siteId = siteNames[currentIndex - 1]
                                        ['siteId']
                                    .toString();
                                String sitename = siteNames[currentIndex - 1]
                                        ['siteName']
                                    .toString();
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
                      SizedBox(
                          height: Height * 0.05,
                          width: Width * 0.6,
                          child: Center(
                            child: Text(
                              sitename,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      SizedBox(
                        width: Width * 0.01,
                      ),
                      IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: currentIndex < siteNames.length - 1
                          ? () {
                              String siteId = siteNames[currentIndex + 1]
                                      ['siteId']
                                  .toString();
                              String sitename = siteNames[currentIndex + 1]
                                      ['siteName']
                                  .toString();
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
                    ],
                  ),
                ),
                const Divider(
                  height: 1, // Set the height of the line
                  thickness: 1, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
                 SizedBox(
                  height: Height*0.03,
                ),
                Row(
                  //49,24,34
                  children: [
                     SizedBox(
                      width: Width*0.13,
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
                    SizedBox(
                      width: Width*0.06,
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
                    SizedBox(
                      width: Width*0.06,
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
                
                SizedBox(width: Width*0.85,child:
                    Divider(
                      height: 1,
                      // Set the height of the line
                      thickness: 1, // Set the thickness of the line
                      color: Colors.white, // Set the color of the line
                    ),
                ),
              ],
            ),
            if (selectedButtonIndex == 0) ...[
              // Display content for Button 1
               Positioned(
                top: Height*0.33, // Adjust the position from the bottom
                right: Width*0.65,
                left: Width*0.075,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              
              Column(
                children: [
                  SizedBox(
                    height: Height*0.4,
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
                                        height: Height*0.35,
                                        width: Width*0.85,
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
               Positioned(
                top: Height*0.33, // Adjust the position from the bottom
                left: Width*0.35,
                right: Width*0.35,
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
                      width: Width*0.85,
                      height: Height*0.07,
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
                            SizedBox(
                                width:
                                    Width*0.1), // Add spacing between text and image
                            const Text(
                              'Hours',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                                width:
                                    Width*0.45), // Add spacing between text and next image
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CenterScreen(
                                            i: currentIndex - 1,
                                            siteId: siteId,
                                            Sitename: sitename,
                                          )),
                                );

                                // Add your desired action here
                              },
                              child: Image.asset(
                                'assets/logos/Rectangle.png',
                                height: Height*0.05,
                                width: Width*0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height:Height*0.03,
                    ),
                    Container(
                      width: Width*0.85,
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
                                    SizedBox(
                                      height: Height*0.03,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Width*0.75,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CenterScreen(
                                                        i: currentIndex - 1,
                                                        siteId: siteId,
                                                        Sitename: sitename,
                                                      )),
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
                                      height: Height*0.03,
                                    ),
                                    // ignore: unused_local_variable
                                    for (String site in monitoringNames)
                                      SingleChildScrollView(
                                          child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 0.05,
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
                                            height: Height*0.05,
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            height: 1,
                                            thickness: 1,

                                            // Thickness of the divider
                                          ),
                                          SizedBox(
                                            height: Height*0.05,
                                          ),
                                        ],
                                      )),
                                  ],
                                ),
                             
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Height*0.05,
                    ),
                  ],
                ),
              ),
            ] else if (selectedButtonIndex == 2) ...[
              Positioned(
                top: Height*0.33, // Adjust the position from the bottom
                left: Width*0.65,
                right: Width*0.075,
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
            if (liveview == "F") ...[
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.233,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7024,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.black54,
                    child: Center(
                      child: Text(
                        "You have not availed this service.\n To subscribe please CONTACT",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        siteId: siteId,
        Sitename: sitename,
        i: currentIndex,
        selected: 0,
      ),
    );
  }
}
