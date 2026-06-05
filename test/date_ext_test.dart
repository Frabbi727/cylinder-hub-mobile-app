import 'package:flutter_test/flutter_test.dart';
import 'package:cylinder_hub_mobile_app/app/core/values/date_ext.dart';

void main() {
  group('DateFormatter Extension Tests', () {
    final testDate = DateTime(2026, 6, 5);

    test('toStandardDate formats correctly', () {
      expect(testDate.toStandardDate, '5 June 2026');
    });

    test('toApiDate formats correctly', () {
      expect(testDate.toApiDate, '2026-06-05');
    });

    test('toDayMonth formats correctly', () {
      expect(testDate.toDayMonth, '5 June');
    });
  });

  group('StringDateFormatter Extension Tests', () {
    test('toStandardDate formats valid string', () {
      expect('2026-06-05'.toStandardDate, '5 June 2026');
    });

    test('toStandardDate returns empty for null/empty', () {
      String? nullStr;
      expect(nullStr.toStandardDate, '');
      expect(''.toStandardDate, '');
    });

    test('toApiDate formats valid string', () {
      expect('2026-06-05 10:30:00'.toApiDate, '2026-06-05');
    });
  });
}
