import 'dart:math';

import 'package:intl/intl.dart';
import 'package:leafer/data/rest_ds.dart';

class Utils {
  static Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
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

  /// Returns headers with Bearer token
  static Future<Map<String, String>> getAuthorizationHeaders() async {
    String token = await RestDatasource.storage.read(key: 'jwt');
    headers.putIfAbsent('Authorization', () => 'Bearer $token');
    return headers;
  }

  /// Detects if the value is near 0, but not quite 0, because of floating point value
  static bool equalsZero(double d) {
    double threshold = pow(10, -8);
    return d <= threshold && d >= -threshold;
  }
}
