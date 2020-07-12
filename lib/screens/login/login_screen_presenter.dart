import 'package:leafer/data/rest_ds.dart';

abstract class LoginScreenContract {
  void onLoginSuccess();

  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();

  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((_) {
      _view.onLoginSuccess();
    }).catchError((Object error) {
      _view.onLoginError(error.toString());
      print('doLogin(), error: $error');
    });
  }
}
