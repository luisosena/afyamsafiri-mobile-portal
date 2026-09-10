import 'package:flutter/material.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/point_of_entry.dart';
import '../../domain/repositories/booking_repository.dart';

enum BookingListStatus { initial, loading, loaded, error }

enum BookingSubmitStatus { initial, submitting, success, error }

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

  // --- Booking form state ---

  String? _selectedPointOfEntry;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _flightNumber = '';
  bool _healthDeclaration = false;

  BookingSubmitStatus _submitStatus = BookingSubmitStatus.initial;
  Booking? _confirmedBooking;
  List<PointOfEntry> _pointsOfEntry = [];

  String? get selectedPointOfEntry => _selectedPointOfEntry;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String get flightNumber => _flightNumber;
  bool get healthDeclaration => _healthDeclaration;
  BookingSubmitStatus get submitStatus => _submitStatus;
  Booking? get confirmedBooking => _confirmedBooking;
  List<PointOfEntry> get pointsOfEntry => _pointsOfEntry;

  bool get isFormValid =>
      _selectedPointOfEntry != null &&
      _selectedDate != null &&
      _selectedTime != null;

  bool get isReviewValid => _healthDeclaration;

  void setPointOfEntry(String? value) {
    _selectedPointOfEntry = value;
    notifyListeners();
  }

  void setDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  void setTime(TimeOfDay? value) {
    _selectedTime = value;
    notifyListeners();
  }

  void setFlightNumber(String value) {
    _flightNumber = value;
    notifyListeners();
  }

  void setHealthDeclaration(bool value) {
    _healthDeclaration = value;
    notifyListeners();
  }

  String get formattedDate {
    if (_selectedDate == null) return '';
    return '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
  }

  String get formattedTime {
    if (_selectedTime == null) return '';
    return '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
  }

  Future<void> loadPointsOfEntry() async {
    try {
      _pointsOfEntry = await bookingRepository.getPointsOfEntry();
      notifyListeners();
    } catch (_) {
      _pointsOfEntry = [];
    }
  }

  Future<void> submitBooking() async {
    _submitStatus = BookingSubmitStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      _confirmedBooking = await bookingRepository.createBooking(
        pointOfEntry: _selectedPointOfEntry!,
        arrivalDate: formattedDate,
        arrivalTime: formattedTime,
        flightNumber: _flightNumber.isNotEmpty ? _flightNumber : null,
      );
      _submitStatus = BookingSubmitStatus.success;
      _bookings.insert(0, _confirmedBooking!);
    } catch (e) {
      _submitStatus = BookingSubmitStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  void resetForm() {
    _selectedPointOfEntry = null;
    _selectedDate = null;
    _selectedTime = null;
    _flightNumber = '';
    _healthDeclaration = false;
    _submitStatus = BookingSubmitStatus.initial;
    _confirmedBooking = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await bookingRepository.cancelBooking(bookingId);
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = Booking(
          id: _bookings[index].id,
          referenceCode: _bookings[index].referenceCode,
          pointOfEntry: _bookings[index].pointOfEntry,
          arrivalDate: _bookings[index].arrivalDate,
          arrivalTime: _bookings[index].arrivalTime,
          flightNumber: _bookings[index].flightNumber,
          status: BookingStatus.cancelled,
          qrCodeData: _bookings[index].qrCodeData,
          createdAt: _bookings[index].createdAt,
          updatedAt: DateTime.now(),
          userId: _bookings[index].userId,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
