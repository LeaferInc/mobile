import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/services/plant_service.dart';
import 'package:leafer/widgets/custom_nav_bar.dart';
import 'package:random_string/random_string.dart';

import '../models/plant.dart';

class Collection extends StatefulWidget {
  @override
  CollectionState createState() => CollectionState();
}

class CollectionState extends State<Collection> {
  int _currentIndex = 0;
  List<Plant> _collection = new List<Plant>();

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
          // if (index >= _collection.length) {
          //   _collection.addAll(
          //     // List.generate(
          //     //   newData.length,
          //     //   (int index) => new Plant(
          //     //       name: newData[index]["name"],
          //     //       humidity: newData[index]["humidity"],
          //     //       watering: newData[index]["watering"],
          //     //       difficulty: newData[index]["difficulty"],
          //     //       exposure: newData[index]["exposure"],
          //     //       toxicity: newData[index]["toxicity"],
          //     //       potting: newData[index]["potting"],
          //     //       creationDate: newData[index]["creationDate"],
          //     //       image: newData[index]["image"])));
          // }

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
            Column(children: <Widget>[
              Image(
                  image: NetworkImage("https://picsum.photos/200"),
                  height: 150),
            ]),
            Column(
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
            )
          ],
        ),
      ],
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes plantes'),
      ),
      body: _buildList(context, _collection),
      bottomNavigationBar: CustomNavBar(index: _currentIndex),
      floatingActionButton: FloatingActionButton(onPressed: () {
        RestDatasource.storage.deleteAll();
        Navigator.of(context).pushReplacementNamed("/login");
      }),
    );
  }
}
