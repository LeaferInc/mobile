import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/best_plant.dart';
import 'package:leafer/utils/utils.dart';

class BestPlantService {
  static const _BASE_URL = RestDatasource.HOST + '/best-plant/';

  /// Parses the recognition results from json
  static BestPlant _parseBestPlant(String responseBody) {
    return BestPlant.fromMap(jsonDecode(responseBody));
  }

  /// Get the best plant for a user
  static Future<BestPlant> findBestPlant(BestPlantSearch search) async {
    final response = await post(_BASE_URL,
            headers: await Utils.getAuthorizationHeaders(),
            body: jsonEncode(search))
        .timeout(RestDatasource.TIMEOUT);

    if (response.statusCode == 200) {
      return compute(_parseBestPlant, response.body);
    }
    return null;
  }
}
