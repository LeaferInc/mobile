import 'package:flutter_test/flutter_test.dart';
import 'package:leafer/utils/utils.dart';

void main() {
  test('should update Datetime', () {
    DateTime date = DateTime(2020, 10, 16, 9);

    DateTime updated = Utils.updateDate(date, year: 2019, month: 6, hour: 14);
    expect(updated.year, 2019);
    expect(updated.month, 6);
    expect(updated.day, 16);
    expect(updated.hour, 14);
    expect(updated.minute, 0);
  });

  test('should test double nullity', () {
    expect(Utils.equalsZero(0.0000000001), true);
    expect(Utils.equalsZero(-0.000000009), true);
    expect(Utils.equalsZero(-0.000005), false);
  });
}
