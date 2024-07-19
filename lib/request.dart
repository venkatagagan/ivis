import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ivis_security/apis/login_api_service.dart';
import 'package:ivis_security/drawer.dart';
import 'package:ivis_security/home.dart';
import 'package:ivis_security/navigation.dart';
import 'package:intl/intl.dart';
import 'package:ivis_security/apis/Bussiness_int_api.dart';
import 'package:ivis_security/cctv/camList.dart';

// ignore: must_be_immutable
class RequestScreen extends StatefulWidget {
  String siteId;
  String Sitename;
  int i;

  RequestScreen({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  int selectedButtonIndex = 0; // used for changing new request & request status

  //to locate current values (imported)
  String siteId = '';
  String sitename = '';
  int currentIndex = 0;
  bool isSubCategoryEnabled = false;
  //used for new request
  int selectedOption = 1; //Prority
  DateTime? date; //set date
  String priority = 'low';

  List<TdpCamera> listOfCamera = [];

  int sitID = 36323;

  late Map<String, dynamic> services;
  String alarm = "F";
  //site names
  List<dynamic> siteNames = [];
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
  int? catId;
  int? subCatId;
  String? UcatName;
  String? UsubCatName;
  String? Priority;

  final TextEditingController _descriptionController = TextEditingController();

  String _getPriorityLabel(int? option) {
    switch (option) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Unknown'; // Handle default case
    }
  }

  Future<void> submitData() async {
    final String apiUrl =
        'http://rsmgmt.ivisecurity.com:8949/serviceHelpDesk/addService_1_0';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'siteId': widget.siteId,
        'calling_system': 'mobile',
        'service_cat_id': catId.toString(),
        'service_subcat_id': subCatId.toString(),
        'createdBy': LoginApiService.UserName,
        'description': _descriptionController.text,
        'PrefTimeToCall': isChecked ? date.toString() : "no",
        'priority': _getPriorityLabel(selectedOption),
        'remarks': 'undefined',
      },
    );

