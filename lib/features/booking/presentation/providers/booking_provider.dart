import 'package:flutter/material.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';

enum BookingListStatus { initial, loading, loaded, error }

class BookingProvider extends ChangeNotifier {
  BookingProvider({required this.bookingRepository});

  final BookingRepository bookingRepository;

  BookingListStatus _status = BookingListStatus.initial;
  List<Booking> _bookings = [];
  String? _errorMessage;

  BookingListStatus get status => _status;
  List<Booking> get bookings => _bookings;
  String? get errorMessage => _errorMessage;

  Booking? get nextUpcomingBooking {
    final now = DateTime.now();
    final upcoming = _bookings
        .where((b) =>
            b.isConfirmed &&
            b.arrivalDate != null &&
            DateTime.tryParse(b.arrivalDate!)?.isAfter(now) == true)
        .toList()
      ..sort((a, b) => a.arrivalDate!.compareTo(b.arrivalDate!));
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  bool get hasPendingScreening => _bookings.any((b) => b.isPending);

  Future<void> loadBookings() async {
    _status = BookingListStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await bookingRepository.getBookingHistory();
      _status = BookingListStatus.loaded;
    } catch (e) {
      _status = BookingListStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }
}
