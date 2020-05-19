import 'package:flutter/material.dart';
import 'package:leafer/screens/collection.dart';
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
      appBar: AppBar(
        title: Text(_getTabTitle(_currentIndex)),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            title: Text(_getTabTitle(0)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text(_getTabTitle(1)),
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

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Mes Plantes';
      case 1:
        return 'Événements';
      default:
        return 'Leafer';
    }
  }
}
