import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leafer/pages/events/event-form.dart';
import 'package:leafer/pages/events/events-list.dart';

import './widgets/collection.dart';

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
      initialRoute: '/events',
      routes: {
        '/collection': (context) => Collection(),
        '/events': (context) => EventsList(),
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
