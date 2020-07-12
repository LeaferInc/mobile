import 'package:flutter/material.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/services/plant_service.dart';
import 'package:leafer/services/user_service.dart';

class PlantForm extends StatefulWidget {
  static const String TITLE = 'Création de Plante';

  @override
  _PlantFormState createState() => _PlantFormState();
}

class _PlantFormState extends State<PlantForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Plant _createdPlant;
  bool _isSending;

  @override
  void initState() {
    super.initState();
    _isSending = false;

    _createdPlant = Plant(
        creationDate: DateTime.now(),
        height: 0,
        name: 'Plant name',
        difficulty: "easy",
        exposure: 'exposure',
        humidity: 'humidity',
        potting: 'potting',
        toxicity: false,
        wateringFrequencySpringToSummerNumber: 0,
        wateringFrequencyAutumnToWinterNumber: 0,
        wateringFrequencyAutumnToWinter: "hour",
        wateringFrequencySpringToSummer: "hour");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Nouvelle Plante'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Nom',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Choisissez un nom',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Entrez un nom valide';
                    }
                    return null;
                  },
                  onSaved: (value) => _createdPlant.name = value,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Taille de la plante',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'En cm',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _createdPlant.height = int.parse(value),
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Difficulté',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                DropdownButton<String>(
                  value: _createdPlant.difficulty.toString(),
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      _createdPlant.difficulty = newValue;
                    });
                  },
                  items: <String>["easy", "medium", "hard"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate() && !_isSending) {
                          _createdPlant.ownerId =
                              (await UserService.getCurrentUser()).id;
                          _isSending = true;
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Ajout en cours...')));

                          _formKey.currentState.save();

                          Plant created =
                              await PlantService.savePlant(_createdPlant);

                          _isSending = false;
                          if (created != null) {
                            Navigator.pop(context, created);
                          } else {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('Création impossible')));
                          }
                        }
                      },
                      elevation: 0.0,
                      child: Text('Créer')),
                ),
              ],
            ),
          ),
        ));
  }
}
