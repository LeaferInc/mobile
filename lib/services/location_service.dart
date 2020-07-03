import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/location.dart';

class LocationService {
  static const String _ADDRESS_API_URL =
      'https://api-adresse.data.gouv.fr/search/?q=';

  /// Parses an array of Location from json
  static List<Location> _parseLocations(String responseBody) {
    final parsed =
        jsonDecode(responseBody)['features'].cast<Map<String, dynamic>>();
    return parsed.map<Location>((json) => Location.fromJson(json)).toList();
  }

  /// Gets all matching locations
  static Future<List<Location>> searchLocations(String address) async {
    final response =
        await get(_ADDRESS_API_URL + address).timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseLocations, response.body);
    }
    return [];
  }
}
