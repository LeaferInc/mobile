import 'package:flutter/material.dart';
import 'package:leafer/models/best_plant.dart';

class BestPlantResult extends StatefulWidget {
  final BestPlant plant;

  BestPlantResult({Key key, @required this.plant}) : super(key: key);

  @override
  _BestPlantResultState createState() => _BestPlantResultState(plant);
}

class _BestPlantResultState extends State<BestPlantResult> {
  final BestPlant _plant;

  _BestPlantResultState(this._plant);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plante conseillée'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: _plant.getPicture(),
                height: 250.0,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'Nom: ${_plant.name}',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              'Taille: ${_plant.height}',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              'Exposition lumineuse: ${_plant.luminosity}',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              'Entretien demandé: ${_plant.careTime}',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              'Rempottage: Tous les ${_plant.potting} an(s)',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              'Prix estimé: ~${_plant.price}€',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              'Toxique pour les animaux: ${_plant.toxicity ? 'Oui' : 'Non'}',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
