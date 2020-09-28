import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/plant.dart';
import 'package:leafer/models/plant_collection.dart';
import 'package:leafer/models/user.dart';
import 'package:leafer/services/plant_collection_service.dart';
import 'package:leafer/services/user_service.dart';
import 'package:leafer/utils/utils.dart';

class PlantService {
  static const _BASE_URL = RestDatasource.HOST + '/plants';

  /// Parses an array of Plant from json
  static List<Plant> _parsePlants(String responseBody) {
    if (jsonDecode(responseBody)['items'] != null) {
      final parsed =
          jsonDecode(responseBody)['items'].cast<Map<String, dynamic>>();
      return parsed.map<Plant>((json) => Plant.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  /// Parses a single Plant from json
  static Plant _parsePlant(String responseBody) {
    return Plant.fromMap(jsonDecode(responseBody));
  }

  /// Get all Plants of the user from userId
  static Future<List<Plant>> getPlants() async {
    final response = await get(_BASE_URL + '/my',
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parsePlants, response.body);
    }
    return [];
  }

  /// Get a single plant by its id
  static Future<Plant> getPlantById(int id) async {
    final response =
        await get(_BASE_URL + id.toString()).timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parsePlant, response.body);
    }
    return null;
  }

  /// Post a Plant to save it
  static Future<Plant> savePlant(Plant plant) async {
    final response = await post(_BASE_URL,
            headers: await Utils.getAuthorizationHeaders(),
            body: jsonEncode(plant))
        .timeout(RestDatasource.TIMEOUT);
    User currentUser = await UserService.getCurrentUser();
    if (response.statusCode == 201) {
      Plant res = await compute(_parsePlant, response.body);
      PlantCollection plantCollection =
          new PlantCollection(plantId: res.id, userId: currentUser.id);
      PlantCollectionService.savePlantCollection(plantCollection);
      return res;
    }
    return null;
  }

  /// Get all the plants of my collection
  static Future<List<Plant>> getMyGarden() async {
    final response = await get(_BASE_URL + '/my-garden',
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parsePlants, response.body);
    }
    return [];
  }

  /// Get all the plants of my collection
  static Future<List<Plant>> getAllExceptOwner() async {
    final response = await get(_BASE_URL + '/findAllExceptOwner',
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parsePlants, response.body);
    }
    return [];
  }

  static Future<Plant> deletePlant(int plantId) async {
    final response = await delete(_BASE_URL + '/' + plantId.toString(),
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parsePlant, response.body);
    }
    return null;
  }
}
