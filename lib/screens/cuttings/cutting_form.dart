import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafer/models/cutting.dart';
import 'package:leafer/services/cutting_service.dart';
import 'package:leafer/services/user_service.dart';

class CuttingForm extends StatefulWidget {
  static const String TITLE = 'Création de Bouture';

  @override
  _CuttingFormState createState() => _CuttingFormState();
}

class _CuttingFormState extends State<CuttingForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = new ImagePicker();

  File _image;
  Cutting _createdCutting;
  bool _isSending;

  @override
  void initState() {
    super.initState();
    _isSending = false;

    _createdCutting = Cutting(
        description: 'Cutting desctiption',
        name: 'Cutting name',
        ownerId: 0,
        tradeWith: "",
        viewCount: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Nouvelle Bouture'),
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
                    )
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
                  onSaved: (value) => _createdCutting.name = value,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Description de la bouture',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSaved: (value) => _createdCutting.description = value,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate() && !_isSending) {
                          _createdCutting.ownerId =
                              (await UserService.getCurrentUser()).id;
                          _isSending = true;
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(content: Text('Ajout en cours...')));

                          _formKey.currentState.save();
                          _createdCutting.picture = _image.readAsBytesSync();

                          Cutting created =
                              await CuttingService.saveCutting(_createdCutting);

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
