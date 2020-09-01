import 'package:flutter_test/flutter_test.dart';
import 'package:leafer/models/event.dart';
import 'package:leafer/screens/events/event_info.dart';

import '../../testable_widget.dart';

void main() {
  Event event;
  setUp(() {
    event = Event(
      name: 'Nom Test Flutter',
      description: 'Description de l\'évènement',
      location: '18 rue de la Tamise',
      startDate: new DateTime(2020, 10, 25, 12),
      endDate: new DateTime(2020, 10, 25, 18),
      price: 0,
      maxPeople: 10,
      latitude: 48.2121,
      longitude: 2.0654,
    );
  });

  testWidgets('should build widget', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(
        child: EventInfo(
      eventId: event.id,
    )));
    expect(find.text('Événements'), findsOneWidget);
  });
}
