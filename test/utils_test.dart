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

  test('should test DateTime equality', () {
    DateTime d1 = DateTime(2000, 1, 1, 23);
    DateTime d2 = DateTime(2000, 1, 1, 10);
    DateTime d3 = DateTime(2003, 1, 1);

    expect(Utils.isSameDate(d1, d2), true);
    expect(Utils.isSameDate(d1, d3), false);
    expect(Utils.isSameDate(d1, null), false);
    expect(Utils.isSameDate(null, d2), false);
    expect(Utils.isSameDate(null, null), true);
  });
}
