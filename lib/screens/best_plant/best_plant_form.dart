import 'package:flutter/material.dart';
import 'package:leafer/models/best_plant.dart';
import 'package:leafer/screens/best_plant/best_plant_result.dart';
import 'package:leafer/services/best_plant_service.dart';

class BestPlantForm extends StatefulWidget {
  @override
  _BestPlantFormState createState() => _BestPlantFormState();
}

class _BestPlantFormState extends State<BestPlantForm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  int _idSpace;
  int _idPets;

  BestPlantSearch _plantSearch;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _plantSearch = BestPlantSearch(
      careTime: 'Suffisamment',
      weather: 'Ensoleillé',
      space: false,
      budget: 20,
      hasPet: false,
    );

    _idSpace = _plantSearch.space ? 1 : 0;
    _idPets = _plantSearch.hasPet ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Quelle plante pour moi ?'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Combien de temps pouvez-vous vous occuper d\'une plante ?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton(
                    value: _plantSearch.careTime,
                    items: <String>['Très peu', 'Suffisamment', 'Beaucoup']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _plantSearch.careTime = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                'En général, quel temps fait-il chez vous ?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton(
                    value: _plantSearch.weather,
                    items: <String>['Ensoleillé', 'Nuageux', 'Pluvieux']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _plantSearch.weather = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                'Disposez-vous de beaucoup d\'espace ?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _idSpace,
                      onChanged: (value) {
                        setState(() {
                          _plantSearch.space = value != 0;
                          _idSpace = value;
                        });
                      },
                    ),
                    Text(
                      'Non',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      value: 1,
                      groupValue: _idSpace,
                      onChanged: (value) {
                        setState(() {
                          _plantSearch.space = value != 0;
                          _idSpace = value;
                        });
                      },
                    ),
                    Text(
                      'Oui',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Disposez-vous de beaucoup d\'espace ?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: '20',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      initialValue: _plantSearch.budget.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        try {
                          int nb = int.parse(value);
                          if (nb < 1) return 'Prix incorrect';
                        } on FormatException {
                          return 'Prix incorrect';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          _plantSearch.budget = int.parse(value),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '€',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Avez-vous des animaux de compagnie ?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 0,
                      groupValue: _idPets,
                      onChanged: (value) {
                        setState(() {
                          _plantSearch.hasPet = value != 0;
                          _idPets = value;
                        });
                      },
                    ),
                    Text(
                      'Non',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      value: 1,
                      groupValue: _idPets,
                      onChanged: (value) {
                        setState(() {
                          _plantSearch.hasPet = value != 0;
                          _idPets = value;
                        });
                      },
                    ),
                    Text(
                      'Oui',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Chercher'),
                  onPressed: () async {
                    if (_formKey.currentState.validate() && !_isSending) {
                      _formKey.currentState.save();

                      // Budget check
                      if (_plantSearch.budget < 1) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Budget invalide'),
                        ));
                        return;
                      }

                      // Search Best Plant
                      _isSending = true;
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Recherche...'),
                      ));

                      BestPlant plant =
                          await BestPlantService.findBestPlant(_plantSearch);
                      _isSending = false;
                      _scaffoldKey.currentState.removeCurrentSnackBar();

                      if (plant != null) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BestPlantResult(
                              plant: plant,
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
