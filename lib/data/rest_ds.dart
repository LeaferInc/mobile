import 'dart:convert';

import 'package:leafer/models/user.dart';
import 'package:leafer/utils/network_util.dart';
import 'package:leafer/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static const HOST = "http://10.0.2.2:3000";
  static const LOGIN_ROUTE = "/auth/login";
  static const SIGN_IN_ROUTE = "/user";
  static const COLLECTION_ROUTE = "/plant/search";
  static const LOGIN_URL = HOST + LOGIN_ROUTE;

  Future<User> login(String username, String password) {
    return _netUtil
        .post(LOGIN_URL,
            headers: Utils.headers,
            body: jsonEncode(
                <String, String>{"username": username, "password": password}))
        .then((dynamic res) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', res["token"]);
      return User.fromJson(res["user"]);
    }).catchError((dynamic res) {
      throw new Exception("Error");
    });
  }

  Future<User> signIn(String username, String password, String email,
      String firstname, String lastname) {
    return _netUtil
        .post(HOST + SIGN_IN_ROUTE,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(<String, String>{
              "username": username,
              "email": email,
              "password": password,
              "firstname": firstname,
              "lastname": lastname
            }))
        .then((dynamic res) {
      return User.fromJson(res);
    }).catchError((dynamic res) {
      throw new Exception(res["error_msg"]);
    });
  }
}
