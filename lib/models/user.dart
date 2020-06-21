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

  User copyWith({
    int id,
    String email,
    String userName,
    String firstName,
    String lastName,
    DateTime birthDate,
    String biography,
    int pictureId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      biography: biography ?? this.biography,
      pictureId: pictureId ?? this.pictureId,
    );
  }

  Map<String, dynamic> toJson() {
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
      userName: map['username'],
      firstName: map['firstname'],
      lastName: map['lastname'],
      birthDate: DateTime.parse(map['birthdate'].toString()),
      biography: map['biography'],
      pictureId: map['pictureId'],
    );
  }

  // String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, email: $email, userName: $userName, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, biography: $biography, pictureId: $pictureId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User &&
        o.id == id &&
        o.email == email &&
        o.userName == userName &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.birthDate == birthDate &&
        o.biography == biography &&
        o.pictureId == pictureId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        birthDate.hashCode ^
        biography.hashCode ^
        pictureId.hashCode;
  }
}
