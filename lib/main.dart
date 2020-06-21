import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leafer/screens/cuttings/cutting_form.dart';
import 'package:leafer/screens/events/event_form.dart';
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
        '/home': (BuildContext context) => new Home(),
        '/collection': (BuildContext context) => new Home(initialIndex: 0),
        '/events': (BuildContext context) => new Home(initialIndex: 1),
        '/events/create': (BuildContext context) => new EventForm(),
        '/login': (BuildContext context) => new LoginScreen(),
        '/signIn': (BuildContext context) => new SignIn(),
        '/cuttings/create': (BuildContext context) => new CuttingForm()
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
