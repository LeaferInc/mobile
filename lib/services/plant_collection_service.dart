import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/utils/utils.dart';

class PlantCollectionService {
  static const _BASE_URL = RestDatasource.HOST + '/plant-collection/';

  /// Parses an array of PlantCollection from json
  static List<PlantCollection> _parsePlantCollections(String responseBody) {
    final parsed = jsonDecode(responseBody)[0].cast<Map<String, dynamic>>();
    return parsed
        .map<PlantCollection>((json) => PlantCollection.fromMap(json))
        .toList();
  }

  /// Parses a single PlantCollection from json
  static PlantCollection _parsePlantCollection(String responseBody) {
    return PlantCollection.fromMap(jsonDecode(responseBody));
  }

  static Future<PlantCollection> findByPlantAndUser(int plantId) async {
    final response = await get(
            _BASE_URL + 'findByPlantAndUser?id=' + plantId.toString(),
            headers: Utils.headers)
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parsePlantCollection, response.body);
    }
    return null;
  }

  /// Post a Plant to save it
  static Future<PlantCollection> savePlantCollection(
      PlantCollection plantCollection) async {
    final response = await post(_BASE_URL,
            headers: Utils.headers, body: jsonEncode(plantCollection))
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 201) {
      return compute(_parsePlantCollection, response.body);
    }
    return null;
  }

  static Future<PlantCollection> deletePlantCollection(
      PlantCollection plantCollection) async {
    final response = await delete(_BASE_URL + plantCollection.id.toString(),
            headers: Utils.headers)
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parsePlantCollection, response.body);
    }
    return null;
  }
}
