import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:ivis_security/apis/fetchdata.dart';
import 'package:ivis_security/cctv/camBigScreen.dart';
import 'package:ivis_security/cctv/camList.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/drawer.dart';
import 'package:ivis_security/home.dart';
import 'package:ivis_security/navigation.dart';

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
  List<CameraList> listOfCamera = [];
  int sitID = 36323;
  // ignore: unused_field
  bool _isVisible = false;
  String visibilityScreenName = "";
  Set<String> monitoringNames = Set();
  List<dynamic> siteNames = [];
  String S = "n";

  late Map<String, dynamic> services;
  String liveview = "F";

  late Future<List<Camera>> _camerasFuture;

  @override
  void initState() {
    super.initState();
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;
    _camerasFuture = fetchCameras(siteId);
    sitID = int.parse(widget.siteId);

    fetchSiteNames();
    fetchData(sitID);
  }

  Future<List<Camera>> fetchCameras(String siteId) async {
    final response = await http.get(
        Uri.parse('http://54.92.215.87:943/getCamerasForSiteId_1_0/$siteId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Camera.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cameras');
    }
  }

  bool visiable = false;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
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
                    SizedBox(
                        height: Height * 0.16,
                        child: Column(
                          children: [
                            SizedBox(height: Height * 0.03),
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
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
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
                              height: Height * 0.02,
                            ),
                            const Divider(
                              height: 1, // Set the height of the line
                              thickness: 1, // Set the thickness of the line
                              color: Colors.white, // Set the color of the line
                            ),
                            SizedBox(
                              height: Height * 0.05,
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
                                            String siteId =
                                                siteNames[currentIndex - 1]
                                                        ['siteId']
                                                    .toString();
                                            String sitename =
                                                siteNames[currentIndex - 1]
                                                        ['siteName']
                                                    .toString();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CctvScreen(
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
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    width: Width * 0.01,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    onPressed:
                                        currentIndex < siteNames.length - 1
                                            ? () {
                                                String siteId =
                                                    siteNames[currentIndex + 1]
                                                            ['siteId']
                                                        .toString();
                                                String sitename =
                                                    siteNames[currentIndex + 1]
                                                            ['siteName']
                                                        .toString();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CctvScreen(
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
                              height: Height * 0.01,
                            ),
                          ],
                        )),
                    Row(
                      //49,24,34
                      children: [
                        SizedBox(
                          width: Width * 0.1,
                        ),
                        TextButton(
                          onPressed: () => onButtonPressed(0),
                          child: const Text(
                            'CAMERAS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13, // Set the text color to black
                              // Thickness of the underline
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.04,
                        ),
                        TextButton(
                          onPressed: () => onButtonPressed(1),
                          child: const Text(
                            'MONITORING',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13, // Set the text color to black
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Width * 0.04,
                        ),
                        TextButton(
                          onPressed: () => onButtonPressed(2),
                          child: const Text(
                            'STATUS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13, // Set the text color to black
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: Width * 0.85,
                      child: Divider(
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
                    top: Height * 0.227, // Adjust the position from the bottom
                    right: Width * 0.65,
                    left: Width * 0.075,
                    child: Divider(
                      height: 1, // Set the height of the line
                      thickness: 6, // Set the thickness of the line
                      color: Colors.white, // Set the color of the line
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 200), // Add top padding here
                    child: FutureBuilder<List<Camera>>(
                      future: _camerasFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Camera> cameras = snapshot.data!;
                          return ListView.builder(
                            itemCount: cameras.length,
                            itemBuilder: (context, index) {
                              Camera camera = cameras[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the next screen here
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BigScreen(
                                            httpUrl: camera.httpUrl,
                                            cameraId: camera.cameraId,
                                            cameraName: camera.name,
                                            siteId: int.parse(widget.siteId),
                                            index: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: Width * 0.9,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.04,
                                                child: Text(
                                                  camera.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Color(0xFF000000),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: Icon(
                                                  Icons.visibility,
                                                  size: 20,
                                                  color: camera.snapshotUrl
                                                          .isNotEmpty
                                                      ? Color(
                                                          0xFF00A44C) //#00A44C
                                                      : Color(0xFFEF2800),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  camera.snapshotUrl.isNotEmpty
                                                      ? 'Connected'
                                                      : 'Disconnected',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: camera.snapshotUrl
                                                            .isNotEmpty
                                                        ? Color(
                                                            0xFF00A44C) //#00A44C
                                                        : Color(
                                                            0xFFEF2800), //#EF2800
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: Center(
                                              child: camera
                                                      .snapshotUrl.isNotEmpty
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Image.network(
                                                          camera.snapshotUrl,
                                                          //errorBuilder:
                                                            //  (context, error,
                                                            //      stackTrace) {
                                                            //return Icon(
                                                              //Icons
                                                                //  .visibility_off,
                                                              //size: 50,
                                                              //color:
                                                                //  Colors.grey,
                                                            //);
                                                          //},
                                                        ),
                                                        //if (errorBuilder)
                                                          Icon(
                                                              Icons
                                                                  .play_circle_filled,
                                                              size: 50,
                                                              color:
                                                                  Colors.white),
                                                      ],
                                                    )
                                                  : Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .visibility_off,
                                                            size: 50,
                                                            color: Colors.grey),
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: Width *
                                          0.05), // Add space between the containers
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),

                  // Add rows and columns specific to Button 1
                ] else if (selectedButtonIndex == 1) ...[
                  // Display content for Button 2
                  Positioned(
                    top: Height * 0.227, // Adjust the position from the bottom
                    left: Width * 0.35,
                    right: Width * 0.35,
                    child: Divider(
                      height: 1, // Set the height of the line
                      thickness: 6, // Set the thickness of the line
                      color: Colors.white, // Set the color of the line
                    ),
                  ),

                  Positioned(
                    top: Height * 0.25, // Adjust the position from the bottom
                    left: 30,
                    child: Column(
                      children: [
                        Container(
                          width: Width * 0.85,
                          height: Height * 0.07,
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
                                    width: Width *
                                        0.1), // Add spacing between text and image
                                const Text(
                                  'Hours',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                    width: Width *
                                        0.4), // Add spacing between text and next image
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
                                    height: Height * 0.05,
                                    width: Width * 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Height * 0.03,
                        ),
                        Container(
                          width: Width * 0.85,
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
                                      height: Height * 0.03,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Width * 0.75,
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
                                      height: Height * 0.03,
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
                                            height: Height * 0.05,
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            height: 1,
                                            thickness: 1,

                                            // Thickness of the divider
                                          ),
                                          SizedBox(
                                            height: Height * 0.05,
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
                          height: Height * 0.05,
                        ),
                      ],
                    ),
                  ),
                ] else if (selectedButtonIndex == 2) ...[
                  Positioned(
                    top: Height * 0.227, // Adjust the position from the bottom
                    left: Width * 0.65,
                    right: Width * 0.075,
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
                        height: MediaQuery.of(context).size.height * 0.143,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.726,
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
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          siteId: siteId,
          Sitename: sitename,
          i: currentIndex,
          selected: 0,
        ),
        drawer: DrawerWidget(),
      ),
    );
  }
}

class Camera {
  final String cameraId;
  final String name;
  final String snapshotUrl;
  final String status;
  final String httpUrl;

  Camera({
    required this.cameraId,
    required this.name,
    required this.snapshotUrl,
    required this.status,
    required this.httpUrl,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      cameraId: json['cameraId'],
      name: json['name'],
      snapshotUrl: json['snapshotUrl'],
      status: json['status'],
      httpUrl: json['httpUrl'],
    );
  }
}
