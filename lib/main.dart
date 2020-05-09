import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leafer/screens/event_form.dart';
import 'package:leafer/screens/events.dart';
import 'package:leafer/screens/collection.dart';
import 'package:leafer/screens/login_screen.dart';
import 'package:leafer/screens/sign_in.dart';

void main() => runApp(LeaferApp());

class LeaferApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/login',
        routes: {
          '/collection': (context) => Collection(),
          '/events': (context) => Events(),
          '/events/create': (context) => EventForm(),
          '/login': (context) => LoginScreen(),
          '/signIn': (context) => SignIn()
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('fr'),
        ],
        theme: ThemeData(primaryColor: Colors.green[400]));
  }
}
