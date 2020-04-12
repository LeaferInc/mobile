import 'dart:convert';

import 'package:flutter/material.dart';
import './plant.dart';

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
              if (item.isOdd) return Divider();

              final index = item ~/ 2;
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
                        newData[index]["creationDate"])));
              }

              return _buildRow(_collection[index]);
            },
            itemCount: newData.length * 2, //size of list + dividers
          );
        });
  }

  Widget _buildRow(Plant plant) {
    return ListTile(
      title: Text(plant.name, style: TextStyle(fontSize: 18.0)),
      subtitle: Text("Humidity level needed : " + plant.humidity.toString()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leafer'),
      ),
      body: _buildList(context),
    );
  }
}
