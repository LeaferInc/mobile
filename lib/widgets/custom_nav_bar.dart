import 'dart:developer';

import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final int index;

  CustomNavBar({Key key, @required this.index}) : super(key: key);

  @override
  CustomNavBarState createState() => CustomNavBarState(index);
}

class CustomNavBarState extends State<CustomNavBar> {
  int index;

  CustomNavBarState(this.index);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(onTap: onTabTapped, currentIndex: index, items: [
      BottomNavigationBarItem(
          icon: Icon(Icons.collections), title: Text('My Plants')),
      BottomNavigationBarItem(icon: Icon(Icons.event), title: Text('Events'))
    ]);
  }

  void onTabTapped(int index) {
    log(index.toString());
    setState(() {
      this.index = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, "/collection");
        break;
      case 1:
        Navigator.pushNamed(context, "/events");
        break;
    }
  }
}
