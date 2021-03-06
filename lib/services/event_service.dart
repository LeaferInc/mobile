import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/utils/utils.dart';

class EventService {
  static const _BASE_URL = RestDatasource.HOST + '/events/';

  /// Parses an array of Event from json
  static List<Event> _parseEvents(String responseBody) {
    if (jsonDecode(responseBody) != null) {
      final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
      return parsed.map<Event>((json) => Event.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  /// Parses a single Event from json
  static Event _parseEvent(String responseBody) {
    return Event.fromMap(jsonDecode(responseBody));
  }

  /// Get all Events
  static Future<List<Event>> getEvents() async {
    final response = await get(_BASE_URL, headers: Utils.headers)
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  /// Get organized events
  static Future<List<Event>> getOrganizedEvents() async {
    final response = await get(_BASE_URL + 'organized',
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  /// Get incoming events
  static Future<List<Event>> getIncomingEvents() async {
    final response = await get(_BASE_URL + 'incoming', headers: Utils.headers)
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  /// Get joined events
  static Future<List<Event>> getJoinedEvents() async {
    final response = await get(_BASE_URL + 'joined',
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  /// Get a single event by its id
  static Future<Event> getEventById(int id) async {
    final response = await get(_BASE_URL + id.toString(),
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseEvent, response.body);
    }
    return null;
  }

  /// Search for events
  static Future<List<Event>> searchEvent(String queryParams) async {
    final response = await get(
            _BASE_URL + 'search?${Uri.encodeFull(queryParams)}',
            headers: Utils.headers)
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  /// Post an Event to save it
  static Future<Event> saveEvent(Event event) async {
    final response = await post(_BASE_URL,
            headers: await Utils.getAuthorizationHeaders(),
            body: jsonEncode(event))
        .timeout(RestDatasource.TIMEOUT);
    if (response.statusCode == 201) {
      return compute(_parseEvent, response.body);
    }
    return null;
  }

  static Future<int> deleteEvent(int id) async {
    final response = await delete(_BASE_URL + id.toString(),
            headers: await Utils.getAuthorizationHeaders())
        .timeout(RestDatasource.TIMEOUT);
    return response.statusCode;
  }
}
