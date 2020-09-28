import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/models/sensor_settings.dart';
import 'package:leafer/screens/sensor/sensor_association.dart';
import 'package:leafer/services/plant_collection_service.dart';
import 'package:leafer/services/sensor_service.dart';
import 'package:wifi/wifi.dart';

class PlantInfo extends StatefulWidget {
  final Plant plant;

  PlantInfo({Key key, @required this.plant}) : super(key: key);

  @override
  _PlantInfoState createState() => _PlantInfoState(plant);
}

class _PlantInfoState extends State<PlantInfo> {
  final _editKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static const String _NO_SENSOR = "Pas de capteur associé";

  Plant _plant;
  String _sensorData;

  _PlantInfoState(this._plant);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_plant.name),
      ),
      body: (SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      image: _plant.getPicture(),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _plant.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Taille de la plante : " +
                          _plant.height.toString() +
                          " cm",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Taux d'humidité minimum : " + _plant.humidity + "%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: FutureBuilder<String>(
                        future: this.getSensorData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> value) {
                          if (value.hasError) {
                            return Text(
                              'There was an error :(',
                              style: Theme.of(context).textTheme.headline,
                            );
                          } else if (value.hasData) {
                            _sensorData = value.data;
                            if (_sensorData == _NO_SENSOR) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    onPressed: () async {
                                      PlantCollection _plantCollection =
                                          await PlantCollectionService
                                              .findByPlantAndUser(_plant.id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SensorAssociation(_plant,
                                                      _plantCollection)));
                                    },
                                    elevation: 0.0,
                                    child: Text(
                                        'Associer un capteur d\'humidité')),
                              );
                            } else {
                              return Text(
                                "Capteur d'humidité : " +
                                    jsonDecode(_sensorData)['humidity']
                                        .toString() +
                                    "%",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              );
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        onPressed: () async {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Suppression en cours...')));
                          PlantCollection plantCollection =
                              await PlantCollectionService.findByPlantAndUser(
                                  _plant.id);
                          await PlantCollectionService.deletePlantCollection(
                              plantCollection);
                          Navigator.pushNamed(context, "/collection");
                        },
                        elevation: 0.0,
                        child: Text('Retirer de mon jardin')),
                  ),
                ])),
      )),
    );
  }

  Future<String> getSensorData() async {
    if (Wifi.ssid != "leaferSensor") {
      PlantCollection p =
          await PlantCollectionService.findByPlantAndUser(_plant.id);
      if (p != null) {
        SensorSettings s = await SensorService.getSensorData(p.id);
        if (s != null) {
          return s.toString();
        } else {
          return _NO_SENSOR;
        }
      } else {
        return _NO_SENSOR;
      }
    }
    else return _NO_SENSOR;
  }
}
