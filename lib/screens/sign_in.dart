import 'package:flutter/material.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/screens/sign_in_presenter.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SignInState();
  }
}

class _SignInState extends State<SignIn> implements SignInContract {
  BuildContext _ctx;

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  SignInPresenter _presenter;
  String _username, _password, _email, _firstname, _lastname;

  _SignInState() {
    _presenter = new SignInPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[_buildFormFields(context)],
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _presenter.doSignIn(_username, _password, _email, _firstname, _lastname);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  Widget _buildFormFields(BuildContext context) {
    _ctx = context;

    return Center(
      child: Container(
        width: 250,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  _username = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  _password = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  _email = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your first name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  _firstname = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your last name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  _lastname = value;
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      _submit();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onSignInError(String error) {
    _showSnackBar(error);
  }

  @override
  void onSignInSuccess(User user) async {
    _showSnackBar(user.toString());
    Navigator.of(_ctx).pushNamed("/login");
  }
}
