import 'dart:convert';
import 'dart:typed_data';

class User {
  int id;
  String email;
  String username;
  String firstname;
  String lastname;
  String location;
  DateTime birthdate;
  String biography;
  Uint8List picture;

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
      'picture': '', // TODO: picture,
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
    );
  }

  // String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, email: $email, userName: $username, firstName: $firstname, '
        'lastName: $lastname, birthDate: $birthdate, biography: $biography, picture: $picture)';
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
        o.picture == picture;
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
        picture.hashCode;
  }
}
