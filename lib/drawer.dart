import 'package:flutter/material.dart';
import 'package:ivis_security/apis/login_api_service.dart';
import 'package:ivis_security/contact.dart';
import 'package:ivis_security/login.dart';
import 'package:ivis_security/reset.dart';
import 'package:http/http.dart ' as http;
import 'dart:convert';

class DrawerWidget extends StatefulWidget {
  @override
  _OneStopScreenState createState() => _OneStopScreenState();
}

class _OneStopScreenState extends State<DrawerWidget> {
  late Map<String, dynamic> details;
//class DrawerWidget extends StatelessWidget {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String Name = "";
  String phno = "";
  String mail = "";
  String img = "";
  String add1 = "";
  String add2 = "";
  String dist = "";
  String city = "";
  String country = "";
  String state = "";
  String pincode = "";
  String contact = "";
  String userId = '';

  @override
  void initState() {
    super.initState();
    userId = LoginApiService.UserId.toString();
    fetchUserData(userId);
  }

  Future<void> fetchUserData(userId) async {
    final response = await http.get(
      Uri.parse(
          'http://34.206.37.237/userDetails/getUserInfoForUserId_1_0/$userId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
        Name = userData!['firstName'] ?? "name"; //contactNo1
        phno = userData!['contactNo1'] ?? "contact";
        mail = userData!['email'] ?? "mail"; //profileImage
        img = userData!['profileImage'] ?? "img";
        add1 = userData!['address_line1'] ?? "add1";
        add2 = userData!['address_line2'] ?? "add2";
        dist = userData!['district'] ?? "district";
        city = userData!['city'] ?? "city";
        state = userData!['state'] ?? "state";
        country = userData!['country'] ?? "nation";
        pincode = userData!['pin'] ?? "pincode";
        contact = userData!['contactNo2'] ?? "con2";
      });
    } else {
      throw Exception('Failed to load user details');
    }
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return Drawer(
      width: Width * 0.8,
      child: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 8),
              height: _isExpanded ? Height * 0.4 : Height * 0.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF740000), Color(0xFF00305A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Stack(
                children: [
                  // Positioned user avatar
                  Positioned(
                    top: 20,
                    left: 55,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add your edit button functionality here
                      },
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: CircleAvatar(
                      radius: 30, // Adjust the radius as needed
                      backgroundColor: Colors
                          .grey.shade200, // Background color while loading
                      child: ClipOval(
                        child: Image.network(
                          img,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Icon(
                              Icons.person,
                              size:
                                  50, // Adjust the size to fit the CircleAvatar radius
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // Positioned account name
                  Positioned(
                    top: 50,
                    left: 100,
                    right: 5,
                    child: Text(
                      '$Name \n$phno \n$mail',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    Positioned(
                      top: 150,
                      left: 100,
                      child: Text(
                        "$add1\n$add2\n$dist\ $city $state,\n$country $pincode",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (_isExpanded)
                    Positioned(
                      top: 240,
                      left: 100,
                      child: Text(
                        'Contact: $contact',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Icon(
                        _isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(5),
                        backgroundColor: Colors.blue, // Background color
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //

            ListTile(
              title: const Text("RESET PASSWORD"),
              onTap: () {
                // Handle home item tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResetScreen()),
                ); // Close the drawer
              },
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
            ListTile(
              minLeadingWidth: 25,
              title: const Text("TERMS & CONDITIONS"),
              onTap: () {
                // Handle settings item tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            SizedBox(
              height: Height * 0.15,
            ),
            ListTile(
              minLeadingWidth: 25,
              title: const Text("VERSION 1.2.0"),
              onTap: () {
                // Handle settings item tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            SizedBox(
              height: Height * 0.015,
            ),
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Container(
                  color: Color.fromARGB(255, 5, 69, 122),
                  height: 50,
                  child: Center(
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
