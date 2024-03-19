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
import 'package:intl/intl.dart';

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

  List<dynamic> helpDeskList = [];
  List<dynamic> categoryList = [];
  List<dynamic> subCategoryList = [];
  String? catName;
  String? subCatName;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchStatus();
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse(
          'http://usmgmt.iviscloud.net:777/businessInterface/helpdesk/categoryList_1_0'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'userName': 'ivisus',
        'accessToken': 'abc',
        'calling_System_Detail': 'portal',
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        categoryList = data['CategoryList'];
      });
    } else {
      throw Exception('Failed to load category list');
    }
  }

  //status api
  String formatDate(String dateString) {
    // Parse the string into a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Format the DateTime object
    String formattedDate = DateFormat('dd, MMM, yyyy').format(date);

    return formattedDate;
  }

  Future<void> fetchStatus() async {
    final response = await http.post(
      Uri.parse(
          'http://usmgmt.iviscloud.net:777/businessInterface/helpdesk/getServiceReq_1_0'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'userName': 'ivisus',
        'accessToken': 'abc',
        'calling_System_Detail': 'portal',
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        helpDeskList = data['helpDeskList'];
      });
    } else {
      throw Exception('Failed to load service requests');
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
                          child: Container(
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
                                    SizedBox(
                                      width: 260,
                                      height: 60,
                                      child: DropdownButtonFormField<String>(
                                        value: catName,
                                        items: categoryList.map((item) {
                                          return DropdownMenuItem<String>(
                                            value: item['catName'].toString(),
                                            child: Text(
                                                item['catName'].toString()),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            catName = value;
                                            subCategoryList = [];
                                            if (value != null) {
                                              subCategoryList = categoryList
                                                  .firstWhere((element) =>
                                                      element['catName']
                                                          .toString() ==
                                                      value)['subCategoryList'];
                                              subCatName =
                                                  null; // Reset subcategory selection
                                            }
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Category',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(
                                      width: 260,
                                      height: 60,
                                      child: DropdownButtonFormField<String>(
                                        value: subCatName,
                                        items: subCategoryList.map((item) {
                                          return DropdownMenuItem<String>(
                                            value: item['serviceSubcatName']
                                                .toString(),
                                            child: Text(
                                                item['serviceSubcatName']
                                                    .toString()),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            subCatName = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Subcategory',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
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
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              width: 2,
                                            ),
                                          ),
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Description here',
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.all(16),
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
                                            minimumSize: MaterialStateProperty
                                                .all(const Size(150,
                                                    50)), // Set the size here
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

              Padding(
                padding: EdgeInsets.fromLTRB(50, 270, 50, 0),
                child: ListView.separated(
                  itemCount: helpDeskList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    // Add the space between containers here
                    return SizedBox(height: 20); // Adjust the height as needed
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final item = helpDeskList[index];
                    return Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                                    '${item['serviceId']}',
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
                                    '${item['status']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: item['status'] == 'Deleted'
                                          ? Colors.red
                                          : Colors.green,
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
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 13,
                              ),
                              SizedBox(
                                width: 156,
                                height: 18,
                                child: Text(
                                  '${item['serviceCategoryName']}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatDate('${item['createdTime']}'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 13,
                              ),
                              SizedBox(
                                width: 125,
                                height: 15,
                                child: Text(
                                  '${item['description']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons
                                      .edit_rounded, // Replace with the desired icon
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Add your onPressed functionality here
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(
                                            width: 300,
                                            margin: EdgeInsets.zero,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 300,
                                                  height: 50,
                                                  child: Container(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 18,
                                                ),
                                                SizedBox(
                                                  width: 260,
                                                  height: 60,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: catName,
                                                    items: categoryList
                                                        .map((item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item['catName']
                                                            .toString(),
                                                        child: Text(
                                                            item['catName']
                                                                .toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        catName = value;
                                                        subCategoryList = [];
                                                        if (value != null) {
                                                          subCategoryList = categoryList
                                                              .firstWhere((element) =>
                                                                  element['catName']
                                                                      .toString() ==
                                                                  value)['subCategoryList'];
                                                          subCatName =
                                                              null; // Reset subcategory selection
                                                        }
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Category',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                SizedBox(
                                                  width: 260,
                                                  height: 60,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: subCatName,
                                                    items: subCategoryList
                                                        .map((item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item[
                                                                'serviceSubcatName']
                                                            .toString(),
                                                        child: Text(item[
                                                                'serviceSubcatName']
                                                            .toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        subCatName = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Subcategory',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: 260,
                                                  height: 50,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Description here',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 17,
                                                ),
                                                SizedBox(
                                                  width: 260,
                                                  height: 60,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: subCatName,
                                                    items: subCategoryList
                                                        .map((item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item[
                                                                'serviceSubcatName']
                                                            .toString(),
                                                        child: Text(item[
                                                                'serviceSubcatName']
                                                            .toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        subCatName = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Subcategory',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 17,
                                                ),
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                      value: isChecked,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isChecked = value!;
                                                        });
                                                      },
                                                    ),
                                                    Text(
                                                      "Preferred Time to Call Back",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Center(
                                                    child: OutlinedButton(
                                                  onPressed: () {
                                                    // Add your button press logic here
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Colors
                                                            .blue), // Specify the border color
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // Adjust border radius as needed
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Set Time',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue), // Specify text color
                                                  ),
                                                )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SizedBox(
                                                  width: 260,
                                                  height: 50,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Note here',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .blue), // Blue border
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .white), // White background
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all(const Size(
                                                                    110,
                                                                    50)), // Set the size here
                                                      ),
                                                      child: const Text(
                                                        'cancel',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .blue, // Blue text color
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Icon(
                                                                Icons
                                                                    .check, // Replace with the desired icon
                                                                size: 50,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                              content: Text(
                                                                  'Changes updated successfully'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    // Close the dialog
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                      'Close'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.0), // Adjust the radius as needed
                                                          ),
                                                        ),
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all(const Size(
                                                                    110,
                                                                    50)), // Set the size here
                                                      ),
                                                      child:
                                                          const Text('SUBMIT'),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            )),
                                        actions: [
                                          Container(
                                            margin: const EdgeInsets.all(
                                                0.0), // Adjust top margin as needed
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.preview_rounded,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Show another dialog when the IconButton is pressed
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(
                                            width: 300,
                                            margin: EdgeInsets.zero,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(1),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 300,
                                                  height: 50,
                                                  child: Container(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 18,
                                                ),
                                                SizedBox(
                                                  width: 260,
                                                  height: 60,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: catName,
                                                    items: categoryList
                                                        .map((item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item['catName']
                                                            .toString(),
                                                        child: Text(
                                                            item['catName']
                                                                .toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        catName = value;
                                                        subCategoryList = [];
                                                        if (value != null) {
                                                          subCategoryList = categoryList
                                                              .firstWhere((element) =>
                                                                  element['catName']
                                                                      .toString() ==
                                                                  value)['subCategoryList'];
                                                          subCatName =
                                                              null; // Reset subcategory selection
                                                        }
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Category',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                SizedBox(
                                                  width: 260,
                                                  height: 60,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: subCatName,
                                                    items: subCategoryList
                                                        .map((item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item[
                                                                'serviceSubcatName']
                                                            .toString(),
                                                        child: Text(item[
                                                                'serviceSubcatName']
                                                            .toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        subCatName = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Subcategory',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'SERVICE NAME DISPLAY',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .blue), // Specify text color
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  'Sub Service Name Display',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black), // Specify text color
                                                ),
                                                SizedBox(
                                                  width: 260,
                                                  height: 50,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Description here',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 17,
                                                ),
                                                SizedBox(
                                                  width: 260,
                                                  height: 60,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    value: subCatName,
                                                    items: subCategoryList
                                                        .map((item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item[
                                                                'serviceSubcatName']
                                                            .toString(),
                                                        child: Text(item[
                                                                'serviceSubcatName']
                                                            .toString()),
                                                      );
                                                    }).toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        subCatName = value;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: 'Subcategory',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 17,
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            )),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Close the dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.delete, // Replace with the desired icon
                                size: 20,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
