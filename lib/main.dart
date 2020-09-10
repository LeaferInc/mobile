import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/screens/best_plant/best_plant_form.dart';
import 'package:leafer/screens/chat/conversations.dart';
import 'package:leafer/screens/cuttings/cutting_form.dart';
import 'package:leafer/screens/events/event_form.dart';
import 'package:leafer/screens/events/events_search.dart';
import 'package:leafer/screens/home.dart';
import 'package:leafer/screens/login/login_screen.dart';
import 'package:leafer/screens/recognition/recognition_screen.dart';
import 'package:leafer/screens/sensor/sensor_association.dart';
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
        '/best-plant': (BuildContext context) => new BestPlantForm(),
        '/collection': (BuildContext context) => new Home(initialIndex: 0),
        '/cuttings/create': (BuildContext context) => new CuttingForm(),
        '/events': (BuildContext context) => new Home(initialIndex: 1),
        '/events/create': (BuildContext context) => new EventForm(),
        '/events/search': (BuildContext context) => new EventsSearch(),
        '/home': (BuildContext context) => new Home(),
        '/identify': (BuildContext context) => new RecognitionScreen(),
        '/login': (BuildContext context) => new LoginScreen(),
        '/profile': (BuildContext context) => new Home(initialIndex: 2),
        '/signIn': (BuildContext context) => new SignIn(),
        '/sensorAssociation': (BuildContext context) =>
            new SensorAssociation(new Plant(), new PlantCollection()),
        '/conversations': (BuildContext context) => new Conversations()
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
