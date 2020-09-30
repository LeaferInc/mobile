import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/models/sensor.dart';
import 'package:leafer/models/sensor_data.dart';
import 'package:leafer/services/plant_collection_service.dart';
import 'package:leafer/services/sensor_data_service.dart';
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
                          if (value.data == "" || value.data == _NO_SENSOR) {
                            return Text(
                              "NO DATA",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Humidité de l'air : " +
                                      value.data.airHumidity.toString(),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  "Humidité du sol : " +
                                      value.data.groundHumidity.toString(),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  textAlign: TextAlign.left,
                                )
                              ],
                            );
                          }
                        } else if(value.data == null){
                          return Text(
                              "NO DATA",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            );
                        }
                         else {
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

  Future<SensorData> getLastSensorData() async {
    PlantCollection p =
        await PlantCollectionService.findByPlantAndUser(_plant.id);
    if (p != null) {
      Sensor s = await SensorService.getSensor(p.id);
      if(s != null){
        return await SensorDataService.getLastDataById(s);
      }
      else{
        return null;
      }
    } else {
      return null;
    }
  }
}
