import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:leafer/data/rest_ds.dart';
import 'package:leafer/models/message.dart';
import 'package:leafer/utils/utils.dart';

class MessageService {
  static const _BASE_URL = RestDatasource.HOST + '/message';

  static List<Message> _parseMessages(String responseBody) {
    if (jsonDecode(responseBody) != null) {
      final parsed =
          jsonDecode(responseBody).cast<Map<String, dynamic>>();
      return parsed.map<Message>((json) => Message.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  static Message _parseMessage(String responseBody) {
    return Message.fromMap(jsonDecode(responseBody));
  }

  static Future<List<Message>> getConversationById(int convId) async {
    final response = await get(_BASE_URL + '/conversation?roomId=' + convId.toString(),
            headers: await Utils.getAuthorizationHeaders())
          .timeout(RestDatasource.TIMEOUT);
    if(response.statusCode == 200) {
      return compute(_parseMessages, response.body);
    }
    return [];
  }

  static Future<Message> createConversation() async {
    final response = await get(_BASE_URL + '/createDiscussion',
            headers: await Utils.getAuthorizationHeaders())
          .timeout(RestDatasource.TIMEOUT);
    if(response.statusCode == 200) {
      return compute(_parseMessage, response.body);
    }
    return null;
  }

  static Future<Message> saveMessage(Message message) async {
    final response = await post(_BASE_URL,
            headers: await Utils.getAuthorizationHeaders(),
            body: jsonEncode(message))
        .timeout(RestDatasource.TIMEOUT);
    if(response.statusCode == 201) {
      return compute(_parseMessage, response.body);
    }
    return null;
  }

}