import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/models/sensor_settings.dart';
import 'package:leafer/screens/sensor/sensor_connection.dart';
import 'package:leafer/services/sensor_service.dart';
import 'package:wifi/wifi.dart';

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

  WifiState _wifiState;
  List<WifiResult> ssidList = [];

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
    _wifiState = WifiState.already;
    print(_wifiState);
    loadData();
  }

  void loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
      });
    });
  }

  Future<Null> connection() async {
    Wifi.connection(_settings.ssid, _settings.password).then((v) {
      print(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(SensorAssociation.TITLE),
        ),
        body: SafeArea(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: ssidList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return wifiList(index);
            },
          ),
        ));
  }

  Widget wifiList(index) {
    if (index == 0) {
      return Title(
        child: Text(
          'Sélectionnez un point d\'accès :',
          style: TextStyle(fontSize: 25),
        ),
        color: Colors.black,
      );
    } else {
      return Column(children: <Widget>[
        Divider(),
        ListTile(
          title: Text(ssidList[index - 1].ssid,
              style: TextStyle(color: Colors.black, fontSize: 16.0)),
          dense: true,
          onTap: () {
            this.setState(() {
              _settings.ssid = ssidList[index - 1].ssid;
            });
            showDialog(
                context: this.context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            )),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Title(
                                  child: Text(_settings.ssid),
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Title(
                                  child: Text("Password: "),
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  onSaved: (value) =>
                                      _settings.password = value,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Associer"),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      _settings.plantCollection =
                                          _plantCollection.id;
                                      if (_formKey.currentState.validate() &&
                                          !_isSending) {
                                        _isSending = true;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SensorConnection(sensor: _settings ,ssid :Wifi.ssid.toString(), password: _settings.password)));
    
                                      }
                                    }
                                  },
                                ),
                              )
                            ],
                          ))
                    ],
                  ));
                });
          },
        ),
      ]);
    }
  }
}
