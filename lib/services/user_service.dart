import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/utils/utils.dart';

class UserService {
  static const _BASE_URL_AUTH = RestDatasource.HOST + '/auth/';
  static const _BASE_URL_USER = RestDatasource.HOST + '/user/';

  static User _parseUser(String reponseBody) {
    return User.fromMap(jsonDecode(reponseBody));
  }

  static Future<User> getUserFromId(int id) async {
    final response = await get(_BASE_URL_USER + id.toString())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseUser, response.body);
    }
    return null;
  }

  static Future<User> getCurrentUser() async {
    final response = await get(_BASE_URL_AUTH + 'me',
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseUser, response.body);
    }
    return null;
  }
}
