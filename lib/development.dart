import 'package:flutter/material.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/apis/Services.dart';
import 'package:ivis_security/apis/analytics.dart';
import 'package:ivis_security/cctv/camList.dart';
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
  List<String> disabledDates = [];

  final _dateController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
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

    sitID = int.parse(widget.siteId);

    fetchData(sitID);
    fetchSiteNames();

    // Initialize selectedFromDate and selectedToDate here
    notWorkingDays(Year,widget.siteId);
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

  List<TdpCamera> listOfCamera = [];

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
                            builder: (context) => DevelopmentScreen(
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
                            builder: (context) => DevelopmentScreen(
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
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: Center(
                      child: Text(
                    widget.Sitename,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ))),
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => onButtonPressed(0),
                      child: const Text(
                        'ANALYTICS',
                        style: TextStyle(
                          color: Colors.white, // Set the text color to black
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                    ),
                    TextButton(
                      onPressed: () => onButtonPressed(1),
                      child: const Text(
                        'REPORTS',
                        style: TextStyle(
                          color: Colors.white, // Set the text color to black
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 30.5,
                    ),
                    Divider(
                      height: 1, // Set the height of the line
                      thickness: 1, // Set the thickness of the line
                      color: Colors.white, // Set the color of the line
                    ),
                  ],
                )
              ],
            ),
            if (selectedButtonIndex == 0) ...[
              // Display content for Button 1
              const Positioned(
                top: 253, // Adjust the position from the bottom
                left: 30.5,
                right: 179.5,
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
                        height: 50,
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
                                    controller: dateController,
                                    decoration: InputDecoration(
                                      hintText: 'yyyy-mm-dd',
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
                                ? Center(child: CircularProgressIndicator())
                                : TableCalendar(
                                    locale: 'en_US',
                                    firstDay: DateTime(2000),
                                    lastDay: DateTime.now(),
                                    focusedDay: _focusedDay,
                                    selectedDayPredicate: (day) {
                                      return isSameDay(_selectedDay, day);
                                    },
                                    onPageChanged: (DateTime focusedDay) {
                                      final currentYear = focusedDay.year;
                                      fetchData(currentYear);
                                    },
                                    onDaySelected: (selectedDay, focusedDay) {
                                      if (!_notWorkingDays.contains(
                                          DateFormat('yyyy-MM-dd')
                                              .format(selectedDay))) {
                                        setState(() {
                                          _selectedDay = selectedDay;
                                          _focusedDay = focusedDay;
                                          fetchData(focusedDay.year);

                                          _dateController.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(selectedDay);
                                          Navigator.pop(
                                              context); // Close the dialog
                                        });
                                      }
                                    },
                                    calendarBuilders: CalendarBuilders(
                                      disabledBuilder: (context, date, _) {
                                        final dateFormat =
                                            DateFormat('yyyy-MM-dd');
                                        if (_notWorkingDays.contains(
                                            dateFormat.format(date))) {
                                          return Center(
                                            child: Text(
                                              DateFormat.d().format(date),
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          );
                                        }
                                        return null;
                                      },
                                    ),
                                    enabledDayPredicate: (date) {
                                      final dateFormat =
                                          DateFormat('yyyy-MM-dd');
                                      return !_notWorkingDays
                                          .contains(dateFormat.format(date));
                                    },
                                    availableCalendarFormats: {
                                      CalendarFormat.month: 'Month',
                                    },
                                    calendarStyle: CalendarStyle(
                                      isTodayHighlighted: true,
                                      selectedDecoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      todayDecoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      disabledTextStyle:
                                          TextStyle(color: Colors.red),
                                    ),
                                    headerStyle: HeaderStyle(
                                        formatButtonVisible: false,
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
                          child: FutureBuilder(
                            future: fetchDatas(selectedDate, int.parse(siteId)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  !snapshot.hasError) {
                                if (snapshot.data != null &&
                                    snapshot.data!['AnalyticsList'] != null) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        YourWidget(
                                          analyticsList:
                                              (snapshot.data!['AnalyticsList']
                                                      as List<dynamic>)
                                                  .cast<Map<String, dynamic>>(),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text('No data available'),
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
                left: 180.5,
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
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 35,
                                    ),
                                    Text(
                                      'BUSINESS INTELLIGENCE REPORT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              13 // Set the text color to black
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 23,
                                    ),
                                    // From Date
                                    Container(
                                      width: 110,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(1),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 0, top: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0, top: 0),
                                                child: TextField(
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                  controller:
                                                      fromDateController,
                                                  decoration: InputDecoration(
                                                    hintText: 'From Date',
                                                    border: InputBorder.none,
                                                  ),
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
                                                ).then((FromDate) {
                                                  if (FromDate != null) {
                                                    setState(() {
                                                      this.FromDate = FromDate;
                                                      fromDateController.text =
                                                          FromDate.toString()
                                                              .split(' ')[0];
                                                    });
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                Icons.calendar_today,
                                                size: 14.09,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 44,
                                    ),
                                    // To Date
                                    Container(
                                      width: 110,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(1),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 0, top: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                style: TextStyle(fontSize: 11),
                                                controller: toDateController,
                                                decoration: InputDecoration(
                                                  hintText: 'To Date',
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
                                                          ToDate.toString()
                                                              .split(' ')[0];
                                                    });
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                Icons.calendar_today,
                                                size: 14.09,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 34,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            side: BorderSide(
                                                color: Colors.blue,
                                                width:
                                                    2.0), // Adjust the radius as needed
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(
                                                100, 35)), // Set the size here
                                      ),
                                      child: const Text('Email'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _callApi(FromDate, ToDate);
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            // Adjust the radius as needed
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(
                                                100, 35)), // Set the size here
                                      ),
                                      child: const Text('Download'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              top: 69,
                              left: 150,
                              child: Text("-"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            if (bi == "F") // change logic as alarm == "F"
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
        ),
        drawer: DrawerWidget(),
      ),
    );
    //return Scaffold(

    //);
  }

  //disable not working dates

  Future<void> notWorkingDays(int year,String siteId) async {
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
        _focusedDay = _selectedDay!;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDay!);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

// Modify your initState to use the async function

// Rest of your code remains the same...

  Future<void> downloadPdf(FromDate, ToDate) async {
    // Replace 'YOUR_PDF_API_URL' with your actual API endpoint
    final pdfApiUrl =
        'http://usmgmt.iviscloud.net:777/businessInterface/insights/getPdfReport?siteId=1003&startdate=$ToDate&enddate=$ToDate&calling_System_Detail=IVISUSA';

    try {
      final response = await http.get(Uri.parse(pdfApiUrl));

      if (response.statusCode == 200) {
        final documentDirectory = await getApplicationDocumentsDirectory();
        final file = File('${documentDirectory.path}/downloaded_file.pdf');

        await file.writeAsBytes(response.bodyBytes);

        print('PDF downloaded and saved to: ${file.path}');
      } else {
        throw Exception('Failed to download PDF');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }
}

Future<void> _callApi(DateTime FromDate, DateTime ToDate) async {
  final String fromDate = DateFormat('yyyy/MM/dd').format(FromDate);
  final String toDate = DateFormat('yyyy/MM/dd').format(ToDate);

  final apiUrl =
      "http://usmgmt.iviscloud.net:777/businessInterface/insights/getPdfReport?siteId=1003&startdate=$fromDate&enddate=$toDate&calling_System_Detail=IVISUSA";

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Handle the API response as needed
      print("API Call Successful");
    } else {
      // Handle errors or different status codes
      print("API Call Failed. Status code: ${response.statusCode}");
    }
  } catch (e) {
    // Handle exceptions or network errors
    print("Error during API call: $e");
  }
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),

        // Create a list of Container widgets for each item in analyticsList
        for (var analytics in analyticsList) ...[
          SizedBox(
            height: 10,
          ),

          // ignore: unnecessary_null_comparison
          if (analytics != null && analytics['service'] is String)
            SingleChildScrollView(
              child: Container(
                width: 300,
                height: 100,
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
                          height: 14,
                        ),
                        SizedBox(
                            width: 300,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 18,
                                ),
                                Flexible(
                                  flex: 2, // Adjust this flex value as needed
                                  child: Text(
                                    analytics['service'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  flex: 2, // Adjust this flex value as needed
                                  child: Text(
                                    '(Compare with prior period)',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 18,
                            ),
                            Container(
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                color: getColorBasedOnCriteria(
                                    analytics['analytics'][0]['status']),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Text(
                                        '${analytics['analytics'][0]['type']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: 35,
                                        child: Text(
                                          '(${analytics['analytics'][0]['percentage']}%)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${analytics['analytics'][0]['count']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                color: getColorBasedOnCriteria(
                                    analytics['analytics'][1]['status']),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${analytics['analytics'][1]['type']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: 32,
                                        child: Text(
                                          '(${analytics['analytics'][1]['percentage']}%)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${analytics['analytics'][1]['count']}",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                color: getColorBasedOnCriteria(
                                    analytics['analytics'][3]['status']),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Text(
                                        'QTR',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      SizedBox(
                                        width: 33,
                                        child: Text(
                                          '(${analytics['analytics'][3]['percentage']}%)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${analytics['analytics'][3]['count']}",
                                        style: TextStyle(
                                          color: Colors.white,
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
