import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leafer/pages/events.dart';
import 'package:leafer/pages/event-form.dart';
import './widgets/collection.dart';

void main() => runApp(LeaferApp());

class LeaferApp extends StatelessWidget {
  // TODO: change
  static const SERVER_URL = 'http://192.168.43.200:3000';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[400]),
      initialRoute: '/events',
      routes: {
        '/collection': (context) => Collection(),
        '/events': (context) => Events(),
        '/events/create': (context) => EventForm(),
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
