import 'dart:convert';

class QrUtils {
  static String generateQRData({
    required String bookingID,
    required String arrivalDate,
    required String portOfEntry,
  }) {
    final data = {
      'bookingID': bookingID,
      'arrivalDate': arrivalDate,
      'portOfEntry': portOfEntry,
    };
    return jsonEncode(data);
  }

  static Map<String, dynamic>? validateQRData(String rawData) {
    try {
      final json = jsonDecode(rawData) as Map<String, dynamic>;

      const requiredFields = ['bookingID', 'arrivalDate', 'portOfEntry'];
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