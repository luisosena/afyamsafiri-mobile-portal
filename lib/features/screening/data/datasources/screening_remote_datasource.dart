import '../models/screening_request.dart';
import '../models/screening_response.dart';

class ScreeningRemoteDataSource {
  Future<ScreeningResponse> submitScreening(ScreeningRequest request) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<Map<String, dynamic>?> getScreening(String bookingId) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<void> saveDraft(String bookingId, ScreeningRequest request) async {
    throw UnimplementedError('Remote API not yet available');
  }

  Future<Map<String, dynamic>?> getDraft(String bookingId) async {
    throw UnimplementedError('Remote API not yet available');
  }
}