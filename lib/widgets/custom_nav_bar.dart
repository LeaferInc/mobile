import 'dart:developer';

import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  CustomNavBar({Key key}) : super(key: key);

  @override
  CustomNavBarState createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar> {
  CustomNavBarState();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.collections),
          title: Text('My Plants'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          title: Text('Events'),
        ),
      ],
    );
  }

  void _onTabTapped(int index) {
    log(index.toString());
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, "/collection");
        break;
      case 1:
        Navigator.pushReplacementNamed(context, "/events");
        break;
    }
  }
}
