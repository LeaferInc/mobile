import 'package:flutter_test/flutter_test.dart';
import 'package:leafer/models/event.dart';

void main() {
  group('Event Model tests', () {
    DateTime startDate;
    Event event;

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
      );
    });

    test('should map Event to json', () {
      Map<String, dynamic> json = event.toJson();
      expect(json['name'], 'Nom Test Flutter');
      expect(json['description'], 'Description de l\'évènement');
      expect(json['location'], '18 rue de la Tamise');
      expect(json['startDate'], startDate.toIso8601String());
      expect(json['endDate'], startDate.add(Duration(hours: 4)).toIso8601String());
      expect(json['price'], 0);
      expect(json['maxPeople'], 10);
      expect(json['latitude'], 48.2121);
      expect(json['longitude'], 2.0654);
    });

    test('should map Event from json', () {
      Map<String, dynamic> json = {
        'name': event.name,
        'description': event.description,
        'location': event.location,
        'startDate': event.startDate.toIso8601String(),
        'endDate': event.endDate.toIso8601String(),
        'price': event.price,
        'maxPeople': event.maxPeople,
        'latitude': event.latitude,
        'longitude': event.longitude,
      };

      Event result = Event.fromJson(json);

      expect(result.name, 'Nom Test Flutter');
      expect(result.description, 'Description de l\'évènement');
      expect(result.location, '18 rue de la Tamise');
      expect(result.startDate, startDate);
      expect(result.endDate, startDate.add(Duration(hours: 4)));
      expect(result.price, 0);
      expect(result.maxPeople, 10);
      expect(result.latitude, 48.2121);
      expect(result.longitude, 2.0654);
    });
  });
}
