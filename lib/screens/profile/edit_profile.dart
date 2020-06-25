import 'package:flutter/material.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/screens/profile/profile.dart';

class EditProfile extends StatefulWidget {
  final User user;

  EditProfile({Key key, @required this.user});

  @override
  _EditProfileState createState() => _EditProfileState(this.user);
}

class _EditProfileState extends State<EditProfile> {
  final User _user;
  final Map<String, String> _changes = {};

  _EditProfileState(this._user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Profile.TITLE),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Prénom',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Un nom original',
              hintStyle: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            initialValue: _user.firstname,
            maxLines: 1,
            onSaved: (value) => _changes['firstname'] = value,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
