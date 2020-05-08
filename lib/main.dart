import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leafer/screens/events/event_form.dart';
import 'package:leafer/screens/events/events_list.dart';
import 'package:leafer/screens/collection.dart';
import 'package:leafer/screens/login_screen.dart';

/// Locks the screen to portrait orientation
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(LeaferApp()));
}

class LeaferApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[400]),
      initialRoute: '/login',
      routes: {
        '/collection': (context) => Collection(),
        '/events': (context) => EventsList(),
        '/events/create': (context) => EventForm(),
        '/login': (context) => LoginScreen()
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr'),
      ],
    );
  }
}
