import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/services/plant_collection_service.dart';
import 'package:leafer/services/user_service.dart';

class PlantInfoExchange extends StatefulWidget {
  final Plant plant;

  PlantInfoExchange({Key key, @required this.plant}) : super(key: key);

  @override
  _PlantInfoExchangeState createState() => _PlantInfoExchangeState(plant);
}

class _PlantInfoExchangeState extends State<PlantInfoExchange> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Plant _plant;

  _PlantInfoExchangeState(this._plant);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_plant.name),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: NetworkImage("https://picsum.photos/200"),
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _plant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _plant.height.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _plant.humidityMin.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _plant.humidityMax.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      onPressed: () async {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Ajout en cours en cours...')));
                        User currentUser = await UserService.getCurrentUser();
                        PlantCollection plantCollection = new PlantCollection(
                            plantId: _plant.id, userId: currentUser.id);
                        await PlantCollectionService.savePlantCollection(
                            plantCollection);
                        Navigator.pushNamed(context, "/collection");
                      },
                      elevation: 0.0,
                      child: Text('Ajouter à mon jardin')),
                ),
              ])),
    );
  }
}
