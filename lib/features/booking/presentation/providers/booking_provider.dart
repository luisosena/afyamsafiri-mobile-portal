import 'package:flutter/material.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';

enum BookingSubmitStatus { initial, loading, submitting, success, error }

enum BookingListStatus { initial, loading, loaded, error }

class BookingProvider extends ChangeNotifier {
  BookingProvider({
    required this.bookingRepository,
  });

  final BookingRepository bookingRepository;

  BookingSubmitStatus _status = BookingSubmitStatus.initial;
  String? _errorMessage;
  Booking _booking = Booking(
    symptoms: Booking.createDefaultSymptoms(),
  );

  BookingSubmitStatus get status => BookingSubmitStatus.initial;
  BookingSubmitStatus get currentStatus => _status;
  String? get errorMessage => _errorMessage;
  Booking get booking => _booking;

  // Reference code after submission
  String? _referenceCode;
  String? get referenceCode => _referenceCode;

  // Booking history
  BookingListStatus _listStatus = BookingListStatus.initial;
  List<Booking> _bookings = [];

  BookingListStatus get listStatus => _listStatus;
  List<Booking> get bookings => _bookings;

  Booking? get latestSubmittedBooking {
    final submitted = _bookings
        .where((d) => d.status == BookingStatus.submitted)
        .toList()
      ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    return submitted.isNotEmpty ? submitted.first : null;
  }

  // Dropdown data
  List<String> _portsOfEntry = [];
  List<String> _nationalities = [];
  List<String> _countries = [];
  List<String> _purposesOfVisit = [];

  List<String> get portsOfEntry => _portsOfEntry;
  List<String> get nationalities => _nationalities;
  List<String> get countries => _countries;
  List<String> get purposesOfVisit => _purposesOfVisit;

  // Step 1 validation
  bool get isStep1Valid =>
      _booking.passportNumber.trim().isNotEmpty &&
      _booking.portOfEntry.isNotEmpty &&
      _booking.arrivalDate != null;

  // Step 2 validation
  bool get isStep2Valid =>
      _booking.firstName.trim().isNotEmpty &&
      _booking.surname.trim().isNotEmpty &&
      _booking.gender.isNotEmpty &&
      _booking.dateOfBirth != null &&
      _booking.nationality.isNotEmpty;

  // Step 3 validation
  bool get isStep3Valid =>
      _booking.purposeOfVisit.isNotEmpty &&
      _booking.localPhone.trim().isNotEmpty &&
      _booking.email.trim().isNotEmpty &&
      _booking.journeyStartCountry.isNotEmpty;

  // Step 4 validation
  bool get isStep4Valid =>
      _booking.symptoms.every((s) => s.value != null);

  // Step 5 validation
  bool get isStep5Valid =>
      _booking.visitedOutbreakArea != null &&
      _booking.caredForSick != null &&
      _booking.participatedInBurial != null &&
      _booking.declarationAccepted;

  bool isStepValid(int step) {
    switch (step) {
      case 0:
        return isStep1Valid;
      case 1:
        return isStep2Valid;
      case 2:
        return isStep3Valid;
      case 3:
        return isStep4Valid;
      case 4:
        return isStep5Valid;
      default:
        return false;
    }
  }

  // Step 1 setters
  void setPassportNumber(String value) {
    _booking = _booking.copyWith(passportNumber: value);
    notifyListeners();
  }

  void setPortOfEntry(String? value) {
    if (value != null) {
      _booking = _booking.copyWith(portOfEntry: value);
      notifyListeners();
    }
  }

  void setArrivalDate(DateTime? value) {
    _booking = _booking.copyWith(arrivalDate: value);
    notifyListeners();
  }

  // Step 2 setters
  void setFirstName(String value) {
    _booking = _booking.copyWith(firstName: value);
    notifyListeners();
  }

  void setMiddleName(String value) {
    _booking = _booking.copyWith(middleName: value);
    notifyListeners();
  }

  void setSurname(String value) {
    _booking = _booking.copyWith(surname: value);
    notifyListeners();
  }

  void setGender(String? value) {
    if (value != null) {
      _booking = _booking.copyWith(gender: value);
      notifyListeners();
    }
  }

  void setDateOfBirth(DateTime? value) {
    _booking = _booking.copyWith(dateOfBirth: value);
    notifyListeners();
  }

  void setNationality(String? value) {
    if (value != null) {
      _booking = _booking.copyWith(nationality: value);
      notifyListeners();
    }
  }

