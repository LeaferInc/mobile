import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/cutting.dart';
import 'package:leafer/utils/utils.dart';

class CuttingService {
  static const _BASE_URL = RestDatasource.HOST + '/cuttings';

  static List<Cutting> _parseCuttings(String responseBody) {
    if (jsonDecode(responseBody)["items"] != null) {
      final parsed =
          jsonDecode(responseBody)["items"].cast<Map<String, dynamic>>();
      return parsed.map<Cutting>((json) => Cutting.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  static Cutting _parseCutting(String reponseBody) {
    return Cutting.fromMap(jsonDecode(reponseBody));
  }

  static Future<List<Cutting>> getAllCuttings() async {
    final response = await get(_BASE_URL + '/exchange',
        headers: await Utils.getAuthorizationHeaders());
    if (response.statusCode == 200) {
      return compute(_parseCuttings, response.body);
    }
    return [];
  }

  static Future<List<Cutting>> getMyCuttings() async {
    final response = await get(_BASE_URL + '/my',
        headers: await Utils.getAuthorizationHeaders());
    if (response.statusCode == 200) {
      return compute(_parseCuttings, response.body);
    }
    return [];
  }

  static Future<Cutting> getCuttingById(int id) async {
    final response = await get(_BASE_URL + "/" + id.toString());
    if (response.statusCode == 200) {
      return compute(_parseCutting, response.body);
    }
    return null;
  }

  static Future<Cutting> saveCutting(Cutting cutting) async {
    final response = await post(_BASE_URL,
        headers: await Utils.getAuthorizationHeaders(),
        body: jsonEncode(cutting));
    if (response.statusCode == 201) {
      return compute(_parseCutting, response.body);
    }
    return null;
  }
}
