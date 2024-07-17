import 'package:flutter/material.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:ivis_security/apis/fetchdata.dart';
import 'package:ivis_security/cctv/camList.dart';
import 'package:ivis_security/navigation.dart';
import 'package:ivis_security/home.dart';
import 'package:ivis_security/drawer.dart';

// ignore: must_be_immutable
class HdtvScreen extends StatefulWidget {
  String siteId;
  String Sitename;
  int i;

  HdtvScreen({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HdtvScreen> {
  int selectedButtonIndex = 0; // Track the selected button

  String siteId = '';
  String sitename = '';
  int currentIndex = 0;

  List<TdpCamera> listOfCamera = [];

  int sitID = 36323;

  late Map<String, dynamic> services;
  String ad = "F";
  //site names
  List<dynamic> siteNames = [];

  @override
  void initState() {
    super.initState();
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;

    sitID = int.parse(widget.siteId);

    fetchData(sitID);
    fetchSiteNames();
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

  Future<void> fetchData(int accountId) async {
    try {
      final Map<String, dynamic> response =
          await ApiService.fetchClientServices(accountId);

      setState(() {
        services = response;

        ad = services['siteServicesList']['advertisements']  ?? 'F';
      });
    } catch (e) {
      print('Error fetching client services: $e');
      // Handle errors...
    }
  }

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
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Positioned(
                top: 50, // Adjust the position from the bottom
                left: 71,
                child: GestureDetector(
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
                )),
            Positioned(
              top: 47,
              left: 30,
              child: Builder(
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
                            builder: (context) => HdtvScreen(
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
                            builder: (context) => HdtvScreen(
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
            const Positioned(
              top: 120, // Adjust the top position as needed
              left: 0.5, // Adjust the left position as needed
              right: 0.5, // Adjust the right position as needed
              child: Divider(
                height: 1, // Set the height of the line
                thickness: 1, // Set the thickness of the line
                color: Colors.white, // Set the color of the line
              ),
            ),
            const Positioned(
              top: 175, // Adjust the top position as needed
              left: 0.5, // Adjust the left position as needed
              right: 0.5, // Adjust the right position as needed
              child: Divider(
                height: 1, // Set the height of the line
                thickness: 1, // Set the thickness of the line
                color: Colors.white, // Set the color of the line
              ),
            ),
            
            Positioned(
              left: MediaQuery.of(context).size.width * 0.2,
              top: 135, // Center vertically
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height*0.03,
                  child: Center(child:  Text(
                    widget.Sitename,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    )
                  )),
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
                          height: 310,
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
            if (ad == "F") // change logic as alarm == "F"
              ...[
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
        bottomNavigationBar: CustomBottomNavigationBar(
          siteId: siteId,
          Sitename: sitename,
          i: currentIndex,
          selected: 4,
        ),
        drawer: DrawerWidget(),
      ),
    );
    //return Scaffold(

    //);
  }
}