  // Step 3 setters
  void setVesselName(String value) {
    _booking = _booking.copyWith(vesselName: value);
    notifyListeners();
  }

  void setSeatNumber(String value) {
    _booking = _booking.copyWith(seatNumber: value);
    notifyListeners();
  }

  void setPurposeOfVisit(String? value) {
    if (value != null) {
      _booking = _booking.copyWith(purposeOfVisit: value);
      notifyListeners();
    }
  }

  void setDurationOfStay(String value) {
    _booking = _booking.copyWith(durationOfStay: value);
    notifyListeners();
  }

  void setLocalAddress(String value) {
    _booking = _booking.copyWith(localAddress: value);
    notifyListeners();
  }

  void setHotelName(String value) {
    _booking = _booking.copyWith(hotelName: value);
    notifyListeners();
  }

  void setLocalPhone(String value) {
    _booking = _booking.copyWith(localPhone: value);
    notifyListeners();
  }

  void setEmail(String value) {
    _booking = _booking.copyWith(email: value);
    notifyListeners();
  }

  void setJourneyStartCountry(String? value) {
    if (value != null) {
      _booking = _booking.copyWith(journeyStartCountry: value);
      notifyListeners();
    }
  }

  void setCountriesVisitedCount(String value) {
    _booking = _booking.copyWith(countriesVisitedCount: value);
    notifyListeners();
  }

  // Step 4 setters
  void setSymptomValue(int index, bool? value) {
    final updated = List<SymptomEntry>.from(_booking.symptoms);
    updated[index] = updated[index].copyWith(value: value);
    _booking = _booking.copyWith(symptoms: updated);
    notifyListeners();
  }

  void setAdditionalSymptoms(String value) {
    _booking = _booking.copyWith(additionalSymptoms: value);
    notifyListeners();
  }

  // Step 5 setters
  void setVisitedOutbreakArea(bool? value) {
    _booking = _booking.copyWith(visitedOutbreakArea: value);
    notifyListeners();
  }

  void setCaredForSick(bool? value) {
    _booking = _booking.copyWith(caredForSick: value);
    notifyListeners();
  }

  void setParticipatedInBurial(bool? value) {
    _booking = _booking.copyWith(participatedInBurial: value);
    notifyListeners();
  }

  void setDeclarationAccepted(bool value) {
    _booking = _booking.copyWith(declarationAccepted: value);
    notifyListeners();
  }

  // Load dropdown data
  Future<void> loadPortsOfEntry() async {
    try {
      _portsOfEntry = await bookingRepository.getPortsOfEntry();
      notifyListeners();
    } catch (_) {
      _portsOfEntry = [];
    }
  }

  Future<void> loadNationalities() async {
    try {
      _nationalities = await bookingRepository.getNationalities();
      notifyListeners();
    } catch (_) {
      _nationalities = [];
    }
  }

  Future<void> loadCountries() async {
    try {
      _countries = await bookingRepository.getCountries();
      notifyListeners();
    } catch (_) {
      _countries = [];
    }
  }

  Future<void> loadPurposesOfVisit() async {
    try {
      _purposesOfVisit =
          await bookingRepository.getPurposesOfVisit();
      notifyListeners();
    } catch (_) {
      _purposesOfVisit = [];
    }
  }

  // Submit
  Future<bool> submit() async {
    _status = BookingSubmitStatus.submitting;
    _errorMessage = null;
    notifyListeners();

    try {
      final result =
          await bookingRepository.submitBooking(_booking);
      _booking = result;
      _referenceCode = result.referenceCode;
      _status = BookingSubmitStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = BookingSubmitStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Load booking history
  Future<void> loadBookings() async {
    _listStatus = BookingListStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _bookings = await bookingRepository.getBookings();
      _listStatus = BookingListStatus.loaded;
    } catch (e) {
      _listStatus = BookingListStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await bookingRepository.cancelBooking(bookingId);
      final index = _bookings.indexWhere((d) => d.id == bookingId);
      if (index != -1) {
        _bookings[index] = _bookings[index].copyWith(
          status: BookingStatus.cancelled,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Reset
  void reset() {
    _status = BookingSubmitStatus.initial;
    _errorMessage = null;
    _referenceCode = null;
    _booking = Booking(
      symptoms: Booking.createDefaultSymptoms(),
    );
    notifyListeners();
  }
}