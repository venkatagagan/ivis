import 'package:flutter/material.dart';
import 'package:ivis_security/alarm.dart';
import 'package:ivis_security/cctv.dart';
import 'package:ivis_security/center.dart';
import 'package:ivis_security/development.dart';
import 'package:ivis_security/hdtv.dart';
import 'package:ivis_security/request.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final String siteId;
  final String Sitename;
  final int i;
  final int selected;

  const CustomBottomNavigationBar({
    Key? key,
    required this.siteId,
    required this.Sitename,
    required this.i,
    required this.selected,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex; // Initialize with the provided selected index

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selected; // Initialize with the selected index
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildIconButton('cctv', 'CctvScreen', 0),
          buildIconButton('alarm', 'AlarmScreen', 1),
          buildIconButton('development', 'DevelopmentScreen', 2),
          buildIconButton('center-circle', 'CenterScreen', 3),
          buildIconButton('hdtv', 'HdtvScreen', 4),
          buildIconButton('plus-square', 'RequestScreen', 5),
        ],
      ),
    );
  }

  IconButton buildIconButton(String iconName, String screenName, int index) {
    return IconButton(
      icon: Image.asset(
        _selectedIndex == index
            ? 'assets/logos/$iconName.jpg' // Selected icon
            : 'assets/logos/$iconName.png', // Default icon
        width: 19,
        height: 19,
      ),
      onPressed: () {
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index; // Update selected index
          });
          navigateToScreen(screenName);
        } else {
          // Deselect the current selection if tapped again
        }
      },
    );
  }

  void navigateToScreen(String screenName) {
    switch (screenName) {
      case 'CctvScreen':
        navigateTo(CctvScreen(
            siteId: widget.siteId, Sitename: widget.Sitename, i: widget.i));
        break;
      case 'AlarmScreen':
        navigateTo(AlarmScreen(
            siteId: widget.siteId, Sitename: widget.Sitename, i: widget.i));
        break;
      case 'DevelopmentScreen':
        navigateTo(DevelopmentScreen(
            siteId: widget.siteId, Sitename: widget.Sitename, i: widget.i));
        break;
      case 'CenterScreen':
        navigateTo(CenterScreen(
            siteId: widget.siteId, Sitename: widget.Sitename, i: widget.i));
        break;
      case 'HdtvScreen':
        navigateTo(HdtvScreen(
            siteId: widget.siteId, Sitename: widget.Sitename, i: widget.i));
        break;
      case 'RequestScreen':
        navigateTo(RequestScreen(
            siteId: widget.siteId, Sitename: widget.Sitename, i: widget.i));
        break;
      default:
        // Handle default case
        break;
    }
  }

  void navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
