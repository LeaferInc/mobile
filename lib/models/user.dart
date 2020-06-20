import 'dart:convert';

class User {
  int id;
  String email;
  String username;
  String firstname;
  String lastname;
  String location;
  DateTime birthdate;
  String biography;
  int pictureId;

  User({
    this.id,
    this.email,
    this.username,
    this.firstname,
    this.lastname,
    this.location,
    this.birthdate,
    this.biography,
    this.pictureId,
  });

  User.map(dynamic obj) {
    this.id = obj["id"];
    this.email = obj["email"];
    this.username = obj["username"];
    this.firstname = obj["firstname"];
    this.lastname = obj["lastname"];
    this.location = obj["location"];
    this.birthdate = obj["birthdate"];
    this.biography = obj["biography"];
    this.pictureId = obj["pictureId"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'location': location,
      'birthdate': birthdate?.toIso8601String(),
      'biography': biography,
      'pictureId': pictureId,
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
      pictureId: map['pictureId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));
}
