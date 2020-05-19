import 'package:flutter/material.dart';
import 'package:leafer/auth.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/screens/login/login_screen_presenter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  LoginScreenPresenter _presenter;
  String _username, _password;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/collection");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
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
      _presenter.doLogin(_username, _password);
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
                  hintText: 'Entrez votre login',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ne peut être vide';
                  }
                  _username = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Entrez votre mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ne peut être vide';
                  }
                  _password = value;
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
                  child: Text('Se connecter'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: GestureDetector(
                    child: Text("Créer un compte",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue)),
                    onTap: () {
                      Navigator.pushNamed(_ctx, "/signIn");
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}
