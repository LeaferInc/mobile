import 'dart:io';
import 'dart:math';

import 'package:intl/intl.dart';

class Utils {
  static const SERVER_URL = 'http://192.168.43.200:3000';

  static const Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    // TODO: remove
    HttpHeaders.authorizationHeader: 'Bearer ' +
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InVzZXIiLCJzdWIiOjEsImlhdCI6MTU4ODg1NjkwMH0.yGgf_IrUyjOaGn0RfjCU82uBo7rjMiEjBF6tlAAmkwk',
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

  /// Detects if the value is near 0, but not quite 0, because of floating point value
  static bool equalsZero(double d) {
    double threshold = pow(10, -8);
    return d <= threshold && d >= -threshold;
  }
}
