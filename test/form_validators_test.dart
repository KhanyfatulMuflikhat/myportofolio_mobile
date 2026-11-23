import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/utils/form_validators.dart';

void main() {
  group('requiredText', () {
    test('menolak kosong dan spasi saja', () {
      expect(FormValidators.requiredText('', label: 'Judul'), isNotNull);
      expect(FormValidators.requiredText('   ', label: 'Judul'), isNotNull);
    });
    test('menolak melebihi batas panjang', () {
      expect(
        FormValidators.requiredText('abcdef', label: 'Judul', maxLength: 5),
        isNotNull,
      );
    });
    test('menerima isian valid', () {
      expect(FormValidators.requiredText('Ok', label: 'Judul'), isNull);
    });
  });

  group('optionalUrl', () {
    test('kosong lolos', () => expect(FormValidators.optionalUrl(''), isNull));
    test('http/https lolos', () {
      expect(FormValidators.optionalUrl('https://a.com/x.png'), isNull);
    });
    test('tanpa skema ditolak', () {
      expect(FormValidators.optionalUrl('a.com'), isNotNull);
      expect(FormValidators.optionalUrl('ftp://a.com'), isNotNull);
    });
  });

  group('endDate', () {
    final start = DateTime(2026, 1, 10);
    test('ongoing tidak butuh tanggal selesai', () {
      expect(
        FormValidators.endDate(start: start, end: null, ongoing: true),
        isNull,
      );
    });
    test('wajib jika tidak ongoing', () {
      expect(
        FormValidators.endDate(start: start, end: null, ongoing: false),
        isNotNull,
      );
    });
    test('tidak boleh sebelum mulai', () {
      expect(
        FormValidators.endDate(
          start: start,
          end: DateTime(2026, 1, 9),
          ongoing: false,
        ),
        isNotNull,
      );
    });
  });

  test('formatDate memakai format ISO', () {
    expect(FormValidators.formatDate(DateTime(2026, 3, 5)), '2026-03-05');
  });

  group('pastOrTodayDate', () {
    final today = DateTime(2026, 11, 22);
    test('null ditolak', () {
      expect(FormValidators.pastOrTodayDate(null, today: today), isNotNull);
    });
    test('hari ini dan masa lalu lolos', () {
      expect(FormValidators.pastOrTodayDate(today, today: today), isNull);
      expect(
        FormValidators.pastOrTodayDate(DateTime(2025, 1, 1), today: today),
        isNull,
      );
    });
    test('masa depan ditolak', () {
      expect(
        FormValidators.pastOrTodayDate(DateTime(2026, 11, 23), today: today),
        isNotNull,
      );
    });
  });
}
