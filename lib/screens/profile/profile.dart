import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/screens/profile/edit_profile.dart';
import 'package:leafer/services/user_service.dart';
import 'package:leafer/widgets/loading.dart';

class Profile extends StatefulWidget {
  static const TITLE = "Profil";

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _timeFormat = DateFormat.yMd('fr-FR');

  final _editKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  User user;

  @override
  initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    User _user = await UserService.getCurrentUser();
    setState(() {
      user = _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          Profile.TITLE,
        ),
        actions: <Widget>[
          IconButton(
            key: _editKey,
            icon: Icon(Icons.edit),
            onPressed: () async {
              User updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfile(user: this.user)));
              // Update screen
              if (updated != null) {
                setState(() {
                  this.user = updated;
                });
              }
            },
          ),
          PopupMenuButton(
            onSelected: (item) {
              return showDialog<void>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Suppression du compte'),
                  content: Text(
                      'Voulez-vous vraiment supprimer votre compte ? Cette action est irréversible.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Annuler'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('Supprimer'),
                      onPressed: () async {
                        int res = await UserService.deleteUser();
                        print('res: $res');
                        Navigator.pop(context);
                        if (res != 200) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Impossible de supprimer le compte'),
                          ));
                        } else {
                          await RestDatasource.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                    ),
                  ],
                ),
              );
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text(
                    'Supprimer le compte',
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _buildScreen(),
      ),
    );
  }

  /// display loading or screen if data
  Widget _buildScreen() {
    if (this.user == null) {
      return Center(
        child: Loading(),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      );
    }
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
          '$title:',
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
