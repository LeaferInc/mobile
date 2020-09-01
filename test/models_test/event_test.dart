import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:leafer/models/event.dart';

void main() {
  group('Event Model tests', () {
    DateTime startDate;
    Event event;
    String base64 =
        "iVBORw0KGgoAAAANSUhEUgAAABkAAAAPCAYAAAARZmTlAAAAAXNSR0IArs4c6QAAAARnQU1BAAC"
        "xjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABCSURBVDhPvc0xAQAwCMRAdNcaFqrmDVADGUOHW7Kk6txZh9GG0YbRhtG"
        "G0YbRhtGG0YbRhtGG0dbds62SzLYPk8wDZHi4VEgXAv0AAAAASUVORK5CYII=";

    setUp(() {
      startDate = new DateTime(2020, 10, 25);
      event = Event(
        name: 'Nom Test Flutter',
        description: 'Description de l\'évènement',
        location: '18 rue de la Tamise',
        startDate: startDate,
        endDate: startDate.add(Duration(hours: 4)),
        price: 0,
        maxPeople: 10,
        latitude: 48.2121,
        longitude: 2.0654,
        picture: base64Decode(base64),
      );
    });

    test('should map Event', () {
      Map<String, dynamic> map = event.toJson();
      expect(map['name'], 'Nom Test Flutter');
      expect(map['description'], 'Description de l\'évènement');
      expect(map['location'], '18 rue de la Tamise');
      expect(map['startDate'], startDate.toIso8601String());
      expect(
          map['endDate'], startDate.add(Duration(hours: 4)).toIso8601String());
      expect(map['price'], 0);
      expect(map['maxPeople'], 10);
      expect(map['latitude'], 48.2121);
      expect(map['longitude'], 2.0654);
    });

    test('should get Event from map', () {
      Map<String, dynamic> map = {
        'id': 1,
        'name': event.name,
        'description': event.description,
        'location': event.location,
        'startDate': event.startDate.toIso8601String(),
        'endDate': event.endDate.toIso8601String(),
        'price': event.price,
        'maxPeople': event.maxPeople,
        'latitude': event.latitude,
        'longitude': event.longitude,
        'picture': base64,
        'joined': true,
        'organizer': 2,
        'entrants': [
          {
            'id': 1,
            'username': 'username',
            'firstname': 'Firstname',
            'lastname': 'Lastname'
          }
        ],
      };

      Event result = Event.fromMap(map);
      print(map);
      print(result);
      expect(result.id, 1);
      expect(result.name, 'Nom Test Flutter');
      expect(result.description, 'Description de l\'évènement');
      expect(result.location, '18 rue de la Tamise');
      expect(result.startDate, startDate);
      expect(result.endDate, startDate.add(Duration(hours: 4)));
      expect(result.price, 0);
      expect(result.maxPeople, 10);
      expect(result.latitude, 48.2121);
      expect(result.longitude, 2.0654);
      expect(result.picture, base64Decode(base64));
      expect(result.joined, true);
      expect(result.organizer, 2);
      expect(result.entrants.length, 1);
      expect(result.entrants[0].id, 1);
      expect(result.entrants[0].username, 'username');
    });

    test('it should json encode', () {
      expect(jsonEncode(event), isNotNull);
    });
  });
}
