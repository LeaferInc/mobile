import 'package:flutter/material.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/screens/collection/my_plants.dart';
import 'package:leafer/screens/collection/plant_exchange.dart';
import 'package:leafer/screens/collection/plant_form.dart';
import 'package:leafer/screens/collection/plant_tab.dart';

const List<PlantTab> tabs = const <PlantTab>[
  const PlantTab(title: 'Mon jardins', icon: Icons.collections_bookmark),
  const PlantTab(title: 'Trouver des plantes', icon: Icons.shop),
];

class PlantsHome extends StatelessWidget {
  static const String TITLE = 'Plantes';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plantes'),
          bottom: TabBar(
            tabs: tabs.map((PlantTab tab) {
              return Tab(text: tab.title, icon: Icon(tab.icon));
            }).toList(),
          ),
        ),
        body: TabBarView(children: <Widget>[MyPlants(), PlantExchange()]),
        floatingActionButton: FloatingActionButton(
          heroTag: 'MyPlantsTag',
          child: Icon(Icons.add),
          onPressed: () async {
            final Plant result = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => PlantForm()));
          },
        ),
      ),
    );
  }
}
