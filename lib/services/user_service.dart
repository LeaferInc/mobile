import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/utils/utils.dart';

class UserService {
  static const _BASE_URL_USER = RestDatasource.HOST + '/user/';

  static List<User> _parseUsers(String responseBody) {
    if(jsonDecode(responseBody) != null) {
      final parsed =
        jsonDecode(responseBody).cast<Map<String, dynamic>>();
      return parsed.map<User>((json) => User.fromMap(json)).toList();
    } else {
      return [];
    }
  }

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

  static Future<List<User>> getTalkTo() async {
    final response = await get(_BASE_URL_USER + 'talkTo',
            headers: await Utils.getAuthorizationHeaders())
      .timeout(RestDatasource.TIMEOUT);
    if(response.statusCode == 200) {
      return compute(_parseUsers, response.body);
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
