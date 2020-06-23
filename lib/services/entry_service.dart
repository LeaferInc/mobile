import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/utils/utils.dart';

class EntryService {
  static const _BASE_URL = RestDatasource.HOST + '/entry/';

  /// Join an event
  static Future<int> joinEvent(int id) async {
    final response = await post(_BASE_URL + 'join/' + id.toString(),
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    return response.statusCode;
  }

  /// Unjoin an event
  static Future<int> unjoinEvent(int id) async {
    final response = await delete(_BASE_URL + 'join/' + id.toString(),
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    return response.statusCode;
  }

  /// Get the joined state of the event
  /// Returns true if the user has joined the event, false otherwise
  static Future<bool> getJoinState(int id) async {
    final response = await get(_BASE_URL + 'state/' + id.toString(),
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    return response.body == 'true';
  }
}
