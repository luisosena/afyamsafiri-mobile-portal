import 'dart:convert';

class QrUtils {
  static String generateQRData({
    required String bookingId,
    required String referenceCode,
    required String fullName,
    required String passportNumber,
    required String portOfEntry,
    required String arrivalDate,
  }) {
    final data = {
      'id': bookingId,
      'ref': referenceCode,
      'name': fullName,
      'passport': passportNumber,
      'port': portOfEntry,
      'arrival': arrivalDate,
      'ts': DateTime.now().millisecondsSinceEpoch,
    };
    return base64Encode(utf8.encode(jsonEncode(data)));
  }

  static Map<String, dynamic>? validateQRData(String rawData) {
    try {
      final decoded = utf8.decode(base64Decode(rawData));
      final json = jsonDecode(decoded) as Map<String, dynamic>;

      final requiredFields = ['id', 'ref', 'name', 'passport', 'port', 'arrival'];
      for (final field in requiredFields) {
        if (!json.containsKey(field) || json[field] == null) {
          return null;
        }
      }

      return json;
    } catch (_) {
      return null;
    }
  }
}
