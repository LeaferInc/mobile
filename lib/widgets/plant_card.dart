import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/services/plant_collection_service.dart';
import 'package:leafer/services/sensor_service.dart';

class PlantCard extends StatefulWidget {
  final Plant plant;
  final VoidCallback onTap;

  PlantCard({Key key, @required this.plant, @required this.onTap})
      : super(key: key);

  @override
  _PlantCardState createState() => _PlantCardState(plant, onTap);
}

class _PlantCardState extends State<PlantCard> {
  static const String _NO_SENSOR = "Pas de capteur associé";

  final Plant _plant;
  final VoidCallback _onTap;

  String _sensorData = "";

  @override
  void initState() {
    super.initState();
  }

  _PlantCardState(this._plant, this._onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: SizedBox(
        height: 100.0,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image(
                image: _plant.getPicture(),
                height: 100.0,
                width: 100.0,
                fit: BoxFit.contain,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _plant.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 35),
                ),
                Text(
                  "Difficulté : " + _plant.difficulty.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                SizedBox(
                  child: FutureBuilder<String>(
                      future: this.getSensorData(),
                      builder:
                          (BuildContext context, AsyncSnapshot<String> value) {
                        if (value.hasError) {
                          return Text(
                            'There was an error :(',
                            style: Theme.of(context).textTheme.headline,
                          );
                        } else if (value.hasData) {
                          if (value.data == "" || value.data == _NO_SENSOR) {
                            return Text(
                              value.data,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            );
                          } else {
                            return Text(
                              "Capteur d'humidité : " +
                                  jsonDecode(value.data)['humidity'].toString(),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> getSensorData() async {
    PlantCollection p =
        await PlantCollectionService.findByPlantAndUser(_plant.id);
    if (p != null) {
      String s = await SensorService.getSensorData(p.id);
      return s;
    } else {
      return _NO_SENSOR;
    }
  }
}
