import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as Material;
import 'package:flutter/widgets.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/models/sensor.dart';
import 'package:leafer/models/sensor_data.dart';
import 'package:leafer/screens/sensor/sensor_association.dart';
import 'package:leafer/services/plant_collection_service.dart';
import 'package:leafer/services/sensor_data_service.dart';
import 'package:leafer/services/sensor_service.dart';
import 'package:leafer/widgets/chart_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PlantInfo extends StatefulWidget {
  final Plant plant;

  PlantInfo({Key key, @required this.plant}) : super(key: key);

  @override
  _PlantInfoState createState() => _PlantInfoState(plant);
}

class _PlantInfoState extends State<PlantInfo> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Plant _plant;
  SensorData _sensorData;

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
                      "Taux d'humidité minimum : " +
                          _plant.humidityMin.toString() +
                          "%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Taux d'humidité maximum : " +
                          _plant.humidityMax.toString() +
                          "%",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<SensorData>(
                        future: this.getLastSensorData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<SensorData> value) {
                          if (value.hasError) {
                            return Text(
                              'There was an error :(',
                              style: Theme.of(context).textTheme.headline,
                            );
                          } else if (value.hasData) {
                            _sensorData = value.data;
                            if (_sensorData == "") {
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
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Humidité du sol : " +
                                        _sensorData.groundHumidity.toString() +
                                        "%",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Text(
                                    "Humidité de l'air : " +
                                        _sensorData.airHumidity.toString() +
                                        "%",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                  Text(
                                    "Température : " +
                                        _sensorData.temperature.toString() +
                                        "°C",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )
                                ],
                              );
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  )
                ])),
      )),
    );
  }

  Future<SensorData> getLastSensorData() async {
    PlantCollection p =
        await PlantCollectionService.findByPlantAndUser(_plant.id);
    if (p != null) {
      Sensor s = await SensorService.getSensor(p.id);
      return await SensorDataService.getLastDataById(s);
    } else {
      return null;
    }
  }
}
