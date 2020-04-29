import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/plant.dart';

class Collection extends StatefulWidget {
  @override
  CollectionState createState() => CollectionState();
}

class CollectionState extends State<Collection> {
  final _collection = <Plant>[];

  Widget _buildList(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/plants_test_sample.json'),
        builder: (context, snapshot) {
          List newData = json.decode(snapshot.data.toString());
          return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, item) {
                final index = item;
                if (index >= _collection.length) {
                  _collection.addAll(List.generate(
                      newData.length,
                      (int index) => new Plant(
                          newData[index]["name"],
                          newData[index]["humidity"],
                          newData[index]["watering"],
                          newData[index]["difficulty"],
                          newData[index]["exposure"],
                          newData[index]["toxicity"],
                          newData[index]["potting"],
                          newData[index]["creationDate"],
                          newData[index]["image"])));
                }

                return _buildRow(_collection[index]);
              },
              itemCount: newData.length);
        });
  }

  Widget _buildRow(Plant plant) {
    return Card(
        child: Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Column(children: <Widget>[
              Image(image: NetworkImage(plant.image), height: 150),
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
      body: _buildList(context),
    );
  }
}
