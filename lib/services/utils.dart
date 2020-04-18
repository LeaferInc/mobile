import 'package:intl/intl.dart';

class Utils {
  static final dateFormat = DateFormat('dd/MM/yyyy');
  static final timeFormat = DateFormat('HH:mm');

  /// Returns the `date` with its values overridden by given parameters
  /// I.e, sets all fields if provided
  static DateTime updateDate(DateTime date,
      {
      int year,
      int month,
      int day,
      int hour,
      int minute,
      int second}) {
    return DateTime(year ?? date.year, month ?? date.month, day ?? date.day,
        hour ?? date.hour, minute ?? date.minute, second ?? date.second, 0, 0);
  }
}
