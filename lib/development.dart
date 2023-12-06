import 'package:flutter/material.dart';
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/cctv.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/hdtv.dart';
import 'package:ivis_security/contact.dart';
import 'package:ivis_security/reset.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:ivis_security/home.dart';
import 'package:ivis_security/apis/analytics.dart';

// Import your API service file

void main() async {
  runApp(DevelopmentScreen());
}

class DevelopmentScreen extends StatefulWidget {
  const DevelopmentScreen({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DevelopmentScreen> {
  // Track the selected button
  DateTime selectedDate = DateTime.now();
  DateTime FromDate = DateTime.now();
  DateTime ToDate = DateTime.now();

  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    selectedDate = DateTime.now();
    FromDate = DateTime.now();
    ToDate = DateTime.now();
    // Initialize selectedDate here
  }

  int selectedButtonIndex = 0; // Track the selected button

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
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Background Image

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
                Row(
                  children: [
                    SizedBox(
                      width: 13.13,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),

                      onPressed: () {
                        // Handle right arrow button press
                      },
                      iconSize: 40, // Adjust the size of the button
                      color: Colors.white, // Adjust the color of the button
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'ONE STOP ODESSA',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        // Handle right arrow button press
                      },
                      iconSize: 40, // Adjust the size of the button
                      color: Colors.white, // Adjust the color of the button
                    ),
                  ],
                ),
                Divider(
                  height: 1, // Set the height of the line
                  thickness: 1, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                    ),
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
                      width: 65,
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
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2030),
                                  ).then((selectedDate) {
                                    if (selectedDate != null) {
                                      setState(() {
                                        this.selectedDate = selectedDate;
                                        dateController.text = selectedDate
                                            .toString()
                                            .split(' ')[0];
                                      });
                                    }
                                  });
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
                      Center(
                        child: FutureBuilder(
                          future: fetchData(selectedDate),
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
                                    Container(
                                      width: 110,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(1),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors
                                              .grey, // Set the border color to grey
                                          width: 1, // Set the border width
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
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: TextField(
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                  controller: dateController,
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
                                                  lastDate: DateTime(2030),
                                                ).then((selectedDate) {
                                                  if (selectedDate != null) {
                                                    setState(() {
                                                      this.selectedDate =
                                                          selectedDate;
                                                      dateController.text =
                                                          selectedDate
                                                              .toString()
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
                                    Container(
                                      width: 110,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(1),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors
                                              .grey, // Set the border color to grey
                                          width: 1, // Set the border width
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
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: TextField(
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                  controller: dateController,
                                                  decoration: InputDecoration(
                                                    hintText: 'To Date',
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
                                                  lastDate: DateTime(2030),
                                                ).then((selectedDate) {
                                                  if (selectedDate != null) {
                                                    setState(() {
                                                      this.selectedDate =
                                                          selectedDate;
                                                      dateController.text =
                                                          selectedDate
                                                              .toString()
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
                                        downloadPdf(FromDate, ToDate);
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
            SizedBox(
              height: 20,
            ),
            // Your API Data Display (adjust as needed)
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/logos/bx-cctv.png',
                  width: 19.93, // Adjust image width as needed
                  height: 19.67,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CctvScreen()),
                  );
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
                    MaterialPageRoute(
                        builder: (context) => const AlarmScreen()),
                  ); // Handle settings button press
                },
              ),
              IconButton(
                icon: Image.asset(
                  'assets/logos/development.jpg', // Replace with your image path
                  width: 19.93, // Adjust image width as needed
                  height: 19.67, // Adjust image height as needed
                ),
                onPressed: () {
                  // Handle settings button press
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
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                color: const Color.fromARGB(
                    255, 120, 63, 59), // Background color for the custom header
                height: 230, // Height of the custom header
                child: const Stack(
                  children: [
                    // Positioned user avatar
                    Positioned(
                      top: 20,
                      left: 20,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                    ),
                    // Positioned account name
                    Positioned(
                      top: 44,
                      left: 100,
                      right: 73,
                      child: Text(
                        "NAME              +91XXXXXXXXXX name@email.com",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 108,
                      left: 100,
                      right: 86,
                      child: Text(
                        "Address Line 1 Address Line 2 District/City State, Country Pincode",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 207,
                      left: 100,
                      child: Text(
                        "+91 1234512345",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Positioned account email
                  ],
                ),
              ),
              //
              const SizedBox(
                height: 25,
              ),
              ListTile(
                title: const Text("RESET PASSWORD"),
                onTap: () {
                  // Handle home item tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResetScreen()),
                  ); // Close the drawer
                },
              ),
              const SizedBox(
                height: 25,
              ),
              ListTile(
                title: const Text("CONTACT"),
                onTap: () {
                  // Handle settings item tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactScreen()),
                  ); // Close the drawer
                },
              ),
              const SizedBox(
                height: 25,
              ),
              ListTile(
                minLeadingWidth: 25,
                title: const Text("TERMS & CONDITIONS"),
                onTap: () {
                  // Handle settings item tap
                  Navigator.pop(context); // Close the drawer
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                        Row(
                          children: [
                            SizedBox(
                              width: 18,
                            ),
                            Text(
                              '${analytics['service']}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  '(Compare with prior period)',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
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
                                      Text(
                                        '(${analytics['analytics'][0]['percentage']}%)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
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
                                      Text(
                                        '(${analytics['analytics'][1]['percentage']}%)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
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
                                      Text(
                                        '(${analytics['analytics'][3]['percentage']}%)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
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