    if (response.statusCode == 200) {
      print('Data submitted successfully');
      // Handle successful submission
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data submitted successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to submit data');
      // Handle failed submission
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to submit data'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse(
        'http://rsmgmt.ivisecurity.com:8949/serviceHelpDesk/categoryList_1_0',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categoryList = data['categoryList'];
      });
    } else {
      throw Exception('Failed to load data');
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

  Future<void> fetchStatus(int siteId) async {
    final response = await http.get(
      Uri.parse(
          'http://rsmgmt.ivisecurity.com:8949/serviceHelpDesk/ListServiceHelpDesk_1_0?siteId=$siteId'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        helpDeskList = data['serviceHelpDeskList'];
      });
    } else {
      throw Exception('Failed to load service requests');
    }
  }

  @override
  void initState() {
    super.initState();
    sitename = widget.Sitename;
    siteId = widget.siteId;
    currentIndex = widget.i;

    sitID = int.parse(widget.siteId);

    fetchSiteNames();
    fetchCategories();
    fetchStatus(sitID);
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
                            builder: (context) => RequestScreen(
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
                            builder: (context) => RequestScreen(
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
                                          child:
                                              Text(item['catName'].toString()),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          catName = value;
                                          if (value != null) {
                                            final selectedCategory =
                                                categoryList.firstWhere(
                                              (element) =>
                                                  element['catName']
                                                      .toString() ==
                                                  value,
                                            );
                                            subCategoryList = selectedCategory[
                                                    'subCategoryList'] ??
                                                [];
                                            catId = selectedCategory['catId'];
                                            subCatName =
                                                null; // Reset subcategory selection
                                            subCatId = null;
                                          } else {
                                            subCategoryList = [];
                                            catId = null;
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
                                          child: Text(item['serviceSubcatName']
                                              .toString()),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          subCatName = value;
                                          if (value != null) {
                                            final selectedSubCategory =
                                                subCategoryList.firstWhere(
                                              (element) =>
                                                  element['serviceSubcatName']
                                                      .toString() ==
                                                  value,
                                            );
                                            subCatId = selectedSubCategory[
                                                'serviceSubcatId'];
                                          } else {
                                            subCatId = null;
                                          }
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Subcategory',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(children: [
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      "Priority:",
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Radio<int>(
                                      value: 1,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOption = value!;
                                          priority = 'low';
                                        });
                                      },
                                    ),
                                    Text('low'),
                                    SizedBox(width: 10),
                                    Radio<int>(
                                      value: 2,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOption = value!;
                                          priority = 'medium';
                                        });
                                      },
                                    ),
                                    Text('medium'),
                                    SizedBox(width: 10),
                                    Radio<int>(
                                      value: 3,
                                      groupValue: selectedOption,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOption = value!;

                                          priority = 'high';
                                        });
                                      },
                                    ),
                                    Text('high'),
                                  ]),
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
                                          controller: _descriptionController,
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
                                      SizedBox(width: 12),
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked = value ?? false;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 12),
                                      Text("Preferred Time to Call Back"),
                                    ],
                                  ),
                                  SizedBox(height: 17),
                                  if (isChecked)
                                    Row(
                                      children: [
                                        SizedBox(width: 100),
                                        OutlinedButton(
                                          onPressed: () {
                                            showModalBottomSheet<DateTime>(
                                                context: context,
                                                builder:
                                                    (BuildContext builder) {
                                                  return Container(
                                                      height: 300,
                                                      child:
                                                          CupertinoDatePicker(
                                                        onDateTimeChanged:
                                                            (newDate) {
                                                          setState(() {
                                                            date = newDate;
                                                          });
                                                        },
                                                      ));
                                                });
                                            // Add your button press logic here
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side:
                                                BorderSide(color: Colors.blue),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: Text(
                                            'Set Time',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
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
                                        onPressed: () {
                                          submitData();
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  25.0), // Adjust the radius as needed
                                            ),
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(150,
                                                      50)), // Set the size here
                                        ),
                                        child: const Text('SUBMIT'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 0,
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
              if (helpDeskList != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 270, 50, 0),
                  child: ListView.separated(
                    itemCount: helpDeskList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      // Add the space between containers here
                      return SizedBox(
                          height: 20); // Adjust the height as needed
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
                                      '${item['serviceReqId']}',
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
                                    '${item['service_cat_name']}',
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
                                  width: 100,
                                  height: 15,
                                  child: Text(
                                    '${item['description']}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (item['status'] != 'Deleted') ...[
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
                                          return Edit(
                                            catId: item['service_cat_id']
                                                    ?.toString() ??
                                                'Not Available',
                                            subCatId: item['service_subcat_id']
                                                    ?.toString() ??
                                                'Not Available',
                                            Priority:
                                                item['priority']?.toString() ??
                                                    'Not Available',
                                            catname: item['service_cat_name']
                                                    ?.toString() ??
                                                'Not Available',
                                            subCatName:
                                                item['service_subcat_name']
                                                        ?.toString() ??
                                                    'Not Available',
                                            Desc: item['description']
                                                    ?.toString() ??
                                                'Not Available',
                                            PrefTimeToCall:
                                                item['PrefTimeToCall']
                                                        ?.toString() ??
                                                    'Not Available',
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
                                          return View(
                                            requestId: item['serviceReqId']
                                                    ?.toString() ??
                                                'Not Available',
                                            createdTime: item['createdTime']
                                                    ?.toString() ??
                                                'Not Available',
                                            Status:
                                                item['status']?.toString() ??
                                                    'Not Available',
                                            Priority:
                                                item['priority']?.toString() ??
                                                    'Not Available',
                                            catname: item['service_cat_name']
                                                    ?.toString() ??
                                                'Not Available',
                                            subCatName:
                                                item['service_subcat_name']
                                                        ?.toString() ??
                                                    'Not Available',
                                            Desc: item['description']
                                                    ?.toString() ??
                                                'Not Available',
                                            Resultion: item['resolution']
                                                    ?.toString() ??
                                                'Not Available',
                                            assignedTo: item['assignedTo']
                                                    ?.toString() ??
                                                'Not Available',
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      // Show another dialog when the IconButton is pressed
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Delete(
                                            siteId: widget.siteId,
                                            siteName: widget.Sitename,
                                            index: widget.i.toString(),
                                            Rnum:
                                                item['serviceReqId'].toString(),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ]
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          siteId: siteId,
          Sitename: sitename,
          i: currentIndex,
          selected: 5,
        ),
        drawer: DrawerWidget(),
      ),
    );
    //return Scaffold(

    //);
  }
}

class Edit extends StatefulWidget {
  final String catId;
  final String subCatId;
  final String Priority;
  final String catname;
  final String subCatName;
  final String Desc;
  final String PrefTimeToCall;

  Edit({
    Key? key,
    required this.catId,
    required this.subCatId,
    required this.Priority,
    required this.catname,
    required this.subCatName,
    required this.Desc,
    required this.PrefTimeToCall,
  }) : super(key: key);

  @override
  _CustomFormDialogState createState() => _CustomFormDialogState();
}

class _CustomFormDialogState extends State<Edit> {
  String? catName;
  String? subCatName;
  int? selectedOption;
  List<dynamic> subCategoryList = [];
  int? catId;
  int? subCatId;
  String priority = 'low';
  bool isChecked = false;
  DateTime date = DateTime.now();
  final TextEditingController _descriptionController = TextEditingController();
  List<dynamic> categoryList = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    catName = widget.catname;
    subCatName = widget.subCatName;
    selectedOption = _getPriorityValue(widget.Priority);
    _descriptionController.text = widget.Desc;
    isChecked = widget.PrefTimeToCall.isNotEmpty;
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse(
        'http://rsmgmt.ivisecurity.com:8949/serviceHelpDesk/categoryList_1_0',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categoryList = data['categoryList'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void submitData() {
    // Implement your submit logic here
    print("Category ID: $catId");
    print("Subcategory ID: $subCatId");
    print("Priority: $priority");
    print("Description: ${_descriptionController.text}");
    print("Preferred Time to Call Back: $date");
  }

  int _getPriorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return 1;
      case 'medium':
        return 2;
      case 'high':
        return 3;
      default:
        return 1; // Default to low if the priority is unrecognized
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Expanded(
        child: SingleChildScrollView(
          child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.circular(5),
              ),
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
                          child: Text(item['catName'].toString()),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          catName = value;
                          if (value != null) {
                            final selectedCategory = categoryList.firstWhere(
                              (element) =>
                                  element['catName'].toString() == value,
                            );
                            subCategoryList =
                                selectedCategory['subCategoryList'] ?? [];
                            catId = selectedCategory['catId'];
                            subCatName = null; // Reset subcategory selection
                            subCatId = null;
                          } else {
                            subCategoryList = [];
                            catId = null;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: catName,
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
                          value: item['serviceSubcatName'].toString(),
                          child: Text(item['serviceSubcatName'].toString()),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          subCatName = value;
                          if (value != null) {
                            final selectedSubCategory =
                                subCategoryList.firstWhere(
                              (element) =>
                                  element['serviceSubcatName'].toString() ==
                                  value,
                            );
                            subCatId = selectedSubCategory['serviceSubcatId'];
                          } else {
                            subCatId = null;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: subCatName,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(children: [
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      "Priority:",
                    ),
                  ]),
                  SizedBox(
                    height: 15,
                  ),
                  Row(children: [
                    SizedBox(
                      width: 10,
                    ),
                    Radio<int>(
                      value: 1,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                          priority = 'low';
                        });
                      },
                    ),
                    Text('low'),
                    SizedBox(width: 10),
                    Radio<int>(
                      value: 2,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                          priority = 'medium';
                        });
                      },
                    ),
                    Text('medium'),
                    SizedBox(width: 10),
                    Radio<int>(
                      value: 3,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                          priority = 'high';
                        });
                      },
                    ),
                    Text('high'),
                  ]),
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
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: _descriptionController.text,
                            hintStyle: TextStyle(color: Colors.grey),
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
                      SizedBox(width: 12),
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      SizedBox(width: 12),
                      Text("Preferred Time to Call Back"),
                    ],
                  ),
                  SizedBox(height: 17),
                  if (isChecked)
                    Row(
                      children: [
                        SizedBox(width: 100),
                        OutlinedButton(
                          onPressed: () {
                            showModalBottomSheet<DateTime>(
                                context: context,
                                builder: (BuildContext builder) {
                                  return Container(
                                      height: 300,
                                      child: CupertinoDatePicker(
                                        onDateTimeChanged: (newDate) {
                                          setState(() {
                                            date = newDate;
                                          });
                                        },
                                      ));
                                });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'Set Time',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
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
                        onPressed: () {
                          submitData();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  25.0), // Adjust the radius as needed
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(
                              const Size(150, 50)), // Set the size here
                        ),
                        child: const Text('SUBMIT'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class View extends StatefulWidget {
  final String requestId;
  final String createdTime;
  final String Status;
  final String Priority;
  final String catname;
  final String subCatName;
  final String Desc;
  final String Resultion;
  final String assignedTo;

  const View({
    Key? key,
    required this.requestId,
    required this.createdTime,
    required this.Status,
    required this.Priority,
    required this.catname,
    required this.subCatName,
    required this.Desc,
    required this.Resultion,
    required this.assignedTo,
  }) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Dialog(
      child: Expanded(
        child: SingleChildScrollView(
          child: Container(
              width: Width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: Height * 0.05,
                      width: Width * 0.8,
                      color: Colors.blue,
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: Width * 0.05,
                            ),
                            SizedBox(
                              width: Width * 0.47,
                              child: Text(widget.requestId),
                            ),
                            SizedBox(
                              width: Width * 0.25,
                              child: Text(widget.createdTime),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                    height: Height * 0.03,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                              color: Colors.green,
                              width: 2.0), // Adjust the radius as needed
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                          const Size(150, 50)), // Set the size here
                    ),
                    child: Text(widget.Status),
                  ),
                  SizedBox(
                    height: Height * 0.03,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                              color: Colors.green,
                              width: 2.0), // Adjust the radius as needed
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all(
                          const Size(150, 50)), // Set the size here
                    ),
                    child: Text(widget.Priority),
                  ),
                  SizedBox(
                    height: Height * 0.03,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: Width * 0.05,
                      ),
                      Text(widget.catname),
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
                      Text(widget.subCatName),
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
                      Text(widget.Desc),
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
                      Text(widget.Resultion),
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
                      Text("assigned to"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: Width * 0.05,
                      ),
                      Text(
                        widget.assignedTo,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class Delete extends StatefulWidget {
  final String Rnum;
  final String siteId;
  final String siteName;
  final String index;

  const Delete(
      {Key? key,
      required this.Rnum,
      required this.siteId,
      required this.siteName,
      required this.index})
      : super(key: key);
  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  Future<void> deleteService(
      String rnum, String siteId, String siteName, String index) async {
    final response = await http.put(Uri.parse(
        'http://rsmgmt.ivisecurity.com:8949/serviceHelpDesk/deleteServiceHelpDesk_1_0/$rnum'));

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data submitted successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequestScreen(
                  i: int.parse(index),
                  siteId: siteId,
                  Sitename: siteName,
                )),
      );
      // If the server did return a 200 OK response,
      // then parse the JSON.
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the service.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return Dialog(
      child: Expanded(
        child: SingleChildScrollView(
          child: Container(
              height: Height * 0.3,
              width: Width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Height * 0.05,
                  ),
                  Text("Do you want to delete "),
                  Text(
                    "Request No: ${widget.Rnum}",
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(
                    height: Height * 0.03,
                  ),
                  Text(
                    "You can't undo this action.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: Height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0), // Adjust the radius as needed
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(
                              const Size(100, 35)), // Set the size here
                        ),
                        child: const Text('Cancel'),
                      ),
                      SizedBox(
                        width: Width * 0.02,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // You can replace '69' with the actual rnum you want to delete
                          deleteService(widget.Rnum, widget.siteId,
                              widget.siteName, widget.index);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
