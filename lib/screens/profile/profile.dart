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

  User _user;
  bool _isLoaded = false; // True when query finishes

  @override
  initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    User user = await UserService.getCurrentUser();
    setState(() {
      _user = user;
      _isLoaded = true;
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
                      builder: (context) => EditProfile(user: _user)));
              // Update screen
              if (updated != null) {
                setState(() {
                  _user = updated;
                });
              }
            },
          ),
          PopupMenuButton(
            onSelected: (item) async {
              switch (item) {
                case 0:
                  Navigator.pushNamed(context, '/best-plant');
                  break;
                case 1:
                  // Account deletion
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
                            Navigator.pop(context);
                            if (res != 200) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content:
                                    Text('Impossible de supprimer le compte'),
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
                case 2:
                  // Logout
                  await RestDatasource.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                  break;
              }
              return null;
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 0,
                  child: Text('Quelle plante pour moi ?'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Supprimer le compte'),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text('Déconnexion'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: _buildScreen(),
      ),
    );
  }

  /// display loading or screen if data
  Widget _buildScreen() {
    if (!_isLoaded) {
      return Center(
        child: Loading(),
      );
    } else {
      if (_user == null) {
        return Center(
          child: Text(
            'Profil non trouvé',
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundImage: _user.getPicture(),
              minRadius: 35.0,
              maxRadius: 50.0,
            ),
            _displayData(title: 'Nom utilisateur', data: _user.username),
            _displayData(title: 'Email', data: _user.email),
            _displayData(title: 'Prénom', data: _user.firstname),
            _displayData(title: 'Nom', data: _user.lastname),
            _displayData(title: 'Lieu', data: _user.location),
            _displayData(
                title: 'Naissance',
                data: _user.birthdate != null
                    ? _timeFormat.format(_user.birthdate)
                    : _user.birthdate),
            _displayData(title: 'Bio', data: _user.biography),
          ],
        );
      }
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
