import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/sensor.dart';
import 'package:leafer/models/sensor_settings.dart';
import 'package:leafer/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SensorService {
  static const _BASE_URL_BACKEND = RestDatasource.HOST + '/sensor';
  static const _BASE_URL_SENSOR = "192.168.4.1";

  static List<Sensor> _parseSensors(String responseBody) {
    if (jsonDecode(responseBody)["items"] != null) {
      final parsed =
          jsonDecode(responseBody)["items"].cast<Map<String, dynamic>>();
      return parsed
          .map<Sensor>((json) => Sensor.fromMap(json))
          .toList();
    } else {
      return [];
    }
  }

  static Sensor _parseSensor(String responseBody) {
    return Sensor.fromMap(jsonDecode(responseBody));
  }

  static Future<String> connectToSensor(SensorSettings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri uri = new Uri.http(_BASE_URL_SENSOR, '/connect', {
      'ssid': settings.ssid,
      'pwd': settings.password,
      'token': prefs.getString('jwt'),
      "plantCollectionId": settings.plantCollection.toString()
    });
    final response = await get(uri).timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 201) {
      return response.body;
    }
    return "connection failed";
  }

  static Future<Sensor> getSensor(int plantCollectionId) async {
    final response = await get(
            _BASE_URL_BACKEND +
                '/findByCollectionId?plantCollectionId=' +
                plantCollectionId.toString(),
            headers: Utils.headers)
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseSensor, response.body);
    }
    return null;
  }
}
