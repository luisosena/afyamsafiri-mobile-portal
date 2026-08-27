import '../models/screening_request.dart';
import '../models/screening_response.dart';

class ScreeningMockDataSource {
  final Map<String, Map<String, dynamic>> _drafts = {};
  final Map<String, Map<String, dynamic>> _submitted = {};

  Future<ScreeningResponse> submitScreening(ScreeningRequest request) async {
    await Future.delayed(const Duration(seconds: 1));

    _submitted[request.bookingId] = request.toJson();
    _drafts.remove(request.bookingId);

    return ScreeningResponse(
      screeningId: 'scr-${DateTime.now().millisecondsSinceEpoch}',
      bookingId: request.bookingId,
      status: 'submitted',
      submittedAt: DateTime.now().toIso8601String(),
    );
  }

  Future<Map<String, dynamic>?> getScreening(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _submitted[bookingId];
  }

  Future<void> saveDraft(String bookingId, ScreeningRequest request) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _drafts[bookingId] = request.toJson();
  }

  Future<Map<String, dynamic>?> getDraft(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _drafts[bookingId];
  }
}