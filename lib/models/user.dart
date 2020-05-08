import 'dart:convert';

class User {
  int id;
  String email;
  String userName;
  String firstName;
  String lastName;
  DateTime birthDate;
  String biography;
  int pictureId;

  User({
    this.id,
    this.email,
    this.userName,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.biography,
    this.pictureId,
  });

  User.map(dynamic obj) {
    this.id = obj["id"];
    this.email = obj["email"];
    this.userName = obj["username"];
    this.firstName = obj["firstname"];
    this.lastName = obj["lastname"];
    this.birthDate = obj["birthdate"];
    this.biography = obj["biography"];
    this.pictureId = obj["pictureId"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'biography': biography,
      'pictureId': pictureId,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['id'],
      email: map['email'],
      userName: map['userName'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate']),
      biography: map['biography'],
      pictureId: map['pictureId'],
    );
  }

  String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));
}
