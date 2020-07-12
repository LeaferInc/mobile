import 'package:flutter/material.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/screens/collection/plant_info_exchange.dart';
import 'package:leafer/services/plant_service.dart';
import 'package:leafer/widgets/plant_card.dart';
import 'package:random_string/random_string.dart';

class PlantExchange extends StatefulWidget {
  static const String TITLE = 'Trouver des plantes';

  @override
  PlantExchangeState createState() => PlantExchangeState();
}

class PlantExchangeState extends State<PlantExchange> {
  List<Plant> _myPlants = new List<Plant>();

  @override
  initState() {
    super.initState();
    _getMyCuttings();
  }

  void _getMyCuttings() async {
    List<Plant> data = await PlantService.getAllExceptOwner();
    setState(() {
      _myPlants = data;
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
            PlantCard(
              plant: plant,
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlantInfoExchange(plant: plant)));
              },
            )
          ],
        ),
      ],
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildList(context, _myPlants),
    );
  }
}
