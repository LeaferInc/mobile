import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/user.dart';
// import 'package:leafer/utils/network_util.dart';
import 'package:http/http.dart';
import 'package:leafer/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  HttpClient _client = new HttpClient();
  static final HOST = "http://10.0.2.2:3000";
  static final LOGIN_ROUTE = "/auth/login";
  static final SIGN_IN_ROUTE = "/user";
  static final COLLECTION_ROUTE = "/plant/search";
  static final LOGIN_URL = HOST + LOGIN_ROUTE;
  static final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<User> login(String username, String password) {
    return _netUtil
        .post(LOGIN_URL,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(
                <String, String>{"username": username, "password": password}))
        .then((dynamic res) {
      storage.write(key: 'jwt', value: res["token"]);
      return new User.map(res["user"]);
    }).catchError((dynamic res) {
      throw new Exception(res["error_msg"]);
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
      return new User.map(res);
    }).catchError((dynamic res) {
      throw new Exception(res["error_msg"]);
    });
  }
}
