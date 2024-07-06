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
  String catId = '0';
  String subCatId = '0';

  String? UcatName;
  String? UsubCatName;
  String? Priority;

  final TextEditingController _descriptionController = TextEditingController();

  Future<void> submitData() async {
    final url = Uri.parse(
        'http://rsmgmt.ivisecurity.com:8949/serviceHelpDesk/addService_1_0');

    var request = http.MultipartRequest('POST', url)
      ..fields['siteId'] = widget.siteId
      ..fields['calling_system'] = 'Mobile'
      ..fields['service_cat_id'] = catId
      ..fields['service_subcat_id'] = subCatId
      ..fields['createdBy'] = LoginApiService.UserName
      ..fields['description'] = _descriptionController.text
      ..fields['PrefTimeToCall'] = isChecked ? date.toString() : 'null'
      ..fields['priority'] = priority
      ..fields['remarks'] = 'undefined';

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('Data submitted successfully: $responseBody');
        // Show success message or navigate to another page
      } else {
        print('Failed to submit data: ${response.statusCode}');
        // Show error message
      }
    } catch (e) {
      print('Error occurred while submitting data: $e');
      // Show error message
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
                                          subCategoryList = [];
                                          if (value != null) {
                                            subCategoryList = categoryList
                                                .firstWhere((element) =>
                                                    element['catName']
                                                        .toString() ==
                                                    value)['subCategoryList'];
                                            final selectedCategory =
                                                categoryList.firstWhere(
                                              (element) =>
                                                  element['catName']
                                                      .toString() ==
                                                  value,
                                            );
                                            catId = selectedCategory['catId'];
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
                                                'serviceSubcatId']; // Reset subcategory selection
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
                                                      value: UcatName,
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
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          UcatName = value;
                                                          subCategoryList = [];
                                                          if (value != null) {
                                                            subCategoryList = categoryList
                                                                .firstWhere((element) =>
                                                                    element['catName']
                                                                        .toString() ==
                                                                    value)['subCategoryList'];
                                                            UsubCatName =
                                                                null; // Reset subcategory selection
                                                          }
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
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
                                                      value: UsubCatName,
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
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          UsubCatName = value;
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Subcategory',
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
                                                              color:
                                                                  Colors.grey),
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
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Subcategory',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      value: Priority,
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          Priority = newValue!;
                                                        });
                                                      },
                                                      items: <String>[
                                                        'High',
                                                        'Medium',
                                                        'Low'
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
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
                                                    style: OutlinedButton
                                                        .styleFrom(
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
                                                              color:
                                                                  Colors.grey),
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
                                                            builder:
                                                                (BuildContext
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
                                                        child: const Text(
                                                            'SUBMIT'),
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
                                                      onChanged:
                                                          (String? value) {
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
                                                      decoration:
                                                          InputDecoration(
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
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          subCatName = value;
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Subcategory',
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
                                                              color:
                                                                  Colors.grey),
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
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {
                                                          subCatName = value;
                                                        });
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Subcategory',
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
