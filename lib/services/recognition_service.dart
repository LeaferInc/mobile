import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/recognition.dart';
import 'package:leafer/utils/utils.dart';

class RecognitionService {
  static const _BASE_URL = RestDatasource.HOST + '/recognize/';

  /// Parses the recognition results from json
  static RecognitionResult _parseRecognition(String responseBody) {
    return RecognitionResult.fromMap(jsonDecode(responseBody));
  }

  /// Recognize a plant
  static Future<dynamic> recognize(RecognitionSearch search) async {
    final response = await post(_BASE_URL,
            headers: await Utils.getAuthorizationHeaders(),
            body: jsonEncode(search))
        .timeout(RestDatasource.TIMEOUT);

    if (response.statusCode == 200) {
      return compute(_parseRecognition, response.body);
    }
    return response.statusCode;
  }
}
