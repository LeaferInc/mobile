import 'package:flutter_test/flutter_test.dart';
import 'package:leafer/models/user.dart';

void main() {
  group('User Model tests', () {
    DateTime birthdate = new DateTime(2020, 10, 10);
    User user;

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
        'pictureId': null,
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
    });
  });
}
