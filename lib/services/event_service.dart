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
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromMap(json)).toList();
  }

  /// Parses a single Event from json
  static Event _parseEvent(String responseBody) {
    return Event.fromMap(jsonDecode(responseBody));
  }

  /// Get all Events
  static Future<List<Event>> getEvents() async {
    final response = await get(_BASE_URL, headers: Utils.headers);
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  /// Get incoming events
  static Future<List<Event>> getIncomingEvents() async {
    final response = await get(_BASE_URL + 'incoming', headers: Utils.headers);
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  /// Get joined events
  static Future<List<Event>> getJoinedEvents() async {
    final response = await get(_BASE_URL + 'joined',
        headers: await Utils.getAuthorizationHeaders());
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  /// Get a single event by its id
  static Future<Event> getEventById(int id) async {
    final response = await get(_BASE_URL + id.toString(),
        headers: await Utils.getAuthorizationHeaders());
    if (response.statusCode == 200) {
      return compute(_parseEvent, response.body);
    }
    return null;
  }

  /// Post an Event to save it
  static Future<Event> saveEvent(Event event) async {
    final response = await post(_BASE_URL,
        headers: await Utils.getAuthorizationHeaders(),
        body: jsonEncode(event));
    if (response.statusCode == 201) {
      return compute(_parseEvent, response.body);
    }
    return null;
  }
}
