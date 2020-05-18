import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/utils/utils.dart';

class PlantService {
  static const _BASE_URL = RestDatasource.HOST + '/plant/';

  /// Parses an array of Plant from json
  static List<Plant> _parsePlants(String responseBody) {
    final parsed = jsonDecode(responseBody)[0].cast<Map<String, dynamic>>();
    return parsed.map<Plant>((json) => Plant.fromMap(json)).toList();
  }

  /// Parses a single Plant from json
  static Plant _parsePlant(String responseBody) {
    return Plant.fromMap(jsonDecode(responseBody));
  }

  /// Get all Plants of the user from userId
  static Future<List<Plant>> getPlants() async {
    Map<String, String> headers = new Map<String, String>();

    headers.addAll(Utils.headers);
    headers.addAll(<String, String>{
      'Authorization': 'Bearer ' + await RestDatasource.storage.read(key: 'jwt')
    });
    final response = await get(_BASE_URL + 'my', headers: headers);
    if (response.statusCode == 200) {
      return compute(_parsePlants, response.body);
    }
    return [];
  }

  /// Get a single plant by its id
  static Future<Plant> getPlantById(int id) async {
    final response = await get(_BASE_URL + id.toString());
    if (response.statusCode == 200) {
      return compute(_parsePlant, response.body);
    }
    return null;
  }

  /// Post an Plant to save it
  static Future<Plant> savePlant(Plant plant) async {
    final response =
        await post(_BASE_URL, headers: Utils.headers, body: jsonEncode(plant));
    if (response.statusCode == 201) {
      return compute(_parsePlant, response.body);
    }
    return null;
  }
}
