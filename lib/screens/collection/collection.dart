import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/services/plant_service.dart';
import 'package:random_string/random_string.dart';

class Collection extends StatefulWidget {
  static const String TITLE = 'Plantes';

  @override
  CollectionState createState() => CollectionState();
}

class CollectionState extends State<Collection> {
  List<Plant> _collection = new List<Plant>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    _getCollection();
  }

  void _getCollection() async {
    List<Plant> data = await PlantService.getPlants();
    setState(() {
      _collection = data;
    });
  }

  Widget _buildList(BuildContext context, List<Plant> plants) {
    return ListView.builder(
        key: Key(randomString(20)),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, item) {
          final index = item;
          return _buildRow(plants.elementAt(index));
        },
        itemCount: plants.length);
  }

  Widget _buildRow(Plant plant) {
    return Card(
        child: Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                  image: plant.getPicture(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    child: Text(
                      plant.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.black, fontSize: 35),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      "Besoin en humidité : " + plant.humidity.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Collection.TITLE),
      ),
      body: _buildList(context, _collection),
      floatingActionButton: FloatingActionButton(
        heroTag: 'CollectionTag',
        onPressed: () async {
          await RestDatasource.logout();
          Navigator.of(context).pushReplacementNamed("/login");
        },
      ),
    );
  }
}
