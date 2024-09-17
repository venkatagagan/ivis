import 'package:flutter/material.dart';
import 'package:ivis_security/OneStop.dart';
import 'package:ivis_security/drawer.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int selectedButtonIndex = 0; // Track the selected button
  int i = 0;
  List<dynamic> siteNames = [];
  List<dynamic> filteredSiteNames = [];
  TextEditingController searchController = TextEditingController();

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
        filteredSiteNames = sites; // Initialize filtered list with all sites
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

  void filterSites(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredSiteNames = siteNames;
      });
    } else {
      setState(() {
        filteredSiteNames = siteNames
            .where((site) => site['siteName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: DrawerWidget(),
        body: SafeArea(
          child: Stack(
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
                  SizedBox(height: Height * 0.03),
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
                                color: Color(0xFFFFFFFF),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: Width * 0.03),
                      Image.asset(
                        'assets/logos/logo.png',
                        height: Height * 0.05,
                        width: Width * 0.61,
                      ),
                    ],
                  ),
                  SizedBox(height: Height * 0.02),
                  Divider(
                    height: Height * 0.001,
                    thickness: 1,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Width * 0.08),
                    child: TextField(
                      showCursor: true,
                      cursorColor: Colors.white,
                      controller: searchController,
                      onChanged: filterSites,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.transparent,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Divider(
                    height: Height * 0.001,
                    thickness: 1,
                    color: Colors.white,
                  ),
                  SizedBox(height: Height * 0.02),
                    Center(
                      child: 
                      const Text(
                        'S I T E S',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    
                    ),
                    SizedBox(height: Height * 0.02),
                    SizedBox(width: Width*0.84,child:Divider(
                    height: 1, // Set the height of the line
                    thickness: 6, // Set the thickness of the line
                    color: Colors.white, // Set the color of the line
                  ) ,),
                  SizedBox(height: Height * 0.02),
                    
                    
                ],
              ),
              if (selectedButtonIndex == 0) ...[
                // Display content for Button 1
                
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: Height * 0.27),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (Map<String, dynamic> site
                                  in filteredSiteNames)
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          8.0), // Add space between containers
                                  child: GestureDetector(
                                    onTap: () {
                                      String siteId = site['siteId'].toString();
                                      String SiteName =
                                          site['siteName'].toString();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OneStopScreen(
                                            i: filteredSiteNames.indexOf(site),
                                            siteId: siteId,
                                            Sitename: SiteName,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: Width * 0.85,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, left: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(width: Width * 0.05),
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return LinearGradient(
                                                  colors: [
                                                    Color(0xFFD34124),
                                                    Color(0xFF084982)
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ).createShader(bounds);
                                              },
                                              child: Icon(
                                                Icons.visibility,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: Width * 0.05),
                                            SizedBox(
                                              height: Height * 0.03,
                                              width: Width * 0.55,
                                              child: Text(
                                                site['siteName'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF000000),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: Width * 0.02),
                                            ShaderMask(
                                              shaderCallback: (Rect bounds) {
                                                return LinearGradient(
                                                  colors: [
                                                    Color(0xFFD34124),
                                                    Color(0xFF084982)
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ).createShader(bounds);
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
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
              ] else if (selectedButtonIndex == 1) ...[
                // Display content for Button 2
                Positioned(
                  top: Height * 0.335,
                  right: Width * 0.08,
                  left: Width * 0.5,
                  child: Divider(
                    height: 1,
                    thickness: 6,
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: Height * 0.4),
                    Center(
                      child: Container(
                        width: Width * 0.75,
                        height: Height * 0.56,
                        color: Colors.white,
                        child: Center(
                          child: Text("Coming soon..."),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}
