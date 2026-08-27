import '../entities/screening.dart';

abstract class ScreeningRepository {
  Future<void> submitScreening({
    required String bookingId,
    required Screening screening,
  });

  Future<Screening?> getScreening(String bookingId);

  Future<void> saveDraft({
    required String bookingId,
    required Screening screening,
  });

  Future<Screening?> getDraft(String bookingId);
}