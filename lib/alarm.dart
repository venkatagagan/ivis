import 'package:flutter/material.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/cctv/camList.dart';
import 'package:ivis_security/navigation.dart';
import 'package:ivis_security/home.dart';
import 'package:ivis_security/drawer.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AlarmScreen extends StatefulWidget {
  String siteId;
  String Sitename;
  int i;

  AlarmScreen({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AlarmScreen> {
  int selectedButtonIndex = 0; // Track the selected button
  DateTime FromDate=DateTime.now().subtract(Duration(days: 1));
  DateTime ToDate =DateTime.now().subtract(Duration(days: 2));

  DateTime _selectedFromDate=DateTime.now().subtract(Duration(days: 2));
  DateTime _selectedToDate= DateTime.now().subtract(Duration(days: 1));

  String siteId = '';
  String sitename = '';
  int currentIndex = 0;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  List<TdpCamera> listOfCamera = [];

  int sitID = 36323;

  late Map<String, dynamic> services;
  String alarm = "F";
  //site names
  List<dynamic> siteNames = [];

  Future<Map<String, List>>? _actionTagIncidents;
  Map<String, bool> _expandedState = {};

  Future<Map<String, List>> fetchActionTagIncidents(
      int siteId, DateTime fromDate, DateTime toDate) async {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final String fromDateString = dateFormat.format(fromDate);
    final String toDateString = dateFormat.format(toDate);
    final response = await http.get(Uri.parse(
        'http://rsmgmt.ivisecurity.com:8945/incidents/ListIncidentsForMobileApp_1_0?siteId=$siteId&fromDate=$fromDateString&toDate=$toDateString'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List incidents = data['IncidentList'];

      Map<String, List> actionTagIncidents = {};

      for (var incident in incidents) {
        String actionTag = incident['actionTag'];
        if (actionTagIncidents.containsKey(actionTag)) {
          actionTagIncidents[actionTag]!.add(incident);
        } else {
          actionTagIncidents[actionTag] = [incident];
        }
      }

      return actionTagIncidents;
    } else {
      throw Exception('Failed to load incident list');
    }
  }

  @override
  void initState() {
    super.initState();
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;

    sitID = int.parse(widget.siteId);
    _selectedFromDate =  DateTime.now().subtract(Duration(days: 2));
    _selectedToDate =  DateTime.now().subtract(Duration(days: 1));
    _actionTagIncidents =
        fetchActionTagIncidents(sitID, _selectedFromDate!, _selectedToDate!);
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

        alarm = services['siteServicesList']['alerts'] ?? 'F';
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
                            builder: (context) => AlarmScreen(
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
                            builder: (context) => AlarmScreen(
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
              left: MediaQuery.of(context).size.width / 2 -
                  75, // Adjust the position from the left
              top: 135, // Center vertically
              child:SizedBox(width: MediaQuery.of(context).size.width*0.5, child: 
               Center(child:  Text(
                widget.Sitename,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
               ),
              ),
              ),
              
              

            ),
            Column(
              children: [
                SizedBox(
                  height: Height * 0.25,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Width * 0.05,
                    ),
                    Text(
                      'Start Date',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: Width * 0.3,
                    ),
                    Text(
                      'End Date',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: Height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Width * 0.05,
                    ),
                    Container(
                      width: Width * 0.4,
                      height: Height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0, top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                style: TextStyle(fontSize: 15),
                                controller: toDateController,
                                decoration: InputDecoration(
                                  hintText: DateFormat('yyyy-MM-dd').format(_selectedToDate).toString(),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                ).then((ToDate) {
                                  if (ToDate != null) {
                                    setState(() {
                                      this.ToDate = ToDate;
                                      toDateController.text =
                                          ToDate.toString().split(' ')[0];
                                          FromDate = DateTime.now();
                                    });
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Width * 0.08,
                    ),
                    Container(
                      width: Width * 0.4,
                      height: Height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 0, top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                style: TextStyle(fontSize: 15),
                                controller: fromDateController,
                                decoration: InputDecoration(
                                  hintText: DateFormat('yyyy-MM-dd').format(_selectedFromDate).toString(),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
  onPressed: () {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          this.FromDate = selectedDate;
          fromDateController.text = selectedDate.toString().split(' ')[0];
          fetchActionTagIncidents(sitID, ToDate, selectedDate); // Call fetchActionTagIncidents here
        });
      }
    });
  },
  icon: Icon(
    Icons.calendar_today,
    size: 20,
    color: Colors.grey,
  ),
),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Height*0.02,),
                FutureBuilder<Map<String, List>>(
                  future: _actionTagIncidents,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No incidents found.'));
                    } else {
                      final actionTagIncidents = snapshot.data!;
                      return Expanded(
                        child: ListView.builder(
                          itemCount: actionTagIncidents.length,
                          itemBuilder: (context, index) {
                            String actionTag =
                                actionTagIncidents.keys.elementAt(index);
                            int count = actionTagIncidents[actionTag]!.length;
                            bool isExpanded =
                                _expandedState[actionTag] ?? false;

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _expandedState[actionTag] = !isExpanded;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: Height *
                                            0.03), // Add space between containers
                                    height: Height * 0.05,
                                    width: Width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: Width * 0.05,
                                        ),
                                        Image.asset(
                                          'assets/logos/eye.jpg', // Replace with your image path
                                          width: Width *
                                              0.07, // Adjust image width as needed
                                          height: Height *
                                              0.02, // Adjust image height as needed
                                        ),
                                        SizedBox(
                                          width: Width * 0.03,
                                        ),
                                        SizedBox(
                                          width: Width * 0.6,
                                          child: Text(actionTag),
                                        ),
                                        Text(count.toString()),
                                        SizedBox(
                                          width: Width * 0.03,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isExpanded)
                                  ...actionTagIncidents[actionTag]!
                                      .map((incident) {
                                    DateTime startDateTime = DateTime.parse(
                                        incident['eventFromTime']);
                                    DateTime endDateTime =
                                        DateTime.parse(incident['eventToTime']);
                                    Duration duration =
                                        endDateTime.difference(startDateTime);
                                    String durationString =
                                        "${duration.inHours}${duration.inMinutes.remainder(60)}";

                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: Width * 0.67,
                                                child: Text(incident['name'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              SizedBox(
                                                width: Width * 0.15,
                                                child: Text(
                                                    incident['objectName'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                            ],
                                          ),
                                          Text(
                                              "Start Time: ${incident['eventFromTime']}",
                                              style: TextStyle(fontSize: 14)),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: Width * 0.6,
                                                child: Text(
                                                    'End Time: ${incident['eventToTime']}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: Width * 0.2,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Dialog(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Container(
                                                            height: 400,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    'Files',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: ListView
                                                                      .builder(
                                                                    itemCount: incident[
                                                                            'files']
                                                                        .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child: Image
                                                                            .network(
                                                                          '${incident['files'][index]}',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          errorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Icon(Icons.error);
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('View'),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                              "Duration: ${duration.inHours.toString().padLeft(2, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          siteId: siteId,
          Sitename: sitename,
          i: currentIndex,
        ),
        drawer: DrawerWidget(),
      ),
    );
    //return Scaffold(

    //);
  }
}
