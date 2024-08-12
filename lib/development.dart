import 'package:flutter/material.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:ivis_security/apis/analytics.dart';
import 'package:ivis_security/drawer.dart';
import 'package:ivis_security/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:ivis_security/home.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// Import your API service file

// ignore: must_be_immutable
class DevelopmentScreen extends StatefulWidget {
  String siteId;
  String Sitename;
  int i;

  DevelopmentScreen({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DevelopmentScreen> {
  // Track the selected button
  DateTime selectedDate = DateTime.now();
  DateTime FromDate = DateTime.now();
  DateTime ToDate = DateTime.now();
  String siteId = '';
  TextEditingController dateController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  //DateTime? _selectedDay;
  //List<String> disabledDates = [""];

  final _dateController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<String> _notWorkingDays = [];
  bool _isLoading = false;
  int Year = DateTime.now().year;

  String sitename = '';
  int currentIndex = 0;
  int sitID = 36323;
  String bi = "F";

  late Map<String, dynamic> services;

  @override
  void initState() {
    super.initState();
    fromDateController = TextEditingController();
    toDateController = TextEditingController();

    dateController = TextEditingController();
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;
    selectedDate = _selectedDay;
    sitID = int.parse(widget.siteId);

    fetchData(sitID);
    fetchSiteNames();
    // Initialize selectedFromDate and selectedToDate here
    notWorkingDays(Year, widget.siteId);
  }

  Future<void> fetchData(int accountId) async {
    try {
      final Map<String, dynamic> response =
          await ApiService.fetchClientServices(accountId);

      setState(() {
        services = response;

        bi = services['siteServicesList']['insights'] ?? 'F';
      });
    } catch (e) {
      print('Error fetching client services: $e');
      // Handle errors...
    }
  }

  List<dynamic> siteNames = [];

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

  int selectedButtonIndex = 0; // Track the selected button

  void onButtonPressed(int index) {
    setState(() {
      selectedButtonIndex = index; // Update the selected button index
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                                          siteNames[currentIndex - 1]['siteId']
                                              .toString();
                                      String sitename =
                                          siteNames[currentIndex - 1]
                                                  ['siteName']
                                              .toString();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DevelopmentScreen(
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
                                          siteNames[currentIndex + 1]['siteId']
                                              .toString();
                                      String sitename =
                                          siteNames[currentIndex + 1]
                                                  ['siteName']
                                              .toString();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DevelopmentScreen(
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
              if (bi == "T") ...[
                // Display content for Button 1
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: Height * 0.18,
                        ),
                        SizedBox(
                            height: Height * 0.035,
                            child: Text(
                              "Analytics",
                              style:
                                  TextStyle(color: Colors.white,fontFamily: 'Montserrat', fontSize: 20),
                            )),
                        SizedBox(
                          height: Height * 0.03,
                        ),
                        SizedBox(
                          width: Width * 0.8,
                          child: Divider(
                            height: 1, // Set the height of the line
                            thickness: 6, // Set the thickness of the line
                            color: Colors.white, // Set the color of the line
                          ),
                        ),
                        SizedBox(
                          height: Height * 0.025,
                        ),
                        Container(
                          width: Width * 0.8,
                          height: Height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, top: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: TextField(
                                      controller: _dateController,
                                      decoration: InputDecoration(
                                        hintText: 'yyyy-mm-dd',hintStyle: TextStyle(fontFamily: 'Montserrat',),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _isLoading
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator())
                                                : TableCalendar(
                                                    locale: 'en_US',
                                                    firstDay: DateTime(2000),
                                                    lastDay: DateTime.now(),
                                                    focusedDay: _focusedDay,
                                                    selectedDayPredicate:
                                                        (day) {
                                                      return isSameDay(
                                                          _selectedDay, day);
                                                    },
                                                    onPageChanged:
                                                        (DateTime focusedDay) {
                                                      final currentYear =
                                                          focusedDay.year;
                                                      notWorkingDays(
                                                          currentYear,
                                                          widget.siteId);
                                                      ;
                                                    },
                                                    onDaySelected: (selectedDay,
                                                        focusedDay) {
                                                      if (!_notWorkingDays
                                                          .contains(DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  selectedDay))) {
                                                        setState(() {
                                                          _selectedDay =
                                                              selectedDay;
                                                          _focusedDay =
                                                              focusedDay;

                                                          _dateController
                                                              .text = DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(
                                                                  selectedDay);
                                                          Navigator.pop(
                                                              context); // Close the dialog
                                                        });
                                                      }
                                                    },
                                                    calendarBuilders:
                                                        CalendarBuilders(
                                                      disabledBuilder:
                                                          (context, date, _) {
                                                        final dateFormat =
                                                            DateFormat(
                                                                'yyyy-MM-dd');
                                                        if (_notWorkingDays
                                                            .contains(dateFormat
                                                                .format(
                                                                    date))) {
                                                          return Center(
                                                            child: Text(
                                                              DateFormat.d()
                                                                  .format(date),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          );
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    enabledDayPredicate:
                                                        (date) {
                                                      final dateFormat =
                                                          DateFormat(
                                                              'yyyy-MM-dd');
                                                      return !_notWorkingDays
                                                          .contains(dateFormat
                                                              .format(date));
                                                    },
                                                    availableCalendarFormats: {
                                                      CalendarFormat.month:
                                                          'Month',
                                                    },
                                                    calendarStyle:
                                                        CalendarStyle(
                                                      isTodayHighlighted: true,
                                                      selectedDecoration:
                                                          BoxDecoration(
                                                        color: Colors.blue,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      todayDecoration:
                                                          BoxDecoration(
                                                        color: Colors.orange,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      disabledTextStyle:
                                                          TextStyle(
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                    headerStyle: HeaderStyle(
                                                        formatButtonVisible:
                                                            false,
                                                        titleCentered: true),
                                                  ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Close'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.calendar_today),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: FutureBuilder<Map<String, dynamic>>(
                              future:
                                  fetchDatas(_selectedDay, int.parse(siteId)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Error: ${snapshot.error}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  } else if (snapshot.data == null ||
                                      snapshot.data!['AnalyticsList'] == null) {
                                    return Center(
                                      child: Text(
                                        'No data available',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  } else if (snapshot.data!['AnalyticsList']
                                          is List &&
                                      (snapshot.data!['AnalyticsList'] as List)
                                          .isEmpty) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Empty'),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.data!['AnalyticsList']
                                          is List &&
                                      (snapshot.data!['AnalyticsList'] as List)
                                          .isNotEmpty) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          YourWidget(
                                            analyticsList: (snapshot
                                                        .data!['AnalyticsList']
                                                    as List<dynamic>)
                                                .cast<Map<String, dynamic>>(),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Text(
                                        'No data available',
                                        style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),
                                      ),
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),

                // Add rows and columns specific to Button 1
              ],
              if (bi == "F") // change logic as alarm == "F"
                ...[
                Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.143),
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
          selected: 2,
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

  //disable not working dates

  Future<void> notWorkingDays(int year, String siteId) async {
    setState(() {
      _isLoading = true;
    });

    final url =
        'http://rsmgmt.ivisecurity.com:951/insights/notWorkingDays_1_0?siteId=$siteId&year=$year';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> notWorkingDaysList =
          List<String>.from(data['NotWorkingDaysList']);
      String lastWorkingDay = data['LastWorkingDay'];

      setState(() {
        _notWorkingDays = notWorkingDaysList;
        _selectedDay = DateTime.parse(lastWorkingDay);
        _focusedDay = _selectedDay;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDay);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
// Modify your initState to use the async function
// Rest of your code remains the same...
}

@override
class YourWidget extends StatelessWidget {
  final List<Map<String, dynamic>> analyticsList;

  YourWidget({required this.analyticsList});
  Color getColorBasedOnCriteria(String type) {
    // Your logic to determine the color based on the 'type'
    // For example, let's say if type is 'A' use red, if 'B' use green, else use yellow
    if (type == 'Raise') {
      return Colors.green.withOpacity(1);
    } else if (type == 'Fall') {
      return Colors.red.withOpacity(1);
    } else {
      return Colors.yellow.withOpacity(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Create a list of Container widgets for each item in analyticsList
        for (var analytics in analyticsList) ...[
          SizedBox(
            height: Height * 0.01,
          ),

          // ignore: unnecessary_null_comparison
          if (analytics != null && analytics['service'] is String)
            SingleChildScrollView(
              child: Container(
                width: Width * 0.8,
                height: Height * 0.14,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                    padding: EdgeInsets.only(
                        top: 0, left: 0), // Adjust the left padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Height * 0.02,
                        ),
                        SizedBox(
                            width: Width * 0.8,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: Width * 0.05,
                                ),
                                Flexible(
                                  flex: 2, // Adjust this flex value as needed
                                  child: Text(
                                    analytics['service'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: Width * 0.02,
                                ),
                                Flexible(
                                  flex: 2, // Adjust this flex value as needed
                                  child: Text(
                                    '(Compare with prior period)',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontFamily: 'Montserrat',
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: Height * 0.01,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: Width * 0.05,
                            ),
                            Container(
                              height: Height * 0.066,
                              width: Width * 0.22,
                              decoration: BoxDecoration(
                                color: getColorBasedOnCriteria(
                                    analytics['analytics'][0]['status']),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${analytics['analytics'][0]['type']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: Width * 0.1,
                                        height: Height * 0.012,
                                        child: Text(
                                          '(${analytics['analytics'][0]['percentage']}%)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 8,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${analytics['analytics'][0]['count']}',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Width * 0.03,
                            ),
                            Container(
                              height: Height * 0.066,
                              width: Width * 0.22,
                              decoration: BoxDecoration(
                                color: getColorBasedOnCriteria(
                                    analytics['analytics'][1]['status']),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${analytics['analytics'][1]['type']}',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: Width * 0.1,
                                        height: Height * 0.012,
                                        child: Text(
                                          '(${analytics['analytics'][1]['percentage']}%)',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.white,
                                            fontSize: 7,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${analytics['analytics'][1]['count']}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Width * 0.03,
                            ),
                            Container(
                              height: Height * 0.066,
                              width: Width * 0.22,
                              decoration: BoxDecoration(
                                color: getColorBasedOnCriteria(
                                    analytics['analytics'][3]['status']),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'QTR',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: Width * 0.1,
                                        height: Height * 0.012,
                                        child: Text(
                                          '(${analytics['analytics'][3]['percentage']}%)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${analytics['analytics'][3]['count']}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          // Add more widgets or modify the Container as needed
        ],
      ],
    );
  }
}
