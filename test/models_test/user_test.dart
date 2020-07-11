import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:leafer/models/user.dart';

void main() {
  group('User Model tests', () {
    DateTime birthdate = new DateTime(2020, 10, 10);
    User user;
    String base64 =
        "iVBORw0KGgoAAAANSUhEUgAAABkAAAAPCAYAAAARZmTlAAAAAXNSR0IArs4c6QAAAARnQU1BAAC"
        "xjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABCSURBVDhPvc0xAQAwCMRAdNcaFqrmDVADGUOHW7Kk6txZh9GG0YbRhtG"
        "G0YbRhtGG0YbRhtGG0dbds62SzLYPk8wDZHi4VEgXAv0AAAAASUVORK5CYII=";

    setUp(() {
      user = User(
        id: 1,
        email: 'test@email.com',
        username: 'username',
        firstname: 'John',
        lastname: 'Doe',
        location: 'Paris',
        biography: null,
        birthdate: birthdate,
        picture: base64Decode(base64),
      );
    });

    test('should get User from map', () {
      Map<String, dynamic> map = {
        'id': user.id,
        'email': user.email,
        'username': user.username,
        'firstname': user.firstname,
        'lastname': user.lastname,
        'birthdate': user.birthdate.toIso8601String(),
        'biography': user.biography,
        'location': user.location,
        'picture': base64,
      };

      User result = User.fromMap(map);

      expect(result.id, 1);
      expect(result.username, 'username');
      expect(result.firstname, 'John');
      expect(result.lastname, 'Doe');
      expect(result.email, 'test@email.com');
      expect(result.location, 'Paris');
      expect(result.biography, null);
      expect(result.birthdate, birthdate);
      expect(result.picture, base64Decode(base64));
    });
  });
}
