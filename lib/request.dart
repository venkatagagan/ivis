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
  //final _formKey = GlobalKey<FormState>();
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
        helpDeskList = List.from(data['serviceHelpDeskList'].reversed);

        helpDeskList.sort((a, b) {
          if (a['status'] == 'Deleted' && b['status'] != 'Deleted') {
            return 1;
          } else if (a['status'] != 'Deleted' && b['status'] == 'Deleted') {
            return -1;
          } else {
            return 0;
          }
        });
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
            SizedBox(
                      height: Height * 0.25,
                      child: Column(
                        children: [
                          SizedBox(height: Height * 0.05),
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
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1, // Set the height of the line
                            thickness: 1, // Set the thickness of the line
                            color: Colors.white, // Set the color of the line
                          ),
                          SizedBox(height: Height*0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [TextButton(
                onPressed: () => onButtonPressed(0),
                child: const Text(
                  'NEW REQUEST',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to black
                  ),
                ),
                          ),
                          SizedBox(width: Width*0.05,),
                          TextButton(
                onPressed: () => onButtonPressed(1),
                child: const Text(
                  'REQUEST STATUS',
                  style: TextStyle(
                    color: Colors.white, // Set the text color to black
                  ),
                ),
              ),
                          ],),
                          SizedBox(height: Height*0.01,),
                          SizedBox(width: Width*0.8,child: Divider(
                height: 1, // Set the height of the line
                thickness: 1, // Set the thickness of the line
                color: Colors.white, // Set the color of the line
              ),)
                        ],
                      )),
                     
            
            
            
            
            if (selectedButtonIndex == 0) ...[
              // Display content for Button 1
               Positioned(
                top: Height*0.24, // Adjust the position from the bottom
                left: Width*0.1,
                right: Width*0.5,
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
                      SizedBox(
                        height: Height*0.27,
                      ),
                      
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                              width: Width*0.8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Height*0.02,
                                  ),
                                  SizedBox(
                                    width: Width*0.7,
                                    height: Height*0.08,
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
                                  SizedBox(height: Height*0.01,),
                                  SizedBox(
                                    width: Width*0.7,
                                    height: Height*0.08,
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
                                  SizedBox(height: Height*0.01,),
                                  Row(children: [
                                    SizedBox(
                                      width: Width*0.05,
                                    ),
                                    Text(
                                      "Priority:",
                                    ),
                                  ]),
                                  SizedBox(
                                    height: Height*0.01,
                                  ),
                                  Row(children: [
                                    SizedBox(
                                      width: Width*0.01,
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
                                    height: Height*0.01,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: Width*0.7,
                                        height: Height*0.15,
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
                                    height: Height*0.02,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: Width*0.04),
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
                                  SizedBox(height: Height*0.01),
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
                                                      height: Height*0.3,
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
                                    SizedBox(height: Height*0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                     
                                      ElevatedButton(
                                        onPressed: () {
                                          submitData();
                                        },
                                        style: ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0), // Adjust the radius as needed
      ),
    ),
    minimumSize: MaterialStateProperty.all(const Size(150, 50)), // Set the size here
    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), // Set background color
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
               Positioned(
                top: Height*0.24, // Adjust the position from the bottom
                left: Width*0.5,
                right: Width*0.1,
                child: Divider(
                  height: 1, // Set the height of the line
                  thickness: 6, // Set the thickness of the line
                  color: Colors.white, // Set the color of the line
                ),
              ),
              // ignore: unnecessary_null_comparison
              if (helpDeskList != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(Width*0.1, Height*0.24, Width*0.1, Height*0.03),
                  child: ListView.separated(
                    itemCount: helpDeskList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      // Add the space between containers here
                      return SizedBox(
                          height: Height*0.02); // Adjust the height as needed
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final item = helpDeskList[index];
                      return Container(
                        width: Width*0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Width*0.8,
                              height: Height*0.05,
                              color: Color.fromARGB(255, 220, 222, 222),
                              // Replace with the desired color
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                
                                  Row(
                                    children: [
                                    SizedBox(width: Width*0.03,),
                                    SizedBox(width: Width*0.535,child:Text(
                                      '${item['serviceReqId']}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),),
                                    SizedBox(width: Width*0.22,child:Text(
                                      '${item['status']}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: item['status'] == 'Deleted'
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),),
                                    
                                    
                                  ],),
                                  
                                 
                                 
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Height*0.005,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: Width*0.03,
                                ),
                                SizedBox(
                                  width: Width*0.53,
                                  height: Height*0.02,
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
                                  width: Width*0.005,
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
                              height: Height*0.02,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: Width*0.03,
                                ),
                                SizedBox(
                                  width: Width*0.4,
                                  height: Height*0.03,
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
                                            sitename: widget.Sitename,
                                            index: widget.i,
                                            rnum: item['serviceReqId'],
                                            siteId: widget.siteId,
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
  final String siteId;
  final int rnum;
  final int index;
  final String sitename;

  Edit({
    Key? key,
    required this.catId,
    required this.subCatId,
    required this.Priority,
    required this.catname,
    required this.subCatName,
    required this.Desc,
    required this.PrefTimeToCall,
    required this.siteId,
    required this.rnum,
    required this.index,
    required this.sitename,
  }) : super(key: key);

  @override
  _CustomFormDialogState createState() => _CustomFormDialogState();
}

class _CustomFormDialogState extends State<Edit> {
  String? catName;
  String? subCatName;
  int? selectedOption;
  List<dynamic> subCategoryList = [];
  int catId=0;
  int subCatId=0;
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
    catId = int.parse(widget.catId);
    subCatId = int.parse(widget.subCatId);

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

  Future<void> submitData(int rnum,String siteid,String siteName,int index) async {
    final String apiUrl =
        'http://rsmgmt.ivisecurity.com:8949/serviceHelpDesk/updateService_1_0/$rnum';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'siteId': widget.siteId,
        'calling_system': 'mobile',
        'service_cat_id': catId.toString(),
        'service_subcat_id': subCatId.toString(),
        'editedBy': LoginApiService.UserId.toString(),
        'description': _descriptionController.text,
        'PrefTimeToCall': isChecked ? date.toString() : "",
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
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RequestScreen(
                  i: index,
                  siteId: siteid,
                  Sitename: siteName,
                )),
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
                            
                          } else {
                            subCategoryList = [];
                            
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
                          submitData(widget.rnum,widget.siteId,widget.sitename,widget.index);
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
