import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/sensor.dart';
import 'package:leafer/models/sensor_data.dart';
import 'package:leafer/models/sensor_settings.dart';
import 'package:leafer/utils/utils.dart';

class SensorDataService {
  static const _BASE_URL_BACKEND = RestDatasource.HOST + '/sensor-data';

  static List<SensorData> _parseSensorDatas(String responseBody) {
    if (jsonDecode(responseBody)["items"] != null) {
      final parsed =
          jsonDecode(responseBody)["items"].cast<Map<String, dynamic>>();
      return parsed
          .map<SensorData>((json) => SensorData.fromMap(json))
          .toList();
    } else {
      return [];
    }
  }

  static SensorData _parseSensorData(String responseBody) {
    if(responseBody.isNotEmpty){
      return SensorData.fromMap(jsonDecode(responseBody));
    }
    else{
      return null;
    }
  }

  static Future<SensorData> getLastDataById(Sensor sensor) async {
    final response =
        await get(_BASE_URL_BACKEND + '/last', headers: Utils.headers)
            .timeout(RestDatasource.TIMEOUT);
    if(response.statusCode == 200) {
      return compute(_parseSensorData, response.body);
    }
    return null;
  }
}
