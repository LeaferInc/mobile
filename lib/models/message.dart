import 'dart:convert';

import 'package:leafer/models/room.dart';
import 'package:leafer/models/user.dart';

class Message {
  DateTime createdAt;
  String messageContent;
  User user;
  Room room;
  int roomId;

  Message(
    this.createdAt,
    this.messageContent,
    this.user,
    this.room,
    this.roomId
  );

  Message copyWith({
    DateTime createdAt,
    String messageContent,
    User user,
    Room room,
    int roomId
  }) {
    return Message(
      createdAt ?? this.createdAt,
      messageContent ?? this.messageContent,
      user ?? this.user,
      room ?? this.room,
      roomId ?? roomId
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'messageContent': messageContent,
      'user': user,
      'room': room,
      'roomId': roomId
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Message(
      map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      map['messageContent'] as String,
      map['user'] != null ? User.fromMap(map['user']) : null,
      map['room'] != null ? Room.fromMap(map['room']) : null,
      map['roomId'] as int
    );
  }

  // String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(createdAt: $createdAt, messageContent: $messageContent, user: $user, room: $room, roomId: $roomId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Message &&
      o.createdAt == createdAt &&
      o.messageContent == messageContent &&
      o.user == user &&
      o.room == room &&
      o.roomId == roomId;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
      messageContent.hashCode ^
      user.hashCode ^
      room.hashCode ^
      roomId.hashCode;
  }
}
