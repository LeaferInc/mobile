import 'package:flutter/material.dart';
import 'package:leafer/screens/collection/collection.dart';
import 'package:leafer/screens/events/events_list.dart';

class Home extends StatefulWidget {
  final int initialIndex;

  Home({Key key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(initialIndex);
}

class _HomeState extends State<Home> {
  final List<Widget> _children = [
    Collection(),
    EventsList(),
  ];
  int _currentIndex = 0;

  _HomeState(this._currentIndex);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _children,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
