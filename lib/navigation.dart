import 'package:flutter/material.dart';
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/cctv.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/development.dart';
import 'package:ivis_security/hdtv.dart';
import 'package:ivis_security/request.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  String siteId;
  String Sitename;
  int i;

  CustomBottomNavigationBar({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/logos/cctv.jpg',
              width: 19, // Adjust image width as needed
              height: 19,
            ),
            onPressed: () {
              // Handle home button press
              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  CctvScreen(siteId: siteId,Sitename: Sitename,i: i,)),
                              );
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/logos/alarm.png', // Replace with your image path
              width: 19, // Adjust image width as needed
              height: 19, // Adjust image height as needed
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AlarmScreen(siteId: siteId,Sitename: Sitename,i: i,)),
              ); // Handle settings button press
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/logos/development.png', // Replace with your image path
              width: 19, // Adjust image width as needed
              height: 19, // Adjust image height as needed
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DevelopmentScreen(siteId: siteId,Sitename: Sitename,i: i,)),
              ); // Handle settings button press
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/logos/center-circle.png', // Replace with your image path
              width: 19, // Adjust image width as needed
              height: 19, // Adjust image height as needed
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CenterScreen(siteId: siteId,Sitename: Sitename,i: i,)),
              );
              // Handle search button press
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/logos/hdtv.png', // Replace with your image path
              width: 19, // Adjust image width as needed
              height: 19, // Adjust image height as needed
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HdtvScreen(siteId: siteId,Sitename: Sitename,i: i,)),
              );
              // Handle search button press
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/logos/plus-square.png', // Replace with your image path
              width: 19, // Adjust image width as needed
              height: 19, // Adjust image height as needed
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequestScreen(siteId: siteId,Sitename: Sitename,i: i,)),
              );
              // Handle search button press
            },
          ),
          
        ],
      ),
    );
  }
}
