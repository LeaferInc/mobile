import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:leafer/models/location.dart';

class Utils {
  static const SERVER_URL = 'http://10.0.2.2:3000';
  static const String _ADDRESS_API_URL =
      'https://api-adresse.data.gouv.fr/search/?q=';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };

  static final dateFormat = DateFormat('dd/MM/yyyy');
  static final timeFormat = DateFormat('HH:mm');

  /// Returns the `date` with its values overridden by given parameters
  /// I.e, sets all fields if provided
  static DateTime updateDate(DateTime date,
      {int year, int month, int day, int hour, int minute, int second}) {
    return DateTime(year ?? date.year, month ?? date.month, day ?? date.day,
        hour ?? date.hour, minute ?? date.minute, second ?? date.second, 0, 0);
  }

  /// Parses an array of Location from json
  static List<Location> _parseLocations(String responseBody) {
    final parsed =
        jsonDecode(responseBody)['features'].cast<Map<String, dynamic>>();
    return parsed.map<Location>((json) => Location.fromJson(json)).toList();
  }

  /// Gets all matching locations
  static Future<List<Location>> searchLocations(String address) async {
    final response = await get(Utils._ADDRESS_API_URL + address);
    if (response.statusCode == 200) {
      return compute(_parseLocations, response.body);
    }
    return [];
  }

  /// Detects if the value is near 0, but not quite 0, because of floating point value
  static bool equalsZero(double d) {
    double threshold = pow(10, -8);
    return d <= threshold && d >= -threshold;
  }
}
