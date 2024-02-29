import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/development.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/hdtv.dart';
import 'package:ivis_security/cctv.dart';
import 'package:ivis_security/contact.dart';
import 'package:ivis_security/reset.dart';
import 'package:ivis_security/home.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RequestScreen> {
  int selectedButtonIndex = 0;
  // Track the selected button
  bool isChecked = false;
  void onButtonPressed(int index) {
    setState(() {
      selectedButtonIndex = index; // Update the selected button index
    });
  }

  List<String> categoryList = [];
  String selected = '';
  List<String> subCatList = [];
  int i=0;
  String subCatSelected = '';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchStatus();
    subCatData(categoryList.indexOf(selected) ?? 0);
  }

  Future<void> subCatData(int i) async {
    const String apiUrl =
        'http://usmgmt.iviscloud.net:777/businessInterface/helpdesk/categoryList_1_0';

    // JSON data to be sent in the POST request
    Map<String, dynamic> requestData = {
      "userName": "ivisus",
      "accessToken": "abc",
      "calling_System_Detail": "portal",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> categoryData = data['CategoryList'];

        if (categoryData.length > 1) {
          final Map<String, dynamic> secondCategory = categoryData[i];
          final List<dynamic> subCategoryList =
              secondCategory['subCategoryList'];

          setState(() {
            subCatList = subCategoryList
                .map((subCategory) =>
                    subCategory['serviceSubcatName'].toString())
                .toList();
          });
        }
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  int indexOfSelectedCategory() {
    return categoryList.indexOf(selected);
  }

  Future<void> fetchData() async {
    const String apiUrl =
        'http://usmgmt.iviscloud.net:777/businessInterface/helpdesk/categoryList_1_0';

    // JSON data to be sent in the POST request
    Map<String, dynamic> requestData = {
      "userName": "ivisus",
      "accessToken": "abc",
      "calling_System_Detail": "portal",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> categoryData = data['CategoryList'];

        setState(() {
          categoryList = categoryData
              .map((category) => category['catName'].toString())
              .toList();
        });
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }

  //status api
  Future<Map<String, dynamic>> fetchStatus() async {
    final response = await http.post(
      Uri.parse(
          'http://usmgmt.iviscloud.net:777/businessInterface/helpdesk/getServiceReq_1_0'),
      body: jsonEncode({
        "userName": "ivisus",
        "accessToken": "abc",
        "calling_System_Detail": "portal",
        "siteId": 1004,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      // You might want to throw an exception or handle the error case accordingly
      throw Exception(
          'Failed to fetch data. Status code: ${response.statusCode}');
    }
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
              alignment: Alignment.center,
            ),
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
              ],
            ),
            Positioned(
              right: 30, // Adjust the position from the right
              top: 125, // Center vertically
              child: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  // Handle right arrow button press
                },
                iconSize: 40, // Adjust the size of the button
                color: Colors.white, // Adjust the color of the button
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 -
                  75, // Adjust the position from the left
              top: 135, // Center vertically
              child: const Text(
                'ONE STOP ODESSA',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
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
            const Positioned(
              top: 250, // Adjust the top position as needed
              left: 30.5, // Adjust the left position as needed
              right: 30.5, // Adjust the right position as needed
              child: Divider(
                height: 1, // Set the height of the line
                thickness: 1, // Set the thickness of the line
                color: Colors.white, // Set the color of the line
              ),
            ),
            Positioned(
              top: 202, // Adjust the position from the bottom
              left: 58, // Adjust the position from the left
              child: TextButton(
                onPressed: () => onButtonPressed(0),
                child: const Text(
                  'NEW REQUEST',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to black
                  ),
                ),
              ),
            ),
            Positioned(
              top: 202, // Adjust the position from the bottom
              left: 199, // Adjust the position from the left
              child: TextButton(
                onPressed: () => onButtonPressed(1),
                child: const Text(
                  'REQUEST STATUS',
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
                      Expanded(
                        child: SingleChildScrollView(
                      child:Container(
                        width: 300,
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
                                  height: 18,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      height: 60,
                                      width: 260,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: DropdownButton<String>(
                                          value: selected.isNotEmpty
                                              ? selected
                                              : null,
                                          hint: Text('catName'),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selected = newValue!;
                                              
                                            });
                                          },
                                          items: categoryList
                                              .map((fruit) =>
                                                  DropdownMenuItem<String>(
                                                    value: fruit,
                                                    child: Text(fruit),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      height: 60,
                                      width: 260,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child:Center(
                                      child: DropdownButton<String>(
                                        value: subCatSelected.isNotEmpty
                                            ? subCatSelected
                                            : null,
                                        hint: Text('subcat'),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            subCatSelected = newValue!;
                                          });
                                        },
                                        items: subCatList
                                            .map((fruit) =>
                                                DropdownMenuItem<String>(
                                                  value: fruit,
                                                  child: Text(fruit),
                                                ))
                                            .toList(),
                                      ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 260,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Description here',
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(16),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 17,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 0,
                                    ),
                                    Text("Preferred Time to Call Back"),
                                  ],
                                ),
                                SizedBox(
                                  height: 17,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        // Add your button press logic here
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Colors
                                                .blue), // Specify the border color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Adjust border radius as needed
                                        ),
                                      ),
                                      child: Text(
                                        'Set Time',
                                        style: TextStyle(
                                            color: Colors
                                                .blue), // Specify text color
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 75,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                25.0), // Adjust the radius as needed
                                          ),
                                        ),
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(
                                                150, 50)), // Set the size here
                                      ),
                                      child: const Text('SUBMIT'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            )),
                      ),
                      ),
                      ),
                      SizedBox(
                        height: 50,
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
                      Expanded(
                        child: SingleChildScrollView(
                          child: FutureBuilder(
                            future: fetchStatus(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  !snapshot.hasError) {
                                if (snapshot.data != null &&
                                    snapshot.data!['helpDeskList'] != null) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        YourWidget(
                                          helpDeskList:
                                              (snapshot.data!['helpDeskList']
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
            ],
            Positioned(
              bottom: 0, // Adjust the position from the bottom
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 65,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0), // Adjust the left padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CctvScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/bx-cctv.png', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AlarmScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/alarm.png', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DevelopmentScreen()),
                              );
                              // Handle the button press event here
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/development.png', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CenterScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/center-circle.jpg', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HdtvScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/hdtv.png', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle the button press event here
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 0), // Adjust the left padding
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/logos/plus-square.jpg', // Replace with your image path
                                    width:
                                        19.93, // Adjust image width as needed
                                    height:
                                        19.67, // Adjust image height as needed
                                  ), // Add spacing between text and image
                                ],
                              ),
                            ),
                          ), // Positioned widget at the top-left corner
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    //return Scaffold(

    //);
  }
}

