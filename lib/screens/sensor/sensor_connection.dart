import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leafer/models/sensor_settings.dart';
import 'package:leafer/services/sensor_service.dart';
import 'package:leafer/services/wifi_service.dart';
import 'package:wifi/wifi.dart';

class SensorConnection extends StatefulWidget {
  final String ssid;
  final String password;
  final SensorSettings sensor;

  SensorConnection(
      {Key key,
      @required this.sensor,
      @required this.ssid,
      @required this.password})
      : super(key: key);

  @override
  _SensorConnectionState createState() =>
      _SensorConnectionState(sensor, ssid, password);
}

class _SensorConnectionState extends State<SensorConnection> {
  String _ssid;
  String _password;
  SensorSettings _sensor;

  _SensorConnectionState(this._sensor, this._ssid, this._password);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<String>(
          future: connectLeaferSensor(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Container(
                  child: FutureBuilder<String>(
                    future: createSensor(_sensor),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Container(
                            child: FutureBuilder<String>(
                              future: connectBackWifi(_ssid, _password),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Text('Success !');
                                  }
                                }
                                else{
                                  return Text('Error');
                                }
                              },
                            ),
                          );
                        }
                      }
                      else{
                        return Text('Error');
                      }
                    },
                  ),
                );
              }
            } else {
              return Text("Error");
            }
          }),
    );
  }

  Future<String> createSensor(SensorSettings sensor) async {
    return await SensorService.connectToSensor(sensor);
  }

  Future<String> connectLeaferSensor() async {
    return await WifiService.connectLeaferSensor();
  }

  Future<String> connectBackWifi(ssid, password) async {
    return await WifiService.connectBackToWifi(ssid, password);
  }
}
