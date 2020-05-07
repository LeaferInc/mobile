import 'package:http/http.dart';
import 'package:leafer/services/utils.dart';

class EntryService {
  static const _BASE_URL = Utils.SERVER_URL + '/entry/';

  /// Join an event
  static Future<int> joinEvent(int id) async {
    final response =
        await post(_BASE_URL + 'join/' + id.toString(), headers: Utils.headers);
    return response.statusCode;
  }

  /// Unjoin an event
  static Future<int> unjoinEvent(int id) async {
    final response = await delete(_BASE_URL + 'join/' + id.toString(),
        headers: Utils.headers);
    return response.statusCode;
  }

  /// Get the joined state of the event
  /// Returns true if the user has joined the event, false otherwise
  static Future<bool> getJoinState(int id) async {
    final response =
        await get(_BASE_URL + 'state/' + id.toString(), headers: Utils.headers);
    return response.body == 'true';
  }
}
