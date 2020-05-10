import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/user.dart';

abstract class SignInContract {
  void onSignInSuccess(User user);
  void onSignInError(String errorTxt);
}

class SignInPresenter {
  SignInContract _view;
  RestDatasource api = new RestDatasource();
  SignInPresenter(this._view);

  doSignIn(String username, String password, String email, String firstname,
      String lastname) {
    api
        .signIn(username, password, email, firstname, lastname)
        .then((User user) {
      _view.onSignInSuccess(user);
    }).catchError((Object error) => _view.onSignInError(error.toString()));
  }
}
