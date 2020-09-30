import 'dart:convert';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/screens/profile/profile.dart';
import 'package:leafer/services/user_service.dart';
import 'package:leafer/utils/utils.dart';

class EditProfile extends StatefulWidget {
  final User user;

  EditProfile({Key key, @required this.user});

  @override
  _EditProfileState createState() => _EditProfileState(this.user);
}

class _EditProfileState extends State<EditProfile> {
  static const _BIRTHDATE_KEY = 'birthdate';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  final User _user;

  final Map<String, dynamic> _changes = {};

  bool _isSending = false;
  File _image;

  _EditProfileState(this._user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Profile.TITLE),
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
                      'Avatar:',
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
                        final pickedFile =
                            await _picker.getImage(source: ImageSource.gallery);
                        _image = File(pickedFile.path);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Text(
                'Prénom',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Votre prénom',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  initialValue: _user.firstname,
                  maxLines: 1,
                  onSaved: (value) => _changes['firstname'] = value,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Nom',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Votre nom',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  initialValue: _user.lastname,
                  maxLines: 1,
                  onSaved: (value) => _changes['lastname'] = value,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Date de naissance',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: DateTimeField(
                  format: Utils.dateFormat,
                  initialValue: _user.birthdate,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1960),
                      initialDate: currentValue ?? _user.birthdate,
                      lastDate: DateTime.now(),
                      locale: Locale('fr'),
                    );
                  },
                  onSaved: (DateTime value) {
                    _changes[_BIRTHDATE_KEY] = value;
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Lieu',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Votre lieu de résidence',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  initialValue: _user.location,
                  maxLines: 1,
                  onSaved: (value) => _changes['location'] = value,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Bio',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Quelque chose sur vous...',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  initialValue: _user.biography,
                  minLines: 1,
                  maxLines: 3,
                  onSaved: (value) => _changes['biography'] = value.trim(),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    onPressed: () async {
                      if (!_isSending) {
                        _isSending = true;

                        _formKey.currentState.save();

                        // Remove unmodified or empty fields
                        Map<String, dynamic> userMap = _user.toJson();
                        for (String key in userMap.keys) {
                          if (userMap[key] == _changes[key] ||
                              _changes[key] == '') {
                            _changes.remove(key);
                          }
                        }

                        // Check date equality
                        if (Utils.isSameDate(
                            _user.birthdate, _changes[_BIRTHDATE_KEY])) {
                          _changes.remove(_BIRTHDATE_KEY);
                        }

                        // Check birthdate
                        if ((_changes[_BIRTHDATE_KEY] as DateTime)
                            .isAfter(DateTime.now())) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  'La date de naissance doit être dans le passé.')));
                          return;
                        } else {
                          // Json parse
                          _changes[_BIRTHDATE_KEY] =
                              (_changes[_BIRTHDATE_KEY] as DateTime)
                                  .toIso8601String();
                        }

                        // Check avatar update
                        if (_image != null) {
                          _changes['picture'] =
                              base64Encode(_image.readAsBytesSync());
                        }

                        if (_changes.keys.length == 0) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Aucune modification effectuée')));
                          _isSending = false;
                        } else {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Mise à jour en cours...')));

                          User updated = await UserService.updateUser(_changes);

                          _isSending = false;
                          if (updated != null) {
                            Navigator.pop(context, updated);
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Mise à jour impossible')));
                          }
                        }
                      }
                    },
                    elevation: 0.0,
                    child: Text('Mettre à jour')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
