import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/utils/utils.dart';

class UserService {
  static const _BASE_URL_USER = RestDatasource.HOST + '/user/';

  static User _parseUser(String responseBody) {
    return User.fromMap(jsonDecode(responseBody));
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
    final response = await get(_BASE_URL_USER + 'me',
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseUser, response.body);
    }
    return null;
  }

  static Future<User> updateUser(Map<String, dynamic> changes) async {
    final response = await put(_BASE_URL_USER,
            headers: await Utils.getAuthorizationHeaders(),
            body: jsonEncode(changes))
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseUser, response.body);
    }
    return null;
  }

  static Future<int> deleteUser() async {
    final res = await delete(_BASE_URL_USER,
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    return res.statusCode;
  }
}
