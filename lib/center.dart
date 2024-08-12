import 'package:flutter/material.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:ivis_security/navigation.dart';
import 'package:ivis_security/home.dart';
import 'package:ivis_security/drawer.dart';

// ignore: must_be_immutable
class CenterScreen extends StatefulWidget {
  String siteId;
  String Sitename;
  int i;

  CenterScreen({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CenterScreen> {
  int selectedButtonIndex = 0; // Track the selected button

  String siteId = '';
  String sitename = '';
  int currentIndex = 0;


  int sitID = 36323;

  late Map<String, dynamic> services;
  String se = "F";
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

        se = services['siteServicesList']['safetyEscort'] ;
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
        body:SafeArea(child:  
        Stack(
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            SizedBox(
                      height: Height * 0.18,
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
                                              builder: (context) => CenterScreen(
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
                                          fontFamily: 'Montserrat',
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
                                              builder: (context) => CenterScreen(
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
                          
                        ],
                      )),
                    
            if ("F" == "F") // change logic as se == "F"
              ...[
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
                        style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),
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
          selected: 3,
        ),
        drawer: DrawerWidget(),
      ),
    );
    //return Scaffold(

    //);
  }
}
