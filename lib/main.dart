import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leafer/screens/events/event_form.dart';
import 'package:leafer/screens/events/events-search.dart';
import 'package:leafer/screens/home.dart';
import 'package:leafer/screens/login/login_screen.dart';
import 'package:leafer/screens/signin/sign_in.dart';

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
      initialRoute: '/login',
      routes: {
        '/': (context) => Home(),
        '/collection': (context) => Home(initialIndex: 0),
        '/events': (context) => Home(initialIndex: 1),
        '/events/create': (context) => EventForm(),
        '/events/search': (context) => EventsSearch(),
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
      theme: ThemeData(primaryColor: Colors.green[400]),
    );
  }
}
