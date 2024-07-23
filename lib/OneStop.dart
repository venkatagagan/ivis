import 'package:flutter/material.dart';
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/cctv.dart';
import 'package:ivis_security/development.dart';
import 'package:ivis_security/drawer.dart';
import 'package:ivis_security/hdtv.dart';
import 'package:ivis_security/request.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';

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

  int currentIndex = 1;
  List<dynamic> siteNames = [];

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

    fetchData(int.parse(siteId));

    fetchSiteNames(); // Pass siteid to fetchData
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

  Future<void> fetchData(int accountId) async {
    try {
      final Map<String, dynamic> response =
          await ApiService.fetchClientServices(accountId);

      setState(() {
        services = response;

        liveview = services['siteServicesList']['live'];
        alaram = services['siteServicesList']['alerts'];
        bi = services['siteServicesList']['insights'];
        se = services['siteServicesList']['safetyEscort'];
        ad = services['siteServicesList']['advertisements'];
      });
    } catch (e) {
      print('Error fetching client services: $e');
      // Handle errors...
    }
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
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
            
            Column(
              children: [
                SizedBox(height: Height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Image.asset(
                      'assets/logos/logo.png',
                      height: Height * 0.04,
                      width: Width * 0.6,
                    ),
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
                Row(
                  children: [
                    SizedBox(
                      width: Width * 0.05,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
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
                                  builder: (context) => OneStopScreen(
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
                      width: Width * 0.01,
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
                              color: Color(0xFFFFFFFF),
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
                                  builder: (context) => OneStopScreen(
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
                Divider(
                  height: 1, // Set the height of the line
                  thickness: 1, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
                SizedBox(
                  height: Height * 0.05,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Width * 0.08,
                    ),
                    Text(
                      "GUARD",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle the button press event here
                        if (liveview == "T") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CctvScreen(
                                      i: currentIndex ,
                                      siteId: siteId,
                                      Sitename: sitename,
                                      
                                    )),
                          );
                        } else {
                          showMyDialog(context);
                        }
                      },
                      child: CustomButton(
                        imagePath: 'assets/logos/Acctv.png',
                        text1: 'Live View',
                        isEnabled: liveview == "T",
                      ),
                    ),
                    SizedBox(
                      width: Width * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        // Handle the button press event here
                        if (alaram == "T") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlarmScreen(
                                      i: currentIndex ,
                                      siteId: siteId,
                                      Sitename: sitename,
                                    )),
                          );
                        } else {
                          showMyDialog(context);
                        }
                      },
                      child: CustomButton(
                        imagePath: 'assets/logos/Aalarm.png',
                        text1: 'Alarm',
                        isEnabled: alaram == "T",
                      ),
                    ),
                    SizedBox(
                      width: Width * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        // Handle the button press event here
                        if (se == "T") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CenterScreen(
                                      i: currentIndex ,
                                      siteId: siteId,
                                      Sitename: sitename,
                                    )),
                          );
                        } else {
                          showMyDialog(context);
                        }
                      },
                      child: CustomButton(
                        imagePath: 'assets/logos/Acenter-circle.png',
                        text1: 'Safety \n Escord',
                        isEnabled: se == "T",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Height * 0.05,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Width * 0.08,
                    ),
                    Text(
                      'INSIGHT',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Height * 0.01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Width * 0.08,
                    ),
                    InkWell(
                      onTap: () {
                        // Handle the button press event here
                        if (bi == "T") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DevelopmentScreen(
                                      i: currentIndex ,
                                      siteId: siteId,
                                      Sitename: sitename,
                                    )),
                          );
                        } else {
                          showMyDialog(context);
                        }
                      },
                      child: CustomButton(
                        imagePath: 'assets/logos/Adevelopment.png',
                        text1: 'Business \n Intelligence',
                        isEnabled: bi == "T",
                      ),
                    ),
                    SizedBox(
                      width: Width * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        // Handle the button press event here
                        if (ad == "T") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HdtvScreen(
                                      i: currentIndex ,
                                      siteId: siteId,
                                      Sitename: sitename,
                                    )),
                          );
                        } else {
                          showMyDialog(context);
                        }
                      },
                      child: CustomButton(
                        imagePath: 'assets/logos/Ahdtv.png',
                        text1: 'Ads',
                        isEnabled: ad == "T",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Height * 0.05,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Width * 0.08,
                    ),
                    Text(
                      'HELPDESK',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Height * 0.01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Width * 0.08,
                    ),
                    InkWell(
                      onTap: () {
                        // Handle the button press event here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RequestScreen(
                                    i: currentIndex ,
                                    siteId: siteId,
                                    Sitename: sitename,
                                  )),
                        );
                      },
                      child: CustomButton(
                        imagePath: 'assets/logos/plus-square.jpg',
                        text1: 'Service \nRequest',
                        isEnabled: "T" == "T",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        drawer: DrawerWidget(),
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

class CustomButton extends StatelessWidget {
  final String imagePath;
  final String text1;

  final bool isEnabled;

  CustomButton({
    required this.imagePath,
    required this.text1,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        color: isEnabled
            ? Colors.white.withOpacity(1)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20, width: 33),
            Image.asset(
              imagePath,
              width: 29.5, // Adjust image width as needed
              height: 27, // Adjust image height as needed
            ),
            const SizedBox(height: 10),
            Text(
              text1,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
