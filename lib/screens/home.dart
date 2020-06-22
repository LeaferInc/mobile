import 'package:flutter/material.dart';
import 'package:leafer/screens/collection/collection.dart';
import 'package:leafer/screens/cuttings/cutting_home.dart';
import 'package:leafer/screens/events/events_list.dart';
import 'package:leafer/screens/profile/profile.dart';

class Home extends StatefulWidget {
  final int initialIndex;

  Home({Key key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(initialIndex);
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _children = [
    Collection(),
    EventsList(),
    Profile(),
    CuttingHome()
  ];
  int _currentIndex = 0;

  _HomeState(this._currentIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(
        children: _children,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            title: Text(Collection.TITLE),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text(EventsList.TITLE),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(Profile.TITLE),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            title: Text(CuttingHome.TITLE),
          )
        ],
      ),
    );
  }

  /// Item tapped on the nav bar, changes the view
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
