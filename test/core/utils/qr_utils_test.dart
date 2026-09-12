import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:afyamsafiri/core/utils/qr_utils.dart';

void main() {
  group('QrUtils', () {
    group('generateQRData', () {
      test('returns valid JSON with all fields', () {
        final result = QrUtils.generateQRData(
          bookingID: 'bk-001',
          arrivalDate: '2026-09-15',
          portOfEntry: 'Julius Nyerere International Airport',
        );

        final json = jsonDecode(result) as Map<String, dynamic>;
        expect(json['bookingID'], 'bk-001');
        expect(json['arrivalDate'], '2026-09-15');
        expect(json['portOfEntry'], 'Julius Nyerere International Airport');
      });

      test('produces parseable JSON string', () {
        final result = QrUtils.generateQRData(
          bookingID: 'bk-001',
          arrivalDate: '2026-09-15',
          portOfEntry: 'DAR',
        );

        expect(() => jsonDecode(result), returnsNormally);
      });
    });

    group('validateQRData', () {
      test('returns map for valid QR data', () {
        final rawData = jsonEncode({
          'bookingID': 'bk-001',
          'arrivalDate': '2026-09-15',
          'portOfEntry': 'DAR',
        });

        final result = QrUtils.validateQRData(rawData);

        expect(result, isNotNull);
        expect(result!['bookingID'], 'bk-001');
        expect(result['arrivalDate'], '2026-09-15');
        expect(result['portOfEntry'], 'DAR');
      });

      test('returns null for missing bookingID', () {
        final rawData = jsonEncode({
          'arrivalDate': '2026-09-15',
          'portOfEntry': 'DAR',
        });

        expect(QrUtils.validateQRData(rawData), isNull);
      });

      test('returns null for missing arrivalDate', () {
        final rawData = jsonEncode({
          'bookingID': 'bk-001',
          'portOfEntry': 'DAR',
        });

        expect(QrUtils.validateQRData(rawData), isNull);
      });

      test('returns null for missing portOfEntry', () {
        final rawData = jsonEncode({
          'bookingID': 'bk-001',
          'arrivalDate': '2026-09-15',
        });

        expect(QrUtils.validateQRData(rawData), isNull);
      });

      test('returns null for null field values', () {
        final rawData = jsonEncode({
          'bookingID': null,
          'arrivalDate': '2026-09-15',
          'portOfEntry': 'DAR',
        });

        expect(QrUtils.validateQRData(rawData), isNull);
      });

      test('returns null for invalid JSON', () {
        expect(QrUtils.validateQRData('not-json'), isNull);
      });

      test('returns null for empty string', () {
        expect(QrUtils.validateQRData(''), isNull);
      });

      test('ignores extra fields', () {
        final rawData = jsonEncode({
          'bookingID': 'bk-001',
          'arrivalDate': '2026-09-15',
          'portOfEntry': 'DAR',
          'extra': 'value',
        });

        final result = QrUtils.validateQRData(rawData);
        expect(result, isNotNull);
        expect(result!['extra'], 'value');
      });
    });

    group('round-trip', () {
      test('generate then validate returns same data', () {
        final generated = QrUtils.generateQRData(
          bookingID: 'bk-001',
          arrivalDate: '2026-09-15',
          portOfEntry: 'DAR',
        );

        final validated = QrUtils.validateQRData(generated);

        expect(validated, isNotNull);
        expect(validated!['bookingID'], 'bk-001');
        expect(validated['arrivalDate'], '2026-09-15');
        expect(validated['portOfEntry'], 'DAR');
      });
    });
  });
}
