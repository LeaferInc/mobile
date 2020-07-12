import 'package:flutter/material.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/models/sensor_settings.dart';
import 'package:leafer/services/plant_collection_service.dart';
import 'package:leafer/services/sensor_service.dart';

class SensorAssociation extends StatefulWidget {
  static const String TITLE = 'Association du capteur';

  Plant _plant;
  PlantCollection _plantCollection;
  SensorAssociation(Plant plant, PlantCollection plantCollection) {
    this._plant = plant;
    this._plantCollection = plantCollection;
  }

  @override
  _SensorAssociationState createState() => _SensorAssociationState();
}

class _SensorAssociationState extends State<SensorAssociation> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SensorSettings _settings;
  bool _isSending;
  Plant _plant;
  PlantCollection _plantCollection;

  @override
  void initState() {
    super.initState();
    _plant = widget._plant;
    _plantCollection = widget._plantCollection;
    _isSending = false;
    _settings = SensorSettings(ssid: "", password: "", plantCollection: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(SensorAssociation.TITLE),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'SSID',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'SSID de votre point Wifi',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                maxLines: 1,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Entrez un ssid valide';
                  }
                  return null;
                },
                onChanged: (value) => _settings.ssid = value,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 10.0),
              Text(
                'Mot de passe du point d\'accès',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Clé wifi',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                obscureText: true,
                onChanged: (value) => _settings.password = value,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    onPressed: () async {
                      _settings.plantCollection = _plantCollection.id;
                      if (_formKey.currentState.validate() && !_isSending) {
                        _isSending = true;
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Association en cours...')));
                      }
                      String response =
                          await SensorService.connectToSensor(_settings);
                      if (response == "sensor created and connected") {
                        Navigator.pop(context);
                      } else {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Association impossible')));
                      }
                    },
                    elevation: 0.0,
                    child: Text('Associer le capteur')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
