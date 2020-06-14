import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/cutting.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/utils/utils.dart';

class UserService {
  static const _BASE_URL = RestDatasource.HOST + '/auth/';

  static User _parseUser(String reponseBody) {
    return User.fromMap(jsonDecode(reponseBody));
  }

  static Future<User> getCurrentUser() async {
    final response = await get(_BASE_URL + 'me',
        headers: await Utils.getAuthorizationHeaders());
    if (response.statusCode == 200) {
      return compute(_parseUser, response.body);
    }
    return null;
  }
}
