import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = new ImagePicker();
  final _difficulty = ["facile", "moyen", "difficile"];
  final _wateringFrequencySpringToSummer = ["heure", "jour", "semaine", "mois"];
  final _wateringFrequencyAutumnToWinter = ["heure", "jour", "semaine", "mois"];

  File _image;
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
        difficulty: "facile",
        exposure: 'exposure',
        humidityMax: 100,
        humidityMin: 0,
        potting: 'potting',
        toxicity: false,
        wateringFrequencySpringToSummerNumber: 0,
        wateringFrequencyAutumnToWinterNumber: 0,
        wateringFrequencyAutumnToWinter: "heure",
        wateringFrequencySpringToSummer: "heure");
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
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Image:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: IconButton(
                        icon: Icon(
                          Icons.image,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          final pickedFile = await _picker.getImage(
                              source: ImageSource.gallery);
                          _image = File(pickedFile.path);
                        },
                      ),
                    ),
                  ],
                ),
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
                  'Humidité Max',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'En %',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _createdPlant.humidityMax = int.parse(value),
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Humidité Min',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'En %',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _createdPlant.humidityMin = int.parse(value),
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
                  items:
                      _difficulty.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Fréquence d\'arrosage',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Printemps - été',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Tous les',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _createdPlant
                                .wateringFrequencySpringToSummerNumber =
                            int.parse(value),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _createdPlant.wateringFrequencySpringToSummer
                            .toString(),
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _createdPlant.wateringFrequencySpringToSummer =
                                newValue;
                          });
                        },
                        items: _wateringFrequencySpringToSummer
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                Text(
                  'Automne - hiver',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Tous les',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _createdPlant
                                .wateringFrequencyAutumnToWinterNumber =
                            int.parse(value),
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _createdPlant.wateringFrequencyAutumnToWinter
                            .toString(),
                        underline: Container(
                          height: 2,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _createdPlant.wateringFrequencyAutumnToWinter =
                                newValue;
                          });
                        },
                        items: _wateringFrequencyAutumnToWinter
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Exposition',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Décrire l\'exposition';
                    }
                    return null;
                  },
                  onSaved: (value) => _createdPlant.exposure = value,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Rempotage',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  maxLines: 1,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Instruction de rempotage';
                    }
                    return null;
                  },
                  onSaved: (value) => _createdPlant.potting = value,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Toxique',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Switch(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        value: _createdPlant.toxicity,
                        onChanged: (value) => setState(() {
                              _createdPlant.toxicity = value;
                            })),
                  ],
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
                          _createdPlant.picture = _image.readAsBytesSync();

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
