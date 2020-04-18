import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/main.dart';
import 'package:leafer/models/event.dart';

class EventService {
  // Parses an array of Event from json
  static List<Event> _parseEvents(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }

  /// Parses a single Event from json
  static Event _parseEvent(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return Event.fromJson(parsed);
  }

  static Future<List<Event>> getEvents() async {
    final response = await get(LeaferApp.SERVER_URL + '/events');
    if (response.statusCode == 200) {
      return compute(_parseEvents, response.body);
    }
    return [];
  }

  static Future<Event> saveEvent(Event event) async {
    final response = await post(LeaferApp.SERVER_URL + '/events', body: event);
    if (response.statusCode == 201) {
      return compute(_parseEvent, response.body);
    }
    return null;
  }
}