@override
class YourWidget extends StatelessWidget {
  final List<Map<String, dynamic>> helpDeskList;

  YourWidget({required this.helpDeskList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),

        // Create a list of Container widgets for each item in analyticsList
        for (var analytics in helpDeskList) ...[
          SizedBox(
            height: 10,
          ),

          // ignore: unnecessary_null_comparison
          if (analytics != null && analytics is String)
            SingleChildScrollView(
              child: Container(
                width: 260,
                height: 90,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: Colors.grey, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 0, left: 0), // Adjust the left padding
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: 260,
                          height: 38,
                          color: Color.fromARGB(255, 220, 222, 222),
                          // Replace with the desired color
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Positioned(
                                top: 10,
                                left: 13,
                                child: Text(
                                  '${'serviceId'}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 170,
                                child: Text(
                                  '${'status'}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                left: 235,
                                child: Icon(
                                  Icons
                                      .chevron_right, // Replace with the desired icon
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 44,
                        left: 13,
                        child: Text(
                          '${'serviceSubCategoryName'}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 44,
                        left: 188,
                        child: Text(
                          '${'createdTime'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 63,
                        left: 13,
                        child: Text(
                          '${'description'}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 63,
                        left: 180,
                        child: Icon(
                          Icons.edit_rounded, // Replace with the desired icon
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        top: 63,
                        left: 203,
                        child: Icon(
                          Icons
                              .preview_rounded, // Replace with the desired icon
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        top: 63,
                        left: 230,
                        child: Icon(
                          Icons.delete, // Replace with the desired icon
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Add more widgets or modify the Container as needed
        ],
      ],
    );
  }
}
