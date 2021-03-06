import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:leafer/models/image_model.dart';
import 'package:leafer/models/room.dart';

class User implements IImageModel {
  int id;
  String email;
  String username;
  String firstname;
  String lastname;
  String location;
  DateTime birthdate;
  String biography;
  Uint8List picture;
  Room room;
  int roomId;

  User({
    this.id,
    this.email,
    this.username,
    this.firstname,
    this.lastname,
    this.location,
    this.birthdate,
    this.biography,
    this.picture,
    this.room,
    this.roomId
  });

  User.map(dynamic obj) {
    this.id = obj["id"] as int;
    this.email = obj["email"] as String;
    this.username = obj["username"] as String;
    this.firstname = obj["firstname"] as String;
    this.lastname = obj["lastname"] as String;
    this.location = obj["location"] as String;
    this.birthdate =
        (obj['birthdate'] != null ? DateTime.parse(obj['birthdate']) : null);
    this.biography = obj["biography"] as String;
    this.picture = base64Decode(obj["picture"] as String);
    this.room = obj["roomId"] as Room;
    this.roomId = obj["roomId"] as int;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'location': location,
      'birthdate': birthdate?.toIso8601String(),
      'biography': biography,
      'picture': this.picture != null ? base64Encode(this.picture) : null,
      'room': this.room,
      'roomId': this.roomId
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      username: map['username'] as String,
      firstname: map['firstname'] as String,
      lastname: map['lastname'] as String,
      location: map['location'] as String,
      birthdate:
          (map['birthdate'] != null ? DateTime.parse(map['birthdate']) : null),
      biography: map['biography'] as String,
      picture: map['picture'] != null
          ? base64Decode(map['picture'] as String)
          : null,
      room: map['room'] as Room,
      roomId: map['roomId'] as int
    );
  }

  // String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));

  @override
  ImageProvider getPicture() {
    if (this.picture == null) {
      return AssetImage('assets/images/plant.png');
    } else {
      return MemoryImage(this.picture);
    }
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, userName: $username, firstName: $firstname, '
        'lastName: $lastname, birthDate: $birthdate, biography: $biography, picture: $picture, room: $room, roomId: $roomId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User &&
        o.id == id &&
        o.email == email &&
        o.username == username &&
        o.firstname == firstname &&
        o.lastname == lastname &&
        o.birthdate == birthdate &&
        o.biography == biography &&
        o.picture == picture &&
        o.room == room &&
        o.roomId == roomId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        firstname.hashCode ^
        lastname.hashCode ^
        birthdate.hashCode ^
        biography.hashCode ^
        picture.hashCode ^
        room.hashCode ^
        roomId.hashCode;
  }
}
