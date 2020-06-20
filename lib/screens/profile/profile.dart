import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/screens/profile/edit_profile.dart';

class Profile extends StatefulWidget {
  static const TITLE = "Profil";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _timeFormat = DateFormat.yMd('fr-FR');

  final _editKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    User user = RestDatasource.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Profile.TITLE,
        ),
        actions: <Widget>[
          IconButton(
            key: _editKey,
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _displayData(title: 'Nom utilisateur', data: user.username),
            _displayData(title: 'Email', data: user.email),
            _displayData(title: 'Prénom', data: user.firstname),
            _displayData(title: 'Nom', data: user.lastname),
            _displayData(title: 'Lieu', data: user.location),
            _displayData(
                title: 'Naissance',
                data: user.birthdate != null
                    ? _timeFormat.format(user.birthdate)
                    : user.birthdate),
            _displayData(title: 'Bio', data: user.biography),
          ],
        ),
      ),
    );
  }

  /// Display the value or a placeholder text of none was present
  Row _displayData({@required String title, @required String data}) {
    Text dataText;
    if (data == null || data.isEmpty) {
      dataText = Text(
        'Non renseigné',
        style: TextStyle(
          fontSize: 15.0,
          fontStyle: FontStyle.italic,
        ),
      );
    } else {
      dataText = Text(
        data,
        style: TextStyle(
          fontSize: 15.0,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
          child: dataText,
        ),
      ],
    );
  }
}
