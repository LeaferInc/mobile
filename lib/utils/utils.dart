import 'dart:math';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Weither or not it the same date and true if both are null
  /// Params can be null
  static bool isSameDate(DateTime d1, DateTime d2) {
    if ((d1 != null && d2 == null) || (d1 == null && d2 != null)) {
      return false;
    }

    return (d1 == null && d2 == null) ||
        (d1.year == d2.year && d1.month == d2.month && d1.day == d2.day);
  }

  /// Returns headers with Bearer token
  static Future<Map<String, String>> getAuthorizationHeaders() async {
    String token = (await SharedPreferences.getInstance()).getString("jwt");
    headers.putIfAbsent('Authorization', () => 'Bearer $token');
    return headers;
  }

  /// Detects if the value is near 0, but not quite 0, because of floating point value
  static bool equalsZero(double d) {
    double threshold = pow(10, -8);
    return d <= threshold && d >= -threshold;
  }
}
