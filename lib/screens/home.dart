import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leafer/screens/chat/conversations.dart';
import 'package:leafer/screens/collection/plants_home.dart';
import 'package:leafer/screens/cuttings/cutting_home.dart';
import 'package:leafer/screens/events/events_list.dart';
import 'package:leafer/screens/profile/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:leafer/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Home extends StatefulWidget {
  final int initialIndex;

  Home({Key key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomeState createState() => _HomeState(initialIndex);
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final List<Widget> _children = [
    PlantsHome(),
    EventsList(),
    Profile(),
    CuttingHome(),
    Conversations()
  ];
  int _currentIndex = 0;

  _HomeState(this._currentIndex);

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    print('[myBackgroundMessageHandler]: $message');
  }

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('[onMessage]: $message');
        var notification = message['notification'];
        if(notification != null) {
          var android = AndroidNotificationDetails(
            'id', 'channel ', 'description',
            priority: Priority.High, importance: Importance.Max);
          var iOS = IOSNotificationDetails();
          var platform = new NotificationDetails(android, iOS);
          var payload = {
            'type_notification': message['data']['type_notification'],
          };

          await _flutterLocalNotificationsPlugin.show(
            0, notification['title'], notification['body'], platform,
            payload: jsonEncode(payload));
        }
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print('[onLaunch]: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('[onResume]: $message');
      },
    );

    _firebaseMessaging.getToken().then((token) => setState(() async {
      print('[Token]: $token');
      final prefs = await SharedPreferences.getInstance();
      String fcmToken = prefs.getString('fcmToken');
      if(fcmToken != token) {
        prefs.setString('fcmToken', token);
        print('Send token to rest-api');
        Map<String, String> tokenMap = new Map();
        tokenMap['fcmToken'] = token;
        await UserService.updateUser(tokenMap);
      }
    }));
  }

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
            title: Text(PlantsHome.TITLE),
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
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text("Conversations"),
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

  Future selectNotification(String _payload) async {
    debugPrint('notification payload: $_payload');
    if (_payload != null) {
      var payload = jsonDecode(_payload);
      var typeNotification = payload['type_notification'];
      debugPrint('type_notification: $typeNotification');
    }
  }
}
